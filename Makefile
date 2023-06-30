PAPER=paper
TALK=talk

all: latex/$(TALK).pdf

src = src

lib-agdas:=$(shell find $(src) -name '*.agda' | grep -v 'Old/')
lib-lagdas:=$(shell find $(src) -name '*.lagda.tex' | grep -v 'Old/')
lib-texs:=$(patsubst $(src)/%.lagda.tex,latex/%.tex,$(lib-lagdas))
lib-texs: $(lib-texs)

# Sanity check
test-lib-texs:
	@echo $(lib-texs)

AGDA=agda

PRECIOUS: $(lib-texs)

# LaTeX generated from literate sources
latex/%.tex: $(src)/%.lagda.tex
	@mkdir -p $(dir $@)
	${AGDA} --latex --latex-dir=latex $<

latex-deps=macros.tex unicode.tex agda-commands.tex bib.bib

latex/%.pdf: $(latex-deps) %.tex $(lib-texs) $(test-texs) $(example-texs) $(example-toks)
	latexmk -xelatex -bibtex -output-directory=latex $*.tex
	@touch $@

# The touch is in case latexmk decides not to update the pdf.

# For MacOS
SHOWPDF=open

%.see: latex/%.pdf
	${SHOWPDF} $<

see: $(PAPER).see

clean:
	rm -rf _build latex

web: .token

.token: latex/$(TALK).pdf
	scp $< conal@conal.net:/home/conal/domains/conal/htdocs/talks/galilean-revolution.pdf
	@touch $@

