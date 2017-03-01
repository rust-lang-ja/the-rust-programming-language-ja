% ジェネリクス
<!-- % Generics -->

<!-- Sometimes, when writing a function or data type, we may want it to work for -->
<!-- multiple types of arguments. In Rust, we can do this with generics. -->
<!-- Generics are called ‘parametric polymorphism’ in type theory, -->
<!-- which means that they are types or functions that have multiple forms (‘poly’ -->
<!-- is multiple, ‘morph’ is form) over a given parameter (‘parametric’). -->
時々、関数やデータ型を書いていると、引数が複数の型に対応したものが欲しくなることもあります。
Rustでは、ジェネリクスを用いてこれを実現しています。
ジェネリクスは型理論において「パラメトリック多相」(parametric polymorphism)と呼ばれ、与えられたパラメータにより(「parametric」)型もしくは関数が多数の様相(「poly」は多様、「morph」は様相を意味します)
(訳注: ここで「様相」は型を指します)を持つことを意味しています。

<!-- Anyway, enough type theory, let’s check out some generic code. Rust’s -->
<!-- standard library provides a type, `Option<T>`, that’s generic: -->
さて、型理論はもう十分です。
続いてジェネリックなコードを幾つか見ていきましょう。
Rustが標準ライブラリで提供している型 `Option<T>` はジェネリックです。

```rust
enum Option<T> {
    Some(T),
    None,
}
```

<!-- The `<T>` part, which you’ve seen a few times before, indicates that this is -->
<!-- a generic data type. Inside the declaration of our `enum`, wherever we see a `T`, -->
<!-- we substitute that type for the same type used in the generic. Here’s an -->
<!-- example of using `Option<T>`, with some extra type annotations: -->
`<T>` の部分は、前に少し見たことがあると思いますが、これがジェネリックなデータ型であることを示しています。
`enum` の宣言内であれば、どこでも `T` を使うことができ、宣言内に登場する同じ型をジェネリック内で `T` 型に置き換えています。
型注釈を用いた`Option<T>`の使用例が以下になります。

```rust
let x: Option<i32> = Some(5);
```

<!-- In the type declaration, we say `Option<i32>`. Note how similar this looks to -->
<!-- `Option<T>`. So, in this particular `Option`, `T` has the value of `i32`. On -->
<!-- the right-hand side of the binding, we make a `Some(T)`, where `T` is `5`. -->
<!-- Since that’s an `i32`, the two sides match, and Rust is happy. If they didn’t -->
<!-- match, we’d get an error: -->
この型宣言では `Option<i32>` と書かれています。
`Option<T>` の違いに注目して下さい。
そう、上記の `Option` では `T` の値は `i32` です。
この束縛の右辺の `Some(T)` では、 `T` は `5` となります。
それが `i32` なので、両辺の型が一致するため、Rustは満足します。
型が不一致であれば、以下のようなエラーが発生します。

```rust,ignore
let x: Option<f64> = Some(5);
// error: mismatched types: expected `core::option::Option<f64>`,
// found `core::option::Option<_>` (expected f64 but found integral variable)
```

<!-- That doesn’t mean we can’t make `Option<T>`s that hold an `f64`! They just have -->
<!-- to match up: -->
これは `f64` を保持する `Option<T>` が作れないという意味ではありませんからね！
リテラルと宣言の型をぴったり合わせなければなりません。

```rust
let x: Option<i32> = Some(5);
let y: Option<f64> = Some(5.0f64);
```

<!-- This is just fine. One definition, multiple uses. -->
これだけで結構です。
1つの定義で、多くの用途が得られます。

<!-- Generics don’t have to only be generic over one type. Consider another type from Rust’s standard library that’s similar, `Result<T, E>`: -->
ジェネリクスにおいてジェネリックな型は1つまで、といった制限はありません。
Rustの標準ライブラリに入っている類似の型 `Result<T, E>` について考えてみます。

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

