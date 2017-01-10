% ライフタイム
<!-- % Lifetimes -->

<!-- This guide is three of three presenting Rust’s ownership system. This is one of -->
<!-- Rust’s most unique and compelling features, with which Rust developers should -->
<!-- become quite acquainted. Ownership is how Rust achieves its largest goal, -->
<!-- memory safety. There are a few distinct concepts, each with its own chapter: -->
このガイドはRustの所有権システムの3つの解説の3つ目です。
これはRustの最も独特で注目されている機能です。そして、Rust開発者はそれについて高度に精通しておくべきです。
所有権こそはRustがその最大の目標、メモリ安全性を得るための方法です。
そこにはいくつかの別個の概念があり、各概念が独自の章を持ちます。

<!-- * [ownership][ownership], the key concept -->
<!-- * [borrowing][borrowing], and their associated feature ‘references’ -->
<!-- * lifetimes, which you’re reading now -->
* キーとなる概念、 [所有権][ownership]
* [借用][borrowing] 、そしてそれらに関連する機能、「参照」
* 今読んでいる、ライフタイム

<!-- These three chapters are related, and in order. You’ll need all three to fully -->
<!-- understand the ownership system. -->
それらの3つの章は関連していて、それらは順番に並んでいます。
所有権システムを完全に理解するためには、3つ全てを必要とするでしょう。

[ownership]: ownership.html
[borrowing]: references-and-borrowing.html

<!-- # Meta -->
# 概論

<!-- Before we get to the details, two important notes about the ownership system. -->
詳細に入る前に、所有権システムについての2つの重要な注意があります。

<!-- Rust has a focus on safety and speed. It accomplishes these goals through many -->
<!-- ‘zero-cost abstractions’, which means that in Rust, abstractions cost as little -->
<!-- as possible in order to make them work. The ownership system is a prime example -->
<!-- of a zero-cost abstraction. All of the analysis we’ll talk about in this guide -->
<!-- is _done at compile time_. You do not pay any run-time cost for any of these -->
<!-- features. -->
Rustは安全性とスピードに焦点を合わせます。
Rustはそれらの目標をたくさんの「ゼロコスト抽象化」を通じて成し遂げます。それは、Rustでは抽象化を機能させるためのコストをできる限り小さくすることを意味します。
所有権システムはゼロコスト抽象化の主な例です。
このガイドの中で話すであろう解析の全ては _コンパイル時に行われます_ 。
それらのどの機能に対しても実行時のコストは全く掛かりません。

<!-- However, this system does have a certain cost: learning curve. Many new users -->
<!-- to Rust experience something we like to call ‘fighting with the borrow -->
<!-- checker’, where the Rust compiler refuses to compile a program that the author -->
<!-- thinks is valid. This often happens because the programmer’s mental model of -->
<!-- how ownership should work doesn’t match the actual rules that Rust implements. -->
<!-- You probably will experience similar things at first. There is good news, -->
<!-- however: more experienced Rust developers report that once they work with the -->
<!-- rules of the ownership system for a period of time, they fight the borrow -->
<!-- checker less and less. -->
しかし、このシステムはあるコストを持ちます。それは学習曲線です。
多くの新しいRustのユーザは「借用チェッカとの戦い」と好んで呼ばれるものを経験します。そこではRustコンパイラが開発者が正しいと考えるプログラムをコンパイルすることを拒絶します。
所有権がどのように機能するのかについてのプログラマのメンタルモデルがRustの実装する実際のルールにマッチしないため、これはしばしば起きます。
しかし、よいニュースがあります。より経験豊富なRustの開発者は次のことを報告します。一度彼らが所有権システムのルールとともにしばらく仕事をすれば、彼らが借用チェッカと戦うことは少なくなっていくということです。

<!-- With that in mind, let’s learn about lifetimes. -->
それを念頭に置いて、ライフタイムについて学びましょう。

<!-- # Lifetimes -->
# ライフタイム

