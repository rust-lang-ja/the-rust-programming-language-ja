--- a/src/doc/book/getting-started.md
+++ b/src/doc/book/getting-started.md
@@ -1,13 +1,13 @@
 % Getting Started
 
-This first section of the book will get us going with Rust and its tooling.
+This first chapter of the book will get us going with Rust and its tooling.
 First, we’ll install Rust. Then, the classic ‘Hello World’ program. Finally,
 we’ll talk about Cargo, Rust’s build system and package manager.
 
 # Installing Rust
 
 The first step to using Rust is to install it. Generally speaking, you’ll need
-an Internet connection to run the commands in this chapter, as we’ll be
+an Internet connection to run the commands in this section, as we’ll be
 downloading Rust from the internet.
 
 We’ll be showing off a number of commands using a terminal, and those lines all
@@ -39,6 +39,7 @@ Specifically they will each satisfy the following requirements:
 
 |  Target                       | std |rustc|cargo| notes                      |
 |-------------------------------|-----|-----|-----|----------------------------|
+| `i686-pc-windows-msvc`        |  ✓  |  ✓  |  ✓  | 32-bit MSVC (Windows 7+)   |
 | `x86_64-pc-windows-msvc`      |  ✓  |  ✓  |  ✓  | 64-bit MSVC (Windows 7+)   |
 | `i686-pc-windows-gnu`         |  ✓  |  ✓  |  ✓  | 32-bit MinGW (Windows 7+)  |
 | `x86_64-pc-windows-gnu`       |  ✓  |  ✓  |  ✓  | 64-bit MinGW (Windows 7+)  |
@@ -62,7 +63,13 @@ these platforms are required to have each of the following:
 
 |  Target                       | std |rustc|cargo| notes                      |
 |-------------------------------|-----|-----|-----|----------------------------|
-| `i686-pc-windows-msvc`        |  ✓  |  ✓  |  ✓  | 32-bit MSVC (Windows 7+)   |
+| `x86_64-unknown-linux-musl`   |  ✓  |     |     | 64-bit Linux with MUSL     |
+| `arm-linux-androideabi`       |  ✓  |     |     | ARM Android                |
+| `arm-unknown-linux-gnueabi`   |  ✓  |  ✓  |     | ARM Linux (2.6.18+)        |
+| `arm-unknown-linux-gnueabihf` |  ✓  |  ✓  |     | ARM Linux (2.6.18+)        |
+| `aarch64-unknown-linux-gnu`   |  ✓  |     |     | ARM64 Linux (2.6.18+)      |
+| `mips-unknown-linux-gnu`      |  ✓  |     |     | MIPS Linux (2.6.18+)       |
+| `mipsel-unknown-linux-gnu`    |  ✓  |     |     | MIPS (LE) Linux (2.6.18+)  |
 
 ### Tier 3
 
@@ -75,16 +82,12 @@ unofficial locations.
 
 |  Target                       | std |rustc|cargo| notes                      |
 |-------------------------------|-----|-----|-----|----------------------------|
-| `x86_64-unknown-linux-musl`   |  ✓  |     |     | 64-bit Linux with MUSL     |
-| `arm-linux-androideabi`       |  ✓  |     |     | ARM Android                |
 | `i686-linux-android`          |  ✓  |     |     | 32-bit x86 Android         |
 | `aarch64-linux-android`       |  ✓  |     |     | ARM64 Android              |
-| `arm-unknown-linux-gnueabi`   |  ✓  |  ✓  |     | ARM Linux (2.6.18+)        |
-| `arm-unknown-linux-gnueabihf` |  ✓  |  ✓  |     | ARM Linux (2.6.18+)        |
-| `aarch64-unknown-linux-gnu`   |  ✓  |     |     | ARM64 Linux (2.6.18+)      |
-| `mips-unknown-linux-gnu`      |  ✓  |     |     | MIPS Linux (2.6.18+)       |
-| `mipsel-unknown-linux-gnu`    |  ✓  |     |     | MIPS (LE) Linux (2.6.18+)  |
 | `powerpc-unknown-linux-gnu`   |  ✓  |     |     | PowerPC Linux (2.6.18+)    |
