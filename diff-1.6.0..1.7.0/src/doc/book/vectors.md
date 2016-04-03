--- a/src/doc/book/vectors.md
+++ b/src/doc/book/vectors.md
@@ -61,6 +61,33 @@ error: aborting due to previous error
 There’s a lot of punctuation in that message, but the core of it makes sense:
 you cannot index with an `i32`.
 
+## Out-of-bounds Access
+
+If you try to access an index that doesn’t exist:
+
+```ignore
+let v = vec![1, 2, 3];
+println!("Item 7 is {}", v[7]);
+```
+
+then the current thread will [panic] with a message like this:
+
+```text
+thread '<main>' panicked at 'index out of bounds: the len is 3 but the index is 7'
+```
+
+If you want to handle out-of-bounds errors without panicking, you can use
+methods like [`get`][get] or [`get_mut`][get_mut] that return `None` when
+given an invalid index:
+
+```rust
+let v = vec![1, 2, 3];
+match v.get(7) {
+    Some(x) => println!("Item 7 is {}", x),
+    None => println!("Sorry, this vector is too short.")
+}
+```
+
 ## Iterating
 
 Once you have a vector, you can iterate through its elements with `for`. There
@@ -87,3 +114,6 @@ API documentation][vec].
 
 [vec]: ../std/vec/index.html
 [generic]: generics.html
+[panic]: concurrency.html#panics
+[get]: http://doc.rust-lang.org/std/vec/struct.Vec.html#method.get
+[get_mut]: http://doc.rust-lang.org/std/vec/struct.Vec.html#method.get_mut
diff --git a/src/doc/complement-design-faq.md b/src/doc/complement-design-faq.md
