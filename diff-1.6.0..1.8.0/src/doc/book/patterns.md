--- a/src/doc/book/patterns.md
+++ b/src/doc/book/patterns.md
@@ -27,7 +27,7 @@ There’s one pitfall with patterns: like anything that introduces a new binding
 they introduce shadowing. For example:
 
 ```rust
-let x = 'x';
+let x = 1;
 let c = 'c';
 
 match c {
@@ -41,12 +41,14 @@ This prints:
 
 ```text
 x: c c: c
-x: x
+x: 1
 ```
 
 In other words, `x =>` matches the pattern and introduces a new binding named
-`x` that’s in scope for the match arm. Because we already have a binding named
-`x`, this new `x` shadows it.
+`x`. This new binding is in scope for the match arm and takes on the value of
+`c`. Notice that the value of `x` outside the scope of the match has no bearing
+on the value of `x` within it. Because we already have a binding named `x`, this
+new `x` shadows it.
 
 # Multiple patterns
 
@@ -116,7 +118,7 @@ match origin {
 
 This prints `x is 0`.
 
-You can do this kind of match on any member, not just the first:
+You can do this kind of match on any member, not only the first:
 
 ```rust
 struct Point {
@@ -153,7 +155,7 @@ match some_value {
 ```
 
 In the first arm, we bind the value inside the `Ok` variant to `value`. But
-in the `Err` arm, we use `_` to disregard the specific error, and just print
+in the `Err` arm, we use `_` to disregard the specific error, and print
 a general error message.
 
 `_` is valid in any pattern that creates a binding. This can be useful to
@@ -171,7 +173,39 @@ let (x, _, z) = coordinate();
 Here, we bind the first and last element of the tuple to `x` and `z`, but
 ignore the middle element.
 
-Similarly, you can use `..` in a pattern to disregard multiple values.
+It’s worth noting that using `_` never binds the value in the first place,
+which means a value may not move:
+
+```rust
+let tuple: (u32, String) = (5, String::from("five"));
+
+// Here, tuple is moved, because the String moved:
+let (x, _s) = tuple;
+
+// The next line would give "error: use of partially moved value: `tuple`"
+// println!("Tuple is: {:?}", tuple);
+
+// However,
+
+let tuple = (5, String::from("five"));
+
+// Here, tuple is _not_ moved, as the String was never moved, and u32 is Copy:
+let (x, _) = tuple;
+
+// That means this works:
+println!("Tuple is: {:?}", tuple);
+```
+
+This also means that any temporary variables will be dropped at the end of the
+statement:
+
+```rust
+// Here, the String created will be dropped immediately, as it’s not bound:
+
+let _ = String::from("  hello  ").trim();
+```
+
+You can also use `..` in a pattern to disregard multiple values:
 
 ```rust
 enum OptionalTuple {
@@ -269,7 +303,7 @@ struct Person {
 }
 
 let name = "Steve".to_string();
-let mut x: Option<Person> = Some(Person { name: Some(name) });
+let x: Option<Person> = Some(Person { name: Some(name) });
 match x {
     Some(Person { name: ref a @ Some(_), .. }) => println!("{:?}", a),
     _ => {}
@@ -324,7 +358,7 @@ match x {
 ```
 
 This prints `no`, because the `if` applies to the whole of `4 | 5`, and not to
-just the `5`. In other words, the precedence of `if` behaves like this:
+only the `5`. In other words, the precedence of `if` behaves like this:
 
 ```text
 (4 | 5) if y => ...
diff --git a/src/doc/book/primitive-types.md b/src/doc/book/primitive-types.md
