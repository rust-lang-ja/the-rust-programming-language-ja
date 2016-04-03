--- a/src/doc/reference.md
+++ b/src/doc/reference.md
@@ -208,10 +208,10 @@ A _string literal_ is a sequence of any Unicode characters enclosed within two
 which must be _escaped_ by a preceding `U+005C` character (`\`).
 
 Line-break characters are allowed in string literals. Normally they represent
-themselves (i.e. no translation), but as a special exception, when a `U+005C`
-character (`\`) occurs immediately before the newline, the `U+005C` character,
-the newline, and all whitespace at the beginning of the next line are ignored.
-Thus `a` and `b` are equal:
+themselves (i.e. no translation), but as a special exception, when an unescaped
+`U+005C` character (`\`) occurs immediately before the newline (`U+000A`), the
+`U+005C` character, the newline, and all whitespace at the beginning of the
+next line are ignored. Thus `a` and `b` are equal:
 
 ```rust
 let a = "foobar";
@@ -2044,7 +2044,7 @@ The following configurations must be defined by the implementation:
   production.  For example, it controls the behavior of the standard library's
   `debug_assert!` macro.
 * `target_arch = "..."` - Target CPU architecture, such as `"x86"`, `"x86_64"`
-  `"mips"`, `"powerpc"`, `"arm"`, or `"aarch64"`.
+  `"mips"`, `"powerpc"`, `"powerpc64"`, `"powerpc64le"`, `"arm"`, or `"aarch64"`.
 * `target_endian = "..."` - Endianness of the target CPU, either `"little"` or
   `"big"`.
 * `target_env = ".."` - An option provided by the compiler by default
@@ -2372,10 +2372,6 @@ The currently implemented features of the reference compiler are:
                    Such items should not be allowed by the compiler to exist,
                    so if you need this there probably is a compiler bug.
 
-* `visible_private_types` - Allows public APIs to expose otherwise private
-                            types, e.g. as the return type of a public function.
-                            This capability may be removed in the future.
-
 * `allow_internal_unstable` - Allows `macro_rules!` macros to be tagged with the
                               `#[allow_internal_unstable]` attribute, designed
                               to allow `std` macros to call
@@ -2390,6 +2386,13 @@ The currently implemented features of the reference compiler are:
 * - `stmt_expr_attributes` - Allows attributes on expressions and
                              non-item statements.
 
+* - `deprecated` - Allows using the `#[deprecated]` attribute.
+
+* - `type_ascription` - Allows type ascription expressions `expr: Type`.
+
+* - `abi_vectorcall` - Allows the usage of the vectorcall calling convention
+                             (e.g. `extern "vectorcall" func fn_();`)
+
 If a feature is promoted to a language feature, then all existing programs will
 start to receive compilation warnings about `#![feature]` directives which enabled
 the new feature (because the directive is no longer necessary). However, if a
@@ -3677,10 +3680,10 @@ sites are:
 
 * `let` statements where an explicit type is given.
 
-   For example, `128` is coerced to have type `i8` in the following:
+   For example, `42` is coerced to have type `i8` in the following:
 
    ```rust
-   let _: i8 = 128;
+   let _: i8 = 42;
    ```
 
 * `static` and `const` statements (similar to `let` statements).
@@ -3690,36 +3693,36 @@ sites are:
   The value being coerced is the actual parameter, and it is coerced to
   the type of the formal parameter.
 
-  For example, `128` is coerced to have type `i8` in the following:
+  For example, `42` is coerced to have type `i8` in the following:
 
   ```rust
   fn bar(_: i8) { }
 
   fn main() {
-      bar(128);
+      bar(42);
   }
   ```
 
 * Instantiations of struct or variant fields
 
-  For example, `128` is coerced to have type `i8` in the following:
+  For example, `42` is coerced to have type `i8` in the following:
 
   ```rust
   struct Foo { x: i8 }
 
   fn main() {
-      Foo { x: 128 };
+      Foo { x: 42 };
   }
   ```
 
 * Function results, either the final line of a block if it is not
   semicolon-terminated or any expression in a `return` statement
 
-  For example, `128` is coerced to have type `i8` in the following:
+  For example, `42` is coerced to have type `i8` in the following:
 
   ```rust
   fn foo() -> i8 {
-      128
+      42
   }
   ```
 
