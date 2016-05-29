--- a/src/doc/book/functions.md
+++ b/src/doc/book/functions.md
@@ -68,7 +68,7 @@ You get this error:
 
 ```text
 expected one of `!`, `:`, or `@`, found `)`
-fn print_number(x, y) {
+fn print_sum(x, y) {
 ```
 
 This is a deliberate design decision. While full-program inference is possible,
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
@@ -246,6 +246,19 @@ stack backtrace:
   13:                0x0 - <unknown>
 ```
 
+If you need to override an already set `RUST_BACKTRACE`, 
+in cases when you cannot just unset the variable, 
+then set it to `0` to avoid getting a backtrace. 
+Any other value(even no value at all) turns on backtrace.
+
+```text
+$ export RUST_BACKTRACE=1
+...
+$ RUST_BACKTRACE=0 ./diverges 
+thread '<main>' panicked at 'This function never returns!', hello.rs:2
+note: Run with `RUST_BACKTRACE=1` for a backtrace.
+```
+
 `RUST_BACKTRACE` also works with Cargo’s `run` command:
 
 ```text
diff --git a/src/doc/book/generics.md b/src/doc/book/generics.md
