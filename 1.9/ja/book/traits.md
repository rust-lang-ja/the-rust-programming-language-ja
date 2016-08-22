% トレイト
<!-- % Traits -->

<!-- A trait is a language feature that tells the Rust compiler about
functionality a type must provide. -->
トレイトはある型が提供しなければならない機能をRustのコンパイラに伝える言語機能です。

<!-- Recall the `impl` keyword, used to call a function with [method
syntax][methodsyntax]: -->
[メソッド構文][methodsyntax]で関数を呼び出すのに用いていた、 `impl` キーワードを思い出して下さい。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }
}
```

[methodsyntax]: method-syntax.html

<!-- Traits are similar, except that we first define a trait with a method
signature, then implement the trait for a type. In this example, we implement the trait `HasArea` for `Circle`: -->
始めにトレイトをメソッドのシグネチャと共に定義し、続いてある型のためにトレイトを実装するという流れを除けばトレイトはメソッド構文に似ています。
この例では、 `Circle` に `HasArea` トレイトを実装しています。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

trait HasArea {
    fn area(&self) -> f64;
}

impl HasArea for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }
}
```

<!-- As you can see, the `trait` block looks very similar to the `impl` block,
but we don’t define a body, only a type signature. When we `impl` a trait,
we use `impl Trait for Item`, rather than only `impl Item`. -->
このように、 `trait` ブロックは `impl` ブロックにとても似ているように見えますが、関数本体を定義せず、型シグネチャだけを定義しています。トレイトを `impl` するときは、 `impl Item` とだけ書くのではなく、 `impl Trait for Item` と書きます。

<!-- ## Trait bounds on generic functions -->
## ジェネリック関数におけるトレイト境界

<!-- Traits are useful because they allow a type to make certain promises about its
behavior. Generic functions can exploit this to constrain, or [bound][bounds], the types they
accept. Consider this function, which does not compile: -->
トレイトはある型の振る舞いを確約できるため有用です。ジェネリック関数は制約、あるいは [境界][bounds] が許容する型のみを受け取るためにトレイトを利用できます。以下の関数を考えて下さい、これはコンパイルできません。

[bounds]: glossary.html#bounds

```rust,ignore
fn print_area<T>(shape: T) {
    println!("This shape has an area of {}", shape.area());
}
```

<!-- Rust complains: -->
Rustは以下のエラーを吐きます。

```text
error: no method named `area` found for type `T` in the current scope
```

<!-- Because `T` can be any type, we can’t be sure that it implements the `area`
method. But we can add a trait bound to our generic `T`, ensuring
that it does: -->
`T` はあらゆる型になれるため、 `area` メソッドが実装されているか確認できません。ですがジェネリックな `T` にはトレイト境界を追加でき、境界が実装を保証してくれます。

```rust
# trait HasArea {
#     fn area(&self) -> f64;
# }
fn print_area<T: HasArea>(shape: T) {
    println!("This shape has an area of {}", shape.area());
}
```

<!-- The syntax `<T: HasArea>` means “any type that implements the `HasArea` trait.”
Because traits define function type signatures, we can be sure that any type
which implements `HasArea` will have an `.area()` method. -->
`<T: HasArea>` 構文は「 `HasArea` トレイトを実装するあらゆる型」という意味です。トレイトは関数の型シグネチャを定義しているため、 `HasArea` を実装するあらゆる型が `.area()` メソッドを持っていることを確認できます。

<!-- Here’s an extended example of how this works: -->
トレイトの動作を確認するために拡張した例が以下になります。

```rust
trait HasArea {
    fn area(&self) -> f64;
}

struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl HasArea for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }
}

struct Square {
    x: f64,
    y: f64,
    side: f64,
}

impl HasArea for Square {
    fn area(&self) -> f64 {
        self.side * self.side
    }
}

fn print_area<T: HasArea>(shape: T) {
    println!("This shape has an area of {}", shape.area());
}

fn main() {
    let c = Circle {
        x: 0.0f64,
        y: 0.0f64,
        radius: 1.0f64,
    };

    let s = Square {
        x: 0.0f64,
        y: 0.0f64,
        side: 1.0f64,
    };

    print_area(c);
    print_area(s);
}
```

