AD=asciidoctor -b html5
BASE_NAME=btcphilosophy
MAINADOC=$(BASE_NAME).adoc
ALLADOC := $(wildcard *.adoc)
B=build
ALLPNGS := $(patsubst %,$(B)/%,$(wildcard images/*.png))
ALLJPGS := $(patsubst %,$(B)/%,$(wildcard images/*.jpg))
BOOKHTML=$(B)/$(BASE_NAME).html
SOURCES := sources
SOURCESIMAGES := $(patsubst %,$(B)/%,$(wildcard $(SOURCES)/images/*))
MAINSOURCESADOC := $(SOURCES)/sources.adoc
ALLSOURCESADOC := $(MAINSOURCESADOC) $(wildcard $(SOURCES)/**/*.adoc)
SOURCESHTML=$(B)/$(SOURCES)/sources.html

.PHONY: all
all: full

full: $(B) $(BOOKHTML) $(SOURCESHTML)

$(BOOKHTML): $(ALLADOC) $(ALLPNGS) $(ALLJPGS)
	$(AD) -v $(MAINADOC) -o $@

$(SOURCESHTML): $(ALLSOURCESADOC) $(SOURCESIMAGES)
	mkdir -p $(B)/sources
	$(AD) -v $(MAINSOURCESADOC) -o $@

$(SOURCESIMAGES): $(B)/%: %
	mkdir -p $(dir $@)
	cp $< $@

$(ALLPNGS): $(B)/%.png: %.png
	mkdir -p $(dir $@)
	cp $< $@

$(ALLJPGS): $(B)/%.jpg: %.jpg
	mkdir -p $(dir $@)
	cp $< $@

$(B):
	@mkdir -p $(B)
	@mkdir -p $(B)/images
	cp -fr style $(B)
	@mkdir -p $(B)/$(SOURCES)
	@mkdir -p $(B)/$(SOURCES)/images
	cp -fr $(SOURCES)/style $(B)/$(SOURCES)

clean:
	rm -rf $(B)
