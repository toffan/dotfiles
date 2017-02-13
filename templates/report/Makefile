TEXC = latexmk -lualatex -output-directory=build -shell-escape

.PHONY: FORCE

all: show

show: <name>.pdf
	evince build/<name>.pdf &

<name>.pdf: <name>.tex FORCE
	$(TEXC) $<

clean: FORCE
	$(TEXC) -c

clean_all: clean FORCE
	$(RM) build -r
