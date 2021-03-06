/***********************************************************************/
/* MOUSE.C - THE mouse handling                                        */
/* This file contains all commands that can be assigned to function    */
/* keys or typed on the command line.                                  */
/***********************************************************************/
/*
 * THE - The Hessling Editor. A text editor similar to VM/CMS xedit.
 * Copyright (C) 1991-2013 Mark Hessling
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to:
 *
 *    The Free Software Foundation, Inc.
 *    675 Mass Ave,
 *    Cambridge, MA 02139 USA.
 *
 *
 * If you make modifications to this software that you feel increases
 * it usefulness for the rest of the community, please email the
 * changes, enhancements, bug fixes as well as any and all ideas to me.
 * This software is going to be maintained and enhanced as deemed
 * necessary by the community.
 *
 * Mark Hessling, mark@rexx.org  http://www.rexx.org/
 */


#include <the.h>
#include <proto.h>

/*
 * Following #defines to cater for those platforms that don't
 * have mouse definitions in <curses.h>
 */
#define MY_BUTTON_SHIFT           0010
#define MY_BUTTON_CONTROL         0020
#define MY_BUTTON_ALT             0040

#if defined(NCURSES_MOUSE_VERSION)
MEVENT ncurses_mouse_event;
#endif

/*   3         2         1         0
 * 210987654321098765432109876543210
 *                maaaaabbbbb
 */
/*
 * Button masks
 */
#if 0
#define MOUSE_MODIFIER_MASK(x)  ((x) & 0xE000) /* 1110000000000000 */
#define MOUSE_ACTION_MASK(x)    ((x) & 0x1C00) /* 0001110000000000 */
#define MOUSE_BUTTON_MASK(x)    ((x) & 0x0380) /* 0000001110000000 */
#define MOUSE_WINDOW_MASK(x)    ((x) & 0x007F) /* 0000000001111111 */
#else
#define MOUSE_MODIFIER_MASK(x)  ((x) & 0xE0000) /* 11100000000000000000 */
#define MOUSE_ACTION_MASK(x)    ((x) & 0x1F000) /* 00011111000000000000 */
#define MOUSE_BUTTON_MASK(x)    ((x) & 0x00F80) /* 00000000111110000000 */
#define MOUSE_WINDOW_MASK(x)    ((x) & 0x0007F) /* 00000000000001111111 */
#endif
/*
 * Button modifiers
 */
#define MOUSE_MODIFIER_OFFSET   17 /* was 13 */
#define MOUSE_NORMAL            0
#define MOUSE_SHIFT             ((MY_BUTTON_SHIFT >> 3)   << MOUSE_MODIFIER_OFFSET)
#define MOUSE_CONTROL           ((MY_BUTTON_CONTROL >> 3) << MOUSE_MODIFIER_OFFSET)
#define MOUSE_ALT               ((MY_BUTTON_ALT >> 3)     << MOUSE_MODIFIER_OFFSET)
/*
 * Button actions
 */
#define MOUSE_ACTION_OFFSET     14 /* was 10 */
#define MOUSE_PRESS             (BUTTON_PRESSED << MOUSE_ACTION_OFFSET)
#define MOUSE_RELEASE           (BUTTON_RELEASED << MOUSE_ACTION_OFFSET)
#define MOUSE_DRAG              (BUTTON_MOVED << MOUSE_ACTION_OFFSET)
#define MOUSE_CLICK             (BUTTON_CLICKED << MOUSE_ACTION_OFFSET)
#define MOUSE_DOUBLE_CLICK      (BUTTON_DOUBLE_CLICKED << MOUSE_ACTION_OFFSET)
#if defined(PDCURSES_MOUSE_ENABLED) && defined(WHEEL_SCROLLED)
#define MOUSE_SCROLLED          (WHEEL_SCROLLED << MOUSE_ACTION_OFFSET)
#endif
/*
 * Button numbers
 */
