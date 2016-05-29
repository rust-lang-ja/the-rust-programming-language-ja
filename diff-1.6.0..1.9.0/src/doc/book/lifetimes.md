--- a/src/doc/book/lifetimes.md
+++ b/src/doc/book/lifetimes.md
@@ -56,8 +56,8 @@ To fix this, we have to make sure that step four never happens after step
 three. The ownership system in Rust does this through a concept called
 lifetimes, which describe the scope that a reference is valid for.
 
-When we have a function that takes a reference by argument, we can be implicit
-or explicit about the lifetime of the reference:
+When we have a function that takes an argument by reference, we can be
+implicit or explicit about the lifetime of the reference:
 
 ```rust
 // implicit
@@ -84,7 +84,7 @@ We previously talked a little about [function syntax][functions], but we didn’
 discuss the `<>`s after a function’s name. A function can have ‘generic
 parameters’ between the `<>`s, of which lifetimes are one kind. We’ll discuss
 other kinds of generics [later in the book][generics], but for now, let’s
-just focus on the lifetimes aspect.
+focus on the lifetimes aspect.
 
 [functions]: functions.html
 [generics]: generics.html
@@ -103,13 +103,13 @@ Then in our parameter list, we use the lifetimes we’ve named:
 ...(x: &'a i32)
 ```
 
-If we wanted an `&mut` reference, we’d do this:
+If we wanted a `&mut` reference, we’d do this:
 
 ```rust,ignore
 ...(x: &'a mut i32)
 ```
 
-If you compare `&mut i32` to `&'a mut i32`, they’re the same, it’s just that
+If you compare `&mut i32` to `&'a mut i32`, they’re the same, it’s that
 the lifetime `'a` has snuck in between the `&` and the `mut i32`. We read `&mut
 i32` as ‘a mutable reference to an `i32`’ and `&'a mut i32` as ‘a mutable
 reference to an `i32` with the lifetime `'a`’.
@@ -175,7 +175,7 @@ fn main() {
 ```
 
 As you can see, we need to declare a lifetime for `Foo` in the `impl` line. We repeat
-`'a` twice, just like on functions: `impl<'a>` defines a lifetime `'a`, and `Foo<'a>`
+`'a` twice, like on functions: `impl<'a>` defines a lifetime `'a`, and `Foo<'a>`
 uses it.
 
 ## Multiple lifetimes
@@ -282,14 +282,12 @@ to it.
 
 ## Lifetime Elision
 
-Rust supports powerful local type inference in function bodies, but it’s
-forbidden in item signatures to allow reasoning about the types based on
-the item signature alone. However, for ergonomic reasons a very restricted
-secondary inference algorithm called “lifetime elision” applies in function
-signatures. It infers only based on the signature components themselves and not
-based on the body of the function, only infers lifetime parameters, and does
-this with only three easily memorizable and unambiguous rules. This makes
-lifetime elision a shorthand for writing an item signature, while not hiding
+Rust supports powerful local type inference in the bodies of functions but not in their item signatures. 
+It's forbidden to allow reasoning about types based on the item signature alone. 
+However, for ergonomic reasons, a very restricted secondary inference algorithm called 
+“lifetime elision” does apply when judging lifetimes. Lifetime elision is concerned solely to infer 
+lifetime parameters using three easily memorizable and unambiguous rules. This means lifetime elision 
+acts as a shorthand for writing an item signature, while not hiding
 away the actual types involved as full local inference would if applied to it.
 
 When talking about lifetime elision, we use the term *input lifetime* and
@@ -353,8 +351,8 @@ fn frob<'a, 'b>(s: &'a str, t: &'b str) -> &str; // Expanded: Output lifetime is
 fn get_mut(&mut self) -> &mut T; // elided
 fn get_mut<'a>(&'a mut self) -> &'a mut T; // expanded
 
-fn args<T:ToCStr>(&mut self, args: &[T]) -> &mut Command; // elided
-fn args<'a, 'b, T:ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command; // expanded
+fn args<T: ToCStr>(&mut self, args: &[T]) -> &mut Command; // elided
+fn args<'a, 'b, T: ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command; // expanded
 
 fn new(buf: &mut [u8]) -> BufWriter; // elided
 fn new<'a>(buf: &'a mut [u8]) -> BufWriter<'a>; // expanded
diff --git a/src/doc/book/loops.md b/src/doc/book/loops.md
