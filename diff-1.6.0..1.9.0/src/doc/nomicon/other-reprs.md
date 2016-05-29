--- a/src/doc/nomicon/other-reprs.md
+++ b/src/doc/nomicon/other-reprs.md
@@ -57,7 +57,7 @@ These reprs have no effect on a struct.
 
 # repr(packed)
 
-`repr(packed)` forces rust to strip any padding, and only align the type to a
+`repr(packed)` forces Rust to strip any padding, and only align the type to a
 byte. This may improve the memory footprint, but will likely have other negative
 side-effects.
 
diff --git a/src/doc/nomicon/subtyping.md b/src/doc/nomicon/subtyping.md
