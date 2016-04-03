--- a/src/doc/nomicon/vec-zsts.md
+++ b/src/doc/nomicon/vec-zsts.md
@@ -140,8 +140,8 @@ impl<T> Iterator for RawValIter<T> {
                 self.start = if mem::size_of::<T>() == 0 {
                     (self.start as usize + 1) as *const _
                 } else {
-                    self.start.offset(1);
-                }
+                    self.start.offset(1)
+                };
                 Some(result)
             }
         }
@@ -164,8 +164,8 @@ impl<T> DoubleEndedIterator for RawValIter<T> {
                 self.end = if mem::size_of::<T>() == 0 {
                     (self.end as usize - 1) as *const _
                 } else {
-                    self.end.offset(-1);
-                }
+                    self.end.offset(-1)
+                };
                 Some(ptr::read(self.end))
             }
         }
diff --git a/src/doc/reference.md b/src/doc/reference.md
