VERSION=1.5
LANG=en

all: trpl


trpl: public/$(VERSION)/book/index.html

public/$(VERSION)/book/index.html: $(wildcard $(VERSION)/$(LANG)/trpl/*.md)
	rm -rf public/$(VERSION)/book
	mkdir -p public/$(VERSION)
	$(RUSTBOOK) build $(VERSION)/$(LANG)/trpl public/$(VERSION)/book 
