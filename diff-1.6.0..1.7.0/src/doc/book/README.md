--- a/src/doc/book/README.md
+++ b/src/doc/book/README.md
@@ -14,31 +14,25 @@ Even then, Rust still allows precise control like a low-level language would.
 
 [rust]: https://www.rust-lang.org
 
-“The Rust Programming Language” is split into eight sections. This introduction
+“The Rust Programming Language” is split into chapters. This introduction
 is the first. After this:
 
 * [Getting started][gs] - Set up your computer for Rust development.
-* [Learn Rust][lr] - Learn Rust programming through small projects.
-* [Effective Rust][er] - Higher-level concepts for writing excellent Rust code.
+* [Tutorial: Guessing Game][gg] - Learn some Rust with a small project.
 * [Syntax and Semantics][ss] - Each bit of Rust, broken down into small chunks.
+* [Effective Rust][er] - Higher-level concepts for writing excellent Rust code.
 * [Nightly Rust][nr] - Cutting-edge features that aren’t in stable builds yet.
 * [Glossary][gl] - A reference of terms used in the book.
 * [Bibliography][bi] - Background on Rust's influences, papers about Rust.
 
 [gs]: getting-started.html
-[lr]: learn-rust.html
+[gg]: guessing-game.html
 [er]: effective-rust.html
 [ss]: syntax-and-semantics.html
 [nr]: nightly-rust.html
 [gl]: glossary.html
 [bi]: bibliography.html
 
-After reading this introduction, you’ll want to dive into either ‘Learn Rust’ or
-‘Syntax and Semantics’, depending on your preference: ‘Learn Rust’ if you want
-to dive in with a project, or ‘Syntax and Semantics’ if you prefer to start
-small, and learn a single concept thoroughly before moving onto the next.
-Copious cross-linking connects these parts together.
-
 ### Contributing
 
 The source files from which this book is generated can be found on
diff --git a/src/doc/book/SUMMARY.md b/src/doc/book/SUMMARY.md