#define MOUSE_BUTTON_OFFSET     7
#define MOUSE_LEFT              (1 << MOUSE_BUTTON_OFFSET)
#define MOUSE_MIDDLE            (2 << MOUSE_BUTTON_OFFSET)
#define MOUSE_RIGHT             (3 << MOUSE_BUTTON_OFFSET)
#define THE_MOUSE_WHEEL_UP      (4 << MOUSE_BUTTON_OFFSET)
#define THE_MOUSE_WHEEL_DOWN    (5 << MOUSE_BUTTON_OFFSET)
#define THE_MOUSE_WHEEL_LEFT    (6 << MOUSE_BUTTON_OFFSET)
#define THE_MOUSE_WHEEL_RIGHT   (7 << MOUSE_BUTTON_OFFSET)

#define MOUSE_INFO_TO_KEY(w,b,ba,bm) ((w)|(b<<MOUSE_BUTTON_OFFSET)|(ba<<MOUSE_ACTION_OFFSET)|((bm>>3)<<MOUSE_MODIFIER_OFFSET))

static CHARTYPE *button_names[] =
{
   (CHARTYPE *)"-button 0-",
   (CHARTYPE *)"LB", /* left button */
   (CHARTYPE *)"MB", /* middle button */
   (CHARTYPE *)"RB", /* right button */
   (CHARTYPE *)"UW", /* wheel up */
   (CHARTYPE *)"DW", /* wheel down */
   (CHARTYPE *)"LW", /* wheel left */
   (CHARTYPE *)"RW", /* wheel right */
};

static CHARTYPE *button_modifier_names[] =
{
   (CHARTYPE *)"",
   (CHARTYPE *)"S-", /* shift */
   (CHARTYPE *)"C-", /* control */
   (CHARTYPE *)"?",  /* unknown */
   (CHARTYPE *)"A-", /* alt */
};

static CHARTYPE *button_action_names[] =
{
   (CHARTYPE *)"R", /* release */
   (CHARTYPE *)"P", /* press */
   (CHARTYPE *)"C", /* clicked */
   (CHARTYPE *)"2", /* double clicked */
   (CHARTYPE *)"3", /* triple clicked */
   (CHARTYPE *)"D", /* dragged */
   (CHARTYPE *)"S", /* scrolled */
};

#if defined(PDCURSES_MOUSE_ENABLED) || defined(NCURSES_MOUSE_VERSION)
/*
 * These two variables are saved by each mouse key press or reset to -1
 * when a normal key it pressed.
 */
static int last_mouse_x_pos=-1;
static int last_mouse_y_pos=-1;

