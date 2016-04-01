--- a/src/doc/book/functions.md
+++ b/src/doc/book/functions.md
@@ -124,7 +124,7 @@ statement `x + 1;` doesn’t return a value. There are two kinds of statements i
 Rust: ‘declaration statements’ and ‘expression statements’. Everything else is
 an expression. Let’s talk about declaration statements first.
 
-In some languages, variable bindings can be written as expressions, not just
+In some languages, variable bindings can be written as expressions, not
 statements. Like Ruby:
 
 ```ruby
@@ -145,7 +145,7 @@ Note that assigning to an already-bound variable (e.g. `y = 5`) is still an
 expression, although its value is not particularly useful. Unlike other
 languages where an assignment evaluates to the assigned value (e.g. `5` in the
 previous example), in Rust the value of an assignment is an empty tuple `()`
-because the assigned value can have [just one owner](ownership.html), and any
+because the assigned value can have [only one owner](ownership.html), and any
 other returned value would be too surprising:
 
 ```rust
diff --git a/src/doc/book/generics.md b/src/doc/book/generics.md
