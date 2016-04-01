--- a/src/doc/book/patterns.md
+++ b/src/doc/book/patterns.md
@@ -27,7 +27,7 @@ There’s one pitfall with patterns: like anything that introduces a new binding
 they introduce shadowing. For example:
 
 ```rust
-let x = 'x';
+let x = 1;
 let c = 'c';
 
 match c {
@@ -41,12 +41,14 @@ This prints:
 
 ```text
 x: c c: c
-x: x
+x: 1
 ```
 
 In other words, `x =>` matches the pattern and introduces a new binding named
-`x` that’s in scope for the match arm. Because we already have a binding named
-`x`, this new `x` shadows it.
+`x`. This new binding is in scope for the match arm and takes on the value of
+`c`. Notice that the value of `x` outside the scope of the match has no bearing
+on the value of `x` within it. Because we already have a binding named `x`, this
+new `x` shadows it.
 
 # Multiple patterns
 
@@ -116,7 +118,7 @@ match origin {
 
 This prints `x is 0`.
 
-You can do this kind of match on any member, not just the first:
+You can do this kind of match on any member, not only the first:
 
 ```rust
 struct Point {
@@ -153,7 +155,7 @@ match some_value {
 ```
 
 In the first arm, we bind the value inside the `Ok` variant to `value`. But
-in the `Err` arm, we use `_` to disregard the specific error, and just print
+in the `Err` arm, we use `_` to disregard the specific error, and print
 a general error message.
 
 `_` is valid in any pattern that creates a binding. This can be useful to
@@ -324,7 +326,7 @@ match x {
 ```
 
 This prints `no`, because the `if` applies to the whole of `4 | 5`, and not to
-just the `5`. In other words, the precedence of `if` behaves like this:
+only the `5`. In other words, the precedence of `if` behaves like this:
 
 ```text
 (4 | 5) if y => ...
diff --git a/src/doc/book/primitive-types.md b/src/doc/book/primitive-types.md
