--- a/src/doc/book/lang-items.md
+++ b/src/doc/book/lang-items.md
@@ -39,11 +39,17 @@ unsafe fn allocate(size: usize, _align: usize) -> *mut u8 {
 
     p
 }
+
 #[lang = "exchange_free"]
 unsafe fn deallocate(ptr: *mut u8, _size: usize, _align: usize) {
     libc::free(ptr as *mut libc::c_void)
 }
 
+#[lang = "box_free"]
+unsafe fn box_free<T>(ptr: *mut T) {
+    deallocate(ptr as *mut u8, ::core::mem::size_of::<T>(), ::core::mem::align_of::<T>());
+}
+
 #[start]
 fn main(argc: isize, argv: *const *const u8) -> isize {
     let x = box 1;
diff --git a/src/doc/book/learn-rust.md b/src/doc/book/learn-rust.md
