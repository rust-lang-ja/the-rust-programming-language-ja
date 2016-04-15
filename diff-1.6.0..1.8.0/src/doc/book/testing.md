--- a/src/doc/book/testing.md
+++ b/src/doc/book/testing.md
@@ -24,6 +24,7 @@ Cargo will automatically generate a simple test when you make a new project.
 Here's the contents of `src/lib.rs`:
 
 ```rust
+# fn main() {}
 #[test]
 fn it_works() {
 }
@@ -75,6 +76,7 @@ So why does our do-nothing test pass? Any test which doesn't `panic!` passes,
 and any test that does `panic!` fails. Let's make our test fail:
 
 ```rust
+# fn main() {}
 #[test]
 fn it_works() {
     assert!(false);
@@ -145,6 +147,7 @@ This is useful if you want to integrate `cargo test` into other tooling.
 We can invert our test's failure with another attribute: `should_panic`:
 
 ```rust
+# fn main() {}
 #[test]
 #[should_panic]
 fn it_works() {
@@ -175,6 +178,7 @@ Rust provides another macro, `assert_eq!`, that compares two arguments for
 equality:
 
 ```rust
+# fn main() {}
 #[test]
 #[should_panic]
 fn it_works() {
@@ -209,6 +213,7 @@ make sure that the failure message contains the provided text. A safer version
 of the example above would be:
 
 ```rust
+# fn main() {}
 #[test]
 #[should_panic(expected = "assertion failed")]
 fn it_works() {
@@ -219,6 +224,7 @@ fn it_works() {
 That's all there is to the basics! Let's write one 'real' test:
 
 ```rust,ignore
+# fn main() {}
 pub fn add_two(a: i32) -> i32 {
     a + 2
 }
@@ -238,6 +244,7 @@ Sometimes a few specific tests can be very time-consuming to execute. These
 can be disabled by default by using the `ignore` attribute:
 
 ```rust
+# fn main() {}
 #[test]
 fn it_works() {
     assert_eq!(4, add_two(2));
@@ -299,6 +306,7 @@ missing the `tests` module. The idiomatic way of writing our example
 looks like this:
 
 ```rust,ignore
+# fn main() {}
 pub fn add_two(a: i32) -> i32 {
     a + 2
 }
@@ -327,6 +335,7 @@ a large module, and so this is a common use of globs. Let's change our
 `src/lib.rs` to make use of it:
 
 ```rust,ignore
+# fn main() {}
 pub fn add_two(a: i32) -> i32 {
     a + 2
 }
@@ -365,7 +374,7 @@ test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
 It works!
 
 The current convention is to use the `tests` module to hold your "unit-style"
-tests. Anything that just tests one small bit of functionality makes sense to
+tests. Anything that tests one small bit of functionality makes sense to
 go here. But what about "integration-style" tests instead? For that, we have
 the `tests` directory.
 
@@ -377,6 +386,7 @@ put a `tests/lib.rs` file inside, with this as its contents:
 ```rust,ignore
 extern crate adder;
 
+# fn main() {}
 #[test]
 fn it_works() {
     assert_eq!(4, adder::add_two(2));
@@ -432,6 +442,7 @@ running examples in your documentation (**note:** this only works in library
 crates, not binary crates). Here's a fleshed-out `src/lib.rs` with examples:
 
 ```rust,ignore
+# fn main() {}
 //! The `adder` crate provides functions that add numbers to other numbers.
 //!
 //! # Examples
@@ -503,7 +514,7 @@ for the function test. These will auto increment with names like `add_two_1` as
 you add more examples.
 
 We haven’t covered all of the details with writing documentation tests. For more,
-please see the [Documentation chapter](documentation.html)
+please see the [Documentation chapter](documentation.html).
 
 One final note: documentation tests *cannot* be run on binary crates.
 To see more on file arrangement see the [Crates and
diff --git a/src/doc/book/the-stack-and-the-heap.md b/src/doc/book/the-stack-and-the-heap.md
