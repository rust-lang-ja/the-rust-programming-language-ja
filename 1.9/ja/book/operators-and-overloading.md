% 演算子とオーバーロード
<!-- % Operators and Overloading -->

<!-- Rust allows for a limited form of operator overloading. There are certain -->
<!-- operators that are able to be overloaded. To support a particular operator -->
<!-- between types, there’s a specific trait that you can implement, which then -->
<!-- overloads the operator. -->
Rustは制限された形式での演算子オーバーロードを提供しており、オーバーロード可能な演算子がいくつか存在します。
型同士の間の演算子をサポートするためのトレイトが存在し、それらを実装することで演算子をオーバーロードできます。

<!-- For example, the `+` operator can be overloaded with the `Add` trait: -->
たとえば、 `+` の演算子は `Add` トレイトでオーバーロードできます:

```rust
use std::ops::Add;

#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

impl Add for Point {
    type Output = Point;

    fn add(self, other: Point) -> Point {
        Point { x: self.x + other.x, y: self.y + other.y }
    }
}

fn main() {
    let p1 = Point { x: 1, y: 0 };
    let p2 = Point { x: 2, y: 3 };

    let p3 = p1 + p2;

    println!("{:?}", p3);
}
```

<!-- In `main`, we can use `+` on our two `Point`s, since we’ve implemented -->
<!-- `Add<Output=Point>` for `Point`. -->
`main` 中で、２つの `Point` に対して `+` を使えます。
これは `Point` に対して `Add<Output=Point>` を実装したためです。

<!-- There are a number of operators that can be overloaded this way, and all of -->
<!-- their associated traits live in the [`std::ops`][stdops] module. Check out its -->
<!-- documentation for the full list. -->
同じ方法でオーバーロード可能な演算子が多数あります。
それらに対応したトレイトは [`std::ops`][stdops] モジュール内に存在します。
全てのオーバーロード可能な演算子と対応するトレイトについては [`std::ops`][stdops] のドキュメントを読んで確認して下さい。

[stdops]: ../std/ops/index.html

<!-- Implementing these traits follows a pattern. Let’s look at [`Add`][add] in more -->
<!-- detail: -->
それらのトレイトの実装は、ある一つのパターンに従います。
[`Add`][add] トレイトを詳しく見ていきましょう:

```rust
# mod foo {
pub trait Add<RHS = Self> {
    type Output;

    fn add(self, rhs: RHS) -> Self::Output;
}
# }
```

[add]: ../std/ops/trait.Add.html

<!-- There’s three types in total involved here: the type you `impl Add` for, `RHS`, -->
<!-- which defaults to `Self`, and `Output`. For an expression `let z = x + y`, `x` -->
<!-- is the `Self` type, `y` is the RHS, and `z` is the `Self::Output` type. -->
関連する３つの型が存在します: `impl Add` を実装するもの、 デフォルトが `Self` の `RHS`、 そして `Output` です。
たとえば、式 `let z = x + y` においては `x` は `Self` 型 `y` は RHS、 `z` は `Self::Output` 型となります。

```rust
# struct Point;
# use std::ops::Add;
impl Add<i32> for Point {
    type Output = f64;

    fn add(self, rhs: i32) -> f64 {
# //        // add an i32 to a Point and get an f64
        // i32をPointに加算しf64を返す
# 1.0
    }
}
```

<!-- will let you do this: -->
上のコードによって以下の様に書けるようになります:

```rust,ignore
let p: Point = // ...
let x: f64 = p + 2i32;
```

<!-- # Using operator traits in generic structs -->
# オペレータトレイトをジェネリック構造体で使う

<!-- Now that we know how operator traits are defined, we can define our `HasArea` -->
<!-- trait and `Square` struct from the [traits chapter][traits] more generically: -->
オペレータトレイトがどのように定義されているかを学びましたので、[トレイトについての章][traits] の `HasArea` トレイトと `Square` 構造体をさらに一般的に定義できます:

[traits]: traits.html

```rust
use std::ops::Mul;

trait HasArea<T> {
    fn area(&self) -> T;
}

struct Square<T> {
    x: T,
    y: T,
    side: T,
}

impl<T> HasArea<T> for Square<T>
        where T: Mul<Output=T> + Copy {
    fn area(&self) -> T {
        self.side * self.side
    }
}

fn main() {
    let s = Square {
        x: 0.0f64,
        y: 0.0f64,
        side: 12.0f64,
    };

    println!("Area of s: {}", s.area());
}
```

<!-- For `HasArea` and `Square`, we declare a type parameter `T` and replace -->
<!-- `f64` with it. The `impl` needs more involved modifications: -->
`HasArea` と `Square` について、型パラメータ `T` を宣言し `f64` で置換しました。
`impl` はさらに関連する修正を必要とします:

```ignore
impl<T> HasArea<T> for Square<T>
        where T: Mul<Output=T> + Copy { ... }
```

<!-- The `area` method requires that we can multiply the sides, so we declare that -->
<!-- type `T` must implement `std::ops::Mul`. Like `Add`, mentioned above, `Mul` -->
<!-- itself takes an `Output` parameter: since we know that numbers don't change -->
<!-- type when multiplied, we also set it to `T`. `T` must also support copying, so -->
<!-- Rust doesn't try to move `self.side` into the return value. -->
`area` メソッドは辺を掛けることが可能なことを必要としています。
そのため型 `T` が `std::ops::Mul` を実装していなければならないと宣言しています。
上で説明した `Add` と同様に、`Mul` は `Output` パラメータを取ります:
数値を掛け算した時に型が変わらないことを知っていますので、 `Output` も `T` と設定します。
また `T` は、Rustが `self.side` を返り値にムーブするのを試みないようにコピーをサポートしている必要があります。
