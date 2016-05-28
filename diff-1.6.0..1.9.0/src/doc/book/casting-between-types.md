--- a/src/doc/book/casting-between-types.md
+++ b/src/doc/book/casting-between-types.md
@@ -17,12 +17,12 @@ function result.
 The most common case of coercion is removing mutability from a reference:
 
  * `&mut T` to `&T`
- 
+
 An analogous conversion is to remove mutability from a
 [raw pointer](raw-pointers.md):
 
  * `*mut T` to `*const T`
- 
+
 References can also be coerced to raw pointers:
 
  * `&T` to `*const T`
@@ -32,7 +32,7 @@ References can also be coerced to raw pointers:
 Custom coercions may be defined using [`Deref`](deref-coercions.md).
 
 Coercion is transitive.
- 
+
 # `as`
 
 The `as` keyword does safe casting:
@@ -64,7 +64,7 @@ A cast `e as U` is also valid in any of the following cases:
     and `U` is an integer type; *enum-cast*
  * `e` has type `bool` or `char` and `U` is an integer type; *prim-int-cast*
  * `e` has type `u8` and `U` is `char`; *u8-char-cast*
- 
+
 For example
 
 ```rust
@@ -98,9 +98,9 @@ The semantics of numeric casts are:
 
 [float-int]: https://github.com/rust-lang/rust/issues/10184
 [float-float]: https://github.com/rust-lang/rust/issues/15536
- 
+
 ## Pointer casts
- 
+
 Perhaps surprisingly, it is safe to cast [raw pointers](raw-pointers.md) to and
 from integers, and to cast between pointers to different types subject to
 some constraints. It is only unsafe to dereference the pointer:
@@ -114,7 +114,7 @@ let b = a as u32;
 
 * `e` has type `*T`, `U` has type `*U_0`, and either `U_0: Sized` or
   `unsize_kind(T) == unsize_kind(U_0)`; a *ptr-ptr-cast*
-  
+
 * `e` has type `*T` and `U` is a numeric type, while `T: Sized`; *ptr-addr-cast*
 
 * `e` is an integer and `U` is `*U_0`, while `U_0: Sized`; *addr-ptr-cast*
@@ -154,7 +154,7 @@ implemented. For this, we need something more dangerous.
 The `transmute` function is provided by a [compiler intrinsic][intrinsics], and
 what it does is very simple, but very scary. It tells Rust to treat a value of
 one type as though it were another type. It does this regardless of the
-typechecking system, and just completely trusts you.
+typechecking system, and completely trusts you.
 
 [intrinsics]: intrinsics.html
 
diff --git a/src/doc/book/choosing-your-guarantees.md b/src/doc/book/choosing-your-guarantees.md
