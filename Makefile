# Makefile for THE
#
# The variable 'srcdir' refers to the source-distribution, and can be set with
# the configure script by "--srcdir=DIR".
#

SHELL		= /bin/sh
THIS		= Makefile



VERSION="3.3RC4"
VERSION_UNQUOTED=3.3RC4
VERSION_NODOT="33RC4"
VER_DATE="30-October-2014"
THE_DIR=THE-$(VERSION)

srcdir		= .
abs_srcdir		= /home/joarmc/TheHesslingEditor
prefix		= /usr/local
target		= x86_64-unknown-linux-gnu
exec_prefix	= ${prefix}
libdir		= /usr/local/lib64
bindir		= ${exec_prefix}/bin
includedir		= ${prefix}/include
mandir		= ${prefix}/share/man
datadir		= ${prefix}/share

docdir		= $(srcdir)/doc
imagedir		= $(srcdir)/images
contribdir		= $(srcdir)/contrib
thisdir		=/home/joarmc/TheHesslingEditor

INSTALL		= $(srcdir)/install-sh

HTML_EXT		= .html

CC		= clang
CFLAGS		= -g -O2 -m64 -O3 -Wall
LIBS		= 
DEBUG =            -DNDEBUG
DEBUGGING =        
RPMTOPDIR =        /home/joarmc/rpmbuild

BASE_INSTALL = installbase
BASE_BINARY = binarybase
THEBIN = nthe
THETYPE = ncurses
MYDISTRO=Fedora-40
MACH_ARCH=x86_64

INCDIR		= $(srcdir)
CPPFLAGS	= -I. -I$(INCDIR) -I$(contribdir) $(DEBUG) -DHAVE_CONFIG_H  -DTHE_HOME_DIRECTORY=\"$(datadir)/THE/\"

CCFLAGS		= -c $(CFLAGS) $(CPPFLAGS) -I/usr/include -I/usr/include 

LINK		=  $(CC)
LDFLAGS		=  $(DEBUGGING)  -m64 -L/usr/lib64 -lncurses -L/usr/lib64 -lregina $(LIBS)   -lm 
THELDFLAGS		=  $(DEBUGGING)  -m64 $(LIBS)  -lm 

################################################################################

COMM = \
 $(srcdir)/comm1.c \
 $(srcdir)/comm2.c \
 $(srcdir)/comm3.c \
 $(srcdir)/comm4.c \
 $(srcdir)/comm5.c

COMMSOS = \
 $(srcdir)/commsos.c

COMMSET = \
 $(srcdir)/commset1.c \
 $(srcdir)/commset2.c

QUERY = $(srcdir)/query.c

APPENDIX1 = $(srcdir)/appendix.1
APPENDIX2 = $(srcdir)/appendix.2
APPENDIX3 = $(srcdir)/appendix.3
APPENDIX4 = $(srcdir)/appendix.4
APPENDIX7 = $(srcdir)/appendix.7
APPENDIX = $(APPENDIX1) $(APPENDIX2) $(APPENDIX3) $(APPENDIX4) $(APPENDIX7)

GLOSSARY = $(srcdir)/glossary
OVERVIEW = $(srcdir)/overview

H0=	./config.h $(srcdir)/regex.h
H1=	./config.h $(srcdir)/the.h $(srcdir)/vars.h $(srcdir)/thedefs.h $(srcdir)/proto.h
H2=	./config.h $(srcdir)/the.h $(srcdir)/vars.h $(srcdir)/command.h $(srcdir)/thedefs.h $(srcdir)/proto.h $(srcdir)/getch.h $(srcdir)/key.h
H3=	./config.h $(srcdir)/getch.h $(srcdir)/vars.h $(srcdir)/thedefs.h $(srcdir)/proto.h
H4=	./config.h $(srcdir)/the.h $(srcdir)/vars.h $(srcdir)/query.h $(srcdir)/thedefs.h $(srcdir)/proto.h
H5=	./config.h $(srcdir)/the.h $(srcdir)/vars.h $(srcdir)/thematch.h
H6=	./config.h $(srcdir)/the.h $(srcdir)/vars.h $(srcdir)/directry.h $(srcdir)/thedefs.h $(srcdir)/proto.h
H7=	./config.h $(srcdir)/the.h $(srcdir)/vars.h $(srcdir)/therexx.h $(srcdir)/proto.h $(srcdir)/thedefs.h $(srcdir)/query.h
H8=	./config.h $(srcdir)/the.h $(srcdir)/vars.h $(srcdir)/therexx.h $(srcdir)/thedefs.h