<!-- This program outputs: -->
このプログラムの出力は、

```text
This shape has an area of 3.141593
This shape has an area of 1
```

<!-- As you can see, `print_area` is now generic, but also ensures that we have
passed in the correct types. If we pass in an incorrect type: -->
見ての通り、上記の `print_area` はジェネリックですが、適切な型が渡されることを保証しています。もし不適切な型を渡すと、

```rust,ignore
print_area(5);
```

<!-- We get a compile-time error: -->
コンパイル時エラーが発生します。

```text
error: the trait bound `_ : HasArea` is not satisfied [E0277]
```

<!-- ## Trait bounds on generic structs -->
## ジェネリック構造体におけるトレイト境界

<!-- Your generic structs can also benefit from trait bounds. All you need to
do is append the bound when you declare type parameters. Here is a new
type `Rectangle<T>` and its operation `is_square()`: -->
ジェネリック構造体もトレイト境界による恩恵を受けることができます。型パラメータを宣言する際に境界を追加するだけで良いのです。以下が新しい型 `Rectangle<T>` とそのメソッド `is_square()` です。

```rust
struct Rectangle<T> {
    x: T,
    y: T,
    width: T,
    height: T,
}

impl<T: PartialEq> Rectangle<T> {
    fn is_square(&self) -> bool {
        self.width == self.height
    }
}

fn main() {
    let mut r = Rectangle {
        x: 0,
        y: 0,
        width: 47,
        height: 47,
    };

    assert!(r.is_square());

    r.height = 42;
    assert!(!r.is_square());
}
```

<!-- `is_square()` needs to check that the sides are equal, so the sides must be of
a type that implements the [`core::cmp::PartialEq`][PartialEq] trait: -->
`is_square()` は両辺が等しいかチェックする必要があるため、両辺の型は [`core::cmp::PartialEq`][PartialEq] トレイトを実装しなければなりません。

```ignore
impl<T: PartialEq> Rectangle<T> { ... }
```

<!-- Now, a rectangle can be defined in terms of any type that can be compared for
equality. -->
これで、長方形を等値性の比較できる任意の型として定義できました。

[PartialEq]: ../core/cmp/trait.PartialEq.html

<!-- Here we defined a new struct `Rectangle` that accepts numbers of any
precision—really, objects of pretty much any type—as long as they can be
compared for equality. Could we do the same for our `HasArea` structs, `Square`
and `Circle`? Yes, but they need multiplication, and to work with that we need
to know more about [operator traits][operators-and-overloading]. -->
上記の例では任意の精度の数値を受け入れる `Rectangle` 構造体を新たに定義しました-実は、等値性を比較できるほぼ全ての型に対して利用可能なオブジェクトです。同じことを `Square` や `Circle` のような `HasArea` を実装する構造体に対してできるでしょうか?可能では有りますが乗算が必要になるため、それをするには [オペレータトレイト][operators-and-overloading] についてより詳しく知らなければなりません。

[operators-and-overloading]: operators-and-overloading.html

<!-- # Rules for implementing traits -->
# トレイト実装のルール

<!-- So far, we’ve only added trait implementations to structs, but you can
implement a trait for any type. So technically, we _could_ implement `HasArea`
for `i32`: -->
ここまでで、構造体へトレイトの実装を追加することだけを説明してきましたが、あらゆる型についてトレイトを実装することもできます。技術的には、 `i32` に `HasArea` を実装することも _できなくはない_ です。

```rust
trait HasArea {
    fn area(&self) -> f64;
}

impl HasArea for i32 {
    fn area(&self) -> f64 {
        println!("this is silly");

        *self as f64
    }
}

5.area();
```

<!-- It is considered poor style to implement methods on such primitive types, even
though it is possible. -->
しかし例え可能であったとしても、そのようなプリミティブ型のメソッドを実装するのは適切でない手法だと考えられています。

