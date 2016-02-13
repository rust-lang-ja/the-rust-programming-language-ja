% `type` エイリアス
<!-- % `type` Aliases -->

<!-- The `type` keyword lets you declare an alias of another type: -->
`type` キーワードを用いることで他の型へのエイリアスを宣言することができます:

```rust
type Name = String;
```

<!-- You can then use this type as if it were a real type: -->
このようにすると 定義した型を実際の型であるかのように利用することができます:

```rust
type Name = String;

let x: Name = "Hello".to_string();
```

<!-- Note, however, that this is an _alias_, not a new type entirely. In other -->
<!-- words, because Rust is strongly typed, you’d expect a comparison between two -->
<!-- different types to fail: -->
しかしながら、これはあくまで _エイリアス_ であって、新しい型ではありません。
言い換えると、Rustは強い型付け言語であるため、異なる型同士の比較が失敗することを期待するでしょう。
例えば:

```rust,ignore
let x: i32 = 5;
let y: i64 = 5;

if x == y {
   // ...
}
```

<!-- this gives -->
このようなコードは以下のエラーを発生させます:

```text
error: mismatched types:
 expected `i32`,
    found `i64`
(expected i32,
    found i64) [E0308]
     if x == y {
             ^
```

<!-- But, if we had an alias: -->
一方で、エイリアス用いた場合は:

```rust
type Num = i32;

let x: i32 = 5;
let y: Num = 5;

if x == y {
   // ...
}
```

<!-- This compiles without error. Values of a `Num` type are the same as a value of -->
<!-- type `i32`, in every way. You can use [tuple struct] to really get a new type. -->
このコードはエラーを起こすこと無くコンパイルを通ります。 `Num` 型の値は `i32` 型の値とすべての面において等価です。
本当に新しい型がほしい時は [タプル構造体] を使うことができます。

[タプル構造体]: structs.html#tuple-structs

<!-- You can also use type aliases with generics: -->
また、エイリアスをジェネリクスと共に利用する事もできます:

```rust
use std::result;

enum ConcreteError {
    Foo,
    Bar,
}

type Result<T> = result::Result<T, ConcreteError>;
```

<!-- This creates a specialized version of the `Result` type, which always has a -->
<!-- `ConcreteError` for the `E` part of `Result<T, E>`. This is commonly used -->
<!-- in the standard library to create custom errors for each subsection. For -->
<!-- example, [io::Result][ioresult]. -->
このようにすると `Result` 型の `Result<T, E>` の `E` として常に `ConcreteError` を持っている特殊化されたバージョンが定義されます。
このような方法は標準ライブラリで細かく分類されたエラーを定義するために頻繁に使われています。
一例を上げると [io::Result][ioresult] がそれに当たります。

[ioresult]: ../std/io/type.Result.html
