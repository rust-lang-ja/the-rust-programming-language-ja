VERSION=1.6
LANG=ja

all: book


book: public/$(VERSION)/book/index.html

public/$(VERSION)/book/index.html: $(wildcard $(VERSION)/$(LANG)/book/*.md)
	rm -rf public/$(VERSION)/book
	mkdir -p public/$(VERSION)
	$(RUSTBOOK) build $(VERSION)/$(LANG)/book public/$(VERSION)/book 
