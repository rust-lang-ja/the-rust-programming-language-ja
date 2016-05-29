--- a/src/doc/book/strings.md
+++ b/src/doc/book/strings.md
@@ -39,12 +39,17 @@ The second, with a `\`, trims the spaces and the newline:
 
 ```rust
 let s = "foo\
-    bar"; 
+    bar";
 
 assert_eq!("foobar", s);
 ```
 
-Rust has more than just `&str`s though. A `String`, is a heap-allocated string.
+Note that you normally cannot access a `str` directly, but only through a `&str`
+reference. This is because `str` is an unsized type which requires additional
+runtime information to be usable. For more information see the chapter on
+[unsized types][ut].
+
+Rust has more than only `&str`s though. A `String` is a heap-allocated string.
 This string is growable, and is also guaranteed to be UTF-8. `String`s are
 commonly created by converting from a string slice using the `to_string`
 method.
@@ -89,7 +94,7 @@ Viewing a `String` as a `&str` is cheap, but converting the `&str` to a
 
 ## Indexing
 
-Because strings are valid UTF-8, strings do not support indexing:
+Because strings are valid UTF-8, they do not support indexing:
 
 ```rust,ignore
 let s = "hello";
@@ -185,5 +190,6 @@ let hello_world = hello + &world;
 This is because `&String` can automatically coerce to a `&str`. This is a
 feature called ‘[`Deref` coercions][dc]’.
 
+[ut]: unsized-types.html
 [dc]: deref-coercions.html
 [connect]: ../std/net/struct.TcpStream.html#method.connect
diff --git a/src/doc/book/structs.md b/src/doc/book/structs.md
