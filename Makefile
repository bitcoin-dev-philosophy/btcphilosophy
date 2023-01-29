AD=asciidoctor -b html5 -v
BASE_NAME=btcphilosophy
MAINADOC=$(BASE_NAME).adoc
ALLADOC := $(wildcard *.adoc)
B=build
ALLPNGS := $(patsubst %,$(B)/%,$(wildcard images/*.png))
ALLJPGS := $(patsubst %,$(B)/%,$(wildcard images/*.jpg))
ALLIMGS := $(ALLPNGS) $(ALLJPGS)
STYLE := $(patsubst %,$(B)/%,$(wildcard style/*))
BOOKHTML=$(B)/$(BASE_NAME).html
SOURCES := sources
SOURCESIMAGES := $(patsubst %,$(B)/%,$(wildcard $(SOURCES)/images/*))
MAINSOURCESADOC := $(SOURCES)/sources.adoc
ALLSOURCESADOC := $(MAINSOURCESADOC) $(wildcard $(SOURCES)/**/*.adoc)
SOURCESHTML=$(B)/$(SOURCES)/sources.html
IMEXISTS := $(shell convert -version 2> /dev/null)

.PHONY: all
all: full

full: $(B) $(STYLE) $(BOOKHTML) $(SOURCESHTML)

$(BOOKHTML): $(ALLADOC) $(ALLPNGS) $(ALLJPGS)
	$(AD) $(MAINADOC) -o $@

$(SOURCESHTML): $(ALLSOURCESADOC) $(SOURCESIMAGES)
	mkdir -p $(B)/sources
	$(AD) $(MAINSOURCESADOC) -o $@

$(SOURCESIMAGES): $(B)/%: %
	mkdir -p $(dir $@)
# We don't resize sources images because they're rarely downloaded
# and there are many formats to make special cases for (mp4, pdf)
# Maybe we'll change this at some point.
	cp $< $@

$(ALLIMGS): $(B)/%: %
	mkdir -p $(dir $@)
ifndef IMEXISTS
	echo "WARN: ImageMagick is not installed, images will not be resized"
	cp $< $@
else
	convert $< -resize 1024x1024\> $@
endif

$(STYLE): $(B)/%: %
	cp $< $@

$(B):
	@mkdir $(B)
	@mkdir $(B)/images
	@mkdir $(B)/style
	@mkdir $(B)/$(SOURCES)
	@mkdir $(B)/$(SOURCES)/images
	@mkdir $(B)/$(SOURCES)/style

clean:
	rm -rf $(B)
