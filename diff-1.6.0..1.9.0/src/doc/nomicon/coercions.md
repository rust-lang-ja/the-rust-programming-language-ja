--- a/src/doc/nomicon/coercions.md
+++ b/src/doc/nomicon/coercions.md
@@ -64,7 +64,7 @@ fn main() {
 ```
 
 ```text
-<anon>:10:5: 10:8 error: the trait `Trait` is not implemented for the type `&mut i32` [E0277]
+<anon>:10:5: 10:8 error: the trait bound `&mut i32 : Trait` is not satisfied [E0277]
 <anon>:10     foo(t);
               ^~~
 ```
diff --git a/src/doc/nomicon/lifetime-elision.md b/src/doc/nomicon/lifetime-elision.md