#if defined(PDCURSES_MOUSE_ENABLED)
/***********************************************************************/
#ifdef HAVE_PROTO
short get_mouse_info(int *button,int *button_action,int *button_modifier)
#else
short get_mouse_info(button,button_action,button_modifier)
int *button,*button_action,*button_modifier;
#endif
/***********************************************************************/
{
   short rc=RC_OK;

   TRACE_FUNCTION("mouse.c:  get_mouse_info");
   request_mouse_pos();
   /*
    * Save the current mouse position
    */
   last_mouse_x_pos = MOUSE_X_POS;
   last_mouse_y_pos = MOUSE_Y_POS;
   if (A_BUTTON_CHANGED)
   {
      if (BUTTON_CHANGED(1))
         *button = 1;
      else if (BUTTON_CHANGED(2))
         *button = 2;
      else if (BUTTON_CHANGED(3))
         *button = 3;
      else
      {
         TRACE_RETURN();
         return(RC_OK);
      }
      if (BUTTON_STATUS(*button) & BUTTON_SHIFT)
         *button_modifier = MY_BUTTON_SHIFT;
      else if (BUTTON_STATUS(*button) & BUTTON_CONTROL)
         *button_modifier = MY_BUTTON_CONTROL;
      else if (BUTTON_STATUS(*button) & BUTTON_ALT)
         *button_modifier = MY_BUTTON_ALT;
      else
         *button_modifier = 0;
      if (MOUSE_MOVED)
         *button_action = BUTTON_MOVED;
      else
         *button_action = BUTTON_STATUS(*button) & BUTTON_ACTION_MASK;
   }
#if defined(MOUSE_WHEEL_UP) && defined(WHEEL_SCROLLED)
   else if ( MOUSE_WHEEL_UP )
   {
      *button_action = WHEEL_SCROLLED;
      *button = 4;
      *button_modifier = 0;
   }
#endif
#if defined(MOUSE_WHEEL_DOWN) && defined(WHEEL_SCROLLED)
   else if ( MOUSE_WHEEL_DOWN )
   {
      *button_action = WHEEL_SCROLLED;
      *button = 5;
      *button_modifier = 0;
   }
#endif
#if defined(MOUSE_WHEEL_LEFT) && defined(WHEEL_SCROLLED)
   else if ( MOUSE_WHEEL_LEFT )
   {
      *button_action = WHEEL_SCROLLED;
      *button = 6;
      *button_modifier = 0;
   }
#endif
#if defined(MOUSE_WHEEL_RIGHT) && defined(WHEEL_SCROLLED)
   else if ( MOUSE_WHEEL_RIGHT )
   {
      *button_action = WHEEL_SCROLLED;
      *button = 7;
      *button_modifier = 0;
   }
#endif
   else
   {
      *button = *button_action = *button_modifier = 0;
      rc = RC_INVALID_OPERAND;
   }
   TRACE_RETURN();
   return(rc);
}
#endif
#if defined(NCURSES_MOUSE_VERSION)
/***********************************************************************/
#ifdef HAVE_PROTO
void wmouse_position(WINDOW *win, int *y, int *x)
#else
void wmouse_position(win,y,x)
WINDOW *win;
int *y,*x;
#endif
/***********************************************************************/
{
   int begy,begx,maxy,maxx;

   TRACE_FUNCTION("mouse.c:  wmouse_position");
   /*
    * if the current mouse position is outside the provided window, put
    * -1 in x and y
    */
   if (win == (WINDOW *)NULL)
   {
      *y = *x = (-1);
      TRACE_RETURN();
      return;
   }
   getbegyx(win,begy,begx);
   getmaxyx(win,maxy,maxx);
   if (begy > ncurses_mouse_event.y
   ||  begx > ncurses_mouse_event.x
   ||  begy+maxy <= ncurses_mouse_event.y
   ||  begx+maxx <= ncurses_mouse_event.x)
   {
      *x = *y = (-1);
   }
   else
   {
      *x = ncurses_mouse_event.x - begx;
      *y = ncurses_mouse_event.y - begy;
   }
   TRACE_RETURN();
   return;
}
/***********************************************************************/
#ifdef HAVE_PROTO
short get_mouse_info(int *button,int *button_action,int *button_modifier)
#else
short get_mouse_info(button,button_action,button_modifier)
int *button,*button_action,*button_modifier;
#endif
/***********************************************************************/
{
   short rc=RC_OK;

   TRACE_FUNCTION("mouse.c:  get_mouse_info");
   getmouse(&ncurses_mouse_event);
   /*
    * Save the current mouse position
    */
   last_mouse_x_pos = ncurses_mouse_event.x;
   last_mouse_y_pos = ncurses_mouse_event.y;

   if (ncurses_mouse_event.bstate & BUTTON1_RELEASED
   ||  ncurses_mouse_event.bstate & BUTTON1_PRESSED
   ||  ncurses_mouse_event.bstate & BUTTON1_CLICKED
   ||  ncurses_mouse_event.bstate & BUTTON1_DOUBLE_CLICKED)
      *button = 1;
   else
   {
      if (ncurses_mouse_event.bstate & BUTTON2_RELEASED
      ||  ncurses_mouse_event.bstate & BUTTON2_PRESSED
      ||  ncurses_mouse_event.bstate & BUTTON2_CLICKED
      ||  ncurses_mouse_event.bstate & BUTTON2_DOUBLE_CLICKED)
         *button = 2;
      else
      {
         if (ncurses_mouse_event.bstate & BUTTON3_RELEASED
         ||  ncurses_mouse_event.bstate & BUTTON3_PRESSED
         ||  ncurses_mouse_event.bstate & BUTTON3_CLICKED
         ||  ncurses_mouse_event.bstate & BUTTON3_DOUBLE_CLICKED)
            *button = 3;
         else
         {
            *button = *button_action = *button_modifier = 0;
            TRACE_RETURN();
            return RC_INVALID_OPERAND;
         }
      }
   }
   if (ncurses_mouse_event.bstate & BUTTON_SHIFT)
      *button_modifier = MY_BUTTON_SHIFT;
   else if (ncurses_mouse_event.bstate & BUTTON_CTRL)
      *button_modifier = MY_BUTTON_CONTROL;
   else if (ncurses_mouse_event.bstate & BUTTON_ALT)
      *button_modifier = MY_BUTTON_ALT;
   else
      *button_modifier = 0;

   if (ncurses_mouse_event.bstate & BUTTON1_RELEASED
   ||  ncurses_mouse_event.bstate & BUTTON2_RELEASED
   ||  ncurses_mouse_event.bstate & BUTTON3_RELEASED)
      *button_action = BUTTON_RELEASED;
   else
   {
      if (ncurses_mouse_event.bstate & BUTTON1_PRESSED
      ||  ncurses_mouse_event.bstate & BUTTON2_PRESSED
      ||  ncurses_mouse_event.bstate & BUTTON3_PRESSED)
         *button_action = BUTTON_PRESSED;
      else
      {
         if (ncurses_mouse_event.bstate & BUTTON1_CLICKED
         ||  ncurses_mouse_event.bstate & BUTTON2_CLICKED
         ||  ncurses_mouse_event.bstate & BUTTON3_CLICKED)
            *button_action = BUTTON_CLICKED;
         else
         {
            if (ncurses_mouse_event.bstate & BUTTON1_DOUBLE_CLICKED
            ||  ncurses_mouse_event.bstate & BUTTON2_DOUBLE_CLICKED
            ||  ncurses_mouse_event.bstate & BUTTON3_DOUBLE_CLICKED)
               *button_action = BUTTON_DOUBLE_CLICKED;
         }
      }
   }
   TRACE_RETURN();
   return(rc);
}
#endif

