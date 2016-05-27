--- a/src/doc/book/method-syntax.md
+++ b/src/doc/book/method-syntax.md
@@ -49,11 +49,11 @@ and inside it, define a method, `area`.
 Methods take a special first parameter, of which there are three variants:
 `self`, `&self`, and `&mut self`. You can think of this first parameter as
 being the `foo` in `foo.bar()`. The three variants correspond to the three
-kinds of things `foo` could be: `self` if it’s just a value on the stack,
+kinds of things `foo` could be: `self` if it’s a value on the stack,
 `&self` if it’s a reference, and `&mut self` if it’s a mutable reference.
-Because we took the `&self` parameter to `area`, we can use it just like any
+Because we took the `&self` parameter to `area`, we can use it like any
 other parameter. Because we know it’s a `Circle`, we can access the `radius`
-just like we would with any other `struct`.
+like we would with any other `struct`.
 
 We should default to using `&self`, as you should prefer borrowing over taking
 ownership, as well as taking immutable references over mutable ones. Here’s an
@@ -151,7 +151,7 @@ fn grow(&self, increment: f64) -> Circle {
 # Circle } }
 ```
 
-We just say we’re returning a `Circle`. With this method, we can grow a new
+We say we’re returning a `Circle`. With this method, we can grow a new
 `Circle` to any arbitrary size.
 
 # Associated functions
diff --git a/src/doc/book/nightly-rust.md b/src/doc/book/nightly-rust.md
