TEXC = latexmk -lualatex -output-directory=build -shell-escape

.PHONY: FORCE

all: <name>.pdf notes-<name>.pdf

<name>.pdf: <name>.tex FORCE
	$(TEXC) $<

notes-<name>.pdf: <name>.tex FORCE
	$(TEXC) -jobname=notes-<name> $<

clean: FORCE
	$(TEXC) -c

clean_all: clean FORCE
	$(RM) build -r
