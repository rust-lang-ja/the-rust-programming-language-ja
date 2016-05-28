--- a/src/doc/book/traits.md
+++ b/src/doc/book/traits.md
@@ -44,8 +44,8 @@ impl HasArea for Circle {
 ```
 
 As you can see, the `trait` block looks very similar to the `impl` block,
-but we don’t define a body, just a type signature. When we `impl` a trait,
-we use `impl Trait for Item`, rather than just `impl Item`.
+but we don’t define a body, only a type signature. When we `impl` a trait,
+we use `impl Trait for Item`, rather than only `impl Item`.
 
 ## Trait bounds on generic functions
 
@@ -154,7 +154,7 @@ print_area(5);
 We get a compile-time error:
 
 ```text
-error: the trait `HasArea` is not implemented for the type `_` [E0277]
+error: the trait bound `_ : HasArea` is not satisfied [E0277]
 ```
 
 ## Trait bounds on generic structs
@@ -277,16 +277,22 @@ This will compile without error.
 This means that even if someone does something bad like add methods to `i32`,
 it won’t affect you, unless you `use` that trait.
 
-There’s one more restriction on implementing traits: either the trait, or the
-type you’re writing the `impl` for, must be defined by you. So, we could
-implement the `HasArea` type for `i32`, because `HasArea` is in our code. But
-if we tried to implement `ToString`, a trait provided by Rust, for `i32`, we could
-not, because neither the trait nor the type are in our code.
+There’s one more restriction on implementing traits: either the trait
+or the type you’re implementing it for must be defined by you. Or more
+precisely, one of them must be defined in the same crate as the `impl`
+you're writing. For more on Rust's module and package system, see the
+chapter on [crates and modules][cm].
+
+So, we could implement the `HasArea` type for `i32`, because we defined
+`HasArea` in our code. But if we tried to implement `ToString`, a trait
+provided by Rust, for `i32`, we could not, because neither the trait nor
+the type are defined in our crate.
 
 One last thing about traits: generic functions with a trait bound use
 ‘monomorphization’ (mono: one, morph: form), so they are statically dispatched.
 What’s that mean? Check out the chapter on [trait objects][to] for more details.
 
+[cm]: crates-and-modules.html
 [to]: trait-objects.html
 
 # Multiple trait bounds
@@ -490,7 +496,7 @@ impl FooBar for Baz {
 If we forget to implement `Foo`, Rust will tell us:
 
 ```text
-error: the trait `main::Foo` is not implemented for the type `main::Baz` [E0277]
+error: the trait bound `main::Baz : main::Foo` is not satisfied [E0277]
 ```
 
 # Deriving
diff --git a/src/doc/book/unsafe.md b/src/doc/book/unsafe.md
