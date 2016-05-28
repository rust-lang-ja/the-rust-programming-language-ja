--- a/src/doc/style/features/traits/generics.md
+++ b/src/doc/style/features/traits/generics.md
@@ -27,8 +27,7 @@ explicitly implement to be used by this generic function.
 * _Inference_. Since the type parameters to generic functions can usually be
   inferred, generic functions can help cut down on verbosity in code where
   explicit conversions or other method calls would usually be necessary. See the
-  [overloading/implicits use case](#use-case-limited-overloading-andor-implicit-conversions)
-  below.
+  overloading/implicits use case below.
 * _Precise types_. Because generics give a _name_ to the specific type
   implementing a trait, it is possible to be precise about places where that
   exact type is required or produced. For example, a function
@@ -51,7 +50,7 @@ explicitly implement to be used by this generic function.
   a `Vec<T>` contains elements of a single concrete type (and, indeed, the
   vector representation is specialized to lay these out in line). Sometimes
   heterogeneous collections are useful; see
-  [trait objects](#use-case-trait-objects) below.
+  trait objects below.
 * _Signature verbosity_. Heavy use of generics can bloat function signatures.
   **[Ed. note]** This problem may be mitigated by some language improvements; stay tuned.
 
diff --git a/src/doc/style/style/naming/README.md b/src/doc/style/style/naming/README.md
