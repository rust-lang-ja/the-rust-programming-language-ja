% 変数束縛
<!-- % Variable Bindings -->

<!-- Virtually every non-'Hello World’ Rust program uses *variable bindings*. They -->
<!-- bind some value to a name, so it can be used later. `let` is -->
<!-- used to introduce a binding, like this: -->
事実上全ての「Hello World」でないRustのプログラムは *変数束縛* を使っています。
変数束縛は何らかの値を名前へと束縛するので、後でその値を使えます。
このように、 `let` が束縛を導入するのに使われています。

> 訳注: 普通、束縛というときは名前 *を* 値 *へ* と束縛しますが、このドキュメントでは逆になっています。
>      Rustでは他の言語と違って1つの値に対して1つの名前が対応するのであえてこう書いてるのかもしれません。

```rust
fn main() {
    let x = 5;
}
```

<!-- Putting `fn main() {` in each example is a bit tedious, so we’ll leave that out -->
<!-- in the future. If you’re following along, make sure to edit your `main()` -->
<!-- function, rather than leaving it off. Otherwise, you’ll get an error. -->
例で毎回 `fn main() {` と書くのは長ったらしいのでこれ以後は省略します。
もし試しながら読んでいるのならそのまま書くのではなくちゃんと `main()` 関数の中身を編集するようにしてください。そうしないとエラーになります。

<!-- # Patterns -->
# パターン

<!-- In many languages, a variable binding would be called a *variable*, but Rust’s -->
<!-- variable bindings have a few tricks up their sleeves. For example the -->
<!-- left-hand side of a `let` statement is a ‘[pattern][pattern]’, not just a -->
<!-- variable name. This means we can do things like: -->
多くの言語では変数束縛は *変数* と呼ばれるでしょうが、Rustの変数束縛は多少皮を被せてあります。
例えば、 `let` 文の左側は「[パターン][pattern]」であって、ただの変数名ではありません。
これはこのようなことができるということです。

```rust
let (x, y) = (1, 2);
```

<!-- After this statement is evaluated, `x` will be one, and `y` will be two. -->
<!-- Patterns are really powerful, and have [their own section][pattern] in the -->
<!-- book. We don’t need those features for now, so we’ll keep this in the back -->
<!-- of our minds as we go forward. -->
この文が評価されたあと、 `x` は1になり、 `y` は2になります。
パターンは本当に強力で、本書には[パターンのセクション][pattern]もあります。
今のところこの機能は必要ないので頭の片隅に留めておいてだけいてください。

[pattern]: patterns.html

<!-- # Type annotations -->
# 型アノテーション

<!-- Rust is a statically typed language, which means that we specify our types up -->
<!-- front, and they’re checked at compile time. So why does our first example -->
<!-- compile? Well, Rust has this thing called ‘type inference’. If it can figure -->
<!-- out what the type of something is, Rust doesn’t require you to actually type it -->
<!-- out. -->
Rustは静的な型付言語であり、前もって型を与えておいて、それがコンパイル時に検査されます。
じゃあなぜ最初の例はコンパイルが通るのでしょう?ええと、Rustには「型推論」と呼ばれるものがあります。
型推論が型が何であるか判断できるなら、型を書く必要はなくなります。

<!-- We can add the type if we want to, though. Types come after a colon (`:`): -->
書きたいなら型を書くこともできます。型はコロン(`:`)のあとに書きます。

```rust
let x: i32 = 5;
```

<!-- If I asked you to read this out loud to the rest of the class, you’d say “`x` -->
<!-- is a binding with the type `i32` and the value `five`.” -->
これをクラスのみんなに聞こえるように声に出して読むなら、「 `x` は型 `i32` を持つ束縛で、値は `五` である。」となります。