/***********************************************************************/
#ifdef HAVE_PROTO
short THEMouse(CHARTYPE *params)
#else
short THEMouse(params)
CHARTYPE *params;
#endif
/***********************************************************************/
{
   int w=0;
   CHARTYPE scrn=0;
   short rc=RC_OK;
   int curr_button_action=0;
   int curr_button_modifier=0;
   int curr_button=0;

   TRACE_FUNCTION( "mouse.c:  THEMouse" );
   which_window_is_mouse_in( &scrn, &w );
   if (w == (-1)) /* shouldn't happen! */
   {
      TRACE_RETURN();
      return(RC_OK);
   }
   rc = get_mouse_info(&curr_button,&curr_button_action,&curr_button_modifier);
   if (rc != RC_OK)
   {
      TRACE_RETURN();
      return(rc);
   }
   rc = execute_mouse_commands(MOUSE_INFO_TO_KEY(w,curr_button,curr_button_action,curr_button_modifier));
   TRACE_RETURN();
   return(rc);
}
/***********************************************************************/
#ifdef HAVE_PROTO
void which_window_is_mouse_in(CHARTYPE *scrn,int *w)
#else
void which_window_is_mouse_in(scrn,w)
CHARTYPE *scrn;
int *w;
#endif
/***********************************************************************/
{
   CHARTYPE i=0;
   int j=0;
   int y=0,x=0;

   TRACE_FUNCTION("mouse.c:  which_window_is_mouse_in");
   for (i=0;i<display_screens;i++)
   {
      for (j=0;j<VIEW_WINDOWS;j++)
      {
         if (screen[i].win[j] != (WINDOW *)NULL)
         {
            wmouse_position(screen[i].win[j],&y,&x);
            if (y != (-1)
            &&  x != (-1))
            {
               *scrn = i;
               *w = j;
               TRACE_RETURN();
               return;
            }
         }
      }
   }
   /*
    * To get here, the mouse is NOT in any of the view windows; is it in
    * the status line ?
    */
   wmouse_position(statarea,&y,&x);
   if (y != (-1)
   &&  x != (-1))
   {
      *w = WINDOW_STATAREA;
      *scrn = current_screen;
      TRACE_RETURN();
      return;
   }
   /*
    * To get here, the mouse is NOT in any of the view windows; or the
    * status line. Is it in the FILETABS window ?
    */
   wmouse_position( filetabs, &y, &x );
   if ( y != (-1)
   &&   x != (-1) )
   {
      *w = WINDOW_FILETABS;
      *scrn = current_screen;
      TRACE_RETURN();
      return;
   }
   /*
    * To get here, the mouse is NOT in any of the view windows; or the
    * status line, or the FILETABS window. Is it in the DIVIDER window ?
    */
   if ( display_screens > 1
   &&   !horizontal)
   {
      wmouse_position( divider, &y, &x );
      if ( y != (-1)
      &&   x != (-1) )
      {
         *w = WINDOW_DIVIDER;
         *scrn = current_screen;
         TRACE_RETURN();
         return;
      }
   }
   /*
    * To get here, the mouse is NOT in ANY window. Return an error.
    */
   *w = WINDOW_ALL /* was (-1) */;
   TRACE_RETURN();
   return;
}
/***********************************************************************/
#ifdef HAVE_PROTO
void reset_saved_mouse_pos(void)
#else
void reset_saved_mouse_pos()
#endif
/***********************************************************************/
{
   TRACE_FUNCTION("mouse.c:  reset_saved_mouse_pos");
   last_mouse_x_pos = -1;
   last_mouse_y_pos = -1;
   TRACE_RETURN();
   return;
}
/***********************************************************************/
#ifdef HAVE_PROTO
void get_saved_mouse_pos(int *y, int *x)
#else
void get_saved_mouse_pos(y,x)
int *y,*x;
#endif
/***********************************************************************/
{
   TRACE_FUNCTION("mouse.c:  get_saved_mouse_pos");
   *x = last_mouse_x_pos;
   *y = last_mouse_y_pos;
   TRACE_RETURN();
   return;
}
/***********************************************************************/
#ifdef HAVE_PROTO
void initialise_mouse_commands(void)
#else
void initialise_mouse_commands()
#endif
/***********************************************************************/
{
   TRACE_FUNCTION("mouse.c:   initialise_mouse_commands");

   /*
    * Default mouse actions in FILEAREA
    */
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_LEFT|MOUSE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"CURSOR MOUSE",FALSE,FALSE,0);
#if defined(PDCURSES_MOUSE_ENABLED) && defined(WHEEL_SCROLLED)
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_ALL|THE_MOUSE_WHEEL_UP|MOUSE_SCROLLED,
            (CHARTYPE *)"BACK 5 LINES",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_ALL|THE_MOUSE_WHEEL_DOWN|MOUSE_SCROLLED,
            (CHARTYPE *)"FOR 5 LINES",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_ALL|THE_MOUSE_WHEEL_LEFT|MOUSE_SCROLLED,
            (CHARTYPE *)"LEFT 5",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_ALL|THE_MOUSE_WHEEL_RIGHT|MOUSE_SCROLLED,
            (CHARTYPE *)"RIGHT 5",FALSE,FALSE,0);
