--- a/src/doc/book/match.md
+++ b/src/doc/book/match.md
@@ -23,26 +23,24 @@ match x {
 `match` takes an expression and then branches based on its value. Each ‘arm’ of
 the branch is of the form `val => expression`. When the value matches, that arm’s
 expression will be evaluated. It’s called `match` because of the term ‘pattern
-matching’, which `match` is an implementation of. There’s an [entire section on
+matching’, which `match` is an implementation of. There’s a [separate section on
 patterns][patterns] that covers all the patterns that are possible here.
 
 [patterns]: patterns.html
 
-So what’s the big advantage? Well, there are a few. First of all, `match`
-enforces ‘exhaustiveness checking’. Do you see that last arm, the one with the
-underscore (`_`)? If we remove that arm, Rust will give us an error:
+One of the many advantages of `match` is it enforces ‘exhaustiveness checking’. 
+For example if we remove the last arm with the underscore `_`, the compiler will 
+give us an error:
 
 ```text
 error: non-exhaustive patterns: `_` not covered
 ```
 
-In other words, Rust is trying to tell us we forgot a value. Because `x` is an
-integer, Rust knows that it can have a number of different values – for
-example, `6`. Without the `_`, however, there is no arm that could match, and
-so Rust refuses to compile the code. `_` acts like a ‘catch-all arm’. If none
-of the other arms match, the arm with `_` will, and since we have this
-catch-all arm, we now have an arm for every possible value of `x`, and so our
-program will compile successfully.
+Rust is telling us that we forgot a value. The compiler infers from `x` that it
+can have any positive 32bit value; for example 1 to 2,147,483,647. The `_` acts 
+as a 'catch-all', and will catch all possible values that *aren't* specified in 
+an arm of `match`. As you can see with the previous example, we provide `match` 
+arms for integers 1-5, if `x` is 6 or any other value, then it is caught by `_`.
 
 `match` is also an expression, which means we can use it on the right-hand
 side of a `let` binding or directly where an expression is used:
@@ -60,7 +58,8 @@ let number = match x {
 };
 ```
 
-Sometimes it’s a nice way of converting something from one type to another.
+Sometimes it’s a nice way of converting something from one type to another; in 
+this example the integers are converted to `String`.
 
 # Matching on enums
 
@@ -91,7 +90,8 @@ fn process_message(msg: Message) {
 
 Again, the Rust compiler checks exhaustiveness, so it demands that you
 have a match arm for every variant of the enum. If you leave one off, it
-will give you a compile-time error unless you use `_`.
+will give you a compile-time error unless you use `_` or provide all possible 
+arms.
 
 Unlike the previous uses of `match`, you can’t use the normal `if`
 statement to do this. You can use the [`if let`][if-let] statement,
diff --git a/src/doc/book/method-syntax.md b/src/doc/book/method-syntax.md