<!-- Lending out a reference to a resource that someone else owns can be -->
<!-- complicated. For example, imagine this set of operations: -->
他の誰かの所有するリソースへの参照の貸付けは複雑になることがあります。
例えば、次のような一連の作業を想像しましょう。

<!-- 1. I acquire a handle to some kind of resource. -->
<!-- 2. I lend you a reference to the resource. -->
<!-- 3. I decide I’m done with the resource, and deallocate it, while you still have -->
<!--   your reference. -->
<!-- 4. You decide to use the resource. -->
1. 私はある種のリソースへのハンドルを取得する
2. 私はあなたにリソースへの参照を貸し付ける
3. 私はリソースを使い終わり、それを解放することを決めるが、あなたはそれに対する参照をまだ持っている
4. あなたはリソースを使うことを決める

<!-- Uh oh! Your reference is pointing to an invalid resource. This is called a -->
<!-- dangling pointer or ‘use after free’, when the resource is memory. -->
あー！　
あなたの参照は無効なリソースを指示しています。
リソースがメモリであるとき、これはダングリングポインタ又は「解放後の使用」と呼ばれます。

<!-- To fix this, we have to make sure that step four never happens after step -->
<!-- three. The ownership system in Rust does this through a concept called -->
<!-- lifetimes, which describe the scope that a reference is valid for. -->
これを修正するためには、ステップ3の後にステップ4が絶対に起こらないようにしなければなりません。
Rustでの所有権システムはこれをライフタイムと呼ばれる概念を通じて行います。それは参照の有効なスコープを記述するものです。

<!-- When we have a function that takes a reference by argument, we can be implicit -->
<!-- or explicit about the lifetime of the reference: -->
引数として参照を受け取る関数について、参照のライフタイムを黙示又は明示することができます。

```rust
# // implicit
// 黙示的に
fn foo(x: &i32) {
}

# // explicit
// 明示的に
fn bar<'a>(x: &'a i32) {
}
```

<!-- The `'a` reads ‘the lifetime a’. Technically, every reference has some lifetime -->
<!-- associated with it, but the compiler lets you elide (i.e. omit, see -->
<!-- ["Lifetime Elision"][lifetime-elision] below) them in common cases. -->
<!-- Before we get to that, though, let’s break the explicit example down: -->
`'a`は「ライフタイムa」と読みます。
技術的には参照は全てそれに関連するライフタイムを持ちますが、一般的な場合にはコンパイラがそれらを省略してもよいように計らってくれます（つまり、「省略」できるということです。 [「ライフタイムの省略」][lifetime-elision] 以下を見ましょう）。
しかし、それに入る前に、明示の例を分解しましょう。

[lifetime-elision]: #lifetime-elision

```rust,ignore
fn bar<'a>(...)
```

<!-- We previously talked a little about [function syntax][functions], but we didn’t -->
<!-- discuss the `<>`s after a function’s name. A function can have ‘generic -->
<!-- parameters’ between the `<>`s, of which lifetimes are one kind. We’ll discuss -->
<!-- other kinds of generics [later in the book][generics], but for now, let’s -->
<!-- just focus on the lifetimes aspect. -->
[関数の構文][functions] については前に少し話しました。しかし、関数名の後の `<>` については議論しませんでした。
関数は `<>` の間に「ジェネリックパラメータ」を持つことができ、ライフタイムはその一種です。
他の種類のジェネリクスについては [本書の後の方][generics] で議論しますが、とりあえず、ライフタイムの面だけに焦点を合わせましょう。

[functions]: functions.html
[generics]: generics.html

<!-- We use `<>` to declare our lifetimes. This says that `bar` has one lifetime, -->
<!-- `'a`. If we had two reference parameters, it would look like this: -->
`<>` はライフタイムを宣言するために使われます。
これは `bar` が1つのライフタイム `'a` を持つことを意味します。
もし2つの参照引数があれば、それは次のような感じになるでしょう。

```rust,ignore
fn bar<'a, 'b>(...)
```

