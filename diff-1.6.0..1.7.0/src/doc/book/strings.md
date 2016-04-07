--- a/src/doc/book/strings.md
+++ b/src/doc/book/strings.md
@@ -44,7 +44,7 @@ let s = "foo\
 assert_eq!("foobar", s);
 ```
 
-Rust has more than just `&str`s though. A `String`, is a heap-allocated string.
+Rust has more than only `&str`s though. A `String`, is a heap-allocated string.
 This string is growable, and is also guaranteed to be UTF-8. `String`s are
 commonly created by converting from a string slice using the `to_string`
 method.
diff --git a/src/doc/book/structs.md b/src/doc/book/structs.md
