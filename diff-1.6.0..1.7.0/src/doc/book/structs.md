--- a/src/doc/book/structs.md
+++ b/src/doc/book/structs.md
@@ -9,7 +9,8 @@ let origin_x = 0;
 let origin_y = 0;
 ```
 
-A `struct` lets us combine these two into a single, unified datatype:
+A `struct` lets us combine these two into a single, unified datatype with `x`
+and `y` as field labels:
 
 ```rust
 struct Point {
@@ -32,7 +33,7 @@ We can create an instance of our `struct` via `let`, as usual, but we use a `key
 value` style syntax to set each field. The order doesn’t need to be the same as
 in the original declaration.
 
-Finally, because fields have names, we can access the field through dot
+Finally, because fields have names, we can access them through dot
 notation: `origin.x`.
 
 The values in `struct`s are immutable by default, like other bindings in Rust.
@@ -67,9 +68,8 @@ struct Point {
 
 Mutability is a property of the binding, not of the structure itself. If you’re
 used to field-level mutability, this may seem strange at first, but it
-significantly simplifies things. It even lets you make things mutable for a short
-time only:
-
+significantly simplifies things. It even lets you make things mutable on a temporary
+basis:
 
 ```rust,ignore
 struct Point {
@@ -82,12 +82,41 @@ fn main() {
 
     point.x = 5;
 
-    let point = point; // this new binding can’t change now
+    let point = point; // now immutable
 
     point.y = 6; // this causes an error
 }
 ```
 
+Your structure can still contain `&mut` pointers, which will let
+you do some kinds of mutation:
+
+```rust
+struct Point {
+    x: i32,
+    y: i32,
+}
+
+struct PointRef<'a> {
+    x: &'a mut i32,
+    y: &'a mut i32,
+}
+
+fn main() {
+    let mut point = Point { x: 0, y: 0 };
+
+    {
+        let r = PointRef { x: &mut point.x, y: &mut point.y };
+
+        *r.x = 5;
+        *r.y = 6;
+    }
+
+    assert_eq!(5, point.x);
+    assert_eq!(6, point.y);
+}
+```
+
 # Update syntax
 
 A `struct` can include `..` to indicate that you want to use a copy of some
@@ -121,27 +150,24 @@ let point = Point3d { z: 1, x: 2, .. origin };
 # Tuple structs
 
 Rust has another data type that’s like a hybrid between a [tuple][tuple] and a
-`struct`, called a ‘tuple struct’. Tuple structs have a name, but
-their fields don’t:
+`struct`, called a ‘tuple struct’. Tuple structs have a name, but their fields
+don't. They are declared with the `struct` keyword, and then with a name
+followed by a tuple:
+
+[tuple]: primitive-types.html#tuples
 
 ```rust
 struct Color(i32, i32, i32);
 struct Point(i32, i32, i32);
-```
-
-[tuple]: primitive-types.html#tuples
-
-These two will not be equal, even if they have the same values:
 
-```rust
-# struct Color(i32, i32, i32);
-# struct Point(i32, i32, i32);
 let black = Color(0, 0, 0);
 let origin = Point(0, 0, 0);
 ```
+Here, `black` and `origin` are not equal, even though they contain the same
+values.
 
-It is almost always better to use a `struct` than a tuple struct. We would write
-`Color` and `Point` like this instead:
+It is almost always better to use a `struct` than a tuple struct. We
+would write `Color` and `Point` like this instead:
 
 ```rust
 struct Color {
@@ -157,13 +183,14 @@ struct Point {
 }
 ```
 
-Now, we have actual names, rather than positions. Good names are important,
-and with a `struct`, we have actual names.
+Good names are important, and while values in a tuple struct can be
+referenced with dot notation as well, a `struct` gives us actual names,
+rather than positions.
 
-There _is_ one case when a tuple struct is very useful, though, and that’s a
-tuple struct with only one element. We call this the ‘newtype’ pattern, because
-it allows you to create a new type, distinct from that of its contained value
-and expressing its own semantic meaning:
+There _is_ one case when a tuple struct is very useful, though, and that is when
+it has only one element. We call this the ‘newtype’ pattern, because
+it allows you to create a new type that is distinct from its contained value
+and also expresses its own semantic meaning:
 
 ```rust
 struct Inches(i32);
@@ -175,7 +202,7 @@ println!("length is {} inches", integer_length);
 ```
 
 As you can see here, you can extract the inner integer type through a
-destructuring `let`, just as with regular tuples. In this case, the
+destructuring `let`, as with regular tuples. In this case, the
 `let Inches(integer_length)` assigns `10` to `integer_length`.
 
 # Unit-like structs
@@ -196,7 +223,7 @@ This is rarely useful on its own (although sometimes it can serve as a
 marker type), but in combination with other features, it can become
 useful. For instance, a library may ask you to create a structure that
 implements a certain [trait][trait] to handle events. If you don’t have
-any data you need to store in the structure, you can just create a
+any data you need to store in the structure, you can create a
 unit-like `struct`.
 
 [trait]: traits.html
diff --git a/src/doc/book/syntax-and-semantics.md b/src/doc/book/syntax-and-semantics.md
