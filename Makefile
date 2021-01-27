.PHONY: clean diagrams

genfiles := $(shell find . -type f -path '*/diagrams/*' -name '*.sh')
dotfiles := $(patsubst %.sh, %.dot, $(genfiles))
svgfiles := $(patsubst %.dot, %.svg, $(dotfiles))
pngfiles := $(patsubst %.dot, %.png, $(dotfiles))

%.dot: %.sh shell/graphviz.zshrc
	@echo executing $<
	@zsh -i ./$< ./$@

%.svg: %.dot
	@echo Generating $@
	@dot -Tsvg $< -o $@

%.png: %.dot
	@echo Generating $@
	@dot -Tpng $< -o $@

clean:
	rm -f $(dotfiles)
	rm -f $(svgfiles)
	rm -f $(pngfiles)
	@echo done

diagrams: $(dotfiles) $(svgfiles) $(pngfiles)
	@echo Done.
