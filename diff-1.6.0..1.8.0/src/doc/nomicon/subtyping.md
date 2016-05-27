--- a/src/doc/nomicon/subtyping.md
+++ b/src/doc/nomicon/subtyping.md
@@ -44,10 +44,11 @@ subtyping of its outputs. There are two kinds of variance in Rust:
 * F is *invariant* over `T` otherwise (no subtyping relation can be derived)
 
 (For those of you who are familiar with variance from other languages, what we
-refer to as "just" variance is in fact *covariance*. Rust does not have
-contravariance. Historically Rust did have some contravariance but it was
-scrapped due to poor interactions with other features. If you experience
-contravariance in Rust call your local compiler developer for medical advice.)
+refer to as "just" variance is in fact *covariance*. Rust has *contravariance*
+for functions. The future of contravariance is uncertain and it may be
+scrapped. For now, `fn(T)` is contravariant in `T`, which is used in matching
+methods in trait implementations to the trait definition. Traits don't have
+inferred variance, so `Fn(T)` is invariant in `T`).
 
 Some important variances:
 
@@ -200,7 +201,7 @@ use std::cell::Cell;
 
 struct Foo<'a, 'b, A: 'a, B: 'b, C, D, E, F, G, H> {
     a: &'a A,     // variant over 'a and A
-    b: &'b mut B, // invariant over 'b and B
+    b: &'b mut B, // variant over 'b and invariant over B
     c: *const C,  // variant over C
     d: *mut D,    // invariant over D
     e: Vec<E>,    // variant over E
diff --git a/src/doc/nomicon/vec-dealloc.md b/src/doc/nomicon/vec-dealloc.md
