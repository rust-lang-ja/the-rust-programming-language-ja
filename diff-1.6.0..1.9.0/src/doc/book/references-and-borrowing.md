--- a/src/doc/book/references-and-borrowing.md
+++ b/src/doc/book/references-and-borrowing.md
@@ -23,7 +23,7 @@ Before we get to the details, two important notes about the ownership system.
 Rust has a focus on safety and speed. It accomplishes these goals through many
 ‘zero-cost abstractions’, which means that in Rust, abstractions cost as little
 as possible in order to make them work. The ownership system is a prime example
-of a zero cost abstraction. All of the analysis we’ll talk about in this guide
+of a zero-cost abstraction. All of the analysis we’ll talk about in this guide
 is _done at compile time_. You do not pay any run-time cost for any of these
 features.
 
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
@@ -163,8 +163,8 @@ both at the same time:
 * exactly one mutable reference (`&mut T`).
 
 
-You may notice that this is very similar, though not exactly the same as,
-to the definition of a data race:
+You may notice that this is very similar to, though not exactly the same as,
+the definition of a data race:
 
 > There is a ‘data race’ when two or more pointers access the same memory
 > location at the same time, where at least one of them is writing, and the
@@ -211,9 +211,10 @@ fn main() {
 ```
 
 In other words, the mutable borrow is held through the rest of our example. What
-we want is for the mutable borrow to end _before_ we try to call `println!` and
-make an immutable borrow. In Rust, borrowing is tied to the scope that the
-borrow is valid for. And our scopes look like this:
+we want is for the mutable borrow by `y` to end so that the resource can be
+returned to the owner, `x`. `x` can then provide a immutable borrow to `println!`.
+In Rust, borrowing is tied to the scope that the borrow is valid for. And our
+scopes look like this:
 
 ```rust,ignore
 let mut x = 5;
@@ -263,7 +264,7 @@ for i in &v {
 }
 ```
 
-This prints out one through three. As we iterate through the vectors, we’re
+This prints out one through three. As we iterate through the vector, we’re
 only given references to the elements. And `v` is itself borrowed as immutable,
 which means we can’t change it while we’re iterating:
 
@@ -378,4 +379,3 @@ statement 1 at 3:14
 
 In the above example, `y` is declared before `x`, meaning that `y` lives longer
 than `x`, which is not allowed.
-
diff --git a/src/doc/book/rust-inside-other-languages.md b/src/doc/book/rust-inside-other-languages.md