#endif
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_LEFT|MOUSE_PRESS|MOUSE_SHIFT,
            (CHARTYPE *)"CURSOR MOUSE#RESET BLOCK#MARK LINE",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_LEFT|MOUSE_PRESS|MOUSE_CONTROL,
            (CHARTYPE *)"CURSOR MOUSE#RESET BLOCK#MARK BOX",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_LEFT|MOUSE_DRAG|MOUSE_SHIFT,
            (CHARTYPE *)"CURSOR MOUSE#MARK LINE",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_LEFT|MOUSE_DRAG|MOUSE_CONTROL,
            (CHARTYPE *)"CURSOR MOUSE#MARK BOX",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_RIGHT|MOUSE_PRESS|MOUSE_SHIFT,
            (CHARTYPE *)"CURSOR MOUSE#MARK LINE",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_RIGHT|MOUSE_PRESS|MOUSE_CONTROL,
            (CHARTYPE *)"CURSOR MOUSE#MARK BOX",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_RIGHT|MOUSE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"CURSOR MOUSE#SOS MAKECURR",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_LEFT|MOUSE_DRAG|MOUSE_SHIFT,
            (CHARTYPE *)"CURSOR MOUSE#MARK LINE",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_LEFT|MOUSE_DRAG|MOUSE_CONTROL,
            (CHARTYPE *)"CURSOR MOUSE#MARK BOX",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_LEFT|MOUSE_DOUBLE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"CURSOR MOUSE#SOS EDIT",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_LEFT|MOUSE_CLICK|MOUSE_ALT,
            (CHARTYPE *)"BACKWARD",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_FILEAREA|MOUSE_RIGHT|MOUSE_CLICK|MOUSE_ALT,
            (CHARTYPE *)"FORWARD",FALSE,FALSE,0);
   /*
    * Default mouse actions in PREFIX area
    */
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_PREFIX|MOUSE_LEFT|MOUSE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"CURSOR MOUSE",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_PREFIX|MOUSE_RIGHT|MOUSE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"CURSOR MOUSE#SOS MAKECURR",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_PREFIX|MOUSE_LEFT|MOUSE_DOUBLE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"CURSOR MOUSE#SOS EDIT",FALSE,FALSE,0);
   /*
    * Default mouse actions in COMMAND line
    */
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_COMMAND|MOUSE_LEFT|MOUSE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"CURSOR MOUSE",FALSE,FALSE,0);
   /*
    * Default mouse actions in STATAREA
    */
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_STATAREA|MOUSE_LEFT|MOUSE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"STATUS",FALSE,FALSE,0);
/*
 * Default mouse actions in FILETABS
 */
   add_define( &first_mouse_define, &last_mouse_define,
               WINDOW_FILETABS|MOUSE_LEFT|MOUSE_CLICK|MOUSE_NORMAL,
               (CHARTYPE *)"TABFILE", FALSE, FALSE, 0 );
   /*
    * Default mouse actions in IDLINE
    */
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_IDLINE|MOUSE_LEFT|MOUSE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"XEDIT",FALSE,FALSE,0);
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_IDLINE|MOUSE_RIGHT|MOUSE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"XEDIT -",FALSE,FALSE,0);
   /*
    * Default mouse actions in DIVIDER
    */
   add_define(&first_mouse_define,&last_mouse_define,
            WINDOW_DIVIDER|MOUSE_LEFT|MOUSE_CLICK|MOUSE_NORMAL,
            (CHARTYPE *)"SCREEN 1",FALSE,FALSE,0);

 TRACE_RETURN();
 return;
}
/***********************************************************************/
#ifdef HAVE_PROTO
int mouse_info_to_key(int w, int button, int button_action, int button_modifier)
#else
int mouse_info_to_key(w,button,button_action,button_modifier)
int w,button,button_action,button_modifier;
#endif
/***********************************************************************/
{
   TRACE_FUNCTION("mouse.c:   mouse_info_to_key");

   TRACE_RETURN();
   return(MOUSE_INFO_TO_KEY(w,button,button_action,button_modifier));
}
#endif
/***********************************************************************/
#ifdef HAVE_PROTO
CHARTYPE *mouse_key_number_to_name(int key_number, CHARTYPE *key_name, int *shift)
#else
CHARTYPE *mouse_key_number_to_name( key_number, key_name, shift )
int key_number;
CHARTYPE *key_name;
int shift;
#endif
/***********************************************************************/
{
   register int i=0;
   int w=0,b=0,ba=0,bm=0;
   CHARTYPE *win_name=(CHARTYPE *)"*** unknown ***";

   TRACE_FUNCTION("mouse.c:   mouse_key_number_to_name");
   w = MOUSE_WINDOW_MASK(key_number);
   b = (MOUSE_BUTTON_MASK(key_number)>>MOUSE_BUTTON_OFFSET);
   ba = (MOUSE_ACTION_MASK(key_number)>>MOUSE_ACTION_OFFSET);
   bm = (MOUSE_MODIFIER_MASK(key_number)>>MOUSE_MODIFIER_OFFSET);
   *shift = bm;
   if ( w == WINDOW_ALL )
      win_name = (CHARTYPE *)"*";
   else
   {
      for ( i = 0; i < ATTR_MAX; i++ )
      {
         if ( w == valid_areas[i].area_window
         &&   valid_areas[i].actual_window )
         {
            win_name = valid_areas[i].area;
            break;
         }
      }
   }
   sprintf( (DEFCHAR *)key_name, "%s%s%s in %s", button_modifier_names[bm], button_action_names[ba], button_names[b], win_name );
   TRACE_RETURN();
   return( key_name );
}