<!-- In this case we chose to represent `x` as a 32-bit signed integer. Rust has -->
<!-- many different primitive integer types. They begin with `i` for signed integers -->
<!-- and `u` for unsigned integers. The possible integer sizes are 8, 16, 32, and 64 -->
<!-- bits. -->
この場合 `x` を32bit符号付き整数として表現することを選びました。
Rustには多くのプリミティブな整数型があります。プリミティブな整数型は符号付き型は `i` 、符号無し型は `u` から始まります。
整数型として可能なサイズは8、16、32、64ビットです。

<!-- In future examples, we may annotate the type in a comment. The examples will -->
<!-- look like this: -->
以後の例では型はコメントで注釈することにします。
先の例はこのようになります。

```rust
fn main() {
    let x = 5; // x: i32
}
```

<!-- Note the similarities between this annotation and the syntax you use with -->
<!-- `let`. Including these kinds of comments is not idiomatic Rust, but we'll -->
<!-- occasionally include them to help you understand what the types that Rust -->
<!-- infers are. -->
この注釈と `let` の時に使う記法の類似性に留意してください。
このようなコメントを書くのはRust的ではありませんが、時折理解の手助けのためにRustが推論する型をコメントで注釈します。

<!-- # Mutability -->
# 可変性
<!-- By default, bindings are *immutable*. This code will not compile: -->
デフォルトで、 束縛は *イミュータブル* です。このコードのコンパイルは通りません。

```rust,ignore
let x = 5;
x = 10;
```

<!-- It will give you this error: -->
次のようなエラーが出ます。

```text
error: re-assignment of immutable variable `x`
     x = 10;
     ^~~~~~~
```

> 訳注:
> ```
> エラー: イミュータブルな変数 `x` に再代入しています
> ```


<!-- If you want a binding to be mutable, you can use `mut`: -->
束縛をミュータブルにしたいなら、`mut`が使えます。

```rust
let mut x = 5; // mut x: i32
x = 10;
```

<!-- There is no single reason that bindings are immutable by default, but we can -->
<!-- think about it through one of Rust’s primary focuses: safety. If you forget to -->
<!-- say `mut`, the compiler will catch it, and let you know that you have mutated -->
<!-- something you may not have intended to mutate. If bindings were mutable by -->
<!-- default, the compiler would not be able to tell you this. If you _did_ intend -->
<!-- mutation, then the solution is quite easy: add `mut`. -->
束縛がデフォルトでイミュータブルであるのは複合的な理由によるものですが、Rustの主要な焦点、安全性の一環だと考えることができます。
もし `mut` を忘れたらコンパイラが捕捉して、変更するつもりでなかったものを変更した旨を教えてくれます。
束縛がデフォルトでミュータブルだったらコンパイラはこれを捕捉できません。
もし _本当に_ 変更を意図していたのなら話は簡単です。 `mut` をつけ加えればいいのです。

<!-- There are other good reasons to avoid mutable state when possible, but they’re -->
<!-- out of the scope of this guide. In general, you can often avoid explicit -->
<!-- mutation, and so it is preferable in Rust. That said, sometimes, mutation is -->
<!-- what you need, so it’s not verboten. -->
可能な時にはミュータブルを避けた方が良い理由は他にもあるのですがそれはこのガイドの範囲を越えています。
一般に、明示的な変更は避けられることが多いのでRustでもそうした方が良いのです。
しかし変更が本当に必要なこともあるという意味で、厳禁という訳ではないのです。

<!-- # Initializing bindings -->
# 束縛を初期化する

<!-- Rust variable bindings have one more aspect that differs from other languages: -->
<!-- bindings are required to be initialized with a value before you're allowed to -->
<!-- use them. -->
Rustの束縛はもう1つ他の言語と異る点があります。束縛を使う前に値で初期化されている必要があるのです。

<!-- Let’s try it out. Change your `src/main.rs` file to look like this: -->
試してみましょう。 `src/main.rs` をいじってこのようにしてみてください。

```rust
fn main() {
    let x: i32;

    println!("Hello world!");
}
```

<!-- You can use `cargo build` on the command line to build it. You’ll get a -->
<!-- warning, but it will still print "Hello, world!": -->
コマンドラインで `cargo build` を使ってビルドできます。
警告が出ますが、それでもまだ「Hello, world!」は表示されます。