<!-- This may seem like the Wild West, but there are two restrictions around
implementing traits that prevent this from getting out of hand. The first is
that if the trait isn’t defined in your scope, it doesn’t apply. Here’s an
example: the standard library provides a [`Write`][write] trait which adds
extra functionality to `File`s, for doing file I/O. By default, a `File`
won’t have its methods: -->
ここまでくると世紀末感が漂いますが、手に負えなくなることを防ぐためにトレイトの実装周りには2つの制限が設けられています。第1に、あなたのスコープ内で定義されていないトレイトは適用されません。例えば、標準ライブラリは `File` にI/O機能を追加するための `Write` トレイトを提供しています。デフォルトでは、 `File` は `Writes` で定義されるメソッド群を持っていません。

[write]: ../std/io/trait.Write.html

```rust,ignore
let mut f = std::fs::File::open("foo.txt").expect("Couldn’t open foo.txt");
# // let buf = b"whatever"; // byte string literal. buf: &[u8; 8]
let buf = b"whatever"; // buf: &[u8; 8] はバイト文字列リテラルです。
let result = f.write(buf);
# // result.unwrap(); // ignore the error
# // result.unwrap(); // エラーを無視します。
```

<!-- Here’s the error: -->
エラーは以下のようになります。

```text
error: type `std::fs::File` does not implement any method in scope named `write`
let result = f.write(buf);
               ^~~~~~~~~~
```

<!-- We need to `use` the `Write` trait first: -->
始めに `Write` トレイトを `use` する必要があります。

```rust,ignore
use std::io::Write;

let mut f = std::fs::File::open("foo.txt").expect("Couldn’t open foo.txt");
let buf = b"whatever";
let result = f.write(buf);
# // result.unwrap(); // ignore the error
# // result.unwrap(); // エラーを無視します。
```

<!-- This will compile without error. -->
これはエラー無しでコンパイルされます。

<!-- This means that even if someone does something bad like add methods to `i32`,
it won’t affect you, unless you `use` that trait. -->
これは、例え誰かが `i32` へメソッドを追加するような望ましくない何かを行ったとしても、あなたがトレイトを `use` しない限り、影響はないことを意味します。

<!-- There’s one more restriction on implementing traits: either the trait
or the type you’re implementing it for must be defined by you. Or more
precisely, one of them must be defined in the same crate as the `impl`
you're writing. For more on Rust's module and package system, see the
chapter on [crates and modules][cm]. -->
トレイトの実装における制限はもう1つあります。トレイトまたはあなたがそれを実装している型はあなた自身によって定義されなければなりません。より正確に言えば、それらの内の1つはあなたが書く `impl` と同一のクレートに定義されなければなりません。Rustのモジュールとパッケージシステムについての詳細は、 [クレートとモジュール][cm] の章を見てください。

<!-- So, we could implement the `HasArea` type for `i32`, because we defined
`HasArea` in our code. But if we tried to implement `ToString`, a trait
provided by Rust, for `i32`, we could not, because neither the trait nor
the type are defined in our crate. -->
以上により `i32` について `HasArea` 型が実装できるはずです、コードには `HasArea` を定義しましたからね。しかし `i32` にRustによって提供されている `ToString` を実装しようとすると失敗するはずです、トレイトと型の両方が私達のクレートで定義されていませんからね。

<!-- One last thing about traits: generic functions with a trait bound use
‘monomorphization’ (mono: one, morph: form), so they are statically dispatched.
What’s that mean? Check out the chapter on [trait objects][to] for more details. -->
トレイトに関して最後に1つ。トレイト境界が設定されたジェネリック関数は「単相化」(monomorphization)(mono:単一の、morph:様相)されるため、静的ディスパッチが行われます。一体どういう意味でしょうか？詳細については、 [トレイトオブジェクト][to] の章をチェックしてください。

[cm]: crates-and-modules.html
[to]: trait-objects.html

<!-- # Multiple trait bounds -->
# 複数のトレイト境界

<!-- You’ve seen that you can bound a generic type parameter with a trait: -->
トレイトによってジェネリックな型パラメータに境界が与えられることを見てきました。

```rust
fn foo<T: Clone>(x: T) {
    x.clone();
}
```

<!-- If you need more than one bound, you can use `+`: -->
1つ以上の境界を与えたい場合、 `+` を使えます。

