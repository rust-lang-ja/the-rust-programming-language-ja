--- a/src/doc/book/references-and-borrowing.md
+++ b/src/doc/book/references-and-borrowing.md
@@ -84,7 +84,7 @@ it borrows ownership. A binding that borrows something does not deallocate the
 resource when it goes out of scope. This means that after the call to `foo()`,
 we can use our original bindings again.
 
-References are immutable, just like bindings. This means that inside of `foo()`,
+References are immutable, like bindings. This means that inside of `foo()`,
 the vectors can’t be changed at all:
 
 ```rust,ignore
@@ -126,10 +126,10 @@ the thing `y` points at. You’ll notice that `x` had to be marked `mut` as well
 If it wasn’t, we couldn’t take a mutable borrow to an immutable value.
 
 You'll also notice we added an asterisk (`*`) in front of `y`, making it `*y`,
-this is because `y` is an `&mut` reference. You'll also need to use them for
+this is because `y` is a `&mut` reference. You'll also need to use them for
 accessing the contents of a reference as well.
 
-Otherwise, `&mut` references are just like references. There _is_ a large
+Otherwise, `&mut` references are like references. There _is_ a large
 difference between the two, and how they interact, though. You can tell
 something is fishy in the above example, because we need that extra scope, with
 the `{` and `}`. If we remove them, we get an error:
@@ -263,7 +263,7 @@ for i in &v {
 }
 ```
 
-This prints out one through three. As we iterate through the vectors, we’re
+This prints out one through three. As we iterate through the vector, we’re
 only given references to the elements. And `v` is itself borrowed as immutable,
 which means we can’t change it while we’re iterating:
 
diff --git a/src/doc/book/rust-inside-other-languages.md b/src/doc/book/rust-inside-other-languages.md
