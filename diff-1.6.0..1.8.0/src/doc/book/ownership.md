--- a/src/doc/book/ownership.md
+++ b/src/doc/book/ownership.md
@@ -51,15 +51,26 @@ fn foo() {
 }
 ```
 
-When `v` comes into scope, a new [`Vec<T>`][vect] is created. In this case, the
-vector also allocates space on [the heap][heap], for the three elements. When
-`v` goes out of scope at the end of `foo()`, Rust will clean up everything
-related to the vector, even the heap-allocated memory. This happens
-deterministically, at the end of the scope.
-
-[vect]: ../std/vec/struct.Vec.html
+When `v` comes into scope, a new [vector] is created on [the stack][stack],
+and it allocates space on [the heap][heap] for its elements. When `v` goes out
+of scope at the end of `foo()`, Rust will clean up everything related to the
+vector, even the heap-allocated memory. This happens deterministically, at the
+end of the scope.
+
+We'll cover [vectors] in detail later in this chapter; we only use them
+here as an example of a type that allocates space on the heap at runtime. They
+behave like [arrays], except their size may change by `push()`ing more
+elements onto them.
+
+Vectors have a [generic type][generics] `Vec<T>`, so in this example `v` will have type
+`Vec<i32>`. We'll cover generics in detail later in this chapter.
+
+[arrays]: primitive-types.html#arrays
+[vectors]: vectors.html
 [heap]: the-stack-and-the-heap.html
+[stack]: the-stack-and-the-heap.html#the-stack
 [bindings]: variable-bindings.html
+[generics]: generics.html
 
 # Move semantics
 
@@ -113,21 +124,65 @@ special annotation here, it’s the default thing that Rust does.
 ## The details
 
 The reason that we cannot use a binding after we’ve moved it is subtle, but
-important. When we write code like this:
+important. 
+
+When we write code like this:
+
+```rust
+let x = 10;
+```
+
+Rust allocates memory for an integer [i32] on the [stack][sh], copies the bit
+pattern representing the value of 10 to the allocated memory and binds the
+variable name x to this memory region for future reference.
+
+Now consider the following code fragment:
 
 ```rust
 let v = vec![1, 2, 3];
 
-let v2 = v;
+let mut v2 = v;
+```
+
+The first line allocates memory for the vector object `v` on the stack like
+it does for `x` above. But in addition to that it also allocates some memory
+on the [heap][sh] for the actual data (`[1, 2, 3]`). Rust copies the address
+of this heap allocation to an internal pointer, which is part of the vector
+object placed on the stack (let's call it the data pointer). 
+
+It is worth pointing out (even at the risk of stating the obvious) that the
+vector object and its data live in separate memory regions instead of being a
+single contiguous memory allocation (due to reasons we will not go into at
+this point of time). These two parts of the vector (the one on the stack and
+one on the heap) must agree with each other at all times with regards to
+things like the length, capacity etc.
+
+When we move `v` to `v2`, Rust actually does a bitwise copy of the vector
+object `v` into the stack allocation represented by `v2`. This shallow copy
+does not create a copy of the heap allocation containing the actual data.
+Which means that there would be two pointers to the contents of the vector
+both pointing to the same memory allocation on the heap. It would violate
+Rust’s safety guarantees by introducing a data race if one could access both
+`v` and `v2` at the same time. 
+
+For example if we truncated the vector to just two elements through `v2`:
+
+```rust
+# let v = vec![1, 2, 3];
+# let mut v2 = v;
+v2.truncate(2);
 ```
 
-The first line allocates memory for the vector object, `v`, and for the data it
-contains. The vector object is stored on the [stack][sh] and contains a pointer
-to the content (`[1, 2, 3]`) stored on the [heap][sh]. When we move `v` to `v2`,
-it creates a copy of that pointer, for `v2`. Which means that there would be two
-pointers to the content of the vector on the heap. It would violate Rust’s
-safety guarantees by introducing a data race. Therefore, Rust forbids using `v`
-after we’ve done the move.
+and `v1` were still accessible we'd end up with an invalid vector since `v1`
+would not know that the heap data has been truncated. Now, the part of the
+vector `v1` on the stack does not agree with the corresponding part on the
+heap. `v1` still thinks there are three elements in the vector and will
+happily let us access the non existent element `v1[2]` but as you might
+already know this is a recipe for disaster. Especially because it might lead
+to a segmentation fault or worse allow an unauthorized user to read from
+memory to which they don't have access.
+
+This is why Rust forbids using `v` after we’ve done the move.
 
 [sh]: the-stack-and-the-heap.html
 
diff --git a/src/doc/book/patterns.md b/src/doc/book/patterns.md
