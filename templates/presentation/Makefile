TEXC = latexmk -lualatex -output-directory=build -shell-escape

.PHONY: FORCE

all: show

show: <name>.pdf notes-<name>.pdf
	evince build/<name>.pdf build/notes-<name>.pdf &

present: notes-<name>.pdf
	dspdfviewer build/notes-<name>.pdf

<name>.pdf: <name>.tex FORCE
	$(TEXC) $<

notes-<name>.pdf: <name>.tex FORCE
	$(TEXC) -jobname=notes-<name> $<

clean: FORCE
	$(TEXC) -c

clean_all: clean FORCE
	$(RM) build -r
