--- a/src/doc/book/ownership.md
+++ b/src/doc/book/ownership.md
@@ -51,15 +51,24 @@ fn foo() {
 }
 ```
 
-When `v` comes into scope, a new [`Vec<T>`][vect] is created. In this case, the
-vector also allocates space on [the heap][heap], for the three elements. When
-`v` goes out of scope at the end of `foo()`, Rust will clean up everything
-related to the vector, even the heap-allocated memory. This happens
-deterministically, at the end of the scope.
+When `v` comes into scope, a new [vector] is created, and it allocates space on
+[the heap][heap] for each of its elements. When `v` goes out of scope at the
+end of `foo()`, Rust will clean up everything related to the vector, even the
+heap-allocated memory. This happens deterministically, at the end of the scope.
 
-[vect]: ../std/vec/struct.Vec.html
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
 [bindings]: variable-bindings.html
+[generics]: generics.html
 
 # Move semantics
 
diff --git a/src/doc/book/patterns.md b/src/doc/book/patterns.md
