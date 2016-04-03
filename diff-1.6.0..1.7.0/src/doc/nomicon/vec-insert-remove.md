--- a/src/doc/nomicon/vec-insert-remove.md
+++ b/src/doc/nomicon/vec-insert-remove.md
@@ -24,7 +24,7 @@ pub fn insert(&mut self, index: usize, elem: T) {
             // ptr::copy(src, dest, len): "copy from source to dest len elems"
             ptr::copy(self.ptr.offset(index as isize),
                       self.ptr.offset(index as isize + 1),
-                      len - index);
+                      self.len - index);
         }
         ptr::write(self.ptr.offset(index as isize), elem);
         self.len += 1;
@@ -44,7 +44,7 @@ pub fn remove(&mut self, index: usize) -> T {
         let result = ptr::read(self.ptr.offset(index as isize));
         ptr::copy(self.ptr.offset(index as isize + 1),
                   self.ptr.offset(index as isize),
-                  len - index);
+                  self.len - index);
         result
     }
 }
diff --git a/src/doc/nomicon/vec-zsts.md b/src/doc/nomicon/vec-zsts.md
