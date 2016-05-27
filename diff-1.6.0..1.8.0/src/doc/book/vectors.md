--- a/src/doc/book/vectors.md
+++ b/src/doc/book/vectors.md
@@ -11,8 +11,8 @@ let v = vec![1, 2, 3, 4, 5]; // v: Vec<i32>
 ```
 
 (Notice that unlike the `println!` macro we’ve used in the past, we use square
-brackets `[]` with `vec!` macro. Rust allows you to use either in either situation,
-this is just convention.)
+brackets `[]` with `vec!` macro. Rust allows you to use either in either
+situation, this is just convention.)
 
 There’s an alternate form of `vec!` for repeating an initial value:
 
@@ -20,6 +20,12 @@ There’s an alternate form of `vec!` for repeating an initial value:
 let v = vec![0; 10]; // ten zeroes
 ```
 
+Vectors store their contents as contiguous arrays of `T` on the heap. This means
+that they must be able to know the size of `T` at compile time (that is, how
+many bytes are needed to store a `T`?). The size of some things can't be known
+at compile time. For these you'll have to store a pointer to that thing:
+thankfully, the [`Box`][box] type works perfectly for this.
+
 ## Accessing elements
 
 To get the value at a particular index in the vector, we use `[]`s:
@@ -61,6 +67,33 @@ error: aborting due to previous error
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
@@ -86,4 +119,8 @@ Vectors have many more useful methods, which you can read about in [their
 API documentation][vec].
 
 [vec]: ../std/vec/index.html
+[box]: ../std/boxed/index.html
 [generic]: generics.html
+[panic]: concurrency.html#panics
+[get]: http://doc.rust-lang.org/std/vec/struct.Vec.html#method.get
+[get_mut]: http://doc.rust-lang.org/std/vec/struct.Vec.html#method.get_mut
diff --git a/src/doc/complement-design-faq.md b/src/doc/complement-design-faq.md
