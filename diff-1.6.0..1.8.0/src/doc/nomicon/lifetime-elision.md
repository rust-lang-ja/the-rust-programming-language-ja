--- a/src/doc/nomicon/lifetime-elision.md
+++ b/src/doc/nomicon/lifetime-elision.md
@@ -55,8 +55,8 @@ fn frob(s: &str, t: &str) -> &str;                      // ILLEGAL
 fn get_mut(&mut self) -> &mut T;                        // elided
 fn get_mut<'a>(&'a mut self) -> &'a mut T;              // expanded
 
-fn args<T:ToCStr>(&mut self, args: &[T]) -> &mut Command                  // elided
-fn args<'a, 'b, T:ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command // expanded
+fn args<T: ToCStr>(&mut self, args: &[T]) -> &mut Command                  // elided
+fn args<'a, 'b, T: ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command // expanded
 
 fn new(buf: &mut [u8]) -> BufWriter;                    // elided
 fn new<'a>(buf: &'a mut [u8]) -> BufWriter<'a>          // expanded
diff --git a/src/doc/nomicon/lifetimes.md b/src/doc/nomicon/lifetimes.md