```rust
use std::fmt::Debug;

fn foo<T: Clone + Debug>(x: T) {
    x.clone();
    println!("{:?}", x);
}
```

<!-- `T` now needs to be both `Clone` as well as `Debug`. -->
この `T` 型は `Clone` と `Debug` 両方が必要です。

<!-- # Where clause -->
# Where 節

<!-- Writing functions with only a few generic types and a small number of trait
bounds isn’t too bad, but as the number increases, the syntax gets increasingly
awkward: -->
ジェネリック型もトレイト境界の数も少ない関数を書いているうちは悪く無いのですが、数が増えるとこの構文ではいよいよ不便になってきます。

```rust
use std::fmt::Debug;

fn foo<T: Clone, K: Clone + Debug>(x: T, y: K) {
    x.clone();
    y.clone();
    println!("{:?}", y);
}
```

<!-- The name of the function is on the far left, and the parameter list is on the
far right. The bounds are getting in the way. -->
関数名は左端にあり、引数リストは右端にあります。境界を記述する部分が邪魔になっているのです。


<!-- Rust has a solution, and it’s called a ‘`where` clause’: -->
Rustは「 `where` 節」と呼ばれる解決策を持っています。

```rust
use std::fmt::Debug;

fn foo<T: Clone, K: Clone + Debug>(x: T, y: K) {
    x.clone();
    y.clone();
    println!("{:?}", y);
}

fn bar<T, K>(x: T, y: K) where T: Clone, K: Clone + Debug {
    x.clone();
    y.clone();
    println!("{:?}", y);
}

fn main() {
    foo("Hello", "world");
    bar("Hello", "world");
}
```

<!-- `foo()` uses the syntax we showed earlier, and `bar()` uses a `where` clause.
All you need to do is leave off the bounds when defining your type parameters,
and then add `where` after the parameter list. For longer lists, whitespace can
be added: -->
`foo()` は先程見せたままの構文で、 `bar()` は `where` 節を用いています。型パラメータを定義する際に境界の設定をせず、引数リストの後ろに `where` を追加するだけで良いのです。長いリストであれば、空白を加えることもできます。

```rust
use std::fmt::Debug;

fn bar<T, K>(x: T, y: K)
    where T: Clone,
          K: Clone + Debug {

    x.clone();
    y.clone();
    println!("{:?}", y);
}
```

<!-- This flexibility can add clarity in complex situations. -->
この柔軟性により複雑な状況であっても可読性を改善できます。

<!-- `where` is also more powerful than the simpler syntax. For example: -->
また、`where` は基本の構文よりも強力です。例えば、

```rust
trait ConvertTo<Output> {
    fn convert(&self) -> Output;
}

impl ConvertTo<i64> for i32 {
    fn convert(&self) -> i64 { *self as i64 }
}

# // can be called with T == i32
// T == i32の時に呼び出せる
fn normal<T: ConvertTo<i64>>(x: &T) -> i64 {
    x.convert()
}

# // can be called with T == i64
// T == i64の時に呼び出せる
fn inverse<T>() -> T
#        // this is using ConvertTo as if it were "ConvertTo<i64>"
        // これは「ConvertTo<i64>」であるかのようにConvertToを用いている
        where i32: ConvertTo<T> {
    42.convert()
}
```

