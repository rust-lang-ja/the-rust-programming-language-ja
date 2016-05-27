--- a/src/doc/book/guessing-game.md
+++ b/src/doc/book/guessing-game.md
@@ -1,10 +1,14 @@
 % Guessing Game
 
-For our first project, we’ll implement a classic beginner programming problem:
-the guessing game. Here’s how it works: Our program will generate a random
-integer between one and a hundred. It will then prompt us to enter a guess.
-Upon entering our guess, it will tell us if we’re too low or too high. Once we
-guess correctly, it will congratulate us. Sounds good?
+Let’s learn some Rust! For our first project, we’ll implement a classic
+beginner programming problem: the guessing game. Here’s how it works: Our
+program will generate a random integer between one and a hundred. It will then
+prompt us to enter a guess. Upon entering our guess, it will tell us if we’re
+too low or too high. Once we guess correctly, it will congratulate us. Sounds
+good?
+
+Along the way, we’ll learn a little bit about Rust. The next chapter, ‘Syntax
+and Semantics’, will dive deeper into each part.
 
 # Set up
 
@@ -64,7 +68,7 @@ Hello, world!
 ```
 
 Great! The `run` command comes in handy when you need to rapidly iterate on a
-project. Our game is just such a project, we need to quickly test each
+project. Our game is such a project, we need to quickly test each
 iteration before moving on to the next one.
 
 # Processing a Guess
@@ -254,7 +258,7 @@ done:
     io::stdin().read_line(&mut guess).expect("failed to read line");
 ```
 
-But that gets hard to read. So we’ve split it up, three lines for three method
+But that gets hard to read. So we’ve split it up, two lines for two method
 calls. We already talked about `read_line()`, but what about `expect()`? Well,
 we already mentioned that `read_line()` puts what the user types into the `&mut
 String` we pass it. But it also returns a value: in this case, an
@@ -272,10 +276,10 @@ it’s called on, and if it isn’t a successful one, [`panic!`][panic]s with a
 message you passed it. A `panic!` like this will cause our program to crash,
 displaying the message.
 
-[expect]: ../std/option/enum.Option.html#method.expect
+[expect]: ../std/result/enum.Result.html#method.expect
 [panic]: error-handling.html
 
-If we leave off calling these two methods, our program will compile, but
+If we leave off calling this method, our program will compile, but
 we’ll get a warning:
 
 ```bash
@@ -290,12 +294,12 @@ src/main.rs:10     io::stdin().read_line(&mut guess);
 Rust warns us that we haven’t used the `Result` value. This warning comes from
 a special annotation that `io::Result` has. Rust is trying to tell you that
 you haven’t handled a possible error. The right way to suppress the error is
-to actually write error handling. Luckily, if we just want to crash if there’s
+to actually write error handling. Luckily, if we want to crash if there’s
 a problem, we can use these two little methods. If we can recover from the
 error somehow, we’d do something else, but we’ll save that for a future
 project.
 
-There’s just one line of this first example left:
+There’s only one line of this first example left:
 
 ```rust,ignore
     println!("You guessed: {}", guess);
@@ -404,7 +408,7 @@ $ cargo build
 That’s right, no output! Cargo knows that our project has been built, and that
 all of its dependencies are built, and so there’s no reason to do all that
 stuff. With nothing to do, it simply exits. If we open up `src/main.rs` again,
-make a trivial change, and then save it again, we’ll just see one line:
+make a trivial change, and then save it again, we’ll only see one line:
 
 ```bash
 $ cargo build
@@ -500,7 +504,7 @@ so we need `1` and `101` to get a number ranging from one to a hundred.
 
 [concurrency]: concurrency.html
 
-The second line just prints out the secret number. This is useful while
+The second line prints out the secret number. This is useful while
 we’re developing our program, so we can easily test it out. But we’ll be
 deleting it for the final version. It’s not much of a game if it prints out
 the answer when you start it up!
@@ -640,7 +644,7 @@ So far, that hasn’t mattered, and so Rust defaults to an `i32`. However, here,
 Rust doesn’t know how to compare the `guess` and the `secret_number`. They
 need to be the same type. Ultimately, we want to convert the `String` we
 read as input into a real number type, for comparison. We can do that
-with three more lines. Here’s our new program:
+with two more lines. Here’s our new program:
 
 ```rust,ignore
 extern crate rand;
@@ -676,7 +680,7 @@ fn main() {
 }
 ```
 
-The new three lines:
+The new two lines:
 
 ```rust,ignore
     let guess: u32 = guess.trim().parse()
@@ -701,7 +705,7 @@ input in it. The `trim()` method on `String`s will eliminate any white space at
 the beginning and end of our string. This is important, as we had to press the
 ‘return’ key to satisfy `read_line()`. This means that if we type `5` and hit
 return, `guess` looks like this: `5\n`. The `\n` represents ‘newline’, the
-enter key. `trim()` gets rid of this, leaving our string with just the `5`. The
+enter key. `trim()` gets rid of this, leaving our string with only the `5`. The
 [`parse()` method on strings][parse] parses a string into some kind of number.
 Since it can parse a variety of numbers, we need to give Rust a hint as to the
 exact type of number we want. Hence, `let guess: u32`. The colon (`:`) after
@@ -849,8 +853,8 @@ fn main() {
 
 By adding the `break` line after the `You win!`, we’ll exit the loop when we
 win. Exiting the loop also means exiting the program, since it’s the last
-thing in `main()`. We have just one more tweak to make: when someone inputs a
-non-number, we don’t want to quit, we just want to ignore it. We can do that
+thing in `main()`. We have only one more tweak to make: when someone inputs a
+non-number, we don’t want to quit, we want to ignore it. We can do that
 like this:
 
 ```rust,ignore
@@ -902,16 +906,17 @@ let guess: u32 = match guess.trim().parse() {
     Err(_) => continue,
 };
 ```
-
 This is how you generally move from ‘crash on error’ to ‘actually handle the
-returned by `parse()` is an `enum` just like `Ordering`, but in this case, each
-variant has some data associated with it: `Ok` is a success, and `Err` is a
+error’, by switching from `expect()` to a `match` statement. A `Result` is
+returned by `parse()`, this is an `enum`  like `Ordering`, but in this case,
+each variant has some data associated with it: `Ok` is a success, and `Err` is a
 failure. Each contains more information: the successfully parsed integer, or an
-error type. In this case, we `match` on `Ok(num)`, which sets the inner value
-of the `Ok` to the name `num`, and then we just return it on the right-hand
-side. In the `Err` case, we don’t care what kind of error it is, so we just
-use `_` instead of a name. This ignores the error, and `continue` causes us
-to go to the next iteration of the `loop`.
+error type. In this case, we `match` on `Ok(num)`, which sets the name `num` to
+the unwrapped `Ok` value (ythe integer), and then we  return it on the
+right-hand side. In the `Err` case, we don’t care what kind of error it is, so
+we just use the catch all `_` instead of a name. This catches everything that
+isn't `Ok`, and `continue` lets us move to the next iteration of the loop; in
+effect, this enables us to ignore all errors and continue with our program.
 
 Now we should be good! Let’s try:
 
diff --git a/src/doc/book/iterators.md b/src/doc/book/iterators.md
