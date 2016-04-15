--- a/src/doc/book/syntax-index.md
+++ b/src/doc/book/syntax-index.md
@@ -2,7 +2,7 @@
 
 ## Keywords
 
-* `as`: primitive casting.  See [Casting Between Types (`as`)].
+* `as`: primitive casting, or disambiguating the specific trait containing an item.  See [Casting Between Types (`as`)], [Universal Function Call Syntax (Angle-bracket Form)], [Associated Types].
 * `break`: break out of loop.  See [Loops (Ending Iteration Early)].
 * `const`: constant items and constant raw pointers.  See [`const` and `static`], [Raw Pointers].
 * `continue`: continue to next loop iteration.  See [Loops (Ending Iteration Early)].
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
@@ -114,8 +115,11 @@
 * `::path`: path relative to the crate root (*i.e.* an explicitly absolute path).  See [Crates and Modules (Re-exporting with `pub use`)].
 * `self::path`: path relative to the current module (*i.e.* an explicitly relative path).  See [Crates and Modules (Re-exporting with `pub use`)].
 * `super::path`: path relative to the parent of the current module.  See [Crates and Modules (Re-exporting with `pub use`)].
-* `type::ident`: associated constants, functions, and types.  See [Associated Types].
+* `type::ident`, `<type as trait>::ident`: associated constants, functions, and types.  See [Associated Types].
 * `<type>::…`: associated item for a type which cannot be directly named (*e.g.* `<&T>::…`, `<[T]>::…`, *etc.*).  See [Associated Types].
+* `trait::method(…)`: disambiguating a method call by naming the trait which defines it. See [Universal Function Call Syntax].
+* `type::method(…)`: disambiguating a method call by naming the type for which it's defined. See [Universal Function Call Syntax].
+* `<type as trait>::method(…)`: disambiguating a method call by naming the trait _and_ type. See [Universal Function Call Syntax (Angle-bracket Form)].
 
 <!-- Generics -->
 
@@ -131,7 +135,8 @@
 <!-- Constraints -->
 
 * `T: U`: generic parameter `T` constrained to types that implement `U`.  See [Traits].
-* `T: 'a`: generic type `T` must outlive lifetime `'a`.
+* `T: 'a`: generic type `T` must outlive lifetime `'a`. When we say that a type 'outlives' the lifetime, we mean that it cannot transitively contain any references with lifetimes shorter than `'a`.
+* `T : 'static`: The generic type `T` contains no borrowed references other than `'static` ones.
 * `'b: 'a`: generic lifetime `'b` must outlive lifetime `'a`.
 * `T: ?Sized`: allow generic type parameter to be a dynamically-sized type.  See [Unsized Types (`?Sized`)].
 * `'a + trait`, `trait + trait`: compound type constraint.  See [Traits (Multiple Trait Bounds)].
@@ -233,6 +238,8 @@
 [Traits (`where` clause)]: traits.html#where-clause
 [Traits (Multiple Trait Bounds)]: traits.html#multiple-trait-bounds
 [Traits]: traits.html
+[Universal Function Call Syntax]: ufcs.html
+[Universal Function Call Syntax (Angle-bracket Form)]: ufcs.html#angle-bracket-form
 [Unsafe]: unsafe.html
-[Unsized Types (`?Sized`)]: unsized-types.html#?sized
+[Unsized Types (`?Sized`)]: unsized-types.html#sized
 [Variable Bindings]: variable-bindings.html
diff --git a/src/doc/book/testing.md b/src/doc/book/testing.md