<!-- Then in our parameter list, we use the lifetimes we’ve named: -->
そして引数リストでは、名付けたライフタイムを使います。

```rust,ignore
...(x: &'a i32)
```

<!-- If we wanted an `&mut` reference, we’d do this: -->
もし `&mut` 参照が欲しいのならば、次のようにします。

```rust,ignore
...(x: &'a mut i32)
```

<!-- If you compare `&mut i32` to `&'a mut i32`, they’re the same, it’s just that -->
<!-- the lifetime `'a` has snuck in between the `&` and the `mut i32`. We read `&mut -->
<!-- i32` as ‘a mutable reference to an `i32`’ and `&'a mut i32` as ‘a mutable -->
<!-- reference to an `i32` with the lifetime `'a`’. -->
もし `&mut i32` を `&'a mut i32` と比較するならば、それらは同じです。それはライフタイム `'a` が `&` と `mut i32` の間にこっそり入っているだけです。
`&mut i32` は「 `i32` へのミュータブルな参照」のように読み、 `&'a mut i32` は「ライフタイム `'a` を持つ `i32` へのミュータブルな参照」のように読みます。

<!-- # In `struct`s -->
# `struct` の中

<!-- You’ll also need explicit lifetimes when working with [`struct`][structs]s that -->
<!-- contain references: -->
参照を含む [`struct`][structs] を使うときにも、明示的なライフタイムを必要とするでしょう。

```rust
struct Foo<'a> {
    x: &'a i32,
}

fn main() {
# //    let y = &5; // this is the same as `let _y = 5; let y = &_y;`
    let y = &5; // これは`let _y = 5; let y = &_y;`と同じ
    let f = Foo { x: y };

    println!("{}", f.x);
}
```

[structs]: structs.html

<!-- As you can see, `struct`s can also have lifetimes. In a similar way to functions, -->
見てのとおり、 `struct` もライフタイムを持つことができます。
これは関数と同じ方法です。

```rust
struct Foo<'a> {
# x: &'a i32,
# }
```

<!-- declares a lifetime, and -->
このようにライフタイムを宣言します。

```rust
# struct Foo<'a> {
x: &'a i32,
# }
```

<!-- uses it. So why do we need a lifetime here? We need to ensure that any reference -->
<!-- to a `Foo` cannot outlive the reference to an `i32` it contains. -->
そしてそれを使います。
それではなぜここでライフタイムを必要とするのでしょうか。
`Foo` への全ての参照がそれの含む `i32` への参照より長い間有効にはならないことを保証する必要があるからです。

<!-- ## `impl` blocks -->
## `impl` ブロック

<!-- Let’s implement a method on `Foo`: -->
`Foo` に次のようなメソッドを実装しましょう。

```rust
struct Foo<'a> {
    x: &'a i32,
}

impl<'a> Foo<'a> {
    fn x(&self) -> &'a i32 { self.x }
}

fn main() {
# //    let y = &5; // this is the same as `let _y = 5; let y = &_y;`
    let y = &5; // これは`let _y = 5; let y = &_y;`と同じ
    let f = Foo { x: y };

    println!("x is: {}", f.x());
}
```

<!-- As you can see, we need to declare a lifetime for `Foo` in the `impl` line. We repeat -->
<!-- `'a` twice, just like on functions: `impl<'a>` defines a lifetime `'a`, and `Foo<'a>` -->
<!-- uses it. -->
見てのとおり、 `Foo` のライフタイムは `impl` 行で宣言する必要があります。
ちょうど関数のときのように `'a` は2回繰り返されます。つまり、 `impl<'a>` はライフタイム `'a` を定義し、 `Foo<'a>` はそれを使うのです。

<!-- ## Multiple lifetimes -->
## 複数のライフタイム

<!-- If you have multiple references, you can use the same lifetime multiple times: -->
もし複数の参照があれば、同じライフタイムを複数回使うことができます。

```rust
fn x_or_y<'a>(x: &'a str, y: &'a str) -> &'a str {
#    x
# }
```

