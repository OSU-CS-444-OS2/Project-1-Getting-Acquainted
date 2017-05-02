#Simply type make\
   Then type ./project1
LATEX	= latex -shell-escape
BIBTEX	= bibtex
DVIPS	= dvips
DVIPDF  = dvipdft
XDVI	= xdvi -gamma 4
GH		= gv

EXAMPLES = $(wildcard *.c)
SRC	:= $(shell egrep -l '^[^%]*\\begin\{document\}' *.tex)
TRG	= $(SRC:%.tex=%.dvi)
PSF	= $(SRC:%.tex=%.ps)
PDF	= $(SRC:%.tex=%.pdf)

all: project1 pdf

pdf: $(PDF)

ps: $(PSF)

$(TRG): %.dvi: %.tex $(EXAMPLES)

	$(LATEX) $<
	#$(BIBTEX) $(<:%.tex=%)
	$(LATEX) $<
	$(LATEX) $<



$(PSF):%.ps: %.dvi
	$(DVIPS) -R -Poutline -t letter $< -o $@

$(PDF): %.pdf: %.ps
	ps2pdf $<

show: $(TRG)
	@for i in $(TRG) ; do $(XDVI) $$i & done

showps: $(PSF)
	@for i in $(PSF) ; do $(GH) $$i & done

project1: project1.o
	gcc project1.o -o project1 -pthread

project1.o:
	gcc -c project1.c -g


clean:
	rm -f *.pdf *.ps *.dvi *.out *.log *.aux *.bbl *.blg *.pyg project1 *.o *.out

.PHONY: all show clean ps pdf showps
