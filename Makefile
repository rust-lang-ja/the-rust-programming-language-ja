VERSION=1.6
LANG=ja

all: book


book: public/$(VERSION)/book/index.html

public/$(VERSION)/book/index.html: $(wildcard $(VERSION)/$(LANG)/book/*.md)
	rm -rf public/$(VERSION)/book
	mkdir -p public/$(VERSION)
	$(RUSTBOOK) build $(VERSION)/$(LANG)/book public/$(VERSION)/book 

publish:
	git subtree -P public push "git@github.com:rust-lang-ja/the-rust-programming-language-ja.git" gh-pages

.PHONY: publish
