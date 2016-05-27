--- a/src/doc/index.md
+++ b/src/doc/index.md
@@ -1,72 +1,37 @@
 % Rust Documentation
 
-Welcome to the Rust documentation! You can use the section headings above
-to jump to any particular section.
+<style>
+nav {
+    display: none;
+}
+</style>
 
-# Getting Started
+This is an index of the documentation included with the Rust
+compiler. For more comprehensive documentation see [the
+website](https://www.rust-lang.org).
 
-If you haven't seen Rust at all yet, the first thing you should read is the
-introduction to [The Rust Programming Language](book/index.html). It'll give
-you a good idea of what Rust is like.
+[**The Rust Programming Language**][book]. Also known as "The Book",
+The Rust Programming Language is the most comprehensive resource for
+all topics related to Rust, and is the primary official document of
+the language.
 
-The book provides a lengthy explanation of Rust, its syntax, and its
-concepts. Upon completing the book, you'll be an intermediate Rust
-developer, and will have a good grasp of the fundamental ideas behind
-Rust.
+[**The Rust Reference**][ref]. While Rust does not have a
+specification, the reference tries to describe its working in
+detail. It tends to be out of date.
 
-[Rust By Example][rbe] teaches you Rust through a series of small
-examples.
+[**Standard Library API Reference**][api]. Documentation for the
+standard library.
 
-[rbe]: http://rustbyexample.com/
+[**The Rustonomicon**][nomicon]. An entire book dedicated to
+explaining how to write unsafe Rust code. It is for advanced Rust
+programmers.
 
-# Language Reference
+[**Compiler Error Index**][err]. Extended explanations of
+the errors produced by the Rust compiler.
 
-Rust does not have an exact specification yet, but an effort to describe as much of
-the language in as much detail as possible is in [the reference](reference.html).
+[book]: book/index.html
+[ref]: reference.html
+[api]: std/index.html
+[nomicon]: nomicon/index.html
+[err]: error-index.html
 
-# Standard Library Reference
-
-We have [API documentation for the entire standard
-library](std/index.html). There's a list of crates on the left with more
-specific sections, or you can use the search bar at the top to search for
-something if you know its name.
-
-# The Rustonomicon
-
-[The Rustonomicon] is an entire book dedicated to explaining
-how to write `unsafe` Rust code. It is for advanced Rust programmers.
-
-[The Rustonomicon]: nomicon/index.html
-
-# Tools
-
-[Cargo](http://doc.crates.io/index.html) is the Rust package manager providing access to libraries
-beyond the standard one, and its website contains lots of good documentation.
-
-[`rustdoc`](book/documentation.html) is the Rust's documentation generator, a tool converting
-annotated source code into HTML docs.
-
-# FAQs
-
-There are questions that are asked quite often, so we've made FAQs for them:
-
-* [Language Design FAQ](complement-design-faq.html)
-* [Language FAQ](complement-lang-faq.html)
-* [Project FAQ](complement-project-faq.html)
-* [How to submit a bug report](https://github.com/rust-lang/rust/blob/master/CONTRIBUTING.md#bug-reports)
-
-# The Error Index
-
-If you encounter an error while compiling your code you may be able to look it
-up in the [Rust Compiler Error Index](error-index.html).
-
-# Community Translations
-
-Several projects have been started to translate the documentation into other
-languages:
-
-- [Russian](https://github.com/kgv/rust_book_ru)
-- [Korean](https://github.com/rust-kr/doc.rust-kr.org)
-- [Chinese](https://github.com/KaiserY/rust-book-chinese)
-- [Spanish](https://goyox86.github.io/elpr)
-- [German](https://panicbit.github.io/rustbook-de)
diff --git a/src/doc/nomicon/lifetime-elision.md b/src/doc/nomicon/lifetime-elision.md
