# latexmk parts adapted from:
# http://tex.stackexchange.com/questions/40738/how-to-properly-make-a-latex-project

paper=CUDAHM-Paper1v2

# Include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: MyDoc.pdf all clean

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: paper

# CUSTOM BUILD RULES

# Recall:  '$@' is a variable holding the name of the target,
# and '$<' is a variable holding the (first) dependency of a rule.
# "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# you might have.

#%.tex: %.raw
#	./raw2tex $< > $@

#%.tex: %.dat
#	./dat2tex $< > $@

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

paper: $(paper).tex
	latexmk -bibtex-cond -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make $(paper).tex

clean:
	latexmk -c

clobber:
	latexmk -C


UNAME := $(shell uname)
view:  $(paper).pdf
ifeq ($(UNAME),Darwin)
	open -a Skim $(paper).pdf
else
	acroread -openInNewWindow -geometry 800x825 $(paper).pdf &
endif


# "make refs" requires a local copy of the .bst file.
# Creates a .bbl file that will be read by the main document.
refs:  $(paper).tex XMATCH.bib
	bibtex $(paper)
	echo '***** FIX ANY REF FORMAT PROBLEMS THAT MAY BE IN BBL FILE!!! *****'

# Bundling targets:
#
# The file lists are partly found using tex_file_list.py.

ARXIV_FIGS = Orion-Optical+ROSAT+labeled.eps GRBs-250+close39.eps CR+LocalAGN-all-bare.eps SDSS-2MASS-Galex-SMongo.eps PairMLMs-Singlets+Doublet-omega.eps DoubletBF.eps pm1.eps pm2.eps S+14-LIGO+Virgo-DrxnPDFs.eps
JCGS_FIGS = 
ARXIV_INPUTS = ar-1col.cls ar-style1.bst

arxiv:
	tar czf arxiv.tgz $(paper).tex $(paper).bbl \
	$(ARXIV_INPUTS) $(ARXIV_FIGS)
	mkdir test
	tar -C test -xf arxiv.tgz
	echo 'arxiv.tgz created and upacked into "test" folder; test and delete...'

jcgs:
	tar czf arsa.tgz $(paper).tex $(paper).bbl $(paper).pdf \
	$(ARXIV_INPUTS) $(ARXIV_FIGS) $(ARSA_FIGS)
	mkdir test
	tar -C test -xf jcgs.tgz
	echo 'jcgs.tgz created and upacked into "test" folder; test and delete...'
