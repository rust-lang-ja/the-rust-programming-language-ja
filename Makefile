LANG=ja
VERSION ?= 1.9
VER_HASH=
SHORT_VER_HASH=
RUSTBOOK ?= rustbook
RUSTDOC ?= rustdoc

BASE_DIR=$(VERSION)/$(LANG)
TARGET_DIR=docs/$(VERSION)

DOCS := index \
    complement-lang-faq complement-design-faq complement-project-faq \
    rustdoc reference grammar

# Legacy guides, preserved for a while to reduce the number of 404s
DOCS += guide-crates guide-error-handling guide-ffi guide-macros guide \
    guide-ownership guide-plugins guide-pointers guide-strings guide-tasks \
    guide-testing tutorial intro

RUSTDOC_DEPS_reference := $(TARGET_DIR)/full-toc.inc
RUSTDOC_FLAGS_reference := --html-in-header=$(TARGET_DIR)/full-toc.inc

RUSTDOC_HTML_OPTS_NO_CSS = --html-before-content=$(TARGET_DIR)/version_info.html \
	--html-in-header=$(TARGET_DIR)/favicon.inc \
	--html-after-content=$(TARGET_DIR)/footer.inc \
	--markdown-playground-url='https://play.rust-lang.org/'

RUSTDOC_HTML_OPTS = $(RUSTDOC_HTML_OPTS_NO_CSS) --markdown-css rust.css

STATIC_DIRS := alloc collections core implementors libc rustc_unicode std
STATIC_FILES := jquery.js main.css main.js playpen.js search-index.js rustdoc.css \
	LICENSE-APACHE LICENSE-MIT \
	FiraSans-Medium.woff FiraSans-Regular.woff Heuristica-Italic.woff \
	SourceCodePro-Regular.woff SourceCodePro-Semibold.woff \
	SourceSerifPro-Bold.woff SourceSerifPro-Regular.woff

DOC_TARGETS := book nomicon style


default: all

publish:
	git subtree -P docs push "git@github.com:rust-lang-ja/the-rust-programming-language-ja.git" gh-pages



book: $(TARGET_DIR)/book/index.html

nomicon: $(TARGET_DIR)/nomicon/index.html

style: $(TARGET_DIR)/style/index.html

.PHONY: publish book nomicon style docs clean all



$(TARGET_DIR)/book/index.html: $(wildcard $(BASE_DIR)/book/*.md) | $(TARGET_DIR)
	@echo ""
	@echo "== rustbook: Generating HTML from $(BASE_DIR)/book/*.md"
	rm -rf $(TARGET_DIR)/book
	$(RUSTBOOK) build $(BASE_DIR)/book $(TARGET_DIR)/book

$(TARGET_DIR)/nomicon/index.html: $(wildcard $(BASE_DIR)/nomicon/*.md) | $(TARGET_DIR)
	@echo ""
	@echo "== rustbook: Generating HTML from $(BASE_DIR)/nomicon/*.md"
	rm -rf $(TARGET_DIR)/nomicon
	$(RUSTBOOK) build $(BASE_DIR)/nomicon $(TARGET_DIR)/nomicon

$(TARGET_DIR)/style/index.html: $(wildcard $(BASE_DIR)/style/*.md) | $(TARGET_DIR)
	@echo ""
	@echo "== rustbook: Generating HTML from $(BASE_DIR)/style/*.md"
	rm -rf $(TARGET_DIR)/style
	$(RUSTBOOK) build $(BASE_DIR)/style $(TARGET_DIR)/style

$(TARGET_DIR):
	@echo ""
	@echo "== Creating $(TARGET_DIR)"
	mkdir -p $(TARGET_DIR)


######################################################################
# Rust version
######################################################################

HTML_DEPS += $(TARGET_DIR)/version_info.html
$(TARGET_DIR)/version_info.html: $(BASE_DIR)/version_info.html.template $(MKFILE_DEPS) \
                       $(wildcard $(BASE_DIR)/*.*) | $(BASE_DIR)
	@echo ""
	@echo "== Setting Rust version to $@"
	sed -e "s/VERSION/$(VERSION)/; \
                s/SHORT_HASH/$(SHORT_VER_HASH)/; \
                s/STAMP/$(VER_HASH)/;" $< >$@
	@echo ""

######################################################################
# Docs from rustdoc
######################################################################

HTML_DEPS += $(TARGET_DIR)/rust.css
$(TARGET_DIR)/rust.css: $(BASE_DIR)/rust.css | $(TARGET_DIR)
	cp -PRp $< $@ 2> /dev/null

HTML_DEPS += $(TARGET_DIR)/favicon.inc
$(TARGET_DIR)/favicon.inc: $(BASE_DIR)/favicon.inc | $(TARGET_DIR)
	cp -PRp $< $@ 2> /dev/null

$(TARGET_DIR)/full-toc.inc: $(BASE_DIR)/full-toc.inc | $(TARGET_DIR)/
	cp -PRp $< $@ 2> /dev/null

HTML_DEPS += $(TARGET_DIR)/footer.inc
$(TARGET_DIR)/footer.inc: $(BASE_DIR)/footer.inc | $(TARGET_DIR)/
	cp -PRp $< $@ 2> /dev/null


## HTML
# Generating targets of single markdown files.
# this is template definition
define DEF_DOC

# HTML (rustdoc)
DOC_TARGETS += $$(TARGET_DIR)/$(1).html
$$(TARGET_DIR)/$(1).html: $$(BASE_DIR)/$(1).md $$(HTML_DEPS) $$(RUSTDOC_DEPS_$(1)) | $$(TARGET_DIR)
	@echo ""
	@echo "== rustdoc: Generating HTML from $$<"
	$$(RUSTDOC) $$(RUSTDOC_HTML_OPTS) $$(RUSTDOC_FLAGS_$(1)) $$< -o $$(TARGET_DIR)

endef

# then, apply template for each $(DOCS)
$(foreach docname,$(DOCS),$(eval $(call DEF_DOC,$(docname))))
###

## Copy already renderd docs
define DEF_COPY_DIR

DOC_TARGETS += $$(TARGET_DIR)/$(1)/
$$(TARGET_DIR)/$(1)/:
	cp -R $(BASE_DIR)/$(1) $(TARGET_DIR)/$(1)

endef
$(foreach dirname,$(STATIC_DIRS),$(eval $(call DEF_COPY_DIR,$(dirname))))

## Copy static files
define DEF_COPY_FILE

DOC_TARGETS += $$(TARGET_DIR)/$(1)
$$(TARGET_DIR)/$(1):
	cp $(VERSION)/static/$(1) $(TARGET_DIR)/$(1)


endef
$(foreach filename,$(STATIC_FILES),$(eval $(call DEF_COPY_FILE,$(filename))))


# Do not forget to specify the VERSION to clean. e.g `make clean VERSION=1.6`
clean:
	@rm -rf $(TARGET_DIR)
	@echo "== Removed $(TARGET_DIR)"

all: $(DOC_TARGETS)