/***********************************************************************/
#ifdef HAVE_PROTO
int find_mouse_key_value( CHARTYPE *mnemonic )
#else
int find_mouse_key_value( mnemonic )
CHARTYPE *mnemonic;
#endif
/***********************************************************************/
/*   Function: find the matching mouse key value for the supplied name */
/* Parameters:                                                         */
/*   mnemonic: the key name to be matched                              */
/*   win_name: the window to be matched                                */
/*    Returns: the mouse button, action and modifier or -1 if error    */
/***********************************************************************/
{
   int key=0,len=0;
   int b=0,ba=0,bm=0;
   CHARTYPE tmp_buf[6];

   TRACE_FUNCTION("mouse.c:   find_mouse_key_value");
   /*
    * Parse the mnemonic for a valid mouse key definition...
    */
   len = strlen((DEFCHAR *)mnemonic);
   if (len == 3)
   {
      strcpy((DEFCHAR *)tmp_buf,"N-");
      strcat((DEFCHAR *)tmp_buf,(DEFCHAR *)mnemonic);
   }
   else
   {
      if (len == 5)
      {
         strcpy((DEFCHAR *)tmp_buf,(DEFCHAR *)mnemonic);
      }
      else
      {
         display_error(1,mnemonic,FALSE);
         TRACE_RETURN();
         return(-1);
      }
   }
   if (tmp_buf[1] != '-'
   || ( tmp_buf[4] != 'B'
      && tmp_buf[4] != 'b'
#if defined(PDCURSES_MOUSE_ENABLED)
      && tmp_buf[4] != 'W'
      && tmp_buf[4] != 'w'
#endif
      ))
   {
      display_error(1,mnemonic,FALSE);
      TRACE_RETURN();
      return(-1);
   }
   /*
    * Validate button modifier
    */
   switch(tmp_buf[0])
   {
      case 'N':
      case 'n':
         bm = 0;
         break;
      case 'S':
      case 's':
         bm = MOUSE_SHIFT;
         break;
      case 'C':
      case 'c':
         bm = MOUSE_CONTROL;
         break;
      case 'A':
      case 'a':
         bm = MOUSE_ALT;
         break;
      default:
         display_error(1,mnemonic,FALSE);
         TRACE_RETURN();
         return(-1);
         break;
   }
   /*
    * Validate button action
    */
   switch(tmp_buf[2])
   {
      case 'P':
      case 'p':
         ba = MOUSE_PRESS;
         break;
      case 'C':
      case 'c':
         ba = MOUSE_CLICK;
         break;
      case 'R':
      case 'r':
         ba = MOUSE_RELEASE;
         break;
      case '2':
         ba = MOUSE_DOUBLE_CLICK;
         break;
      case 'D':
      case 'd':
         ba = MOUSE_DRAG;
         break;
#if defined(PDCURSES_MOUSE_ENABLED) && defined(WHEEL_SCROLLED)
      case 'S':
      case 's':
         ba = MOUSE_SCROLLED;
         break;
#endif
      default:
         display_error(1,mnemonic,FALSE);
         TRACE_RETURN();
         return(-1);
         break;
   }
   /*
    * Validate button number
    */
   switch(tmp_buf[3])
   {
      case 'L':
      case 'l':
#if defined(PDCURSES_MOUSE_ENABLED)
         if ( ba == MOUSE_SCROLLED )
            b = THE_MOUSE_WHEEL_LEFT;
         else
#endif
            b = MOUSE_LEFT;
         break;
      case 'R':
      case 'r':
#if defined(PDCURSES_MOUSE_ENABLED)
         if ( ba == MOUSE_SCROLLED )
            b = THE_MOUSE_WHEEL_RIGHT;
         else
#endif
            b = MOUSE_RIGHT;
         break;
      case 'M':
      case 'm':
         b = MOUSE_MIDDLE;
         break;
#if defined(PDCURSES_MOUSE_ENABLED)
      case 'U':
      case 'u':
         b = THE_MOUSE_WHEEL_UP;
         break;
      case 'D':
      case 'd':
         b = THE_MOUSE_WHEEL_DOWN;
         break;
#endif
      default:
         display_error(1,mnemonic,FALSE);
         TRACE_RETURN();
         return(-1);
         break;
   }
   key = b|ba|bm;
   TRACE_RETURN();
   return(key);
}

