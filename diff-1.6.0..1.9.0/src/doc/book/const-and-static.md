--- a/src/doc/book/const-and-static.md
+++ b/src/doc/book/const-and-static.md
@@ -64,16 +64,16 @@ unsafe {
 
 [unsafe]: unsafe.html
 
-Furthermore, any type stored in a `static` must be `Sync`, and may not have
+Furthermore, any type stored in a `static` must be `Sync`, and must not have
 a [`Drop`][drop] implementation.
 
 [drop]: drop.html
 
 # Initializing
 
-Both `const` and `static` have requirements for giving them a value. They may
-only be given a value that’s a constant expression. In other words, you cannot
-use the result of a function call or anything similarly complex or at runtime.
+Both `const` and `static` have requirements for giving them a value. They must
+be given a value that’s a constant expression. In other words, you cannot use
+the result of a function call or anything similarly complex or at runtime.
 
 # Which construct should I use?
 
diff --git a/src/doc/book/crates-and-modules.md b/src/doc/book/crates-and-modules.md
