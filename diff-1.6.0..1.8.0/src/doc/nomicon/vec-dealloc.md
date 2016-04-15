--- a/src/doc/nomicon/vec-dealloc.md
+++ b/src/doc/nomicon/vec-dealloc.md
@@ -21,7 +21,7 @@ impl<T> Drop for Vec<T> {
             let elem_size = mem::size_of::<T>();
             let num_bytes = elem_size * self.cap;
             unsafe {
-                heap::deallocate(*self.ptr, num_bytes, align);
+                heap::deallocate(*self.ptr as *mut _, num_bytes, align);
             }
         }
     }
diff --git a/src/doc/nomicon/vec-final.md b/src/doc/nomicon/vec-final.md
