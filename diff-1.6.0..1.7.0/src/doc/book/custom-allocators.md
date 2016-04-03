--- a/src/doc/book/custom-allocators.md
+++ b/src/doc/book/custom-allocators.md
@@ -13,7 +13,7 @@ own allocator up and running.
 
 The compiler currently ships two default allocators: `alloc_system` and
 `alloc_jemalloc` (some targets don't have jemalloc, however). These allocators
-are just normal Rust crates and contain an implementation of the routines to
+are normal Rust crates and contain an implementation of the routines to
 allocate and deallocate memory. The standard library is not compiled assuming
 either one, and the compiler will decide which allocator is in use at
 compile-time depending on the type of output artifact being produced.
@@ -134,7 +134,7 @@ pub extern fn __rust_usable_size(size: usize, _align: usize) -> usize {
     size
 }
 
-# // just needed to get rustdoc to test this
+# // only needed to get rustdoc to test this
 # fn main() {}
 # #[lang = "panic_fmt"] fn panic_fmt() {}
 # #[lang = "eh_personality"] fn eh_personality() {}
diff --git a/src/doc/book/dining-philosophers.md b/src/doc/book/dining-philosophers.md
