--- a/src/doc/book/error-handling.md
+++ b/src/doc/book/error-handling.md
@@ -5,18 +5,18 @@ errors in a particular way. Generally speaking, error handling is divided into
 two broad categories: exceptions and return values. Rust opts for return
 values.
 
-In this chapter, we intend to provide a comprehensive treatment of how to deal
+In this section, we intend to provide a comprehensive treatment of how to deal
 with errors in Rust. More than that, we will attempt to introduce error handling
 one piece at a time so that you'll come away with a solid working knowledge of
 how everything fits together.
 
 When done naïvely, error handling in Rust can be verbose and annoying. This
-chapter will explore those stumbling blocks and demonstrate how to use the
+section will explore those stumbling blocks and demonstrate how to use the
 standard library to make error handling concise and ergonomic.
 
 # Table of Contents
 
-This chapter is very long, mostly because we start at the very beginning with
+This section is very long, mostly because we start at the very beginning with
 sum types and combinators, and try to motivate the way Rust does error handling
 incrementally. As such, programmers with experience in other expressive type
 systems may want to jump around.
@@ -117,8 +117,8 @@ the first example. This is because the
 panic is embedded in the calls to `unwrap`.
 
 To “unwrap” something in Rust is to say, “Give me the result of the
-computation, and if there was an error, just panic and stop the program.”
-It would be better if we just showed the code for unwrapping because it is so
+computation, and if there was an error, panic and stop the program.”
+It would be better if we showed the code for unwrapping because it is so
 simple, but to do that, we will first need to explore the `Option` and `Result`
 types. Both of these types have a method called `unwrap` defined on them.
 
@@ -154,7 +154,7 @@ fn find(haystack: &str, needle: char) -> Option<usize> {
 }
 ```
 
-Notice that when this function finds a matching character, it doesn't just
+Notice that when this function finds a matching character, it doesn't only
 return the `offset`. Instead, it returns `Some(offset)`. `Some` is a variant or
 a *value constructor* for the `Option` type. You can think of it as a function
 with the type `fn<T>(value: T) -> Option<T>`. Correspondingly, `None` is also a
@@ -182,7 +182,7 @@ analysis is the only way to get at the value stored inside an `Option<T>`. This
 means that you, as the programmer, must handle the case when an `Option<T>` is
 `None` instead of `Some(t)`.
 
-But wait, what about `unwrap`,which we used [`previously`](#code-unwrap-double)?
+But wait, what about `unwrap`, which we used [previously](#code-unwrap-double)?
 There was no case analysis there! Instead, the case analysis was put inside the
 `unwrap` method for you. You could define it yourself if you want:
 
@@ -216,7 +216,7 @@ we saw how to use `find` to discover the extension in a file name. Of course,
 not all file names have a `.` in them, so it's possible that the file name has
 no extension. This *possibility of absence* is encoded into the types using
 `Option<T>`. In other words, the compiler will force us to address the
-possibility that an extension does not exist. In our case, we just print out a
+possibility that an extension does not exist. In our case, we only print out a
 message saying as such.
 
 Getting the extension of a file name is a pretty common operation, so it makes
@@ -248,7 +248,7 @@ tiresome.
 
 In fact, the case analysis in `extension_explicit` follows a very common
 pattern: *map* a function on to the value inside of an `Option<T>`, unless the
-option is `None`, in which case, just return `None`.
+option is `None`, in which case, return `None`.
 
 Rust has parametric polymorphism, so it is very easy to define a combinator
 that abstracts this pattern:
@@ -350,7 +350,7 @@ fn file_name(file_path: &str) -> Option<&str> {
 }
 ```
 