<!-- This says that `x` and `y` both are alive for the same scope, and that the -->
<!-- return value is also alive for that scope. If you wanted `x` and `y` to have -->
<!-- different lifetimes, you can use multiple lifetime parameters: -->
これは `x` と `y` が両方とも同じスコープで有効であり、戻り値もそのスコープで有効であることを示します。
もし `x` と `y` に違うライフタイムを持たせたいのであれば、複数のライフタイムパラメータを使うことができます。

```rust
fn x_or_y<'a, 'b>(x: &'a str, y: &'b str) -> &'a str {
#    x
# }
```

<!-- In this example, `x` and `y` have different valid scopes, but the return value -->
<!-- has the same lifetime as `x`. -->
この例では `x` と `y` が異なる有効なスコープを持ちますが、戻り値は `x` と同じライフタイムを持ちます。

<!-- ## Thinking in scopes -->
## スコープの考え方

<!-- A way to think about lifetimes is to visualize the scope that a reference is -->
<!-- valid for. For example: -->
ライフタイムについて考えるには、参照の有効なスコープを可視化することです。
例えばこうです。

```rust
fn main() {
# //     let y = &5;     // -+ y goes into scope
# //                     //  |
# //     // stuff        //  |
# //                     //  |
# // }                   // -+ y goes out of scope
    let y = &5;     // -+ yがスコープに入る
                    //  |
    // stuff        //  |
                    //  |
}                   // -+ yがスコープから出る
```

<!-- Adding in our `Foo`: -->
`Foo` を追加するとこうなります。

```rust
struct Foo<'a> {
    x: &'a i32,
}

fn main() {
# //     let y = &5;           // -+ y goes into scope
# //     let f = Foo { x: y }; // -+ f goes into scope
# //     // stuff              //  |
# //                           //  |
# // }                         // -+ f and y go out of scope
    let y = &5;           // -+ yがスコープに入る
    let f = Foo { x: y }; // -+ fがスコープに入る
    // stuff              //  |
                          //  |
}                         // -+ fとyがスコープから出る
```

<!-- Our `f` lives within the scope of `y`, so everything works. What if it didn’t? -->
<!-- This code won’t work: -->
`f` は `y` のスコープの中で有効なので、全て動きます。
もしそれがそうではなかったらどうでしょうか。
このコードは動かないでしょう。

```rust,ignore
struct Foo<'a> {
    x: &'a i32,
}

fn main() {
# //     let x;                    // -+ x goes into scope
# //                               //  |
# //     {                         //  |
# //         let y = &5;           // ---+ y goes into scope
# //         let f = Foo { x: y }; // ---+ f goes into scope
# //         x = &f.x;             //  | | error here
# //     }                         // ---+ f and y go out of scope
# //                               //  |
# //     println!("{}", x);        //  |
# // }                             // -+ x goes out of scope
    let x;                    // -+ xがスコープに入る
                              //  |
    {                         //  |
        let y = &5;           // ---+ yがスコープに入る
        let f = Foo { x: y }; // ---+ fがスコープに入る
        x = &f.x;             //  | | ここでエラーが起きる
    }                         // ---+ fとyがスコープから出る
                              //  |
    println!("{}", x);        //  |
}                             // -+ xがスコープから出る
```

<!-- Whew! As you can see here, the scopes of `f` and `y` are smaller than the scope -->
<!-- of `x`. But when we do `x = &f.x`, we make `x` a reference to something that’s -->
<!-- about to go out of scope. -->
ふう!
見てのとおり、ここでは `f` と `y` のスコープは `x` のスコープよりも小さいです。
しかし `x = &f.x` を実行するとき、 `x` をまさにスコープから外れた何かの参照にしてしまいます。

<!-- Named lifetimes are a way of giving these scopes a name. Giving something a -->
<!-- name is the first step towards being able to talk about it. -->
名前の付いたライフタイムはそれらのスコープに名前を与える方法です。
何かに名前を与えることはそれについて話をすることができるようになるための最初のステップです。

