--- a/src/doc/book/enums.md
+++ b/src/doc/book/enums.md
@@ -1,7 +1,8 @@
 % Enums
 
-An `enum` in Rust is a type that represents data that could be one of
-several possible variants:
+An `enum` in Rust is a type that represents data that is one of
+several possible variants. Each variant in the `enum` can optionally
+have data associated with it:
 
 ```rust
 enum Message {
@@ -12,9 +13,8 @@ enum Message {
 }
 ```
 
-Each variant can optionally have data associated with it. The syntax for
-defining variants resembles the syntaxes used to define structs: you can
-have variants with no data (like unit-like structs), variants with named
+The syntax for defining variants resembles the syntaxes used to define structs:
+you can have variants with no data (like unit-like structs), variants with named
 data, and variants with unnamed data (like tuple structs). Unlike
 separate struct definitions, however, an `enum` is a single type. A
 value of the enum can match any of the variants. For this reason, an
@@ -41,7 +41,7 @@ let y: BoardGameTurn = BoardGameTurn::Move { squares: 1 };
 Both variants are named `Move`, but since they’re scoped to the name of
 the enum, they can both be used without conflict.
 
-A value of an enum type contains information about which variant it is,
+A value of an `enum` type contains information about which variant it is,
 in addition to any data associated with that variant. This is sometimes
 referred to as a ‘tagged union’, since the data includes a ‘tag’
 indicating what type it is. The compiler uses this information to
@@ -62,12 +62,11 @@ learn in the next section. We don’t know enough about Rust to implement
 equality yet, but we’ll find out in the [`traits`][traits] section.
 
 [match]: match.html
-[if-let]: if-let.html
 [traits]: traits.html
 
 # Constructors as functions
 
-An enum’s constructors can also be used like functions. For example:
+An `enum` constructor can also be used like a function. For example:
 
 ```rust
 # enum Message {
@@ -76,7 +75,7 @@ An enum’s constructors can also be used like functions. For example:
 let m = Message::Write("Hello, world".to_string());
 ```
 
-Is the same as
+is the same as
 
 ```rust
 # enum Message {
diff --git a/src/doc/book/error-handling.md b/src/doc/book/error-handling.md
