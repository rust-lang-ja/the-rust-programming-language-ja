--- a/src/doc/book/casting-between-types.md
+++ b/src/doc/book/casting-between-types.md
@@ -154,7 +154,7 @@ implemented. For this, we need something more dangerous.
 The `transmute` function is provided by a [compiler intrinsic][intrinsics], and
 what it does is very simple, but very scary. It tells Rust to treat a value of
 one type as though it were another type. It does this regardless of the
-typechecking system, and just completely trusts you.
+typechecking system, and completely trusts you.
 
 [intrinsics]: intrinsics.html
 
diff --git a/src/doc/book/choosing-your-guarantees.md b/src/doc/book/choosing-your-guarantees.md