<!-- ## 'static -->
## 'static

<!-- The lifetime named ‘static’ is a special lifetime. It signals that something -->
<!-- has the lifetime of the entire program. Most Rust programmers first come across -->
<!-- `'static` when dealing with strings: -->
「static」と名付けられたライフタイムは特別なライフタイムです。
それは何かがプログラム全体に渡るライフタイムを持つことを示します。
ほとんどのRustのプログラマが最初に `'static` に出会うのは、文字列を扱うときです。

```rust
let x: &'static str = "Hello, world.";
```

<!-- String literals have the type `&'static str` because the reference is always -->
<!-- alive: they are baked into the data segment of the final binary. Another -->
<!-- example are globals: -->
文字列リテラルは `&'static str` 型を持ちます。なぜなら、参照が常に有効だからです。それらは最終的なバイナリのデータセグメントに焼き付けられます。
もう1つの例はグローバルです。

```rust
static FOO: i32 = 5;
let x: &'static i32 = &FOO;
```

<!-- This adds an `i32` to the data segment of the binary, and `x` is a reference -->
<!-- to it. -->
これはバイナリのデータセグメントに `i32` を追加します。そして、 `x` はそれへの参照です。

<!-- ## Lifetime Elision -->
## ライフタイムの省略

<!-- Rust supports powerful local type inference in function bodies, but it’s -->
<!-- forbidden in item signatures to allow reasoning about the types based on -->
<!-- the item signature alone. However, for ergonomic reasons a very restricted -->
<!-- secondary inference algorithm called “lifetime elision” applies in function -->
<!-- signatures. It infers only based on the signature components themselves and not -->
<!-- based on the body of the function, only infers lifetime parameters, and does -->
<!-- this with only three easily memorizable and unambiguous rules. This makes -->
<!-- lifetime elision a shorthand for writing an item signature, while not hiding -->
<!-- away the actual types involved as full local inference would if applied to it. -->
Rustは関数本体の部分では強力なローカル型推論をサポートします。しかし要素のシグネチャの部分では、型が要素のシグネチャだけでわかるようにするため、（型推論が）許されていません。
とはいえ、エルゴノミック（人間にとっての扱いやすさ）の理由により、"ライフタイムの省略"と呼ばれている、非常に制限された第二の推論アルゴリズムがシグネチャの部分に適用されます。
その推論はシグネチャのコンポーネントだけに基づき、関数本体には基づかず、ライフタイムパラメータだけを推論します。そしてたった3つの覚えやすく明確なルールに従って行います。
ライフタイムの省略で要素のシグネチャを短く書くことができます。しかしローカル型推論が適用されるときのように実際の型を隠すことはできません。

<!-- When talking about lifetime elision, we use the term *input lifetime* and -->
<!-- *output lifetime*. An *input lifetime* is a lifetime associated with a parameter -->
<!-- of a function, and an *output lifetime* is a lifetime associated with the return -->
<!-- value of a function. For example, this function has an input lifetime: -->
ライフタイムの省略について話すときには、 *入力ライフタイム* と *出力ライフタイム* という用語を使います。
*入力ライフタイム* は関数の引数に関連するライフタイムで、 *出力ライフタイム* は関数の戻り値に関連するライフタイムです。
例えば、次の関数は入力ライフタイムを持ちます。

```rust,ignore
fn foo<'a>(bar: &'a str)
```

<!-- This one has an output lifetime: -->
この関数は出力ライフタイムを持ちます。

```rust,ignore
fn foo<'a>() -> &'a str
```

<!-- This one has a lifetime in both positions: -->
この関数は両方の位置のライフタイムを持ちます。

```rust,ignore
fn foo<'a>(bar: &'a str) -> &'a str
```

<!-- Here are the three rules: -->
これが3つのルールです。

<!-- * Each elided lifetime in a function’s arguments becomes a distinct lifetime -->
<!--   parameter. -->
* 関数の引数の中の省略された各ライフタイムは互いに異なるライフタイムパラメータになる

