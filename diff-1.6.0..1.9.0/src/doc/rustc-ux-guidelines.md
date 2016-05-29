--- a/src/doc/rustc-ux-guidelines.md
+++ b/src/doc/rustc-ux-guidelines.md
@@ -1,3 +1,5 @@
+% Rustc UX guidelines
+
 Don't forget the user. Whether human or another program, such as an IDE, a
 good user experience with the compiler goes a long way into making developer
 lives better. We don't want users to be baffled by compiler output or
@@ -70,4 +72,4 @@ understandable compiler scripts.
 * The `--verbose` flag is for adding verbose information to `rustc` output
 when not compiling a program. For example, using it with the `--version` flag
 gives information about the hashes of the code.
-* Experimental flags and options must be guarded behind the `-Z unstable-options` flag.
\ No newline at end of file
+* Experimental flags and options must be guarded behind the `-Z unstable-options` flag.
diff --git a/src/doc/style/README.md b/src/doc/style/README.md
