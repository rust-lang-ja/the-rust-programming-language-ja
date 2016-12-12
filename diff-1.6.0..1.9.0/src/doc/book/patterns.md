--- a/src/doc/book/patterns.md
+++ b/src/doc/book/patterns.md
 
@@ -324,7 +358,7 @@ match x {
 ```
 
 This prints `no`, because the `if` applies to the whole of `4 | 5`, and not to
-just the `5`. In other words, the precedence of `if` behaves like this:
+only the `5`. In other words, the precedence of `if` behaves like this:
 
 ```text
 (4 | 5) if y => ...
diff --git a/src/doc/book/primitive-types.md b/src/doc/book/primitive-types.md
