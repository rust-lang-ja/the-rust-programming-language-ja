--- a/src/doc/book/lifetimes.md
+++ b/src/doc/book/lifetimes.md
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
@@ -353,8 +353,8 @@ fn frob<'a, 'b>(s: &'a str, t: &'b str) -> &str; // Expanded: Output lifetime is
 fn get_mut(&mut self) -> &mut T; // elided
 fn get_mut<'a>(&'a mut self) -> &'a mut T; // expanded
 
-fn args<T:ToCStr>(&mut self, args: &[T]) -> &mut Command; // elided
-fn args<'a, 'b, T:ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command; // expanded
+fn args<T: ToCStr>(&mut self, args: &[T]) -> &mut Command; // elided
+fn args<'a, 'b, T: ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command; // expanded
 
 fn new(buf: &mut [u8]) -> BufWriter; // elided
 fn new<'a>(buf: &'a mut [u8]) -> BufWriter<'a>; // expanded
diff --git a/src/doc/book/loops.md b/src/doc/book/loops.md
