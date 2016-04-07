--- a/src/doc/book/traits.md
+++ b/src/doc/book/traits.md
@@ -44,8 +44,8 @@ impl HasArea for Circle {
 ```
 
 As you can see, the `trait` block looks very similar to the `impl` block,
-but we don’t define a body, just a type signature. When we `impl` a trait,
-we use `impl Trait for Item`, rather than just `impl Item`.
+but we don’t define a body, only a type signature. When we `impl` a trait,
+we use `impl Trait for Item`, rather than only `impl Item`.
 
 ## Trait bounds on generic functions
 
diff --git a/src/doc/book/unsafe.md b/src/doc/book/unsafe.md
