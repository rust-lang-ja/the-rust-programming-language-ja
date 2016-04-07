--- a/src/doc/book/crates-and-modules.md
+++ b/src/doc/book/crates-and-modules.md
@@ -2,7 +2,7 @@
 
 When a project starts getting large, it’s considered good software
 engineering practice to split it up into a bunch of smaller pieces, and then
-fit them together. It’s also important to have a well-defined interface, so
+fit them together. It is also important to have a well-defined interface, so
 that some of your functionality is private, and some is public. To facilitate
 these kinds of things, Rust has a module system.
 
@@ -222,7 +222,7 @@ fn hello() -> String {
 }
 ```
 
-Of course, you can copy and paste this from this web page, or just type
+Of course, you can copy and paste this from this web page, or type
 something else. It’s not important that you actually put ‘konnichiwa’ to learn
 about the module system.
 
@@ -299,7 +299,7 @@ depth.
 Rust allows you to precisely control which aspects of your interface are
 public, and so private is the default. To make things public, you use the `pub`
 keyword. Let’s focus on the `english` module first, so let’s reduce our `src/main.rs`
-to just this:
+to only this:
 
 ```rust,ignore
 extern crate phrases;
@@ -447,7 +447,7 @@ use phrases::english::{greetings, farewells};
 
 ## Re-exporting with `pub use`
 
-You don’t just use `use` to shorten identifiers. You can also use it inside of your crate
+You don’t only use `use` to shorten identifiers. You can also use it inside of your crate
 to re-export a function inside another module. This allows you to present an external
 interface that may not directly map to your internal code organization.
 
@@ -584,5 +584,5 @@ use sayings::english::farewells as en_farewells;
 ```
 
 As you can see, the curly brackets compress `use` statements for several items
-under the same path, and in this context `self` just refers back to that path.
+under the same path, and in this context `self` refers back to that path.
 Note: The curly brackets cannot be nested or mixed with star globbing.
diff --git a/src/doc/book/custom-allocators.md b/src/doc/book/custom-allocators.md
