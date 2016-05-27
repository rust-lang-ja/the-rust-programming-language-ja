--- a/src/doc/book/documentation.md
+++ b/src/doc/book/documentation.md
@@ -73,7 +73,7 @@ hello.rs:4 }
 ```
 
 This [unfortunate error](https://github.com/rust-lang/rust/issues/22547) is
-correct: documentation comments apply to the thing after them, and there's
+correct; documentation comments apply to the thing after them, and there's
 nothing after that last comment.
 
 [rc-new]: https://doc.rust-lang.org/nightly/std/rc/struct.Rc.html#method.new
@@ -118,7 +118,7 @@ least. If your function has a non-trivial contract like this, that is
 detected/enforced by panics, documenting it is very important.
 
 ```rust
-/// # Failures
+/// # Errors
 # fn foo() {}
 ```
 
@@ -193,7 +193,7 @@ If you want something that's not Rust code, you can add an annotation:
 ```
 
 This will highlight according to whatever language you're showing off.
-If you're just showing plain text, choose `text`.
+If you're only showing plain text, choose `text`.
 
 It's important to choose the correct annotation here, because `rustdoc` uses it
 in an interesting way: It can be used to actually test your examples in a
@@ -273,7 +273,7 @@ be hidden from the output, but will be used when compiling your code. You
 can use this to your advantage. In this case, documentation comments need
 to apply to some kind of function, so if I want to show you just a
 documentation comment, I need to add a little function definition below
-it. At the same time, it's just there to satisfy the compiler, so hiding
+it. At the same time, it's only there to satisfy the compiler, so hiding
 it makes the example more clear. You can use this technique to explain
 longer examples in detail, while still preserving the testability of your
 documentation.
@@ -319,7 +319,7 @@ our source code:
 ```text
     First, we set `x` to five:
 
-    ```text
+    ```rust
     let x = 5;
     # let y = 6;
     # println!("{}", x + y);
@@ -327,7 +327,7 @@ our source code:
 
     Next, we set `y` to six:
 
-    ```text
+    ```rust
     # let x = 5;
     let y = 6;
     # println!("{}", x + y);
@@ -335,7 +335,7 @@ our source code:
 
     Finally, we print the sum of `x` and `y`:
 
-    ```text
+    ```rust
     # let x = 5;
     # let y = 6;
     println!("{}", x + y);
@@ -385,7 +385,7 @@ error handling. Lets say you want the following,
 
 ```rust,ignore
 /// use std::io;
-/// let mut input = String::new(); 
+/// let mut input = String::new();
 /// try!(io::stdin().read_line(&mut input));
 ```
 
@@ -398,7 +398,7 @@ don't return anything so this will give a mismatched types error.
 /// ```
 /// use std::io;
 /// # fn foo() -> io::Result<()> {
-/// let mut input = String::new(); 
+/// let mut input = String::new();
 /// try!(io::stdin().read_line(&mut input));
 /// # Ok(())
 /// # }
@@ -512,7 +512,7 @@ the documentation with comments. For example:
 # fn foo() {}
 ```
 
-is just
+is:
 
 ~~~markdown
 # Examples
diff --git a/src/doc/book/effective-rust.md b/src/doc/book/effective-rust.md
