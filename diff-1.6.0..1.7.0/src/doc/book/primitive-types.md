--- a/src/doc/book/primitive-types.md
+++ b/src/doc/book/primitive-types.md
@@ -160,20 +160,23 @@ documentation][array].
 
 A ‘slice’ is a reference to (or “view” into) another data structure. They are
 useful for allowing safe, efficient access to a portion of an array without
-copying. For example, you might want to reference just one line of a file read
+copying. For example, you might want to reference only one line of a file read
 into memory. By nature, a slice is not created directly, but from an existing
 variable binding. Slices have a defined length, can be mutable or immutable.
 
 ## Slicing syntax
 
 You can use a combo of `&` and `[]` to create a slice from various things. The
-`&` indicates that slices are similar to references, and the `[]`s, with a
-range, let you define the length of the slice:
+`&` indicates that slices are similar to [references], which we will cover in
+detail later in this section. The `[]`s, with a range, let you define the
+length of the slice:
+
+[references]: references-and-borrowing.html
 
 ```rust
 let a = [0, 1, 2, 3, 4];
 let complete = &a[..]; // A slice containing all of the elements in a
-let middle = &a[1..4]; // A slice of a: just the elements 1, 2, and 3
+let middle = &a[1..4]; // A slice of a: only the elements 1, 2, and 3
 ```
 
 Slices have type `&[T]`. We’ll talk about that `T` when we cover
@@ -189,11 +192,13 @@ documentation][slice].
 # `str`
 
 Rust’s `str` type is the most primitive string type. As an [unsized type][dst],
-it’s not very useful by itself, but becomes useful when placed behind a reference,
-like [`&str`][strings]. As such, we’ll just leave it at that.
+it’s not very useful by itself, but becomes useful when placed behind a
+reference, like `&str`. We'll elaborate further when we cover
+[Strings][strings] and [references].
 
 [dst]: unsized-types.html
 [strings]: strings.html
+[references]: references-and-borrowing.html
 
 You can find more documentation for `str` [in the standard library
 documentation][str].
@@ -215,11 +220,11 @@ with the type annotated:
 let x: (i32, &str) = (1, "hello");
 ```
 
-As you can see, the type of a tuple looks just like the tuple, but with each
+As you can see, the type of a tuple looks like the tuple, but with each
 position having a type name rather than the value. Careful readers will also
 note that tuples are heterogeneous: we have an `i32` and a `&str` in this tuple.
 In systems programming languages, strings are a bit more complex than in other
-languages. For now, just read `&str` as a *string slice*, and we’ll learn more
+languages. For now, read `&str` as a *string slice*, and we’ll learn more
 soon.
 
 You can assign one tuple into another, if they have the same contained types
@@ -244,7 +249,7 @@ println!("x is {}", x);
 ```
 
 Remember [before][let] when I said the left-hand side of a `let` statement was more
-powerful than just assigning a binding? Here we are. We can put a pattern on
+powerful than assigning a binding? Here we are. We can put a pattern on
 the left-hand side of the `let`, and if it matches up to the right-hand side,
 we can assign multiple bindings at once. In this case, `let` “destructures”
 or “breaks up” the tuple, and assigns the bits to three bindings.
diff --git a/src/doc/book/references-and-borrowing.md b/src/doc/book/references-and-borrowing.md