/***********************************************************************/
#ifdef HAVE_PROTO
int find_mouse_key_value_in_window(CHARTYPE *mnemonic,CHARTYPE *win_name)
#else
int find_mouse_key_value_in_window(mnemonic,win_name)
CHARTYPE *mnemonic,*win_name;
#endif
/***********************************************************************/
/*   Function: find the matching mouse key value for the supplied name */
/*             in the specified window.                                */
/* Parameters:                                                         */
/*   mnemonic: the key name to be matched                              */
/*   win_name: the window to be matched                                */
/*    Returns: the mouse button, action, modifier and window           */
/*             or -1 if error.                                         */
/***********************************************************************/
{
   register short i=0;
   int w=(-1),key=0;
   int mb;

   TRACE_FUNCTION("mouse.c:   find_mouse_key_value_in_window");
   /*
    * Parse the mnemonic for a valid mouse key definition...
    */
   mb = find_mouse_key_value( mnemonic );
   if ( mb == (-1) )
   {
      TRACE_RETURN();
      return mb;
   }
   /*
    * Find a valid window name for win_name...
    */
#if defined(PDCURSES_MOUSE_ENABLED)
   if ( strcmp( "*", (DEFCHAR *)win_name ) == 0 )
      w = WINDOW_ALL;
   else
#endif
   {
      for (i=0;i<ATTR_MAX;i++)
      {
         if (equal(valid_areas[i].area,win_name,valid_areas[i].area_min_len))
         {
            w = valid_areas[i].area_window;
            break;
         }
      }
   }
   if (w == (-1))
   {
      display_error(1,win_name,FALSE);
      TRACE_RETURN();
      return(-1);
   }
   key = w | mb;
   TRACE_RETURN();
   return(key);
}

