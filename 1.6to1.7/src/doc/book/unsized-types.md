--- a/src/doc/book/unsized-types.md
+++ b/src/doc/book/unsized-types.md
@@ -11,7 +11,7 @@ Rust understands a few of these types, but they have some restrictions. There
 are three:
 
 1. We can only manipulate an instance of an unsized type via a pointer. An
-   `&[T]` works just fine, but a `[T]` does not.
+   `&[T]` works fine, but a `[T]` does not.
 2. Variables and arguments cannot have dynamically sized types.
 3. Only the last field in a `struct` may have a dynamically sized type; the
    other fields must not. Enum variants must not have dynamically sized types as
diff --git a/src/doc/book/variable-bindings.md b/src/doc/book/variable-bindings.md