-You might think that we could just use the `map` combinator to reduce the case
+You might think that we could use the `map` combinator to reduce the case
 analysis, but its type doesn't quite fit. Namely, `map` takes a function that
 does something only with the inner value. The result of that function is then
 *always* [rewrapped with `Some`](#code-option-map). Instead, we need something
@@ -636,7 +636,7 @@ Thus far, we've looked at error handling where everything was either an
 `Option` and a `Result`? Or what if you have a `Result<T, Error1>` and a
 `Result<T, Error2>`? Handling *composition of distinct error types* is the next
 challenge in front of us, and it will be the major theme throughout the rest of
-this chapter.
+this section.
 
 ## Composing `Option` and `Result`
 
@@ -648,7 +648,7 @@ Of course, in real code, things aren't always as clean. Sometimes you have a
 mix of `Option` and `Result` types. Must we resort to explicit case analysis,
 or can we continue using combinators?
 
-For now, let's revisit one of the first examples in this chapter:
+For now, let's revisit one of the first examples in this section:
 
 ```rust,should_panic
 use std::env;
@@ -670,7 +670,7 @@ The tricky aspect here is that `argv.nth(1)` produces an `Option` while
 with both an `Option` and a `Result`, the solution is *usually* to convert the
 `Option` to a `Result`. In our case, the absence of a command line parameter
 (from `env::args()`) means the user didn't invoke the program correctly. We
-could just use a `String` to describe the error. Let's try:
+could use a `String` to describe the error. Let's try:
 
 <span id="code-error-double-string"></span>
 
@@ -709,7 +709,7 @@ fn ok_or<T, E>(option: Option<T>, err: E) -> Result<T, E> {
 
 The other new combinator used here is
 [`Result::map_err`](../std/result/enum.Result.html#method.map_err).
-This is just like `Result::map`, except it maps a function on to the *error*
+This is like `Result::map`, except it maps a function on to the *error*
 portion of a `Result` value. If the `Result` is an `Ok(...)` value, then it is
 returned unmodified.
 
@@ -841,7 +841,7 @@ example, the very last call to `map` multiplies the `Ok(...)` value (which is
 an `i32`) by `2`. If an error had occurred before that point, this operation
 would have been skipped because of how `map` is defined.
 
-`map_err` is the trick that makes all of this work. `map_err` is just like
+`map_err` is the trick that makes all of this work. `map_err` is like
 `map`, except it applies a function to the `Err(...)` value of a `Result`. In
 this case, we want to convert all of our errors to one type: `String`. Since
 both `io::Error` and `num::ParseIntError` implement `ToString`, we can call the
@@ -887,7 +887,7 @@ fn main() {
 }
 ```
 
-Reasonable people can disagree over whether this code is better that the code
+Reasonable people can disagree over whether this code is better than the code
 that uses combinators, but if you aren't familiar with the combinator approach,
 this code looks simpler to read to me. It uses explicit case analysis with
 `match` and `if let`. If an error occurs, it simply stops executing the
@@ -901,7 +901,7 @@ reduce explicit case analysis. Combinators aren't the only way.
 ## The `try!` macro
 
 A cornerstone of error handling in Rust is the `try!` macro. The `try!` macro
-abstracts case analysis just like combinators, but unlike combinators, it also
+abstracts case analysis like combinators, but unlike combinators, it also
 abstracts *control flow*. Namely, it can abstract the *early return* pattern
 seen above.
 
@@ -1319,7 +1319,7 @@ and [`cause`](../std/error/trait.Error.html#method.cause), but the
 limitation remains: `Box<Error>` is opaque. (N.B. This isn't entirely
 true because Rust does have runtime reflection, which is useful in
 some scenarios that are [beyond the scope of this
-chapter](https://crates.io/crates/error).)
+section](https://crates.io/crates/error).)
 
 It's time to revisit our custom `CliError` type and tie everything together.
 
@@ -1461,7 +1461,7 @@ expose its representation (like
 [`ErrorKind`](../std/io/enum.ErrorKind.html)) or keep it hidden (like
 [`ParseIntError`](../std/num/struct.ParseIntError.html)). Regardless
 of how you do it, it's usually good practice to at least provide some
-information about the error beyond just its `String`
+information about the error beyond its `String`
 representation. But certainly, this will vary depending on use cases.
 
 At a minimum, you should probably implement the
@@ -1486,7 +1486,7 @@ and [`fmt::Result`](../std/fmt/type.Result.html).
 
 # Case study: A program to read population data
 
-This chapter was long, and depending on your background, it might be
+This section was long, and depending on your background, it might be
 rather dense. While there is plenty of example code to go along with
 the prose, most of it was specifically designed to be pedagogical. So,
 we're going to do something new: a case study.
@@ -1499,7 +1499,7 @@ that can go wrong!
 The data we'll be using comes from the [Data Science
 Toolkit][11]. I've prepared some data from it for this exercise. You
 can either grab the [world population data][12] (41MB gzip compressed,
-145MB uncompressed) or just the [US population data][13] (2.2MB gzip
+145MB uncompressed) or only the [US population data][13] (2.2MB gzip
 compressed, 7.2MB uncompressed).
 
 Up until now, we've kept the code limited to Rust's standard library. For a real
@@ -1512,7 +1512,7 @@ and [`rustc-serialize`](https://crates.io/crates/rustc-serialize) crates.
 
 We're not going to spend a lot of time on setting up a project with
 Cargo because it is already covered well in [the Cargo
-chapter](../book/hello-cargo.html) and [Cargo's documentation][14].
+section](../book/hello-cargo.html) and [Cargo's documentation][14].
 
 To get started from scratch, run `cargo new --bin city-pop` and make sure your
 `Cargo.toml` looks something like this:
@@ -1573,11 +1573,11 @@ fn main() {
 
     let matches = match opts.parse(&args[1..]) {
         Ok(m)  => { m }
-	Err(e) => { panic!(e.to_string()) }
+        Err(e) => { panic!(e.to_string()) }
     };
     if matches.opt_present("h") {
         print_usage(&program, opts);
-	return;
+        return;
     }
     let data_path = args[1].clone();
     let city = args[2].clone();
@@ -1613,6 +1613,9 @@ CSV data given to us and print out a field in matching rows. Let's do it. (Make
 sure to add `extern crate csv;` to the top of your file.)
 
 ```rust,ignore
+use std::fs::File;
+use std::path::Path;
+
 // This struct represents the data in each row of the CSV file.
 // Type based decoding absolves us of a lot of the nitty gritty error
 // handling, like parsing strings as integers or floats.
@@ -1656,7 +1659,7 @@ fn main() {
 	let data_path = Path::new(&data_file);
 	let city = args[2].clone();
 
-	let file = fs::File::open(data_path).unwrap();
+	let file = File::open(data_path).unwrap();
 	let mut rdr = csv::Reader::from_reader(file);
 
 	for row in rdr.decode::<Row>() {
@@ -1674,7 +1677,7 @@ fn main() {
 Let's outline the errors. We can start with the obvious: the three places that
 `unwrap` is called:
 
-1. [`fs::File::open`](../std/fs/struct.File.html#method.open)
+1. [`File::open`](../std/fs/struct.File.html#method.open)
    can return an
    [`io::Error`](../std/io/struct.Error.html).
 2. [`csv::Reader::decode`](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.decode)
@@ -1703,7 +1706,7 @@ compiler can no longer reason about its underlying type.
 
 [Previously](#the-limits-of-combinators) we started refactoring our code by
 changing the type of our function from `T` to `Result<T, OurErrorType>`. In
-this case, `OurErrorType` is just `Box<Error>`. But what's `T`? And can we add
+this case, `OurErrorType` is only `Box<Error>`. But what's `T`? And can we add
 a return type to `main`?
 
 The answer to the second question is no, we can't. That means we'll need to
@@ -1734,7 +1737,7 @@ fn print_usage(program: &str, opts: Options) {
 
 fn search<P: AsRef<Path>>(file_path: P, city: &str) -> Vec<PopulationCount> {
     let mut found = vec![];
-    let file = fs::File::open(file_path).unwrap();
+    let file = File::open(file_path).unwrap();
     let mut rdr = csv::Reader::from_reader(file);
     for row in rdr.decode::<Row>() {
         let row = row.unwrap();
@@ -1792,11 +1795,15 @@ To convert this to proper error handling, we need to do the following:
 Let's try it:
 
 ```rust,ignore
+use std::error::Error;
+
+// The rest of the code before this is unchanged
+
 fn search<P: AsRef<Path>>
          (file_path: P, city: &str)
          -> Result<Vec<PopulationCount>, Box<Error+Send+Sync>> {
     let mut found = vec![];
-    let file = try!(fs::File::open(file_path));
+    let file = try!(File::open(file_path));
     let mut rdr = csv::Reader::from_reader(file);
     for row in rdr.decode::<Row>() {
         let row = try!(row);
@@ -1900,8 +1907,13 @@ let city = if !matches.free.is_empty() {
 	return;
 };
 
-for pop in search(&data_file, &city) {
-	println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
+match search(&data_file, &city) {
+    Ok(pops) => {
+        for pop in pops {
+            println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
+        }
+    }
+    Err(err) => println!("{}", err)
 }
 ...
 ```
@@ -1921,16 +1933,20 @@ parser out of
 But how can we use the same code over both types? There's actually a
 couple ways we could go about this. One way is to write `search` such
 that it is generic on some type parameter `R` that satisfies
-`io::Read`. Another way is to just use trait objects:
+`io::Read`. Another way is to use trait objects:
 
 ```rust,ignore
+use std::io;
+
+// The rest of the code before this is unchanged
+
 fn search<P: AsRef<Path>>
          (file_path: &Option<P>, city: &str)
          -> Result<Vec<PopulationCount>, Box<Error+Send+Sync>> {
     let mut found = vec![];
     let input: Box<io::Read> = match *file_path {
         None => Box::new(io::stdin()),
-        Some(ref file_path) => Box::new(try!(fs::File::open(file_path))),
+        Some(ref file_path) => Box::new(try!(File::open(file_path))),
     };
     let mut rdr = csv::Reader::from_reader(input);
     // The rest remains unchanged!
@@ -2017,7 +2033,7 @@ fn search<P: AsRef<Path>>
     let mut found = vec![];
     let input: Box<io::Read> = match *file_path {
         None => Box::new(io::stdin()),
-        Some(ref file_path) => Box::new(try!(fs::File::open(file_path))),
+        Some(ref file_path) => Box::new(try!(File::open(file_path))),
     };
     let mut rdr = csv::Reader::from_reader(input);
     for row in rdr.decode::<Row>() {
@@ -2078,7 +2094,7 @@ opts.optflag("q", "quiet", "Silences errors and warnings.");
 ...
 ```
 
-Now we just need to implement our “quiet” functionality. This requires us to
+Now we only need to implement our “quiet” functionality. This requires us to
 tweak the case analysis in `main`:
 
 ```rust,ignore
@@ -2105,13 +2121,13 @@ handling.
 
 # The Short Story
 
-Since this chapter is long, it is useful to have a quick summary for error
+Since this section is long, it is useful to have a quick summary for error
 handling in Rust. These are some good “rules of thumb." They are emphatically
 *not* commandments. There are probably good reasons to break every one of these
 heuristics!
 
 * If you're writing short example code that would be overburdened by error
-  handling, it's probably just fine to use `unwrap` (whether that's
+  handling, it's probably fine to use `unwrap` (whether that's
   [`Result::unwrap`](../std/result/enum.Result.html#method.unwrap),
   [`Option::unwrap`](../std/option/enum.Option.html#method.unwrap)
   or preferably
diff --git a/src/doc/book/ffi.md b/src/doc/book/ffi.md