```text
   Compiling hello_world v0.0.1 (file:///home/you/projects/hello_world)
src/main.rs:2:9: 2:10 warning: unused variable: `x`, #[warn(unused_variable)]
   on by default
src/main.rs:2     let x: i32;
                      ^
```

<!-- Rust warns us that we never use the variable binding, but since we never use -->
<!-- it, no harm, no foul. Things change if we try to actually use this `x`, -->
<!-- however. Let’s do that. Change your program to look like this: -->
Rustは一度も使われない変数について警告を出しますが、一度も使われないので人畜無害です。
ところがこの `x` を使おうとすると事は一変します。やってみましょう。
プログラムをこのように変更してください。

```rust,ignore
fn main() {
    let x: i32;

    println!("The value of x is: {}", x);
}
```

<!-- And try to build it. You’ll get an error: -->
そしてビルドしてみてください。このようなエラーが出るはずです。

```bash
$ cargo build
   Compiling hello_world v0.0.1 (file:///home/you/projects/hello_world)
src/main.rs:4:39: 4:40 error: use of possibly uninitialized variable: `x`
src/main.rs:4     println!("The value of x is: {}", x);
                                                    ^
note: in expansion of format_args!
<std macros>:2:23: 2:77 note: expansion site
<std macros>:1:1: 3:2 note: in expansion of println!
src/main.rs:4:5: 4:42 note: expansion site
error: aborting due to previous error
Could not compile `hello_world`.
```

<!-- Rust will not let us use a value that has not been initialized. Next, let’s -->
<!-- talk about this stuff we've added to `println!`. -->
Rustでは未初期化の値を使うことは許されていません。
次に、 `println!` に追加したものについて話しましょう。

<!-- If you include two curly braces (`{}`, some call them moustaches...) in your -->
<!-- string to print, Rust will interpret this as a request to interpolate some sort -->
<!-- of value. *String interpolation* is a computer science term that means "stick -->
<!-- in the middle of a string." We add a comma, and then `x`, to indicate that we -->
<!-- want `x` to be the value we’re interpolating. The comma is used to separate -->
<!-- arguments we pass to functions and macros, if you’re passing more than one. -->
表示する文字列に2つの波括弧(`{}`、口髭という人もいます…(訳注: 海外の顔文字は横になっているので首を傾けて `{` を眺めてみてください。また、日本語だと「中括弧」と呼ぶ人もいますね))を入れました。
Rustはこれを、何かの値で補間(interpolate)してほしいのだと解釈します。
*文字列補間* (string interpolation)はコンピュータサイエンスの用語で、「文字列の間に差し込む」という意味です。
その後に続けてカンマ、そして `x` を置いて、 `x` が補間に使う値だと指示しています。
カンマは2つ以上の引数を関数やマクロに渡す時に使われます。

<!-- When you use the curly braces, Rust will attempt to display the value in a -->
<!-- meaningful way by checking out its type. If you want to specify the format in a -->
<!-- more detailed manner, there are a [wide number of options available][format]. -->
<!-- For now, we'll stick to the default: integers aren't very complicated to -->
<!-- print. -->
波括弧を使うと、Rustは補間に使う値の型を調べて意味のある方法で表示しようとします。
フォーマットをさらに詳しく指定したいなら[数多くのオプションが利用できます][format]。
とりあえずのところ、デフォルトに従いましょう。整数の表示はそれほど複雑ではありません。

[format]: ../std/fmt/index.html

<!-- # Scope and shadowing -->
# スコープとシャドーイング

