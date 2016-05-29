--- a/src/doc/book/crates-and-modules.md
+++ b/src/doc/book/crates-and-modules.md
@@ -2,7 +2,7 @@
 
 When a project starts getting large, it’s considered good software
 engineering practice to split it up into a bunch of smaller pieces, and then
-fit them together. It’s also important to have a well-defined interface, so
+fit them together. It is also important to have a well-defined interface, so
 that some of your functionality is private, and some is public. To facilitate
 these kinds of things, Rust has a module system.
 
@@ -118,7 +118,7 @@ build  deps  examples  libphrases-a7448e02a0468eaa.rlib  native
 `libphrases-hash.rlib` is the compiled crate. Before we see how to use this
 crate from another crate, let’s break it up into multiple files.
 
-# Multiple file crates
+# Multiple File Crates
 
 If each crate were just one file, these files would get very large. It’s often
 easier to split up crates into multiple files, and Rust supports this in two
@@ -190,13 +190,19 @@ mod farewells;
 ```
 
 Again, these declarations tell Rust to look for either
-`src/english/greetings.rs` and `src/japanese/greetings.rs` or
-`src/english/farewells/mod.rs` and `src/japanese/farewells/mod.rs`. Because
-these sub-modules don’t have their own sub-modules, we’ve chosen to make them
-`src/english/greetings.rs` and `src/japanese/farewells.rs`. Whew!
-
-The contents of `src/english/greetings.rs` and `src/japanese/farewells.rs` are
-both empty at the moment. Let’s add some functions.
+`src/english/greetings.rs`, `src/english/farewells.rs`,
+`src/japanese/greetings.rs` and `src/japanese/farewells.rs` or
+`src/english/greetings/mod.rs`, `src/english/farewells/mod.rs`,
+`src/japanese/greetings/mod.rs` and
+`src/japanese/farewells/mod.rs`. Because these sub-modules don’t have
+their own sub-modules, we’ve chosen to make them
+`src/english/greetings.rs`, `src/english/farewells.rs`,
+`src/japanese/greetings.rs` and `src/japanese/farewells.rs`. Whew!
+
+The contents of `src/english/greetings.rs`,
+`src/english/farewells.rs`, `src/japanese/greetings.rs` and
+`src/japanese/farewells.rs` are all empty at the moment. Let’s add
+some functions.
 
 Put this in `src/english/greetings.rs`:
 
@@ -222,7 +228,7 @@ fn hello() -> String {
 }
 ```
 
-Of course, you can copy and paste this from this web page, or just type
+Of course, you can copy and paste this from this web page, or type
 something else. It’s not important that you actually put ‘konnichiwa’ to learn
 about the module system.
 
@@ -299,7 +305,7 @@ depth.
 Rust allows you to precisely control which aspects of your interface are
 public, and so private is the default. To make things public, you use the `pub`
 keyword. Let’s focus on the `english` module first, so let’s reduce our `src/main.rs`
-to just this:
+to only this:
 
 ```rust,ignore
 extern crate phrases;
@@ -447,7 +453,7 @@ use phrases::english::{greetings, farewells};
 
 ## Re-exporting with `pub use`
 
-You don’t just use `use` to shorten identifiers. You can also use it inside of your crate
+You don’t only use `use` to shorten identifiers. You can also use it inside of your crate
 to re-export a function inside another module. This allows you to present an external
 interface that may not directly map to your internal code organization.
 
@@ -567,10 +573,11 @@ to it as "sayings". Similarly, the first `use` statement pulls in the
 `ja_greetings` as opposed to simply `greetings`. This can help to avoid
 ambiguity when importing similarly-named items from different places.
 
-The second `use` statement uses a star glob to bring in _all_ symbols from the
-`sayings::japanese::farewells` module. As you can see we can later refer to
+The second `use` statement uses a star glob to bring in all public symbols from
+the `sayings::japanese::farewells` module. As you can see we can later refer to
 the Japanese `goodbye` function with no module qualifiers. This kind of glob
-should be used sparingly.
+should be used sparingly. It’s worth noting that it only imports the public
+symbols, even if the code doing the globbing is in the same module.
 
 The third `use` statement bears more explanation. It's using "brace expansion"
 globbing to compress three `use` statements into one (this sort of syntax
@@ -584,5 +591,5 @@ use sayings::english::farewells as en_farewells;
 ```
 
 As you can see, the curly brackets compress `use` statements for several items
-under the same path, and in this context `self` just refers back to that path.
+under the same path, and in this context `self` refers back to that path.
 Note: The curly brackets cannot be nested or mixed with star globbing.
diff --git a/src/doc/book/custom-allocators.md b/src/doc/book/custom-allocators.md