+| `powerpc64-unknown-linux-gnu` |  ✓  |     |     | PPC64 Linux (2.6.18+)      |
+|`powerpc64le-unknown-linux-gnu`|  ✓  |     |     | PPC64LE Linux (2.6.18+)    |
+|`armv7-unknown-linux-gnueabihf`|  ✓  |     |     | ARMv7 Linux (2.6.18+)      |
 | `i386-apple-ios`              |  ✓  |     |     | 32-bit x86 iOS             |
 | `x86_64-apple-ios`            |  ✓  |     |     | 64-bit x86 iOS             |
 | `armv7-apple-ios`             |  ✓  |     |     | ARM iOS                    |
@@ -97,6 +100,7 @@ unofficial locations.
 | `x86_64-unknown-bitrig`       |  ✓  |  ✓  |     | 64-bit Bitrig              |
 | `x86_64-unknown-dragonfly`    |  ✓  |  ✓  |     | 64-bit DragonFlyBSD        |
 | `x86_64-rumprun-netbsd`       |  ✓  |     |     | 64-bit NetBSD Rump Kernel  |
+| `x86_64-sun-solaris`          |  ✓  |  ✓  |     | 64-bit Solaris/SunOS       |
 | `i686-pc-windows-msvc` (XP)   |  ✓  |     |     | Windows XP support         |
 | `x86_64-pc-windows-msvc` (XP) |  ✓  |     |     | Windows XP support         |
 
@@ -111,7 +115,7 @@ If we're on Linux or a Mac, all we need to do is open a terminal and type this:
 $ curl -sSf https://static.rust-lang.org/rustup.sh | sh
 ```
 
-This will download a script, and stat the installation. If it all goes well,
+This will download a script, and start the installation. If it all goes well,
 you’ll see this appear:
 
 ```text
@@ -127,7 +131,7 @@ not want the script to run ‘sudo’ then pass it the --disable-sudo flag.
 You may uninstall later by running /usr/local/lib/rustlib/uninstall.sh,
 or by running this script again with the --uninstall flag.
 
-Continue? (y/N) 
+Continue? (y/N)
 ```
 
 From here, press `y` for ‘yes’, and then follow the rest of the prompts.
@@ -140,7 +144,7 @@ If you're on Windows, please download the appropriate [installer][install-page].
 
 ## Uninstalling
 
-Uninstalling Rust is as easy as installing it. On Linux or Mac, just run
+Uninstalling Rust is as easy as installing it. On Linux or Mac, run
 the uninstall script:
 
 ```bash
@@ -167,6 +171,10 @@ variable. If it isn't, run the installer again, select "Change" on the "Change,
 repair, or remove installation" page and ensure "Add to PATH" is installed on
 the local hard drive.
 
