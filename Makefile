V ?= 0
ifeq ($(V),1)
	helper=
	progress=
else
	helper=@
	progress=@echo $@;
endif

PARTS = $(shell find . -name '*.md')

PREPROCESSED_PARTS = $(patsubst %, public/%.in, $(PARTS))
HTML = $(patsubst ./%.md, public/%.html, $(PARTS))
ASSETS = $(patsubst template/%, public/%, $(wildcard template/*.css template/*.png template/*.jpg template/images/*))

all: $(HTML) $(ASSETS)
	@cp -R ./images public/
	@echo
	@echo "Site built."
	@echo

public/%: template/%
	$(helper) mkdir -p $$(dirname $@)
	$(progress) ln $< $@

%.html.in: %.md.in
	$(helper) pandoc -f markdown+smart -t html -o $@ $<

%.html: %.html.in ./script/apply-template.rb template/layout.html
	$(progress) ruby ./script/apply-template.rb template/layout.html $< > $@

public/%.md.in: %.md script/expand-links.sed
	$(helper) mkdir -p $$(dirname $@)
	$(helper) sed -f script/expand-links.sed $< > $@

.PRECIOUS: %.html.in public/%.md.in

clean:
	$(RM) -r public
