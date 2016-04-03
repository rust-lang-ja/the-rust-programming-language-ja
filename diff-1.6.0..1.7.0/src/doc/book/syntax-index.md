--- a/src/doc/book/syntax-index.md
+++ b/src/doc/book/syntax-index.md
@@ -41,6 +41,7 @@
 
 * `!` (`ident!(…)`, `ident!{…}`, `ident![…]`): denotes macro expansion.  See [Macros].
 * `!` (`!expr`): bitwise or logical complement.  Overloadable (`Not`).
+* `!=` (`var != expr`): nonequality comparison.  Overloadable (`PartialEq`).
 * `%` (`expr % expr`): arithmetic remainder.  Overloadable (`Rem`).
 * `%=` (`var %= expr`): arithmetic remainder & assignment.
 * `&` (`expr & expr`): bitwise and.  Overloadable (`BitAnd`).
@@ -75,13 +76,13 @@
 * `;` (`[…; len]`): part of fixed-size array syntax.  See [Primitive Types (Arrays)].
 * `<<` (`expr << expr`): left-shift.  Overloadable (`Shl`).
 * `<<=` (`var <<= expr`): left-shift & assignment.
-* `<` (`expr < expr`): less-than comparison.  Overloadable (`Cmp`, `PartialCmp`).
-* `<=` (`var <= expr`): less-than or equal-to comparison.  Overloadable (`Cmp`, `PartialCmp`).
+* `<` (`expr < expr`): less-than comparison.  Overloadable (`PartialOrd`).
+* `<=` (`var <= expr`): less-than or equal-to comparison.  Overloadable (`PartialOrd`).
 * `=` (`var = expr`, `ident = type`): assignment/equivalence.  See [Variable Bindings], [`type` Aliases], generic parameter defaults.
-* `==` (`var == expr`): comparison.  Overloadable (`Eq`, `PartialEq`).
+* `==` (`var == expr`): equality comparison.  Overloadable (`PartialEq`).
 * `=>` (`pat => expr`): part of match arm syntax.  See [Match].
-* `>` (`expr > expr`): greater-than comparison.  Overloadable (`Cmp`, `PartialCmp`).
-* `>=` (`var >= expr`): greater-than or equal-to comparison.  Overloadable (`Cmp`, `PartialCmp`).
+* `>` (`expr > expr`): greater-than comparison.  Overloadable (`PartialOrd`).
+* `>=` (`var >= expr`): greater-than or equal-to comparison.  Overloadable (`PartialOrd`).
 * `>>` (`expr >> expr`): right-shift.  Overloadable (`Shr`).
 * `>>=` (`var >>= expr`): right-shift & assignment.
 * `@` (`ident @ pat`): pattern binding.  See [Patterns (Bindings)].
@@ -234,5 +235,5 @@
 [Traits (Multiple Trait Bounds)]: traits.html#multiple-trait-bounds
 [Traits]: traits.html
 [Unsafe]: unsafe.html
-[Unsized Types (`?Sized`)]: unsized-types.html#?sized
+[Unsized Types (`?Sized`)]: unsized-types.html#sized
 [Variable Bindings]: variable-bindings.html
diff --git a/src/doc/book/testing.md b/src/doc/book/testing.md