<!-- * If there is exactly one input lifetime, elided or not, that lifetime is -->
<!--   assigned to all elided lifetimes in the return values of that function. -->
* もし入力ライフタイムが1つだけならば、省略されたかどうかにかかわらず、そのライフタイムはその関数の戻り値の中の省略されたライフタイム全てに割り当てられる

<!-- * If there are multiple input lifetimes, but one of them is `&self` or `&mut -->
<!--   self`, the lifetime of `self` is assigned to all elided output lifetimes. -->
* もし入力ライフタイムが複数あるが、その1つが `&self` 又は `&mut self` であれば、 `self` のライフタイムは省略された出力ライフタイム全てに割り当てられる

<!-- Otherwise, it is an error to elide an output lifetime. -->
そうでないときは、出力ライフタイムの省略はエラーです。

<!-- ### Examples -->
# 例

<!-- Here are some examples of functions with elided lifetimes.  We’ve paired each -->
<!-- example of an elided lifetime with its expanded form. -->
ここにライフタイムの省略された関数の例を示します。
省略されたライフタイムの各例をその展開した形式と組み合わせています。

```rust,ignore
# // fn print(s: &str); // elided
# // fn print<'a>(s: &'a str); // expanded
fn print(s: &str); // 省略された形
fn print<'a>(s: &'a str); // 展開した形

# // fn debug(lvl: u32, s: &str); // elided
# // fn debug<'a>(lvl: u32, s: &'a str); // expanded
fn debug(lvl: u32, s: &str); // 省略された形
fn debug<'a>(lvl: u32, s: &'a str); // 展開された形

# // In the preceding example, `lvl` doesn’t need a lifetime because it’s not a
# // reference (`&`). Only things relating to references (such as a `struct`
# // which contains a reference) need lifetimes.
// 前述の例では`lvl`はライフタイムを必要としません。なぜなら、それは参照（`&`）
// ではないからです。（参照を含む`struct`のような）参照に関係するものだけがライ
// フタイムを必要とします。

# // fn substr(s: &str, until: u32) -> &str; // elided
# // fn substr<'a>(s: &'a str, until: u32) -> &'a str; // expanded
fn substr(s: &str, until: u32) -> &str; // 省略された形
fn substr<'a>(s: &'a str, until: u32) -> &'a str; // 展開された形

# // fn get_str() -> &str; // ILLEGAL, no inputs
fn get_str() -> &str; // 不正。入力がない

# // fn frob(s: &str, t: &str) -> &str; // ILLEGAL, two inputs
# // fn frob<'a, 'b>(s: &'a str, t: &'b str) -> &str; // Expanded: Output lifetime is ambiguous
fn frob(s: &str, t: &str) -> &str; // 不正。入力が2つある
fn frob<'a, 'b>(s: &'a str, t: &'b str) -> &str; // 展開された形。出力ライフタイムが決まらない

# // fn get_mut(&mut self) -> &mut T; // elided
# // fn get_mut<'a>(&'a mut self) -> &'a mut T; // expanded
fn get_mut(&mut self) -> &mut T; // 省略された形
fn get_mut<'a>(&'a mut self) -> &'a mut T; // 展開された形

# // fn args<T:ToCStr>(&mut self, args: &[T]) -> &mut Command; // elided
# // fn args<'a, 'b, T:ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command; // expanded
fn args<T:ToCStr>(&mut self, args: &[T]) -> &mut Command; // 省略された形
fn args<'a, 'b, T:ToCStr>(&'a mut self, args: &'b [T]) -> &'a mut Command; // 展開された形

# // fn new(buf: &mut [u8]) -> BufWriter; // elided
# // fn new<'a>(buf: &'a mut [u8]) -> BufWriter<'a>; // expanded
fn new(buf: &mut [u8]) -> BufWriter; // 省略された形
fn new<'a>(buf: &'a mut [u8]) -> BufWriter<'a>; // 展開された形
```
