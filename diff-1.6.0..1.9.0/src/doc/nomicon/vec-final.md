--- a/src/doc/nomicon/vec-final.md
+++ b/src/doc/nomicon/vec-final.md
@@ -226,7 +226,11 @@ impl<T> Iterator for RawValIter<T> {
         } else {
             unsafe {
                 let result = ptr::read(self.start);
-                self.start = self.start.offset(1);
+                self.start = if mem::size_of::<T>() == 0 {
+                    (self.start as usize + 1) as *const _
+                } else {
+                    self.start.offset(1)
+                };
                 Some(result)
             }
         }
@@ -246,7 +250,11 @@ impl<T> DoubleEndedIterator for RawValIter<T> {
             None
         } else {
             unsafe {
-                self.end = self.end.offset(-1);
+                self.end = if mem::size_of::<T>() == 0 {
+                    (self.end as usize - 1) as *const _
+                } else {
+                    self.end.offset(-1)
+                };
                 Some(ptr::read(self.end))
             }
         }
diff --git a/src/doc/nomicon/vec-insert-remove.md b/src/doc/nomicon/vec-insert-remove.md
