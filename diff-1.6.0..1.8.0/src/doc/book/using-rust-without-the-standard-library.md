--- a/src/doc/book/using-rust-without-the-standard-library.md
+++ b/src/doc/book/using-rust-without-the-standard-library.md
@@ -11,7 +11,7 @@ don’t want to use the standard library via an attribute: `#![no_std]`.
 > For details on binaries without the standard library, see [the nightly
 > chapter on `#![no_std]`](no-stdlib.html)
 
-To use `#![no_std]`, add a it to your crate root:
+To use `#![no_std]`, add it to your crate root:
 
 ```rust
 #![no_std]
@@ -25,7 +25,7 @@ Much of the functionality that’s exposed in the standard library is also
 available via the [`core` crate](../core/). When we’re using the standard
 library, Rust automatically brings `std` into scope, allowing you to use
 its features without an explicit import. By the same token, when using
-`!#[no_std]`, Rust will bring `core` into scope for you, as well as [its
+`#![no_std]`, Rust will bring `core` into scope for you, as well as [its
 prelude](../core/prelude/v1/). This means that a lot of code will Just Work:
 
 ```rust
diff --git a/src/doc/book/variable-bindings.md b/src/doc/book/variable-bindings.md
