--- a/src/doc/book/generics.md
+++ b/src/doc/book/generics.md
@@ -37,7 +37,7 @@ let x: Option<f64> = Some(5);
 // found `core::option::Option<_>` (expected f64 but found integral variable)
 ```
 
-That doesn’t mean we can’t make `Option<T>`s that hold an `f64`! They just have
+That doesn’t mean we can’t make `Option<T>`s that hold an `f64`! They have
 to match up:
 
 ```rust
@@ -118,7 +118,7 @@ let float_origin = Point { x: 0.0, y: 0.0 };
 Similar to functions, the `<T>` is where we declare the generic parameters,
 and we then use `x: T` in the type declaration, too.
 
-When you want to add an implementation for the generic `struct`, you just
+When you want to add an implementation for the generic `struct`, you
 declare the type parameter after the `impl`:
 
 ```rust
diff --git a/src/doc/book/getting-started.md b/src/doc/book/getting-started.md