ARCHIVE_FILES = \
 $(THE_DIR)/README $(THE_DIR)/INSTALL $(THE_DIR)/FAQ $(THE_DIR)/TODO $(THE_DIR)/COPYING $(THE_DIR)/HISTORY $(THE_DIR)/THE_Help.txt \
 $(THE_DIR)/overview $(THE_DIR)/appendix.1 $(THE_DIR)/appendix.2 $(THE_DIR)/appendix.3 $(THE_DIR)/appendix.4 $(THE_DIR)/appendix.7 $(THE_DIR)/glossary $(THE_DIR)/README.OS2 $(THE_DIR)/README.Amiga \
 $(THE_DIR)/box.c $(THE_DIR)/colour.c $(THE_DIR)/comm*.c $(THE_DIR)/cursor.c $(THE_DIR)/default.c $(THE_DIR)/directry.c $(THE_DIR)/execthe.c \
 $(THE_DIR)/edit.c $(THE_DIR)/error.c $(THE_DIR)/scroll.c $(THE_DIR)/column.c $(THE_DIR)/execute.c $(THE_DIR)/print.c $(THE_DIR)/alloca.c \
 $(THE_DIR)/file.c $(THE_DIR)/thematch.c $(THE_DIR)/getch.c $(THE_DIR)/mygetopt.c $(THE_DIR)/linked.c $(THE_DIR)/mouse.c $(THE_DIR)/memory.c \
 $(THE_DIR)/nonansi.c $(THE_DIR)/os2eas.c $(THE_DIR)/prefix.c $(THE_DIR)/query.c $(THE_DIR)/query2.c $(THE_DIR)/query1.c $(THE_DIR)/reserved.c $(THE_DIR)/parser.c $(THE_DIR)/regex.c \
 $(THE_DIR)/rexx.c $(THE_DIR)/show.c $(THE_DIR)/single.c $(THE_DIR)/sort.c $(THE_DIR)/target.c $(THE_DIR)/the.c $(THE_DIR)/trace.c $(THE_DIR)/util.c \
 $(THE_DIR)/command.h $(THE_DIR)/thedefs.h $(THE_DIR)/directry.h $(THE_DIR)/thematch.h $(THE_DIR)/getch.h $(THE_DIR)/vars.h $(THE_DIR)/regex.h $(THE_DIR)/mygetopt.h \
 $(THE_DIR)/key.h $(THE_DIR)/query.h $(THE_DIR)/proto.h $(THE_DIR)/therexx.h $(THE_DIR)/the.h $(THE_DIR)/contrib/*.c $(THE_DIR)/contrib/*.h \
 $(THE_DIR)/manext.c $(THE_DIR)/*.rsp $(THE_DIR)/*.def $(THE_DIR)/*.diz $(THE_DIR)/files.rcs $(THE_DIR)/the*.xbm \
 $(THE_DIR)/*.ico $(THE_DIR)/the.res $(THE_DIR)/*.rc $(THE_DIR)/the.eas $(THE_DIR)/doc/THE_Help* $(THE_DIR)/doc/*.htm $(THE_DIR)/doc/*.the $(THE_DIR)/doc/*.gif \
 $(THE_DIR)/append.the $(THE_DIR)/comm.the $(THE_DIR)/uncomm.the $(THE_DIR)/total.the $(THE_DIR)/match.the $(THE_DIR)/rm.the $(THE_DIR)/build.the $(THE_DIR)/setbuild.the $(THE_DIR)/nl.the \
 $(THE_DIR)/words.the $(THE_DIR)/l.the $(THE_DIR)/compile.the $(THE_DIR)/spell.the $(THE_DIR)/demo.the $(THE_DIR)/demo.txt $(THE_DIR)/cua.the $(THE_DIR)/config.the $(THE_DIR)/tags.the \
 $(THE_DIR)/codecomp.the $(THE_DIR)/syntax.the $(THE_DIR)/complete.the \
 $(THE_DIR)/the.nsi $(THE_DIR)/the.ver \
 $(THE_DIR)/*.mak $(THE_DIR)/*.tld $(THE_DIR)/thedit.lnk $(THE_DIR)/the.1 \
 $(THE_DIR)/common/config.guess $(THE_DIR)/common/config.sub $(THE_DIR)/install-sh \
 $(THE_DIR)/aclocal.m4 $(THE_DIR)/configure.in $(THE_DIR)/common/accommon.m4 $(THE_DIR)/common/*.nsh \
 $(THE_DIR)/Makefile.in $(THE_DIR)/config.h.in $(THE_DIR)/configure \
 $(THE_DIR)/man2html.rex $(THE_DIR)/man2hv.rex $(THE_DIR)/makehtml.rex $(THE_DIR)/makehv.rex $(THE_DIR)/makedist.cmd $(THE_DIR)/tld2c.rex \
 $(THE_DIR)/THE*.spec $(THE_DIR)/the64.xpm $(THE_DIR)/images/*.png $(THE_DIR)/descrip.mms $(THE_DIR)/build.com \
 $(THE_DIR)/syntax/*.syntax \
 $(THE_DIR)/debian/compat $(THE_DIR)/debian/control $(THE_DIR)/debian/copyright $(THE_DIR)/debian/rules $(THE_DIR)/debian/changelog

################################################################################
all:	$(THEBIN) the the.man THE_Help.txt

the.man:	manext $(OVERVIEW) $(COMM) $(COMMSOS) $(COMMSET) $(QUERY) $(APPENDIX) $(GLOSSARY)
	-chmod u+w *
	-cp $(docdir)/* .
	./manext $(OVERVIEW) $(COMM) $(COMMSOS) $(COMMSET) $(QUERY) $(APPENDIX) $(GLOSSARY) > the.man

THE_Help.txt:	manext $(COMM) $(COMMSET) $(COMMSOS) $(docdir)/THE_Help_head $(docdir)/THE_Help_set $(docdir)/THE_Help_sos $(docdir)/THE_Help_tail
	-chmod u+w *
	-cp $(docdir)/* .
	echo "                         THE Quick Reference" > THE_Help_part01
	echo "                             Version $(VERSION)" > THE_Help_part02
	cp THE_Help_head THE_Help_part03
	./manext -q $(COMM) > THE_Help_part04
	cp THE_Help_set THE_Help_part05
	./manext -q $(COMMSET) > THE_Help_part06
	cp THE_Help_sos THE_Help_part07
	./manext -q $(COMMSOS) > THE_Help_part08
	cp THE_Help_tail THE_Help_part09
	cat THE_Help_part?? > THE_Help.txt
	rm -f THE_Help_*

doc/html:
	mkdir -p doc/html

html:	manext doc/html
	-rm -fr *$(HTML_EXT) *.man
	cp $(imagedir)/the64.png .
	rexx $(srcdir)/makehtml.rex src=$(srcdir) ext=$(HTML_EXT) ver=$(VERSION) dest=. doc=$(docdir) \
		overview=$(OVERVIEW)  \
		comm=$(COMM)      \
		commset=$(COMMSET)   \
		commsos=$(COMMSOS)   \
		query=$(QUERY)     \
		glossary=$(GLOSSARY)  \
		appendix1=$(APPENDIX1) \
		appendix2=$(APPENDIX2) \
		appendix3=$(APPENDIX3) \
		appendix4=$(APPENDIX4) \
		appendix7=$(APPENDIX7)

doc/helpviewer:
	mkdir -p doc/helpviewer

helpviewer: manext doc/helpviewer
	-rm -f *$(HTML_EXT) *.man comm/* commsos/* commset/* misc/*
	cp $(imagedir)/the64.png .
	rexx $(srcdir)/makehv.rex src=$(srcdir) ext=$(HTML_EXT) ver=$(VERSION) dest=. doc=$(docdir) \
		overview=$(OVERVIEW)  \
		comm=$(COMM)      \
		commset=$(COMMSET)   \
		commsos=$(COMMSOS)   \
		query=$(QUERY)     \
		glossary=$(GLOSSARY)  \
		appendix1=$(APPENDIX1) \
		appendix2=$(APPENDIX2) \
		appendix3=$(APPENDIX3) \
		appendix4=$(APPENDIX4) \
		appendix7=$(APPENDIX7)

doc/combined:
	mkdir -p doc/combined

combined: doc/combined
	-rm -fr doc/combined/*$(HTML_EXT) doc/combined/*.man doc/combined/comm/* doc/combined/commsos/* doc/combined/commset/* doc/combined/misc/*
	cp $(imagedir)/the64.png doc/combined
	rexx $(srcdir)/makehtml.rex src=$(srcdir) ext=$(HTML_EXT) ver=$(VERSION) dest=doc/combined doc=$(docdir) \
		overview=$(OVERVIEW)  \
		comm=$(COMM)      \
		commset=$(COMMSET)   \
		commsos=$(COMMSOS)   \
		query=$(QUERY)     \
		glossary=$(GLOSSARY)  \
		appendix1=$(APPENDIX1) \
		appendix2=$(APPENDIX2) \
		appendix3=$(APPENDIX3) \
		appendix4=$(APPENDIX4) \
		appendix7=$(APPENDIX7)
	./$(THEBIN) -w 15000 -b -p $(docdir)/preparecomb.the \
		doc/combined/index$(HTML_EXT) \
		doc/combined/overview$(HTML_EXT) \
		doc/combined/comm$(HTML_EXT) \
		doc/combined/commset$(HTML_EXT) \
		doc/combined/commsos$(HTML_EXT) \
		doc/combined/query$(HTML_EXT) \
		doc/combined/glossary$(HTML_EXT) \
		doc/combined/app1$(HTML_EXT) \
		doc/combined/app2$(HTML_EXT) \
		doc/combined/app3$(HTML_EXT) \
		doc/combined/app4$(HTML_EXT) \
		doc/combined/app5$(HTML_EXT) \
		doc/combined/app6$(HTML_EXT) \
		doc/combined/app7$(HTML_EXT) \
		doc/combined/history$(HTML_EXT) \
		doc/combined/quickref$(HTML_EXT) \
		doc/combined/fdl$(HTML_EXT)
	cat doc/combined/index$(HTML_EXT).new \
		doc/combined/overview$(HTML_EXT).new \
		doc/combined/comm$(HTML_EXT).new \
		doc/combined/commset$(HTML_EXT).new \
		doc/combined/commsos$(HTML_EXT).new \
		doc/combined/query$(HTML_EXT).new \
		doc/combined/glossary$(HTML_EXT).new \
		doc/combined/app1$(HTML_EXT).new \
		doc/combined/app2$(HTML_EXT).new \
		doc/combined/app3$(HTML_EXT).new \
		doc/combined/app4$(HTML_EXT).new \
		doc/combined/app5$(HTML_EXT).new \
		doc/combined/app6$(HTML_EXT).new \
		doc/combined/app7$(HTML_EXT).new \
		doc/combined/history$(HTML_EXT).new \
		doc/combined/quickref$(HTML_EXT).new \
		doc/combined/fdl$(HTML_EXT)> \
		doc/combined/THE-$(VERSION)$(HTML_EXT).save
	rm -f doc/combined/*.new doc/combined/*.man doc/combined/*.html
	mv doc/combined/THE-$(VERSION)$(HTML_EXT).save doc/combined/THE-$(VERSION)$(HTML_EXT)

doc/pdf:
	mkdir -p doc/pdf

pdf: doc/pdf
	-rm -fr doc/pdf/*$(HTML_EXT) doc/pdf/*.man doc/pdf/comm/* doc/pdf/commsos/* doc/pdf/commset/* doc/pdf/misc/*
	cp $(docdir)/*.gif doc/pdf
	cp $(docdir)/title.htm doc/pdf/title$(HTML_EXT)
	rexx $(srcdir)/makehtml.rex src=$(srcdir) ext=$(HTML_EXT) ver=$(VERSION) dest=doc/pdf doc=$(docdir) \
		overview=$(OVERVIEW)  \
		comm=$(COMM)      \
		commset=$(COMMSET)   \
		commsos=$(COMMSOS)   \
		query=$(QUERY)     \
		glossary=$(GLOSSARY)  \
		appendix1=$(APPENDIX1) \
		appendix2=$(APPENDIX2) \
		appendix3=$(APPENDIX3) \
		appendix4=$(APPENDIX4) \
		appendix7=$(APPENDIX7)
	./$(THEBIN) -w 15000 -b -p $(docdir)/preparecomb.the -a "pdf $(VERSION)" \
		doc/pdf/title$(HTML_EXT) \
		doc/pdf/overview$(HTML_EXT) \
		doc/pdf/comm$(HTML_EXT) \
		doc/pdf/commset$(HTML_EXT) \
		doc/pdf/commsos$(HTML_EXT) \
		doc/pdf/query$(HTML_EXT) \
		doc/pdf/glossary$(HTML_EXT) \
		doc/pdf/app1$(HTML_EXT) \
		doc/pdf/app2$(HTML_EXT) \
		doc/pdf/app3$(HTML_EXT) \
		doc/pdf/app4$(HTML_EXT) \
		doc/pdf/app5$(HTML_EXT) \
		doc/pdf/app6$(HTML_EXT) \
		doc/pdf/app7$(HTML_EXT) \
		doc/pdf/history$(HTML_EXT) \
		doc/pdf/quickref$(HTML_EXT) \
		doc/pdf/fdl$(HTML_EXT) title$(HTML_EXT)
	-htmldoc -v --firstpage p1 --titlefile doc/pdf/title$(HTML_EXT).new --compression=9 --bodycolor "#FFFFFF" --size universal -f doc/pdf/THE-$(VERSION).pdf doc/pdf/overview$(HTML_EXT).new doc/pdf/comm$(HTML_EXT).new doc/pdf/commset$(HTML_EXT).new doc/pdf/commsos$(HTML_EXT).new doc/pdf/query$(HTML_EXT).new doc/pdf/glossary$(HTML_EXT).new doc/pdf/app1$(HTML_EXT).new doc/pdf/app2$(HTML_EXT).new doc/pdf/app3$(HTML_EXT).new doc/pdf/app4$(HTML_EXT).new doc/pdf/app5$(HTML_EXT).new doc/pdf/app6$(HTML_EXT).new doc/pdf/app7$(HTML_EXT).new doc/pdf/history$(HTML_EXT).new doc/pdf/quickref$(HTML_EXT).new doc/pdf/fdl$(HTML_EXT).new
	rm -f doc/pdf/*.new doc/pdf/*.man doc/pdf/*.html doc/pdf/*.gif

website: helpviewer
	-mkdir images
	-cp $(srcdir)/images/*.png images
	-rm thedoc*.zip
	zip -r thedoc$(VERSION_NODOT) index.html images comm commset commsos misc

perminstall:
	-chmod u+x $(INSTALL)

install: perminstall $(BASE_INSTALL)

uninstall: un$(BASE_INSTALL)

installbase: $(THEBIN) the the.man THE_Help.txt installrpm installdoc installcommon

uninstallbase: uninstallrpm uninstalldoc uninstallcommon

installrpm: perminstall $(THEBIN)
	$(INSTALL) -m 755 -d $(DESTDIR)$(bindir)
	$(INSTALL) -m 755 -c ./$(THEBIN) $(DESTDIR)$(bindir)/$(THEBIN)
	$(INSTALL) -m 755 -c ./the $(DESTDIR)$(bindir)/the

uninstallrpm: $(THEBIN)
	-rm -f $(DESTDIR)$(bindir)/the
	-rm -f $(DESTDIR)$(bindir)/$(THEBIN)
	-rmdir $(DESTDIR)$(bindir)

installdoc: the.man THE_Help.txt helpviewer

installcommon: perminstall
	$(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
	$(INSTALL) -m 644 -c $(srcdir)/the.1        $(DESTDIR)$(mandir)/man1/the.1
	gzip -f $(DESTDIR)$(mandir)/man1/the.1
	$(INSTALL) -m 755 -d $(DESTDIR)$(datadir)/THE
	$(INSTALL) -m 644 -c ./THE_Help.txt         $(DESTDIR)$(datadir)/THE/THE_Help.txt
	$(INSTALL) -m 644 -c $(srcdir)/append.the   $(DESTDIR)$(datadir)/THE/append.the
	$(INSTALL) -m 644 -c $(srcdir)/comm.the     $(DESTDIR)$(datadir)/THE/comm.the
	$(INSTALL) -m 644 -c $(srcdir)/build.the    $(DESTDIR)$(datadir)/THE/build.the
	$(INSTALL) -m 644 -c $(srcdir)/uncomm.the   $(DESTDIR)$(datadir)/THE/uncomm.the
	$(INSTALL) -m 644 -c $(srcdir)/total.the    $(DESTDIR)$(datadir)/THE/total.the
	$(INSTALL) -m 644 -c $(srcdir)/match.the    $(DESTDIR)$(datadir)/THE/match.the
	$(INSTALL) -m 644 -c $(srcdir)/rm.the       $(DESTDIR)$(datadir)/THE/rm.the
	$(INSTALL) -m 644 -c $(srcdir)/nl.the       $(DESTDIR)$(datadir)/THE/nl.the
	$(INSTALL) -m 644 -c $(srcdir)/words.the    $(DESTDIR)$(datadir)/THE/words.the
	$(INSTALL) -m 644 -c $(srcdir)/l.the        $(DESTDIR)$(datadir)/THE/l.the
	$(INSTALL) -m 644 -c $(srcdir)/compile.the  $(DESTDIR)$(datadir)/THE/compile.the
	$(INSTALL) -m 644 -c $(srcdir)/spell.the    $(DESTDIR)$(datadir)/THE/spell.the
	$(INSTALL) -m 644 -c $(srcdir)/demo.the     $(DESTDIR)$(datadir)/THE/demo.the
	$(INSTALL) -m 644 -c $(srcdir)/cua.the      $(DESTDIR)$(datadir)/THE/cua.the
	$(INSTALL) -m 644 -c $(srcdir)/config.the   $(DESTDIR)$(datadir)/THE/config.the
	$(INSTALL) -m 644 -c $(srcdir)/tags.the     $(DESTDIR)$(datadir)/THE/tags.the
	$(INSTALL) -m 644 -c $(srcdir)/codecomp.the $(DESTDIR)$(datadir)/THE/codecomp.the
	$(INSTALL) -m 644 -c $(srcdir)/complete.the $(DESTDIR)$(datadir)/THE/complete.the
	$(INSTALL) -m 644 -c $(srcdir)/syntax.the   $(DESTDIR)$(datadir)/THE/syntax.the
	for a in $(srcdir)/*.tld; do \
		bn=`basename $$a`; \
		$(INSTALL) -m 644 -c $$a $(DESTDIR)$(datadir)/THE/$$bn; \
	done;
	for a in $(srcdir)/syntax/*.syntax; do \
		bn=`basename $$a`; \
		$(INSTALL) -m 644 -c $$a $(DESTDIR)$(datadir)/THE/$$bn; \
	done;

uninstalldoc:

uninstallcommon:
	-rm -f $(DESTDIR)$(mandir)/man1/the.1.gz
	-rm -f $(DESTDIR)$(datadir)/THE/THE_Help.txt
	-rm -f $(DESTDIR)$(datadir)/THE/append.the
	-rm -f $(DESTDIR)$(datadir)/THE/comm.the
	-rm -f $(DESTDIR)$(datadir)/THE/build.the
	-rm -f $(DESTDIR)$(datadir)/THE/uncomm.the
	-rm -f $(DESTDIR)$(datadir)/THE/total.the
	-rm -f $(DESTDIR)$(datadir)/THE/match.the
	-rm -f $(DESTDIR)$(datadir)/THE/rm.the
	-rm -f $(DESTDIR)$(datadir)/THE/nl.the
	-rm -f $(DESTDIR)$(datadir)/THE/words.the
	-rm -f $(DESTDIR)$(datadir)/THE/l.the
	-rm -f $(DESTDIR)$(datadir)/THE/compile.the
	-rm -f $(DESTDIR)$(datadir)/THE/spell.the
	-rm -f $(DESTDIR)$(datadir)/THE/demo.the
	-rm -f $(DESTDIR)$(datadir)/THE/cua.the
	-rm -f $(DESTDIR)$(datadir)/THE/config.the
	-rm -f $(DESTDIR)$(datadir)/THE/tags.the
	-rm -f $(DESTDIR)$(datadir)/THE/codecomp.the
	-rm -f $(DESTDIR)$(datadir)/THE/syntax.the
	for a in $(srcdir)/*.tld; do \
		bn=`basename $$a`; \
		rm -f $(DESTDIR)$(datadir)/THE/$$bn; \
	done;
	for a in $(srcdir)/syntax/*.syntax; do \
		bn=`basename $$a`; \
		rm -f $(DESTDIR)$(datadir)/THE/$$bn; \
	done;
	-rmdir $(DESTDIR)$(datadir)/THE

binary: $(BASE_BINARY)

binarybase: $(THEBIN) the the.man THE_Help.txt
	-rm -fr ./tmpdir
	$(INSTALL) -m 755 -d ./tmpdir/bin
	$(INSTALL) -m 755 -d ./tmpdir/man/man1
	$(INSTALL) -m 755 -d ./tmpdir/share/THE
	$(INSTALL) -m 755 -c ./$(THEBIN) ./tmpdir/bin/$(THEBIN)
	$(INSTALL) -m 755 -c ./the ./tmpdir/bin/the
	$(INSTALL) -m 644 -c $(srcdir)/the.1 ./tmpdir/man/man1/the.1
	$(INSTALL) -m 644 -c ./THE_Help.txt ./tmpdir/share/THE/THE_Help.txt
	$(INSTALL) -m 644 -c $(srcdir)/append.the   ./tmpdir/share/THE/append.the
	$(INSTALL) -m 644 -c $(srcdir)/comm.the     ./tmpdir/share/THE/comm.the
	$(INSTALL) -m 644 -c $(srcdir)/build.the    ./tmpdir/share/THE/build.the
	$(INSTALL) -m 644 -c $(srcdir)/uncomm.the   ./tmpdir/share/THE/uncomm.the
	$(INSTALL) -m 644 -c $(srcdir)/total.the    ./tmpdir/share/THE/total.the
	$(INSTALL) -m 644 -c $(srcdir)/match.the    ./tmpdir/share/THE/match.the
	$(INSTALL) -m 644 -c $(srcdir)/rm.the       ./tmpdir/share/THE/rm.the
	$(INSTALL) -m 644 -c $(srcdir)/nl.the       ./tmpdir/share/THE/nl.the
	$(INSTALL) -m 644 -c $(srcdir)/words.the    ./tmpdir/share/THE/words.the
	$(INSTALL) -m 644 -c $(srcdir)/l.the        ./tmpdir/share/THE/l.the
	$(INSTALL) -m 644 -c $(srcdir)/compile.the  ./tmpdir/share/THE/compile.the
	$(INSTALL) -m 644 -c $(srcdir)/spell.the    ./tmpdir/share/THE/spell.the
	$(INSTALL) -m 644 -c $(srcdir)/demo.the     ./tmpdir/share/THE/demo.the
	$(INSTALL) -m 644 -c $(srcdir)/cua.the      ./tmpdir/share/THE/cua.the
	$(INSTALL) -m 644 -c $(srcdir)/config.the   ./tmpdir/share/THE/config.the
	$(INSTALL) -m 644 -c $(srcdir)/tags.the     ./tmpdir/share/THE/tags.the
	$(INSTALL) -m 644 -c $(srcdir)/codecomp.the ./tmpdir/share/THE/codecomp.the
	$(INSTALL) -m 644 -c $(srcdir)/complete.the ./tmpdir/share/THE/complete.the
	$(INSTALL) -m 644 -c $(srcdir)/syntax.the   ./tmpdir/share/THE/syntax.the
	for a in $(srcdir)/*.tld; do \
		bn=`basename $$a`; \
		$(INSTALL) -m 644 -c $$a ./tmpdir/share/THE/$$bn; \
	done;
	for a in $(srcdir)/syntax/*.syntax; do \
		bn=`basename $$a`; \
		$(INSTALL) -m 644 -c $$a ./tmpdir/share/THE/$$bn; \
	done;
	(cd ./tmpdir; \
	tar cvf - * | gzip > ../THE-$(THETYPE)-regina-$(VERSION)-$(MACH_ARCH)-$(MYDISTRO).tgz )

cygwinbinary: the.exe the.man THE_Help.txt
	-rm -fr ./tmpdir
	$(INSTALL) -m 755 -d ./tmpdir/usr/bin
	$(INSTALL) -m 755 -d ./tmpdir/usr/man/man1
	$(INSTALL) -m 755 -d ./tmpdir/usr/share/THE
	$(INSTALL) -m 755 -c ./the.exe ./tmpdir/usr/bin/the.exe
	$(INSTALL) -m 644 -c $(srcdir)/the.1 ./tmpdir/usr/man/man1/the.1
	$(INSTALL) -m 644 -c ./THE_Help.txt ./tmpdir/usr/share/THE/THE_Help.txt
	$(INSTALL) -m 644 -c $(srcdir)/append.the   ./tmpdir/usr/share/THE/append.the
	$(INSTALL) -m 644 -c $(srcdir)/comm.the     ./tmpdir/usr/share/THE/comm.the
	$(INSTALL) -m 644 -c $(srcdir)/build.the    ./tmpdir/usr/share/THE/build.the
	$(INSTALL) -m 644 -c $(srcdir)/uncomm.the   ./tmpdir/usr/share/THE/uncomm.the
	$(INSTALL) -m 644 -c $(srcdir)/total.the    ./tmpdir/usr/share/THE/total.the
	$(INSTALL) -m 644 -c $(srcdir)/match.the    ./tmpdir/usr/share/THE/match.the
	$(INSTALL) -m 644 -c $(srcdir)/rm.the       ./tmpdir/usr/share/THE/rm.the
	$(INSTALL) -m 644 -c $(srcdir)/nl.the       ./tmpdir/usr/share/THE/nl.the
	$(INSTALL) -m 644 -c $(srcdir)/words.the    ./tmpdir/usr/share/THE/words.the
	$(INSTALL) -m 644 -c $(srcdir)/l.the        ./tmpdir/usr/share/THE/l.the
	$(INSTALL) -m 644 -c $(srcdir)/compile.the  ./tmpdir/usr/share/THE/compile.the
	$(INSTALL) -m 644 -c $(srcdir)/spell.the    ./tmpdir/usr/share/THE/spell.the
	$(INSTALL) -m 644 -c $(srcdir)/demo.the     ./tmpdir/usr/share/THE/demo.the
	$(INSTALL) -m 644 -c $(srcdir)/cua.the      ./tmpdir/usr/share/THE/cua.the
	$(INSTALL) -m 644 -c $(srcdir)/config.the   ./tmpdir/usr/share/THE/config.the
	$(INSTALL) -m 644 -c $(srcdir)/tags.the     ./tmpdir/usr/share/THE/tags.the
	$(INSTALL) -m 644 -c $(srcdir)/codecomp.the ./tmpdir/usr/share/THE/codecomp.the
	$(INSTALL) -m 644 -c $(srcdir)/complete.the ./tmpdir/usr/share/THE/complete.the
	$(INSTALL) -m 644 -c $(srcdir)/syntax.the   ./tmpdir/usr/share/THE/syntax.the
	for a in $(srcdir)/*.tld; do \
		bn=`basename $$a`; \
		$(INSTALL) -m 644 -c $$a ./tmpdir/share/THE/$$bn; \
	done;
	for a in $(srcdir)/syntax/*.syntax; do \
		bn=`basename $$a`; \
		$(INSTALL) -m 644 -c $$a ./tmpdir/share/THE/$$bn; \
	done;
	(cd ./tmpdir; \
	tar cvf - * | gzip > ../THE-$(THETYPE)-$(VERSION)-$(target).tgz )

clean:
	-rm -f *.o trace $(THEBIN) the manext *.man *$(HTML_EXT) *.new config.log config.cache config.status

distclean: clean
	-rm -f Makefile

docclean:
	-rm -fr *.man *$(HTML_EXT) *.png *.new misc comm commset commsos images

mostlyclean: clean

realclean: distclean

#------------------------------------------------------------------------

XTRA_OBJS =  

OBJS =      \
	box.o      \
	colour.o   \
	column.o   \
	comm1.o    \
	comm2.o    \
	comm3.o    \
	comm4.o    \
	comm5.o    \
	commset1.o \
	commset2.o \
	commsos.o  \
	commutil.o \
	cursor.o   \
	default.o  \
	directry.o \
	edit.o     \
	error.o    \
	execute.o  \
	file.o     \
	thematch.o \
	getch.o    \
	linked.o   \
	mouse.o    \
	memory.o   \
	nonansi.o  \
	parser.o   \
	prefix.o   \
	print.o    \
	query.o    \
	query1.o   \
	query2.o   \
	regex.o    \
	reserved.o \
	rexx.o     \
	scroll.o   \
	show.o     \
	single.o   \
	sort.o     \
	target.o   \
	the.o      \
	mygetopt.o \
	util.o

the: execthe.o mygetopt.o
	$(LINK) execthe.o mygetopt.o -o the $(THELDFLAGS)

xthe: $(OBJS) $(XTRA_OBJS)
	$(LINK) $(OBJS) $(XTRA_OBJS) -o xthe $(LDFLAGS)

xwthe: $(OBJS) $(XTRA_OBJS)
	$(LINK) $(OBJS) $(XTRA_OBJS) -o xwthe $(LDFLAGS)

nthe: $(OBJS) $(XTRA_OBJS)
	$(LINK) $(OBJS) $(XTRA_OBJS) -o nthe $(LDFLAGS)

nwthe: $(OBJS) $(XTRA_OBJS)
	$(LINK) $(OBJS) $(XTRA_OBJS) -o nwthe $(LDFLAGS)

box.o: $(srcdir)/box.c $(H1)
	$(CC) $(CCFLAGS) -o box.o $(srcdir)/box.c

colour.o: $(srcdir)/colour.c $(H1)
	$(CC) $(CCFLAGS) -o colour.o $(srcdir)/colour.c

column.o: $(srcdir)/column.c $(H1)
	$(CC) $(CCFLAGS) -o column.o $(srcdir)/column.c

comm1.o: $(srcdir)/comm1.c $(H1)
	$(CC) $(CCFLAGS) -o comm1.o $(srcdir)/comm1.c

comm2.o: $(srcdir)/comm2.c $(H1)
	$(CC) $(CCFLAGS) -o comm2.o $(srcdir)/comm2.c

comm3.o: $(srcdir)/comm3.c $(H1)
	$(CC) $(CCFLAGS) -o comm3.o $(srcdir)/comm3.c

comm4.o: $(srcdir)/comm4.c $(H1)
	$(CC) $(CCFLAGS) -o comm4.o $(srcdir)/comm4.c

comm5.o: $(srcdir)/comm5.c $(H1)
	$(CC) $(CCFLAGS) -o comm5.o $(srcdir)/comm5.c

commset1.o: $(srcdir)/commset1.c $(H1)
	$(CC) $(CCFLAGS) -o commset1.o $(srcdir)/commset1.c

commset2.o: $(srcdir)/commset2.c $(H1)
	$(CC) $(CCFLAGS) -o commset2.o $(srcdir)/commset2.c

commsos.o: $(srcdir)/commsos.c $(H1)
	$(CC) $(CCFLAGS) -o commsos.o $(srcdir)/commsos.c

commutil.o: $(srcdir)/commutil.c $(H2)
	$(CC) $(CCFLAGS) -o commutil.o $(srcdir)/commutil.c

cursor.o: $(srcdir)/cursor.c $(H1)
	$(CC) $(CCFLAGS) -o cursor.o $(srcdir)/cursor.c

default.o: $(srcdir)/default.c $(H1)
	$(CC) $(CCFLAGS) -o default.o $(srcdir)/default.c

directry.o: $(srcdir)/directry.c $(H6)
	$(CC) $(CCFLAGS) -o directry.o $(srcdir)/directry.c

edit.o: $(srcdir)/edit.c $(H1)
	$(CC) $(CCFLAGS) -o edit.o $(srcdir)/edit.c

error.o: $(srcdir)/error.c $(H1)
	$(CC) $(CCFLAGS) -o error.o $(srcdir)/error.c

execute.o: $(srcdir)/execute.c $(H1)
	$(CC) $(CCFLAGS) -o execute.o $(srcdir)/execute.c

file.o: $(srcdir)/file.c $(H6)
	$(CC) $(CCFLAGS) -o file.o $(srcdir)/file.c

thematch.o: $(srcdir)/thematch.c $(H5)
	$(CC) $(CCFLAGS) -o thematch.o $(srcdir)/thematch.c

getch.o: $(srcdir)/getch.c $(H3)
	$(CC) $(CCFLAGS) -o getch.o $(srcdir)/getch.c

mygetopt.o: $(srcdir)/mygetopt.c $(H1)
	$(CC) $(CCFLAGS) -o mygetopt.o $(srcdir)/mygetopt.c

linked.o: $(srcdir)/linked.c $(H1)
	$(CC) $(CCFLAGS) -o linked.o $(srcdir)/linked.c

mouse.o: $(srcdir)/mouse.c $(H1)
	$(CC) $(CCFLAGS) -o mouse.o $(srcdir)/mouse.c

memory.o: $(srcdir)/memory.c $(H1)
	$(CC) $(CCFLAGS) -o memory.o $(srcdir)/memory.c

nonansi.o: $(srcdir)/nonansi.c $(H1)
	$(CC) $(CCFLAGS) -o nonansi.o $(srcdir)/nonansi.c

parser.o: $(srcdir)/parser.c $(H1)
	$(CC) $(CCFLAGS) -o parser.o $(srcdir)/parser.c

os2eas.o: $(srcdir)/os2eas.c $(H1)
	$(CC) $(CCFLAGS) -o os2eas.o $(srcdir)/os2eas.c

prefix.o: $(srcdir)/prefix.c $(H1)
	$(CC) $(CCFLAGS) -o prefix.o $(srcdir)/prefix.c

print.o: $(srcdir)/print.c $(H1)
	$(CC) $(CCFLAGS) -o print.o $(srcdir)/print.c

query.o: $(srcdir)/query.c $(H4)
	$(CC) $(CCFLAGS) -o query.o $(srcdir)/query.c

query1.o: $(srcdir)/query1.c $(H4)
	$(CC) $(CCFLAGS) -o query1.o $(srcdir)/query1.c

query2.o: $(srcdir)/query2.c $(H4)
	$(CC) $(CCFLAGS) -o query2.o $(srcdir)/query2.c

regex.o: $(srcdir)/regex.c $(H0)
	$(CC) $(CCFLAGS) -o regex.o $(srcdir)/regex.c

reserved.o: $(srcdir)/reserved.c $(H1)
	$(CC) $(CCFLAGS) -o reserved.o $(srcdir)/reserved.c

rexx.o: $(srcdir)/rexx.c $(H7)
	$(CC) $(CCFLAGS) -o rexx.o $(srcdir)/rexx.c

scroll.o: $(srcdir)/scroll.c $(H1)
	$(CC) $(CCFLAGS) -o scroll.o $(srcdir)/scroll.c

show.o: $(srcdir)/show.c $(H1)
	$(CC) $(CCFLAGS) -o show.o $(srcdir)/show.c

single.o: $(srcdir)/single.c $(H1)
	$(CC) $(CCFLAGS) -o single.o $(srcdir)/single.c

sort.o: $(srcdir)/sort.c $(H1)
	$(CC) $(CCFLAGS) -o sort.o $(srcdir)/sort.c

target.o: $(srcdir)/target.c $(H1)
	$(CC) $(CCFLAGS) -o target.o $(srcdir)/target.c

the.o: $(srcdir)/the.c $(H1)
	$(CC) $(CCFLAGS) -DTHE_VERSION=\"$(VERSION)\" -DTHE_VERSION_DATE=\"$(VER_DATE)\" -o the.o $(srcdir)/the.c

trace.o: $(srcdir)/trace.c $(H1)
	$(CC) $(CCFLAGS) -o trace.o $(srcdir)/trace.c

util.o: $(srcdir)/util.c $(H1)
	$(CC) $(CCFLAGS) -o util.o $(srcdir)/util.c

alloca.o: $(srcdir)/alloca.c
	$(CC) $(CCFLAGS) -o alloca.o $(srcdir)/alloca.c

utf8.o: $(contribdir)/utf8.c $(H1)
	$(CC) $(CCFLAGS) -o utf8.o $(contribdir)/utf8.c


execthe.o: $(srcdir)/execthe.c $(H1)
	$(CC) $(CCFLAGS) -DTHE_VERSION=\"$(VERSION)\" -DTHE_VERSION_DATE=\"$(VER_DATE)\" -o execthe.o $(srcdir)/execthe.c


manext: manext.o
	$(LINK) manext.o -o manext

manext.o: $(srcdir)/manext.c $(srcdir)/the.h
	$(CC) $(CCFLAGS) -I$(srcdir) -o manext.o $(srcdir)/manext.c


zip:
	zip thesrc$(VERSION_NODOT) README INSTALL FAQ TODO COPYING HISTORY THE_Help.txt
	zip thesrc$(VERSION_NODOT) overview appendix.1 appendix.2 appendix.3 appendix.4 appendix.7 glossary README.OS2 README.Amiga
	zip thesrc$(VERSION_NODOT) box.c colour.c comm*.c cursor.c default.c directry.c
	zip thesrc$(VERSION_NODOT) edit.c error.c scroll.c column.c execute.c print.c alloca.c execthe.c
	zip thesrc$(VERSION_NODOT) file.c thematch.c getch.c mygetopt.c linked.c mouse.c memory.c
	zip thesrc$(VERSION_NODOT) nonansi.c os2eas.c prefix.c query.c query1.c query2.c reserved.c regex.c
	zip thesrc$(VERSION_NODOT) rexx.c show.c single.c sort.c target.c the.c trace.c util.c parser.c
	zip thesrc$(VERSION_NODOT) command.h thedefs.h directry.h thematch.h getch.h vars.h
	zip thesrc$(VERSION_NODOT) key.h query.h proto.h therexx.h the.h regex.h mygetopt.h
	zip thesrc$(VERSION_NODOT) manext.c *.rsp *.def *.diz files.rcs the*.xbm *.ico the.res *.rc the.eas
	zip thesrc$(VERSION_NODOT) append.the comm.the uncomm.the total.the match.the rm.the build.the nl.the syntax.the complete.the
	zip thesrc$(VERSION_NODOT) words.the l.the compile.the spell.the demo.the demo.txt cua.the config.the tags.the
	zip thesrc$(VERSION_NODOT) Makefile.in configure config.h.in $(contribdir)/*.c  $(contribdir)/*.h
	zip thesrc$(VERSION_NODOT) *.tld *.mak thedit.lnk $(docdir)/THE_Help* $(docdir)/*.htm $(docdir)/*.the
	zip thesrc$(VERSION_NODOT) common/config.guess common/config.sub install-sh the.1
	zip thesrc$(VERSION_NODOT) aclocal.m4 configure.in descrip.mms build.com
	zip thesrc$(VERSION_NODOT) man2html.rex man2hv.rex makehtml.rex makehv.rex makedist.cmd tld2c.rex
	zip thesrc$(VERSION_NODOT) common/accommon.m4 common/*.nsh the.nsi the.ver codecomp.the
	zip thesrc$(VERSION_NODOT) THE*.spec the64.xpm images/*.png doc/*.gif
	zip thesrc$(VERSION_NODOT) syntax/*.syntax

zzip:
	(cd $(srcdir)/..; zip thesrc$(VERSION_NODOT) $(ARCHIVE_FILES) )

dist:
	(cd $(srcdir)/..;rm -f $(THE_DIR))
	(cd $(srcdir)/..;ln -sf $(abs_srcdir) $(THE_DIR))
	(cd $(srcdir)/..;tar -cvf - $(ARCHIVE_FILES) | gzip > $(THE_DIR).tar.gz )
	(cd $(srcdir)/..;rm -f $(THE_DIR))

bzip:
	(cd $(srcdir)/..;rm -f $(THE_DIR))
	(cd $(srcdir)/..;ln -sf $(abs_srcdir) $(THE_DIR))
	(cd $(srcdir)/..;tar -cvf - $(ARCHIVE_FILES) | bzip2 > $(THE_DIR).tar.bz2 )
	(cd $(srcdir)/..;rm -f $(THE_DIR))

tar:
	(cd $(srcdir)/..; tar cvf - \
	$(ARCHIVE_FILES) \
	| compress > $(THE_DIR).tar.Z)

rpm: dist rpmtopdir
	cp $(srcdir)/the64.xpm $(RPMTOPDIR)/SOURCES
	cp $(srcdir)/../$(THE_DIR).tar.gz $(RPMTOPDIR)/SOURCES
	-rm $(RPMTOPDIR)/RPMS/*/THE-$(THETYPE)-regina-$(VERSION_UNQUOTED)-[0-9]*.rpm
	-rm $(RPMTOPDIR)/RPMS/*/THE-common-$(VERSION_UNQUOTED)-[0-9]*.rpm
	-rm $(RPMTOPDIR)/RPMS/*/THE-doc-$(VERSION_UNQUOTED)-[0-9]*.rpm
	rpmbuild -ba --clean --define "myversion $(VERSION_UNQUOTED)" --define "myrexx regina" --define "mycurses $(THETYPE)" $(srcdir)/THE.spec
	rpmbuild -bs --clean --define "myversion $(VERSION_UNQUOTED)" --define "myrexx none" --define "mycurses none" $(srcdir)/THE.spec
	mv $(RPMTOPDIR)/RPMS/*/THE-$(THETYPE)-regina-$(VERSION_UNQUOTED)-[0-9]*.rpm `dirname $(RPMTOPDIR)/RPMS/*/THE-$(THETYPE)-regina-$(VERSION_UNQUOTED)-[0-9]*.rpm`/`basename $(RPMTOPDIR)/RPMS/*/THE-$(THETYPE)-regina-$(VERSION_UNQUOTED)-[0-9]*.rpm .rpm`-$(MYDISTRO).rpm
	mv $(RPMTOPDIR)/RPMS/*/THE-common-$(VERSION_UNQUOTED)-[0-9]*.rpm `dirname $(RPMTOPDIR)/RPMS/*/THE-common-$(VERSION_UNQUOTED)-[0-9]*.rpm`/`basename $(RPMTOPDIR)/RPMS/*/THE-common-$(VERSION_UNQUOTED)-[0-9]*.rpm .rpm`-$(MYDISTRO).rpm
	mv $(RPMTOPDIR)/RPMS/*/THE-doc-$(VERSION_UNQUOTED)-[0-9]*.rpm `dirname $(RPMTOPDIR)/RPMS/*/THE-doc-$(VERSION_UNQUOTED)-[0-9]*.rpm`/`basename $(RPMTOPDIR)/RPMS/*/THE-doc-$(VERSION_UNQUOTED)-[0-9]*.rpm .rpm`-$(MYDISTRO).rpm
	ls -l $(RPMTOPDIR)/RPMS/*/THE*rpm

srcrpm: dist rpmtopdir
	cp $(srcdir)/../$(THE_DIR).tar.gz $(RPMTOPDIR)/SOURCES
	rpmbuild -ba --define "myversion $(VERSION_UNQUOTED)" $(srcdir)/THE-doc.spec

rpmtopdir:
	-mkdir -p $(RPMTOPDIR)/SOURCES
	-mkdir -p $(RPMTOPDIR)/SRPMS
	-mkdir -p $(RPMTOPDIR)/RPMS
	-mkdir -p $(RPMTOPDIR)/BUILD
	-mkdir -p $(RPMTOPDIR)/SPECS

deb: dist
	-rm -fr tmp
	-mkdir tmp
	(cd tmp; \
	tar zxvf ../../$(srcdir)/$(THE_DIR).tar.gz; \
	cd $(THE_DIR); \
	dpkg-buildpackage -rfakeroot; \
	cd ..; \
	ls -l )
