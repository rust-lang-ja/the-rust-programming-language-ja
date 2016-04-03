--- a/src/doc/book/trait-objects.md
+++ b/src/doc/book/trait-objects.md
@@ -272,7 +272,7 @@ made more flexible.
 
 Suppose we’ve got some values that implement `Foo`. The explicit form of
 construction and use of `Foo` trait objects might look a bit like (ignoring the
-type mismatches: they’re all just pointers anyway):
+type mismatches: they’re all pointers anyway):
 
 ```rust,ignore
 let a: String = "foo".to_string();
diff --git a/src/doc/book/traits.md b/src/doc/book/traits.md
