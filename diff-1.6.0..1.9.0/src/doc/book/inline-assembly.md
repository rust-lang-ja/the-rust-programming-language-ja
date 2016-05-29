--- a/src/doc/book/inline-assembly.md
+++ b/src/doc/book/inline-assembly.md
@@ -2,8 +2,7 @@
 
 For extremely low-level manipulations and performance reasons, one
 might wish to control the CPU directly. Rust supports using inline
-assembly to do this via the `asm!` macro. The syntax roughly matches
-that of GCC & Clang:
+assembly to do this via the `asm!` macro.
 
 ```ignore
 asm!(assembly template
diff --git a/src/doc/book/iterators.md b/src/doc/book/iterators.md
