--- a/src/doc/book/no-stdlib.md
+++ b/src/doc/book/no-stdlib.md
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
