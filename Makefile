C = pdflatex
.PHONY := all clean
.DEFAULT := mgring

DIR := ./tex/

# This Makefile installs all required dependencies on Ubuntu, without any extra dependencies. The whole installation takes about 186MB+67M=253MB

hascompiler: materials
	which pdflatex || sudo apt-get install texlive-latex-base
	which pdflatex
	which xzdec || sudo apt-get install xzdec
	ls -q ~/texmf/tlpkg/texlive.tlpdb || tlmgr init-usertree && echo "initialized in ~/.texmf"
	tlmgr install mwcls setspace tex-gyre textpos ms xcolor url appendix listings lipsum
#everyshi as ms
	ls -q /usr/share/texlive/texmf-dist/fonts/source/jknappen/ec/ecrm2074.mf || sudo apt-get install texlive-fonts-recommended # Debian bug 743125 on plain tex installation

haspwr: $(DIR)/dyplom.cls
	which curl unzip || sudo apt-get install curl unzip
	ls -q "$(DIR)/dyplom.cls" || (mkdir -p ${DIR} && curl http://www.immt.pwr.wroc.pl/~myszka/TeX/dyplom/dyplom.zip | bsdtar -xv -f - -C ${DIR}) # I preffer `ls` rather than `[ -f $fname ]` aka `test -f $fname` due to easier bash expression evaluation
	#http://unix.stackexchange.com/a/125102/63341

mgring: hascompiler haspwr mgring.tex
	$C --output-directory=/dev/shm/ $@ #Translates to `pdflatex mgring`, note $< translates to first dependency (could be even indirect)

ci: mgring.tex
	# meant to provide constant monitoring of a file and compilation when content changes and is a valid file
	pdflatex --draft-mode mgring.tex
