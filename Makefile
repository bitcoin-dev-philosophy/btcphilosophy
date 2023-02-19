AD=asciidoctor -b html5 -v -r asciidoctor-diagram
ADPDF=asciidoctor-pdf -r asciidoctor-diagram
BASE_NAME=btcphilosophy
B=build
MAINADOC=$(B)/$(BASE_NAME).adoc
ALLADOC := $(patsubst %,$(B)/%,$(wildcard *.adoc))
ALLPNGS := $(patsubst %,$(B)/%,$(wildcard images/*.png))
ALLJPGS := $(patsubst %,$(B)/%,$(wildcard images/*.jpg))
ALLIMGS := $(ALLPNGS) $(ALLJPGS)
CSS := $(B)/style/btcphilosophy.css
DOCINFO := $(B)/style/docinfo.html
BOOKHTML=$(B)/$(BASE_NAME).html
BOOKPDF=$(B)/$(BASE_NAME).pdf
SOURCES := sources
SOURCESIMAGES := $(patsubst %,$(B)/%,$(wildcard $(SOURCES)/images/*))
MAINSOURCESADOC := $(SOURCES)/sources.adoc
ALLSOURCESADOC := $(MAINSOURCESADOC) $(wildcard $(SOURCES)/**/*.adoc)
SOURCESCSS := $(B)/sources/style/btcphilosophy.css
SOURCESDOCINFO := $(B)/sources/style/docinfo.html
SOURCESHTML=$(B)/$(SOURCES)/sources.html

IMEXISTS := $(shell command -v convert 2> /dev/null)
ADPDFEXISTS := $(shell $(ADPDF) --version 2> /dev/null)

.PHONY: all
all: full

pdf: $(BOOKPDF)

$(BOOKPDF): $(ALLADOC) $(ALLPNGS) $(ALLJPGS) style/pdf-theme.yml
ifndef ADPDFEXISTS
	echo "ERROR: asciidoctor-pdf is missing. Nothing built."
else
	$(ADPDF) $(MAINADOC) -o $@
endif

full: $(B) $(BOOKHTML) $(SOURCESHTML)

$(BOOKHTML): $(CSS) $(DOCINFO) $(ALLADOC) $(ALLPNGS) $(ALLJPGS)
	$(AD) $(MAINADOC) -o $@

$(SOURCESHTML): $(SOURCESCSS) $(SOURCESDOCINFO) $(ALLSOURCESADOC) $(SOURCESIMAGES)
	$(AD) $(MAINSOURCESADOC) -o $@

$(SOURCESIMAGES): $(B)/%: %
	mkdir -p $(dir $@)
# We don't resize sources images because they're rarely downloaded
# and there are many formats to make special cases for (mp4, pdf)
# Maybe we'll change this at some point.
	cp $< $@

$(ALLADOC): $(B)/%: %
	cat $< | notes/qrcodes.sh > $@

$(ALLIMGS): $(B)/%: %
	mkdir -p $(dir $@)
ifndef IMEXISTS
	echo "WARN: ImageMagick is not installed, images will not be resized"
	cp $< $@
else
	convert $< -resize 1024x1024\> $@
endif

$(CSS) $(SOURCESCSS) $(DOCINFO) $(SOURCESDOCINFO) $(ALLADOC): $(B)/%: %
	@mkdir -p $(dir $@)
	cp $< $@

$(B):
	@mkdir $(B)
	@mkdir $(B)/images
	@mkdir $(B)/$(SOURCES)
	@mkdir $(B)/$(SOURCES)/images
	@mkdir $(B)/$(SOURCES)/style

clean:
	rm -rf $(B)
