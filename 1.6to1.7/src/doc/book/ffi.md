--- a/src/doc/book/ffi.md
+++ b/src/doc/book/ffi.md
@@ -367,7 +367,7 @@ artifact.
 A few examples of how this model can be used are:
 
 * A native build dependency. Sometimes some C/C++ glue is needed when writing
-  some Rust code, but distribution of the C/C++ code in a library format is just
+  some Rust code, but distribution of the C/C++ code in a library format is
   a burden. In this case, the code will be archived into `libfoo.a` and then the
   Rust crate would declare a dependency via `#[link(name = "foo", kind =
   "static")]`.
@@ -478,6 +478,8 @@ are:
 * `aapcs`
 * `cdecl`
 * `fastcall`
+* `vectorcall`
+This is currently hidden behind the `abi_vectorcall` gate and is subject to change.
 * `Rust`
 * `rust-intrinsic`
 * `system`
@@ -490,7 +492,7 @@ interoperating with the target's libraries. For example, on win32 with a x86
 architecture, this means that the abi used would be `stdcall`. On x86_64,
 however, windows uses the `C` calling convention, so `C` would be used. This
 means that in our previous example, we could have used `extern "system" { ... }`
-to define a block for all windows systems, not just x86 ones.
+to define a block for all windows systems, not only x86 ones.
 
 # Interoperability with foreign code
 
diff --git a/src/doc/book/functions.md b/src/doc/book/functions.md