<!-- Let’s get back to bindings. Variable bindings have a scope - they are -->
<!-- constrained to live in a block they were defined in. A block is a collection -->
<!-- of statements enclosed by `{` and `}`. Function definitions are also blocks! -->
<!-- In the following example we define two variable bindings, `x` and `y`, which -->
<!-- live in different blocks. `x` can be accessed from inside the `fn main() {}` -->
<!-- block, while `y` can be accessed only from inside the inner block: -->
束縛に話を戻しましょう。変数束縛にはスコープがあります。変数束縛は定義されたブロック内でしか有効でありません。
ブロックは `{` と `}` に囲まれた文の集まりです。関数定義もブロックです!
以下の例では異なるブロックで有効な2つの変数束縛、 `x` と `y` を定義しています。
`x` は `fn main() {}` ブロックの中でアクセス可能ですが、 `y` は内側のブロックからのみアクセスできます。


```rust,ignore
fn main() {
    let x: i32 = 17;
    {
        let y: i32 = 3;
        println!("The value of x is {} and value of y is {}", x, y);
    }
# //    println!("The value of x is {} and value of y is {}", x, y); // This won't work
    println!("The value of x is {} and value of y is {}", x, y); // これは動きません
}
```

<!-- The first `println!` would print "The value of x is 17 and the value of y is -->
<!-- 3", but this example cannot be compiled successfully, because the second -->
<!-- `println!` cannot access the value of `y`, since it is not in scope anymore. -->
<!-- Instead we get this error: -->
最初の `println!` は「The value of x is 17 and the value of y is 3」(訳注: 「xの値は17でyの値は3」)と表示するはずですが、
2つめの `println!` は `y` がもうスコープにいないため `y` にアクセスできないのでこの例はコンパイルできません。
代わりに以下のようなエラーが出ます。

```bash
$ cargo build
   Compiling hello v0.1.0 (file:///home/you/projects/hello_world)
main.rs:7:62: 7:63 error: unresolved name `y`. Did you mean `x`? [E0425]
main.rs:7     println!("The value of x is {} and value of y is {}", x, y); // これは動きません
                                                                       ^
note: in expansion of format_args!
<std macros>:2:25: 2:56 note: expansion site
<std macros>:1:1: 2:62 note: in expansion of print!
<std macros>:3:1: 3:54 note: expansion site
<std macros>:1:1: 3:58 note: in expansion of println!
main.rs:7:5: 7:65 note: expansion site
main.rs:7:62: 7:63 help: run `rustc --explain E0425` to see a detailed explanation
error: aborting due to previous error
Could not compile `hello`.

To learn more, run the command again with --verbose.
```

<!-- Additionally, variable bindings can be shadowed. This means that a later -->
<!-- variable binding with the same name as another binding, that's currently in -->
<!-- scope, will override the previous binding. -->
さらに加えて、変数束縛は覆い隠すことができます(訳注: このことをシャドーイングと言います)。
つまり後に出てくる同じ名前の変数束縛があるとそれがスコープに入り、以前の束縛を上書きするのです。

```rust
let x: i32 = 8;
{
# //    println!("{}", x); // Prints "8"
    println!("{}", x); // "8"を表示する
    let x = 12;
# //    println!("{}", x); // Prints "12"
    println!("{}", x); // "12"を表示する
}
# // println!("{}", x); // Prints "8"
println!("{}", x); // "8"を表示する
let x =  42;
# // println!("{}", x); // Prints "42"
println!("{}", x); // "42"を表示する
```

<!-- Shadowing and mutable bindings may appear as two sides of the same coin, but -->
<!-- they are two distinct concepts that can't always be used interchangeably. For -->
<!-- one, shadowing enables us to rebind a name to a value of a different type. It -->
<!-- is also possible to change the mutability of a binding. -->
シャドーイングとミュータブルな束縛はコインの表と裏のように見えるかもしれませんが、それぞれ独立な概念であり互いに代用ができないケースがあります。
その1つにシャドーイングは同じ名前に違う型の値を再束縛することができます。

```rust
let mut x: i32 = 1;
x = 7;
# // let x = x; // x is now immutable and is bound to 7
let x = x; // xはイミュータブルになって7に束縛されました

let y = 4;
# // let y = "I can also be bound to text!"; // y is now of a different type
let y = "I can also be bound to text!"; // yは違う型になりました
```
