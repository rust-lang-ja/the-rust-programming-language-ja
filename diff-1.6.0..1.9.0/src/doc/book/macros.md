--- a/src/doc/book/macros.md
+++ b/src/doc/book/macros.md
@@ -285,9 +285,11 @@ This expands to
 
 ```text
 const char *state = "reticulating splines";
-int state = get_log_state();
-if (state > 0) {
-    printf("log(%d): %s\n", state, state);
+{
+    int state = get_log_state();
+    if (state > 0) {
+        printf("log(%d): %s\n", state, state);
+    }
 }
 ```
 
@@ -335,8 +337,8 @@ fn main() {
 }
 ```
 
-Instead you need to pass the variable name into the invocation, so it’s tagged
-with the right syntax context.
+Instead you need to pass the variable name into the invocation, so that it’s
+tagged with the right syntax context.
 
 ```rust
 macro_rules! foo {
@@ -468,7 +470,7 @@ which syntactic form it matches.
 * `ty`: a type. Examples: `i32`; `Vec<(char, String)>`; `&T`.
 * `pat`: a pattern. Examples: `Some(t)`; `(17, 'a')`; `_`.
 * `stmt`: a single statement. Example: `let x = 3`.
-* `block`: a brace-delimited sequence of statements. Example:
+* `block`: a brace-delimited sequence of statements and optionally an expression. Example:
   `{ log(error, "hi"); return 12; }`.
 * `item`: an [item][item]. Examples: `fn foo() { }`; `struct Bar;`.
 * `meta`: a "meta item", as found in attributes. Example: `cfg(target_os = "windows")`.
@@ -476,19 +478,19 @@ which syntactic form it matches.
 
 There are additional rules regarding the next token after a metavariable:
 
-* `expr` variables may only be followed by one of: `=> , ;`
-* `ty` and `path` variables may only be followed by one of: `=> , : = > as`
-* `pat` variables may only be followed by one of: `=> , = if in`
+* `expr` and `stmt` variables may only be followed by one of: `=> , ;`
+* `ty` and `path` variables may only be followed by one of: `=> , = | ; : > [ { as where`
+* `pat` variables may only be followed by one of: `=> , = | if in`
 * Other variables may be followed by any token.
 
 These rules provide some flexibility for Rust’s syntax to evolve without
 breaking existing macros.
 
 The macro system does not deal with parse ambiguity at all. For example, the
-grammar `$($t:ty)* $e:expr` will always fail to parse, because the parser would
-be forced to choose between parsing `$t` and parsing `$e`. Changing the
+grammar `$($i:ident)* $e:expr` will always fail to parse, because the parser would
+be forced to choose between parsing `$i` and parsing `$e`. Changing the
 invocation syntax to put a distinctive token in front can solve the problem. In
-this case, you can write `$(T $t:ty)* E $e:exp`.
+this case, you can write `$(I $i:ident)* E $e:expr`.
 
 [item]: ../reference.html#items
 
@@ -611,8 +613,7 @@ to define a single macro that works both inside and outside our library. The
 function name will expand to either `::increment` or `::mylib::increment`.
 
 To keep this system simple and correct, `#[macro_use] extern crate ...` may
-only appear at the root of your crate, not inside `mod`. This ensures that
-`$crate` is a single identifier.
+only appear at the root of your crate, not inside `mod`.
 
 # The deep end
 
diff --git a/src/doc/book/match.md b/src/doc/book/match.md
