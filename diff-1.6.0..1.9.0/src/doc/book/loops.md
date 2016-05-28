--- a/src/doc/book/loops.md
+++ b/src/doc/book/loops.md
@@ -125,7 +125,8 @@ Don't forget to add the parentheses around the range.
 #### On iterators:
 
 ```rust
-# let lines = "hello\nworld".lines();
+let lines = "hello\nworld".lines();
+
 for (linenumber, line) in lines.enumerate() {
     println!("{}: {}", linenumber, line);
 }
@@ -134,10 +135,8 @@ for (linenumber, line) in lines.enumerate() {
 Outputs:
 
 ```text
-0: Content of line one
-1: Content of line two
-2: Content of line three
-3: Content of line four
+0: hello
+1: world
 ```
 
 ## Ending iteration early
@@ -195,7 +194,7 @@ for x in 0..10 {
 You may also encounter situations where you have nested loops and need to
 specify which one your `break` or `continue` statement is for. Like most
 other languages, by default a `break` or `continue` will apply to innermost
-loop. In a situation where you would like to a `break` or `continue` for one
+loop. In a situation where you would like to `break` or `continue` for one
 of the outer loops, you can use labels to specify which loop the `break` or
  `continue` statement applies to. This will only print when both `x` and `y` are
  odd:
diff --git a/src/doc/book/macros.md b/src/doc/book/macros.md