<!-- This type is generic over _two_ types: `T` and `E`. By the way, the capital letters -->
<!-- can be any letter you’d like. We could define `Result<T, E>` as: -->
この型では `T` と `E` の _2つ_ がジェネリックです。
ちなみに、大文字の部分はあなたの好きな文字で構いません。
もしあなたが望むなら `Result<T, E>` を、

```rust
enum Result<A, Z> {
    Ok(A),
    Err(Z),
}
```

<!-- if we wanted to. Convention says that the first generic parameter should be -->
<!-- `T`, for ‘type’, and that we use `E` for ‘error’. Rust doesn’t care, however. -->
のように定義できます。
慣習としては、「Type」から第1ジェネリックパラメータは `T` であるべきですし、「Error」から `E` を用いるのですが、Rustは気にしません。

<!-- The `Result<T, E>` type is intended to be used to return the result of a -->
<!-- computation, and to have the ability to return an error if it didn’t work out. -->
`Result<T, E>` 型は計算の結果を返すために使われることが想定されており、正常に動作しなかった場合にエラーの値を返す機能を持っています。

<!-- ## Generic functions -->
## ジェネリック関数

<!-- We can write functions that take generic types with a similar syntax: -->
似た構文でジェネリックな型を取る関数を記述できます。

```rust
fn takes_anything<T>(x: T) {
# // do something with x
  // xで何か行う
}
```

<!-- The syntax has two parts: the `<T>` says “this function is generic over one -->
<!-- type, `T`”, and the `x: T` says “x has the type `T`.” -->
構文は2つのパーツから成ります。
`<T>` は「この関数は1つの型、 `T` に対してジェネリックである」ということであり、 `x: T` は「xは `T` 型である」という意味です。

<!-- Multiple arguments can have the same generic type: -->
複数の引数が同じジェネリックな型を持つこともできます。

```rust
fn takes_two_of_the_same_things<T>(x: T, y: T) {
    // ...
}
```

<!-- We could write a version that takes multiple types: -->
複数の型を取るバージョンを記述することも可能です。

```rust
fn takes_two_things<T, U>(x: T, y: U) {
    // ...
}
```

<!-- ## Generic structs -->
## ジェネリック構造体

<!-- You can store a generic type in a `struct` as well: -->
また、 `struct` 内にジェネリックな型の値を保存することもできます。

```rust
struct Point<T> {
    x: T,
    y: T,
}

let int_origin = Point { x: 0, y: 0 };
let float_origin = Point { x: 0.0, y: 0.0 };
```

<!-- Similar to functions, the `<T>` is where we declare the generic parameters, -->
<!-- and we then use `x: T` in the type declaration, too. -->
関数と同様に、 `<T>` がジェネリックパラメータを宣言する場所であり、型宣言において `x: T` を使うのも同じです。

<!-- When you want to add an implementation for the generic `struct`, you just -->
<!-- declare the type parameter after the `impl`: -->
ジェネリックな `struct` に実装を追加したい場合、 `impl` の後に型パラメータを宣言するだけです。

```rust
# struct Point<T> {
#     x: T,
#     y: T,
# }
#
impl<T> Point<T> {
    fn swap(&mut self) {
        std::mem::swap(&mut self.x, &mut self.y);
    }
}
```

<!-- So far you’ve seen generics that take absolutely any type. These are useful in -->
<!-- many cases: you’ve already seen `Option<T>`, and later you’ll meet universal -->
<!-- container types like [`Vec<T>`][Vec]. On the other hand, often you want to -->
<!-- trade that flexibility for increased expressive power. Read about [trait -->
<!-- bounds][traits] to see why and how. -->
ここまででありとあらゆる型をとることのできるジェネリクスについて見てきました。
多くの場合これらは有用です。
`Option<T>` は既に見た通りですし、のちに `Vec<T>` のような普遍的なコンテナ型を知ることになるでしょう。
一方で、その柔軟性と引き換えに表現力を増加させたくなることもあります。
それは何故か、そしてその方法を知るためには [トレイト境界][traits] を読んで下さい。

[traits]: traits.html
[Vec]: ../std/vec/struct.Vec.html
