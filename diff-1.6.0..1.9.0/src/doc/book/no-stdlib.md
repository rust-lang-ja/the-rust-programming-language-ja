--- a/src/doc/book/no-stdlib.md
+++ b/src/doc/book/no-stdlib.md
@@ -38,7 +38,7 @@ fn start(_argc: isize, _argv: *const *const u8) -> isize {
 // for a bare-bones hello world. These are normally
 // provided by libstd.
 #[lang = "eh_personality"] extern fn eh_personality() {}
-#[lang = "panic_fmt"] fn panic_fmt() -> ! { loop {} }
+#[lang = "panic_fmt"] extern fn panic_fmt() -> ! { loop {} }
 # #[lang = "eh_unwind_resume"] extern fn rust_eh_unwind_resume() {}
 # #[no_mangle] pub extern fn rust_eh_register_frames () {}
 # #[no_mangle] pub extern fn rust_eh_unregister_frames () {}
@@ -65,7 +65,7 @@ pub extern fn main(argc: i32, argv: *const *const u8) -> i32 {
 }
 
 #[lang = "eh_personality"] extern fn eh_personality() {}
-#[lang = "panic_fmt"] fn panic_fmt() -> ! { loop {} }
+#[lang = "panic_fmt"] extern fn panic_fmt() -> ! { loop {} }
 # #[lang = "eh_unwind_resume"] extern fn rust_eh_unwind_resume() {}
 # #[no_mangle] pub extern fn rust_eh_register_frames () {}
 # #[no_mangle] pub extern fn rust_eh_unregister_frames () {}
@@ -77,10 +77,11 @@ The compiler currently makes a few assumptions about symbols which are available
 in the executable to call. Normally these functions are provided by the standard
 library, but without it you must define your own.
 
-The first of these two functions, `eh_personality`, is used by the
-failure mechanisms of the compiler. This is often mapped to GCC's
-personality function (see the
-[libstd implementation](../std/rt/unwind/index.html) for more
-information), but crates which do not trigger a panic can be assured
-that this function is never called. The second function, `panic_fmt`, is
-also used by the failure mechanisms of the compiler.
+The first of these two functions, `eh_personality`, is used by the failure
+mechanisms of the compiler. This is often mapped to GCC's personality function
+(see the [libstd implementation][unwind] for more information), but crates
+which do not trigger a panic can be assured that this function is never
+called. The second function, `panic_fmt`, is also used by the failure
+mechanisms of the compiler.
+
+[unwind]: https://github.com/rust-lang/rust/blob/master/src/libstd/sys/common/unwind/gcc.rs
diff --git a/src/doc/book/operators-and-overloading.md b/src/doc/book/operators-and-overloading.md