+Rust does not do its own linking, and so you’ll need to have a linker
+installed. Doing so will depend on your specific system, consult its
+documentation for more details.
+
 If not, there are a number of places where we can get help. The easiest is
 [the #rust IRC channel on irc.mozilla.org][irc], which we can access through
 [Mibbit][mibbit]. Click that link, and we'll be chatting with other Rustaceans
@@ -188,11 +196,11 @@ was installed.
 Now that you have Rust installed, we'll help you write your first Rust program.
 It's traditional when learning a new language to write a little program to
 print the text “Hello, world!” to the screen, and in this section, we'll follow
-that tradition. 
+that tradition.
 
 The nice thing about starting with such a simple program is that you can
 quickly verify that your compiler is installed, and that it's working properly.
-Printing information to the screen is also just a pretty common thing to do, so
+Printing information to the screen is also a pretty common thing to do, so
 practicing it early on is good.
 
 > Note: This book assumes basic familiarity with the command line. Rust itself
@@ -202,7 +210,7 @@ practicing it early on is good.
 > There are a number of extensions in development by the community, and the
 > Rust team ships plugins for [various editors]. Configuring your editor or
 > IDE is out of the scope of this tutorial, so check the documentation for your
-> specific setup. 
+> specific setup.
 
 [SolidOak]: https://github.com/oakes/SolidOak
 [various editors]: https://github.com/rust-lang/rust/blob/master/src/etc/CONFIGS.md
@@ -244,14 +252,14 @@ following commands:
 
 ```bash
 $ rustc main.rs
-$ ./main 
+$ ./main
 Hello, world!
 ```
 
-In Windows, just replace `main` with `main.exe`. Regardless of your operating
+In Windows, replace `main` with `main.exe`. Regardless of your operating
 system, you should see the string `Hello, world!` print to the terminal. If you
 did, then congratulations! You've officially written a Rust program. That makes
-you a Rust programmer! Welcome. 
+you a Rust programmer! Welcome.
 
 ## Anatomy of a Rust Program
 
@@ -285,13 +293,13 @@ Inside the `main()` function:
 This line does all of the work in this little program: it prints text to the
 screen. There are a number of details that are important here. The first is
 that it’s indented with four spaces, not tabs.
- 
+
 The second important part is the `println!()` line. This is calling a Rust
 *[macro]*, which is how metaprogramming is done in Rust. If it were calling a
 function instead, it would look like this: `println()` (without the !). We'll
-discuss Rust macros in more detail later, but for now you just need to
+discuss Rust macros in more detail later, but for now you only need to
 know that when you see a `!` that means that you’re calling a macro instead of
-a normal function. 
+a normal function.
 
 
 [macro]: macros.html
@@ -303,17 +311,17 @@ prints the string to the screen. Easy enough!
 
 [statically allocated]: the-stack-and-the-heap.html
 
-The line ends with a semicolon (`;`). Rust is an *[expression oriented]*
-language, which means that most things are expressions, rather than statements.
-The `;` indicates that this expression is over, and the next one is ready to
-begin. Most lines of Rust code end with a `;`.
+The line ends with a semicolon (`;`). Rust is an *[expression-oriented
+language]*, which means that most things are expressions, rather than
+statements. The `;` indicates that this expression is over, and the next one is
+ready to begin. Most lines of Rust code end with a `;`.
 
 [expression-oriented language]: glossary.html#expression-oriented-language
 
 ## Compiling and Running Are Separate Steps
 
 In "Writing and Running a Rust Program", we showed you how to run a newly
-created program. We'll break that process down and examine each step now. 
+created program. We'll break that process down and examine each step now.
 
 Before running a Rust program, you have to compile it. You can use the Rust
 compiler by entering the `rustc` command and passing it the name of your source
@@ -395,7 +403,7 @@ in which you installed Rust, to determine if Cargo is separate.
 ## Converting to Cargo
 
 Let’s convert the Hello World program to Cargo. To Cargo-fy a project, you need
-to do three things: 
+to do three things:
 
 1. Put your source file in the right directory.
 2. Get rid of the old executable (`main.exe` on Windows, `main` everywhere else)
@@ -419,7 +427,7 @@ Cargo expects your source files to live inside a *src* directory, so do that
 first. This leaves the top-level project directory (in this case,
 *hello_world*) for READMEs, license information, and anything else not related
 to your code. In this way, using Cargo helps you keep your projects nice and
-tidy. There's a place for everything, and everything is in its place. 
+tidy. There's a place for everything, and everything is in its place.
 
 Now, copy *main.rs* to the *src* directory, and delete the compiled file you
 created with `rustc`. As usual, replace `main` with `main.exe` if you're on
@@ -428,7 +436,7 @@ Windows.
 This example retains `main.rs` as the source filename because it's creating an
 executable. If you wanted to make a library instead, you'd name the file
 `lib.rs`. This convention is used by Cargo to successfully compile your
-projects, but it can be overridden if you wish. 
+projects, but it can be overridden if you wish.
 
 ### Creating a Configuration File
 
@@ -436,7 +444,7 @@ Next, create a new file inside your *hello_world* directory, and call it
 `Cargo.toml`.
 
 Make sure to capitalize the `C` in `Cargo.toml`, or Cargo won't know what to do
-with the configuration file. 
+with the configuration file.
 
 This file is in the *[TOML]* (Tom's Obvious, Minimal Language) format. TOML is
 similar to INI, but has some extra goodies, and is used as Cargo’s
@@ -456,7 +464,7 @@ authors = [ "Your name <you@example.com>" ]
 
 The first line, `[package]`, indicates that the following statements are
 configuring a package. As we add more information to this file, we’ll add other
-sections, but for now, we just have the package configuration.
+sections, but for now, we only have the package configuration.
 
 The other three lines set the three bits of configuration that Cargo needs to
 know to compile your program: its name, what version it is, and who wrote it.
@@ -464,7 +472,7 @@ know to compile your program: its name, what version it is, and who wrote it.
 Once you've added this information to the *Cargo.toml* file, save it to finish
 creating the configuration file.
 
-## Building and Running a Cargo Project 
+## Building and Running a Cargo Project
 
 With your *Cargo.toml* file in place in your project's root directory, you
 should be ready to build and run your Hello World program! To do so, enter the
@@ -477,7 +485,7 @@ $ ./target/debug/hello_world
 Hello, world!
 ```
 
-Bam! If all goes well, `Hello, world!` should print to the terminal once more. 
+Bam! If all goes well, `Hello, world!` should print to the terminal once more.
 
 You just built a project with `cargo build` and ran it with
 `./target/debug/hello_world`, but you can actually do both in one step with
@@ -505,19 +513,23 @@ Cargo checks to see if any of your project’s files have been modified, and onl
 rebuilds your project if they’ve changed since the last time you built it.
 
 With simple projects, Cargo doesn't bring a whole lot over just using `rustc`,
-but it will become useful in future. With complex projects composed of multiple
-crates, it’s much easier to let Cargo coordinate the build. With Cargo, you can
-just run `cargo build`, and it should work the right way.
+but it will become useful in future. This is especially true when you start
+using crates; these are synonymous with a ‘library’ or ‘package’ in other
+programming languages. For complex projects composed of multiple crates, it’s
+much easier to let Cargo coordinate the build. Using Cargo, you can run `cargo
+build`, and it should work the right way.
 
-## Building for Release
+### Building for Release
 
-When your project is finally ready for release, you can use `cargo build
+When your project is ready for release, you can use `cargo build
 --release` to compile your project with optimizations. These optimizations make
 your Rust code run faster, but turning them on makes your program take longer
 to compile. This is why there are two different profiles, one for development,
 and one for building the final program you’ll give to a user.
 
-Running this command also causes Cargo to create a new file called
+### What Is That `Cargo.lock`?
+
+Running `cargo build` also causes Cargo to create a new file called
 *Cargo.lock*, which looks like this:
 
 ```toml
@@ -532,7 +544,7 @@ doesn't have dependencies, so the file is a bit sparse. Realistically, you
 won't ever need to touch this file yourself; just let Cargo handle it.
 
 That’s it! If you've been following along, you should have successfully built
-`hello_world` with Cargo. 
+`hello_world` with Cargo.
 
 Even though the project is simple, it now uses much of the real tooling you’ll
 use for the rest of your Rust career. In fact, you can expect to start
@@ -561,7 +573,7 @@ executable application, as opposed to a library. Executables are often called
 *binaries* (as in `/usr/bin`, if you’re on a Unix system).
 
 Cargo has generated two files and one directory for us: a `Cargo.toml` and a
-*src* directory with a *main.rs* file inside. These should look familliar,
+*src* directory with a *main.rs* file inside. These should look familiar,
 they’re exactly what we created by hand, above.
 
 This output is all you need to get started. First, open `Cargo.toml`. It should
@@ -587,7 +599,7 @@ fn main() {
 }
 ```
 
-Cargo has generated a "Hello World!" for you, and you’re ready to start coding! 
+Cargo has generated a "Hello World!" for you, and you’re ready to start coding!
 
 > Note: If you want to look at Cargo in more detail, check out the official [Cargo
 guide], which covers all of its features.
@@ -598,13 +610,13 @@ guide], which covers all of its features.
 
 This chapter covered the basics that will serve you well through the rest of
 this book, and the rest of your time with Rust. Now that you’ve got the tools
-down, we'll cover more about the Rust language itself. 
+down, we'll cover more about the Rust language itself.
 
-You have two options: Dive into a project with ‘[Learn Rust][learnrust]’, or
+You have two options: Dive into a project with ‘[Tutorial: Guessing Game][guessinggame]’, or
 start from the bottom and work your way up with ‘[Syntax and
 Semantics][syntax]’. More experienced systems programmers will probably prefer
-‘Learn Rust’, while those from dynamic backgrounds may enjoy either. Different
+‘Tutorial: Guessing Game’, while those from dynamic backgrounds may enjoy either. Different
 people learn differently! Choose whatever’s right for you.
 
-[learnrust]: learn-rust.html
+[guessinggame]: guessing-game.html
 [syntax]: syntax-and-semantics.html
diff --git a/src/doc/book/guessing-game.md b/src/doc/book/guessing-game.md