<!-- This shows off the additional feature of `where` clauses: they allow bounds
on the left-hand side not only of type parameters `T`, but also of types (`i32` in this case). In this example, `i32` must implement
`ConvertTo<T>`. Rather than defining what `i32` is (since that's obvious), the
`where` clause here constrains `T`. -->
ここでは `where` 節の追加機能を披露しています。この節は左辺に型パラメータ `T` だけでなく具体的な型(このケースでは `i32` )を指定できます。この例だと、 `i32` は `ConvertTo<T>` を実装していなければなりません。(それは明らかですから)ここの `where` 節は `i32` が何であるか定義しているというよりも、 `T` に対して制約を設定しているといえるでしょう。

<!-- # Default methods -->
# デフォルトメソッド

<!-- A default method can be added to a trait definition if it is already known how a typical implementor will define a method. For example, `is_invalid()` is defined as the opposite of `is_valid()`: -->
典型的な実装者がどうメソッドを定義するか既に分かっているならば、トレイトの定義にデフォルトメソッドを加えることができます。例えば、以下の `is_invalid()` は `is_valid()` の反対として定義されます。

```rust
trait Foo {
    fn is_valid(&self) -> bool;

    fn is_invalid(&self) -> bool { !self.is_valid() }
}
```

<!-- Implementors of the `Foo` trait need to implement `is_valid()` but not `is_invalid()` due to the added default behavior. This default behavior can still be overridden as in: -->
`Foo` トレイトの実装者は `is_valid()` を実装する必要がありますが、デフォルトの動作が加えられている `is_invalid()` には必要ありません。

```rust
# trait Foo {
#     fn is_valid(&self) -> bool;
#
#     fn is_invalid(&self) -> bool { !self.is_valid() }
# }
struct UseDefault;

impl Foo for UseDefault {
    fn is_valid(&self) -> bool {
        println!("Called UseDefault.is_valid.");
        true
    }
}

struct OverrideDefault;

impl Foo for OverrideDefault {
    fn is_valid(&self) -> bool {
        println!("Called OverrideDefault.is_valid.");
        true
    }

    fn is_invalid(&self) -> bool {
        println!("Called OverrideDefault.is_invalid!");
# //         true // overrides the expected value of is_invalid()
        true // 予期されるis_invalid()の値をオーバーライドする
    }
}

let default = UseDefault;
# // assert!(!default.is_invalid()); // prints "Called UseDefault.is_valid."
assert!(!default.is_invalid()); // 「Called UseDefault.is_valid.」を表示

let over = OverrideDefault;
# // assert!(over.is_invalid()); // prints "Called OverrideDefault.is_invalid!"
assert!(over.is_invalid()); // 「Called OverrideDefault.is_invalid!」を表示
```

<!-- # Inheritance -->
# 継承

<!-- Sometimes, implementing a trait requires implementing another trait: -->
時々、1つのトレイトの実装に他のトレイトの実装が必要になります。

```rust
trait Foo {
    fn foo(&self);
}

trait FooBar : Foo {
    fn foobar(&self);
}
```

<!-- Implementors of `FooBar` must also implement `Foo`, like this: -->
`FooBar` の実装者は `Foo` も実装しなければなりません。以下のようになります。

```rust
# trait Foo {
#     fn foo(&self);
# }
# trait FooBar : Foo {
#     fn foobar(&self);
# }
struct Baz;

impl Foo for Baz {
    fn foo(&self) { println!("foo"); }
}

impl FooBar for Baz {
    fn foobar(&self) { println!("foobar"); }
}
```

<!-- If we forget to implement `Foo`, Rust will tell us: -->
`Foo` の実装を忘れると、Rustは以下のように伝えるでしょう。

```text
error: the trait bound `main::Baz : main::Foo` is not satisfied [E0277]
```

<!-- # Deriving -->
# Derive

<!-- Implementing traits like `Debug` and `Default` repeatedly can become
quite tedious. For that reason, Rust provides an [attribute][attributes] that
allows you to let Rust automatically implement traits for you: -->
繰り返し`Debug` や `Default` のようなトレイトを実装するのは非常にうんざりさせられます。そのような理由から、Rustは自動的にトレイトを実装するための [アトリビュート][attributes] を提供しています。

```rust
#[derive(Debug)]
struct Foo;

fn main() {
    println!("{:?}", Foo);
}
```

[attributes]: attributes.html

<!-- However, deriving is limited to a certain set of traits: -->
ただし、deriveは以下の特定のトレイトに制限されています。

- [`Clone`](../core/clone/trait.Clone.html)
- [`Copy`](../core/marker/trait.Copy.html)
- [`Debug`](../core/fmt/trait.Debug.html)
- [`Default`](../core/default/trait.Default.html)
- [`Eq`](../core/cmp/trait.Eq.html)
- [`Hash`](../core/hash/trait.Hash.html)
- [`Ord`](../core/cmp/trait.Ord.html)
- [`PartialEq`](../core/cmp/trait.PartialEq.html)
- [`PartialOrd`](../core/cmp/trait.PartialOrd.html)
