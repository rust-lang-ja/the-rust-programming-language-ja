--- a/src/doc/book/variable-bindings.md
+++ b/src/doc/book/variable-bindings.md
@@ -2,7 +2,7 @@
 
 Virtually every non-'Hello World’ Rust program uses *variable bindings*. They
 bind some value to a name, so it can be used later. `let` is
-used to introduce a binding, just like this:
+used to introduce a binding, like this:
 
 ```rust
 fn main() {
@@ -18,16 +18,16 @@ function, rather than leaving it off. Otherwise, you’ll get an error.
 
 In many languages, a variable binding would be called a *variable*, but Rust’s
 variable bindings have a few tricks up their sleeves. For example the
-left-hand side of a `let` expression is a ‘[pattern][pattern]’, not just a
+left-hand side of a `let` statement is a ‘[pattern][pattern]’, not a
 variable name. This means we can do things like:
 
 ```rust
 let (x, y) = (1, 2);
 ```
 
-After this expression is evaluated, `x` will be one, and `y` will be two.
+After this statement is evaluated, `x` will be one, and `y` will be two.
 Patterns are really powerful, and have [their own section][pattern] in the
-book. We don’t need those features for now, so we’ll just keep this in the back
+book. We don’t need those features for now, so we’ll keep this in the back
 of our minds as we go forward.
 
 [pattern]: patterns.html
@@ -169,10 +169,10 @@ in the middle of a string." We add a comma, and then `x`, to indicate that we
 want `x` to be the value we’re interpolating. The comma is used to separate
 arguments we pass to functions and macros, if you’re passing more than one.
 
-When you just use the curly braces, Rust will attempt to display the value in a
+When you use the curly braces, Rust will attempt to display the value in a
 meaningful way by checking out its type. If you want to specify the format in a
 more detailed manner, there are a [wide number of options available][format].
-For now, we'll just stick to the default: integers aren't very complicated to
+For now, we'll stick to the default: integers aren't very complicated to
 print.
 
 [format]: ../std/fmt/index.html
diff --git a/src/doc/book/vectors.md b/src/doc/book/vectors.md
