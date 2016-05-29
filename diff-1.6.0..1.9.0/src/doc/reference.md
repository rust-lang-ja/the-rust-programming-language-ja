--- a/src/doc/reference.md
+++ b/src/doc/reference.md
@@ -104,7 +104,7 @@ comments (`/** ... */`), are interpreted as a special syntax for `doc`
 `#[doc="..."]` around the body of the comment, i.e., `/// Foo` turns into
 `#[doc="Foo"]`.
 
-Line comments beginning with `//!` and block comments `/*! ... !*/` are
+Line comments beginning with `//!` and block comments `/*! ... */` are
 doc comments that apply to the parent of the comment, rather than the item
 that follows.  That is, they are equivalent to writing `#![doc="..."]` around
 the body of the comment. `//!` comments are usually used to document
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
@@ -236,6 +236,8 @@ following forms:
 * A _whitespace escape_ is one of the characters `U+006E` (`n`), `U+0072`
   (`r`), or `U+0074` (`t`), denoting the Unicode values `U+000A` (LF),
   `U+000D` (CR) or `U+0009` (HT) respectively.
+* The _null escape_ is the character `U+0030` (`0`) and denotes the Unicode
+  value `U+0000` (NUL).
 * The _backslash escape_ is the character `U+005C` (`\`) which must be
   escaped in order to denote *itself*.
 
@@ -297,6 +299,8 @@ following forms:
 * A _whitespace escape_ is one of the characters `U+006E` (`n`), `U+0072`
   (`r`), or `U+0074` (`t`), denoting the bytes values `0x0A` (ASCII LF),
   `0x0D` (ASCII CR) or `0x09` (ASCII HT) respectively.
+* The _null escape_ is the character `U+0030` (`0`) and denotes the byte
+  value `0x00` (ASCII NUL).
 * The _backslash escape_ is the character `U+005C` (`\`) which must be
   escaped in order to denote its ASCII encoding `0x5C`.
 
@@ -375,6 +379,10 @@ Examples of integer literals of various forms:
 0usize;                            // type usize
 ```
 
+Note that the Rust syntax considers `-1i8` as an application of the [unary minus
+operator](#unary-operator-expressions) to an integer literal `1i8`, rather than
+a single integer literal.
+
 ##### Floating-point literals
 
 A _floating-point literal_ has one of two forms:
@@ -841,8 +849,8 @@ extern crate std as ruststd; // linking to 'std' under another name
 
 A _use declaration_ creates one or more local name bindings synonymous with
 some other [path](#paths). Usually a `use` declaration is used to shorten the
-path required to refer to a module item. These declarations may appear at the
-top of [modules](#modules) and [blocks](grammar.html#block-expressions).
+path required to refer to a module item. These declarations may appear in
+[modules](#modules) and [blocks](grammar.html#block-expressions), usually at the top.
 
 > **Note**: Unlike in many languages,
 > `use` declarations in Rust do *not* declare linkage dependency with external crates.
@@ -984,8 +992,8 @@ fn first((value, _): (i32, i32)) -> i32 { value }
 #### Generic functions
 
 A _generic function_ allows one or more _parameterized types_ to appear in its
-signature. Each type parameter must be explicitly declared, in an
-angle-bracket-enclosed, comma-separated list following the function name.
+signature. Each type parameter must be explicitly declared in an
+angle-bracket-enclosed and comma-separated list, following the function name.
 
 ```rust,ignore
 // foo is generic over A and B
@@ -1110,6 +1118,16 @@ type Point = (u8, u8);
 let p: Point = (41, 68);
 ```
 
+Currently a type alias to an enum type cannot be used to qualify the
+constructors:
+
+```
+enum E { A }
+type F = E;
+let _: F = E::A;  // OK
+// let _: F = F::A;  // Doesn't work
+```
+
 ### Structs
 
 A _struct_ is a nominal [struct type](#struct-types) defined with the
@@ -1137,7 +1155,6 @@ the list of fields entirely. Such a struct implicitly defines a constant of
 its type with the same name. For example:
 
 ```
-# #![feature(braced_empty_structs)]
 struct Cookie;
 let c = [Cookie, Cookie {}, Cookie, Cookie {}];
 ```
@@ -1145,7 +1162,6 @@ let c = [Cookie, Cookie {}, Cookie, Cookie {}];
 is equivalent to
 
 ```
-# #![feature(braced_empty_structs)]
 struct Cookie {}
 const Cookie: Cookie = Cookie {};
 let c = [Cookie, Cookie {}, Cookie, Cookie {}];
@@ -1179,7 +1195,7 @@ Enumeration constructors can have either named or unnamed fields:
 ```rust
 enum Animal {
     Dog (String, f64),
-    Cat { name: String, weight: f64 }
+    Cat { name: String, weight: f64 },
 }
 
 let mut a: Animal = Animal::Dog("Cocoa".to_string(), 37.2);
@@ -1189,7 +1205,8 @@ a = Animal::Cat { name: "Spotty".to_string(), weight: 2.7 };
 In this example, `Cat` is a _struct-like enum variant_,
 whereas `Dog` is simply called an enum variant.
 
-Enums have a discriminant. You can assign them explicitly:
+Each enum value has a _discriminant_ which is an integer associated to it. You
+can specify it explicitly:
 
 ```
 enum Foo {
@@ -1197,10 +1214,15 @@ enum Foo {
 }
 ```
 
-If a discriminant isn't assigned, they start at zero, and add one for each
+The right hand side of the specification is interpreted as an `isize` value,
+but the compiler is allowed to use a smaller type in the actual memory layout.
+The [`repr` attribute](#ffi-attributes) can be added in order to change
+the type of the right hand side and specify the memory layout.
+
+If a discriminant isn't specified, they start at zero, and add one for each
 variant, in order.
 
-You can cast an enum to get this value:
+You can cast an enum to get its discriminant:
 
 ```
 # enum Foo { Bar = 123 }
@@ -1237,12 +1259,12 @@ const STRING: &'static str = "bitstring";
 
 struct BitsNStrings<'a> {
     mybits: [u32; 2],
-    mystring: &'a str
+    mystring: &'a str,
 }
 
 const BITS_N_STRINGS: BitsNStrings<'static> = BitsNStrings {
     mybits: BITS,
-    mystring: STRING
+    mystring: STRING,
 };
 ```
 
@@ -1661,7 +1683,7 @@ struct Foo;
 
 // Declare a public struct with a private field
 pub struct Bar {
-    field: i32
+    field: i32,
 }
 
 // Declare a public enum with two public variants
@@ -1764,7 +1786,7 @@ pub mod submodule {
 # fn main() {}
 ```
 
-For a rust program to pass the privacy checking pass, all paths must be valid
+For a Rust program to pass the privacy checking pass, all paths must be valid
 accesses given the two rules above. This includes all use statements,
 expressions, types, etc.
 
@@ -1883,6 +1905,8 @@ type int8_t = i8;
 - `should_panic` - indicates that this test function should panic, inverting the success condition.
 - `cold` - The function is unlikely to be executed, so optimize it (and calls
   to it) differently.
+- `naked` - The function utilizes a custom ABI or custom inline ASM that requires
+  epilogue and prologue to be skipped.
 
 ### Static-only attributes
 
@@ -2044,7 +2068,7 @@ The following configurations must be defined by the implementation:
   production.  For example, it controls the behavior of the standard library's
   `debug_assert!` macro.
 * `target_arch = "..."` - Target CPU architecture, such as `"x86"`, `"x86_64"`
-  `"mips"`, `"powerpc"`, `"arm"`, or `"aarch64"`.
+  `"mips"`, `"powerpc"`, `"powerpc64"`, `"arm"`, or `"aarch64"`.
 * `target_endian = "..."` - Endianness of the target CPU, either `"little"` or
   `"big"`.
 * `target_env = ".."` - An option provided by the compiler by default
@@ -2095,7 +2119,7 @@ along with their default settings.  [Compiler
 plugins](book/compiler-plugins.html#lint-plugins) can provide additional lint checks.
 
 ```{.ignore}
-mod m1 {
+pub mod m1 {
     // Missing documentation is ignored here
     #[allow(missing_docs)]
     pub fn undocumented_one() -> i32 { 1 }
@@ -2115,9 +2139,9 @@ check on and off:
 
 ```{.ignore}
 #[warn(missing_docs)]
-mod m2{
+pub mod m2{
     #[allow(missing_docs)]
-    mod nested {
+    pub mod nested {
         // Missing documentation is ignored here
         pub fn undocumented_one() -> i32 { 1 }
 
@@ -2137,7 +2161,7 @@ that lint check:
 
 ```{.ignore}
 #[forbid(missing_docs)]
-mod m3 {
+pub mod m3 {
     // Attempting to toggle warning signals an error here
     #[allow(missing_docs)]
     /// Returns 2.
@@ -2275,6 +2299,10 @@ The currently implemented features of the reference compiler are:
                     `#[derive_Foo] #[derive_Bar]`, which can be user-defined syntax
                     extensions.
 
+* `inclusive_range_syntax` - Allows use of the `a...b` and `...b` syntax for inclusive ranges.
+
+* `inclusive_range` - Allows use of the types that represent desugared inclusive ranges.
+
 * `intrinsics` - Allows use of the "rust-intrinsics" ABI. Compiler intrinsics
                  are inherently unstable and no promise about them is made.
 
@@ -2372,10 +2400,6 @@ The currently implemented features of the reference compiler are:
                    Such items should not be allowed by the compiler to exist,
                    so if you need this there probably is a compiler bug.
 
-* `visible_private_types` - Allows public APIs to expose otherwise private
-                            types, e.g. as the return type of a public function.
-                            This capability may be removed in the future.
-
 * `allow_internal_unstable` - Allows `macro_rules!` macros to be tagged with the
                               `#[allow_internal_unstable]` attribute, designed
                               to allow `std` macros to call
@@ -2385,11 +2409,17 @@ The currently implemented features of the reference compiler are:
                               terms of encapsulation).
 * - `default_type_parameter_fallback` - Allows type parameter defaults to
                                         influence type inference.
-* - `braced_empty_structs` - Allows use of empty structs and enum variants with braces.
 
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
@@ -2743,13 +2773,34 @@ let y = 0..10;
 assert_eq!(x, y);
 ```
 
+Similarly, the `...` operator will construct an object of one of the
+`std::ops::RangeInclusive` variants.
+
+```
+# #![feature(inclusive_range_syntax)]
+1...2;   // std::ops::RangeInclusive
+...4;    // std::ops::RangeToInclusive
+```
+
+The following expressions are equivalent.
+
+```
+# #![feature(inclusive_range_syntax, inclusive_range)]
+let x = std::ops::RangeInclusive::NonEmpty {start: 0, end: 10};
+let y = 0...10;
+
+assert_eq!(x, y);
+```
+
 ### Unary operator expressions
 
 Rust defines the following unary operators. They are all written as prefix operators,
 before the expression they apply to.
 
 * `-`
-  : Negation. May only be applied to numeric types.
+  : Negation. Signed integer types and floating-point types support negation. It
+    is an error to apply negation to unsigned types; for example, the compiler
+    rejects `-1u32`.
 * `*`
   : Dereference. When applied to a [pointer](#pointer-types) it denotes the
     pointed-to location. For pointers to mutable locations, the resulting
@@ -3033,7 +3084,7 @@ the case of a `while` loop, the head is the conditional expression controlling
 the loop. In the case of a `for` loop, the head is the call-expression
 controlling the loop. If the label is present, then `continue 'foo` returns
 control to the head of the loop with label `'foo`, which need not be the
-innermost label enclosing the `break` expression, but must enclose it.
+innermost label enclosing the `continue` expression, but must enclose it.
 
 A `continue` expression is only permitted in the body of a loop.
 
@@ -3209,7 +3260,7 @@ may refer to the variables bound within the pattern they follow.
 let message = match maybe_digit {
     Some(x) if x < 10 => process_digit(x),
     Some(x) => process_other(x),
-    None => panic!()
+    None => panic!(),
 };
 ```
 
@@ -3279,6 +3330,10 @@ The primitive types are the following:
 * The boolean type `bool` with values `true` and `false`.
 * The machine types (integer and floating-point).
 * The machine-dependent integer types.
+* Arrays
+* Tuples
+* Slices
+* Function pointers
 
 #### Machine types
 
@@ -3501,7 +3556,7 @@ An example of a `fn` type:
 
 ```
 fn add(x: i32, y: i32) -> i32 {
-    return x + y;
+    x + y
 }
 
 let mut x = add(5,7);
@@ -3561,8 +3616,9 @@ Each instance of a trait object includes:
    each method of `SomeTrait` that `T` implements, a pointer to `T`'s
    implementation (i.e. a function pointer).
 
-The purpose of trait objects is to permit "late binding" of methods. A call to
-a method on a trait object is only resolved to a vtable entry at compile time.
+The purpose of trait objects is to permit "late binding" of methods. Calling a
+method on a trait object results in virtual dispatch at runtime: that is, a
+function pointer is loaded from the trait object vtable and invoked indirectly.
 The actual implementation for each vtable entry can vary on an object-by-object
 basis.
 
@@ -3677,10 +3733,10 @@ sites are:
 
 * `let` statements where an explicit type is given.
 
-   For example, `128` is coerced to have type `i8` in the following:
+   For example, `42` is coerced to have type `i8` in the following:
 
    ```rust
-   let _: i8 = 128;
+   let _: i8 = 42;
    ```
 
 * `static` and `const` statements (similar to `let` statements).
@@ -3690,36 +3746,36 @@ sites are:
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
 
@@ -3855,6 +3911,9 @@ The _heap_ is a general term that describes boxes.  The lifetime of an
 allocation in the heap depends on the lifetime of the box values pointing to
 it. Since box values may themselves be passed in and out of frames, or stored
 in the heap, heap allocations may outlive the frame they are allocated within.
+An allocation in the heap is guaranteed to reside at a single location in the
+heap for the whole lifetime of the allocation - it will never be relocated as
+a result of moving a box value.
 
 ### Memory ownership
 
@@ -4057,7 +4116,7 @@ the guarantee that these issues are never caused by safe code.
 * Breaking the [pointer aliasing
   rules](http://llvm.org/docs/LangRef.html#pointer-aliasing-rules)
   with raw pointers (a subset of the rules used by C)
-* `&mut` and `&` follow LLVM’s scoped [noalias] model, except if the `&T`
+* `&mut T` and `&T` follow LLVM’s scoped [noalias] model, except if the `&T`
   contains an `UnsafeCell<U>`. Unsafe code must not violate these aliasing
   guarantees.
 * Mutating non-mutable data (that is, data reached through a shared reference or
diff --git a/src/doc/rustc-ux-guidelines.md b/src/doc/rustc-ux-guidelines.md