#if defined(HAVE_SB_INIT)
/***********************************************************************/
#ifdef HAVE_PROTO
short ScrollbarHorz(CHARTYPE *params)
#else
short ScrollbarHorz(params)
CHARTYPE *params;
#endif
/***********************************************************************/
{
   int cur=0;
   short rc=RC_OK;

   TRACE_FUNCTION("mouse.c:   ScrollbarHorz");
   /*
    * Parse the mnemonic for a valid mouse key definition...
    */
   sb_get_horz(NULL,NULL,&cur);
   if (cur < CURRENT_VIEW->verify_col)
      rc = Left((CHARTYPE*)"FULL");
   else
      rc = Right((CHARTYPE*)"FULL");
   TRACE_RETURN();
   return(rc);
}
/***********************************************************************/
#ifdef HAVE_PROTO
short ScrollbarVert(CHARTYPE *params)
#else
short ScrollbarVert(params)
CHARTYPE *params;
#endif
/***********************************************************************/
{
   int cur=0;
   short rc=RC_OK;

   TRACE_FUNCTION("mouse.c:   ScrollbarVert");
   /*
    * Parse the mnemonic for a valid mouse key definition...
    */
   sb_get_vert( NULL, NULL, &cur );
   rc = execute_makecurr( current_screen, CURRENT_VIEW, (LINETYPE)cur );
   TRACE_RETURN();
   return(rc);
}
#endif
