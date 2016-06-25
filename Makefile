C = pdflatex
.PHONY := all clean
.DEFAULT := mgring

DIR := ./tex/
BUILDDIR := ./build/
VPATH = tex materials build

# This Makefile installs all required dependencies on Ubuntu, without any extra dependencies. The whole installation takes about 186MB+67M=253MB

hascompiler: materials
	which pdflatex || sudo apt-get install texlive-latex-base
	which pdflatex
	which xzdec || sudo apt-get install xzdec
	ls -q ~/texmf/tlpkg/texlive.tlpdb || tlmgr init-usertree && echo "initialized in ~/.texmf"
	tlmgr install mwcls setspace tex-gyre textpos ms xcolor url appendix listings lipsum
#everyshi as ms
	ls -q /usr/share/texlive/texmf-dist/fonts/source/jknappen/ec/ecrm2074.mf || sudo apt-get install texlive-fonts-recommended # Debian bug 743125 on plain tex installation
	mkdir -p $(BUILDDIR)
	touch $(BUILDDIR)hascompiler #this works because of VPATH containing build

dyplom.cls: 
	(mkdir -p ${BUILDDIR} && curl http://www.immt.pwr.wroc.pl/~myszka/TeX/dyplom/dyplom.zip | bsdtar -xv -f - -C ${BUILDDIR})

haspwr: dyplom.cls
	which curl unzip || sudo apt-get install curl unzip
	ls -q $< || (mkdir -p ${BUILDDIR} && curl http://www.immt.pwr.wroc.pl/~myszka/TeX/dyplom/dyplom.zip | bsdtar -xv -f - -C ${BUILDDIR}) 
	# I preffer `ls` rather than `[ -f $fname ]` aka `test -f $fname` due to easier bash expression evaluation
	#http://unix.stackexchange.com/a/125102/63341

mgring: mgring.tex hascompiler haspwr
	$C --output-directory=$(BUILDDIR) $< #Translates to `pdflatex mgring`, note $< translates to first dependency (could be even indirect)

ci: mgring.tex
	# meant to provide constant monitoring of a file and compilation when content changes and is a valid file
	echo pdflatex --draft-mode $<
