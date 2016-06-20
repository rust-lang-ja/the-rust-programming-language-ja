% 数当てゲーム
<!-- % Guessing Game -->

<!-- Let’s learn some Rust! For our first project, we’ll implement a classic -->
<!-- beginner programming problem: the guessing game. Here’s how it works: Our -->
<!-- program will generate a random integer between one and a hundred. It will then -->
<!-- prompt us to enter a guess. Upon entering our guess, it will tell us if we’re -->
<!-- too low or too high. Once we guess correctly, it will congratulate us. Sounds -->
<!-- good? -->
<!-- 訳注："For our first project" となっていますが、プロジェクトはこれ１つだけなので、「このプロジェクトでは」としました。 -->
Rustの学習を始めましょう。
このプロジェクトでは、古典的な初心者向けのプログラミングの問題、数当てゲームを実装します。
これは次のように動作します。
プログラムは1から100までの数字を1つ、ランダムに生成します。
そしてあなたに、数字を予想して入力するよう促します。
予想値を入力すると、大きすぎる、あるいは、小さすぎるといったヒントを出します。
当たったら、おめでとうと言ってくれます。良さそうですか？

<!-- Along the way, we’ll learn a little bit about Rust. The next chapter, ‘Syntax -->
<!-- and Semantics’, will dive deeper into each part. -->
この章を通じて、Rust に関するごく基本なことが学べるでしょう。
次の章「シンタックスとセマンティクス」では、それぞれのパートについて、より深く学んでいきます。

<!-- # Set up -->
# セットアップ

<!-- Let’s set up a new project. Go to your projects directory. Remember how we had -->
<!-- to create our directory structure and a `Cargo.toml` for `hello_world`? Cargo -->
<!-- has a command that does that for us. Let’s give it a shot: -->
新しいプロジェクトを作りましょう。プロジェクトのディレクトリへ行ってください。
`hello_world` の時にどのようなディレクトリ構成で、どのように `Cargo.toml` を作る必要があったか覚えてますか？
Cargoにはそれらのことをしてくれるコマンドがあるのでした。やってみましょう。

```bash
$ cd ~/projects
$ cargo new guessing_game --bin
$ cd guessing_game
```

<!-- We pass the name of our project to `cargo new`, and then the `--bin` flag, -->
<!-- since we’re making a binary, rather than a library. -->
`cargo new` にプロジェクトの名前と、そしてライブラリではなくバイナリを作るので `--bin` フラグを渡します。

<!-- Check out the generated `Cargo.toml`: -->
生成された `Cargo.toml` を確認しましょう。

```toml
[package]

name = "guessing_game"
version = "0.1.0"
authors = ["あなたの名前 <you@example.com>"]
```

<!-- Cargo gets this information from your environment. If it’s not correct, go ahead -->
<!-- and fix that. -->
Cargoはこれらの情報を環境から取得します。もし間違っていたら、どうぞ修正してください。


<!-- Finally, Cargo generated a ‘Hello, world!’ for us. Check out `src/main.rs`: -->
最後に、Cargoは「Hello, world!」を生成します。 `src/main.rs` を確認しましょう。


```rust
fn main() {
    println!("Hello, world!");
}
```

<!-- Let’s try compiling what Cargo gave us: -->
Cargoが用意したものをコンパイルしてみましょう。


```{bash}
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
```

<!-- Excellent! Open up your `src/main.rs` again. We’ll be writing all of -->
<!-- our code in this file. -->
素晴らしい。もう一度 `src/main.rs` を開きましょう。全てのコードをこの中に書いていきます。


<!-- Before we move on, let me show you one more Cargo command: `run`. `cargo run` -->
<!-- is kind of like `cargo build`, but it also then runs the produced executable. -->
<!-- Try it out: -->
先に進む前に、Cargoのコマンドをもう1つ紹介させてください。 `run` です。
`cargo run` は `cargo build` のようなものですが、生成した実行可能ファイルを走らせてくれます。
試してみましょう。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/debug/guessing_game`
Hello, world!
```

<!-- Great! The `run` command comes in handy when you need to rapidly iterate on a -->
<!-- project. Our game is such a project, we need to quickly test each -->
<!-- iteration before moving on to the next one. -->
いい感じです。
`run` コマンドはプロジェクトを細かく回す必要があるときに便利でしょう。
今回のゲームがまさにそのようなプロジェクトです。すぐに試してから次の行動に移るといったことを繰り返していきます。

<!-- # Processing a Guess -->
# 予想値を処理する

<!-- Let’s get to it! The first thing we need to do for our guessing game is -->
<!-- allow our player to input a guess. Put this in your `src/main.rs`: -->
では作り始めましょう。
数当てゲームで最初にしないといけないのは、プレイヤーに予想値を入力させることです。
これを `src/main.rs` に書きましょう。

```rust,no_run
use std::io;

fn main() {
    println!("Guess the number!");

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");

    println!("You guessed: {}", guess);
}
```

> [訳注] それぞれの文言は
>
> * Guess the number!: 数字を当ててみて！
> * Please input your guess.: 予想値を入力してください
> * Failed to read line: 行の読み取りに失敗しました
> * You guessed: {}: あなたの予想値: {}
>
> の意味ですが、エディタの設定などによっては、ソースコード中に日本語を使うとコンパイルできないことがあるので、英文のままにしてあります。

<!-- There’s a lot here! Let’s go over it, bit by bit. -->
いろいろと出てきましたね。順に見ていきましょう。

```rust,ignore
use std::io;
```

<!-- We’ll need to take user input, and then print the result as output. As such, we -->
<!-- need the `io` library from the standard library. Rust only imports a few things -->
<!-- by default into every program, [the ‘prelude’][prelude]. If it’s not in the -->
<!-- prelude, you’ll have to `use` it directly. There is also a second ‘prelude’, the -->
<!-- [`io` prelude][ioprelude], which serves a similar function: you import it, and it -->
<!-- imports a number of useful, `io`-related things. -->
これからユーザの入力を取得して、結果を出力するわけですが、それには、標準ライブラリの中にある `io` ライブラリが必要です。
Rustは全てのプログラムに、ごく限られたものをデフォルトでインポートしますが、これを[「プレリュード」][prelude]と呼びます。
プレリュードにないものは、直接 `use` する必要があります。
なお、2つ目の「プレリュード」、[`io` プレリュード][ioprelude]もあり、もしそれをインポートすると、 `io` に関連した多数の有用なものがインポートされます。

[prelude]: ../std/prelude/index.html
[ioprelude]: ../std/io/prelude/index.html

```rust,ignore
fn main() {
```

<!-- As you’ve seen before, the `main()` function is the entry point into your -->
<!-- program. The `fn` syntax declares a new function, the `()`s indicate that -->
<!-- there are no arguments, and `{` starts the body of the function. Because -->
<!-- we didn’t include a return type, it’s assumed to be `()`, an empty -->
<!-- [tuple][tuples]. -->
すでに見てきたように `main()` 関数がプログラムのエントリーポイントになります。
`fn` 構文は新たな関数を宣言し、 `()` で引数がないことを示し、 `{` が関数本体の始まりです。
返り値の型は書かなかったので、 `()` 、つまり空の[タプル][tuples]として扱われます。


[tuples]: primitive-types.html#tuples

```rust,ignore
    println!("Guess the number!");

    println!("Please input your guess.");
```

<!-- We previously learned that `println!()` is a [macro][macros] that -->
<!-- prints a [string][strings] to the screen. -->
前に `println!()` が[文字列][strings]をスクリーンに表示する[マクロ][macros]であることを学びました。

[macros]: macros.html
[strings]: strings.html

```rust,ignore
    let mut guess = String::new();
```

<!-- Now we’re getting interesting! There’s a lot going on in this little line. -->
<!-- The first thing to notice is that this is a [let statement][let], which is -->
<!-- used to create ‘variable bindings’. They take this form: -->
少し興味深いものが出てきました。このわずか1行で、様々なことが起こっています。
最初に気付くのは、これが「変数束縛」を作る[let文][let]であることです。
let文は以下の形を取ります。


```rust,ignore
let foo = bar;
```

[let]: variable-bindings.html

<!-- This will create a new binding named `foo`, and bind it to the value `bar`. In -->
<!-- many languages, this is called a ‘variable’, but Rust’s variable bindings have -->
<!-- a few tricks up their sleeves. -->
これは `foo` という名前の束縛を作り、それを値 `bar` に束縛します。
多くの言語ではこれを「変数」と呼びますが、Rustの変数束縛は少しばかり皮を被せてあります。

<!-- For example, they’re [immutable][immutable] by default. That’s why our example -->
<!-- uses `mut`: it makes a binding mutable, rather than immutable. `let` doesn’t -->
<!-- take a name on the left hand side of the assignment, it actually accepts a -->
<!-- ‘[pattern][patterns]’. We’ll use patterns later. It’s easy enough -->
<!-- to use for now: -->
例えば、束縛はデフォルトで[イミュータブル][immutable] (不変)です。
ですから、この例ではイミュータブルではなく、ミュータブル(可変)な束縛にするために `mut` を使っているのです。
`let` は代入の左辺に単に１つの名前を取るのではなく、実際には[パターン][patterns]を受け取ります。
パターンは後ほど使います。今のところ、すごく簡単ですね。

```rust
# // let foo = 5; // immutable.
let foo = 5; // イミュータブル
# // let mut bar = 5; // mutable
let mut bar = 5; // ミュータブル
```

[immutable]: mutability.html
[patterns]: patterns.html

<!-- Oh, and `//` will start a comment, until the end of the line. Rust ignores -->
<!-- everything in [comments][comments]. -->
ああ、そして `//` から行末までがコメントです。Rustは[コメント][comments]にある全てのものを無視します。

[comments]: comments.html

<!-- So now we know that `let mut guess` will introduce a mutable binding named -->
<!-- `guess`, but we have to look at the other side of the `=` for what it’s -->
<!-- bound to: `String::new()`. -->
このように `let mut guess` がミュータブルな束縛 `guess` を導入することを知りました。
しかし `=` の反対側、 `String::new()` が何であるかを見る必要があります。

<!-- `String` is a string type, provided by the standard library. A -->
<!-- [`String`][string] is a growable, UTF-8 encoded bit of text. -->
`String` は文字列型で、標準ライブラリで提供されています。
[`String`][string]は伸長可能でUTF-8でエンコードされたテキスト片です。

[string]: ../std/string/struct.String.html

<!-- The `::new()` syntax uses `::` because this is an ‘associated function’ of -->
<!-- a particular type. That is to say, it’s associated with `String` itself, -->
<!-- rather than a particular instance of a `String`. Some languages call this a -->
<!-- ‘static method’. -->
`::new()` という構文ですが、これは特定の型に紐づく「関連関数」なので `::` を使っています。
つまりこれは、 `String` のインスタンスではなく、 `String` 自体に関連付けられているということです。
これを「スタティックメソッド」と呼ぶ言語もあります。

<!-- This function is named `new()`, because it creates a new, empty `String`. -->
<!-- You’ll find a `new()` function on many types, as it’s a common name for making -->
<!-- a new value of some kind. -->
この関数は新たな空の `String` を作るので、 `new()` と名付けられています。
`new()` 関数はある種の新たな値を作るのによく使われる名前なので、様々な型でこの関数を見るでしょう。

<!-- Let’s move forward: -->
次に進みましょう。

```rust,ignore
    io::stdin().read_line(&mut guess)
        .expect("Failed to read line");
```

<!-- That’s a lot more! Let’s go bit-by-bit. The first line has two parts. Here’s -->
<!-- the first: -->
いろいろ出てきました。少しずつ確認していきましょう。最初の行は2つの部分で構成されます。
これが最初の部分です。

```rust,ignore
io::stdin()
```

<!-- Remember how we `use`d `std::io` on the first line of the program? We’re now -->
<!-- calling an associated function on it. If we didn’t `use std::io`, we could -->
<!-- have written this line as `std::io::stdin()`. -->
プログラムの最初の行でどのように `std::io` を `use` したか覚えていますか？
ここでは、その関連関数を呼び出しているのです。
もし `use std::io` としなかったなら、 `std::io::stdin()` と書くことになります。

<!-- This particular function returns a handle to the standard input for your -->
<!-- terminal. More specifically, a [std::io::Stdin][iostdin]. -->
この関数はターミナルの標準入力へのハンドルを返します。詳しくは [std::io::Stdin][iostdin] を見てください。

[iostdin]: ../std/io/struct.Stdin.html

<!-- The next part will use this handle to get input from the user: -->
次の部分では、ハンドルを使ってユーザからの入力を取得します。

```rust,ignore
.read_line(&mut guess)
```

<!-- Here, we call the [`read_line()`][read_line] method on our handle. -->
<!-- [Methods][method] are like associated functions, but are only available on a -->
<!-- particular instance of a type, rather than the type itself. We’re also passing -->
<!-- one argument to `read_line()`: `&mut guess`. -->
ここで、ハンドルに対して[`read_line()`][read_line]メソッドを呼んでいます。
[メソッド][method]は関連関数のようなものですが、型自体ではなくインスタンスに対してだけ使えます。
`read_line()` に引数を1つ渡してます。 `&mut guess` です。

[read_line]: ../std/io/struct.Stdin.html#method.read_line
[method]: method-syntax.html

<!-- Remember how we bound `guess` above? We said it was mutable. However, -->
<!-- `read_line` doesn’t take a `String` as an argument: it takes a `&mut String`. -->
<!-- Rust has a feature called ‘[references][references]’, which allows you to have -->
<!-- multiple references to one piece of data, which can reduce copying. References -->
<!-- are a complex feature, as one of Rust’s major selling points is how safe and -->
<!-- easy it is to use references. We don’t need to know a lot of those details to -->
<!-- finish our program right now, though. For now, all we need to know is that -->
<!-- like `let` bindings, references are immutable by default. Hence, we need to -->
<!-- write `&mut guess`, rather than `&guess`. -->
`guess` がどのように束縛されたか覚えてますか？ ミュータブルであると言いました。
しかしながら、 `read_line` は `String` を引数に取りません。 `&mut String` を取るのです。
Rustには[参照][references]と呼ばれる機能があり、1つのデータに対して複数の参照を持つことができます。
これにより、値をコピーする機会を減らせます。
Rustの主要な売りの1つが、参照をいかに安全に簡単に使えるかなので、参照は複雑な機能です。
しかしこのプログラムを作り終えるのに、今すぐ詳細を知る必要はありません。
今のところ `let` と同じように、参照はデフォルトでイミュータブルであるということだけ覚えておいてください。
なので `&guess` ではなく `&mut guess` と書く必要があるのです。

<!-- Why does `read_line()` take a mutable reference to a string? Its job is -->
<!-- to take what the user types into standard input, and place that into a -->
<!-- string. So it takes that string as an argument, and in order to add -->
<!-- the input, it needs to be mutable. -->
なぜ `read_line()` は文字列へのミュータブルな参照を取るのでしょうか？
`read_line()` はユーザが標準入力に打ったものを取得し、それを文字列に格納します。
ですから、格納先の文字列を引数として受け取り、そこに入力文字列を追加するために、ミュータブルであることが求められるのです。

[references]: references-and-borrowing.html

<!-- But we’re not quite done with this line of code, though. While it’s -->
<!-- a single line of text, it’s only the first part of the single logical line of -->
<!-- code: -->
しかし、この行はまだ終わっていません。テキスト上では1行ですが、コードの論理行の1部でしかないのです。

```rust,ignore
        .expect("Failed to read line");
```

<!-- When you call a method with the `.foo()` syntax, you may introduce a newline -->
<!-- and other whitespace. This helps you split up long lines. We _could_ have -->
<!-- done: -->
メソッドを `.foo()` 構文で呼び出す時、改行してスペースを入れても構いません。
そうすることで長い行を分割できます。
こうすることだって _できました_

```rust,ignore
    io::stdin().read_line(&mut guess).expect("failed to read line");
```

<!-- But that gets hard to read. So we’ve split it up, two lines for two method -->
<!-- calls. We already talked about `read_line()`, but what about `expect()`? Well, -->
<!-- we already mentioned that `read_line()` puts what the user types into the `&mut` -->
<!-- `String` we pass it. But it also returns a value: in this case, an -->
<!-- [`io::Result`][ioresult]. Rust has a number of types named `Result` in its -->
<!-- standard library: a generic [`Result`][result], and then specific versions for -->
<!-- sub-libraries, like `io::Result`. -->
ですがこれだと読み辛いです。そこで2つのメソッド呼び出しを、2つの行に分割したわけです。
さて `read_line()` については話しましたが、 `expect()` は何でしょうか？
実は、`read_line()` は引数として渡した `&mut String` にユーザの入力を入れるだけでなく、[`io::Result`][ioresult] という値も返すのです。
標準ライブラリには `Result` という名の付く型がいくつもあります。
まず汎用の[`Result`][result]があって、さらに個々のライブラリに特殊化されたバージョンもあり、`io::Result` もその１つです。

[ioresult]: ../std/io/type.Result.html
[result]: ../std/result/enum.Result.html

<!-- The purpose of these `Result` types is to encode error handling information. -->
<!-- Values of the `Result` type, like any type, have methods defined on them. In -->
<!-- this case, `io::Result` has an [`expect()` method][expect] that takes a value -->
<!-- it’s called on, and if it isn’t a successful one, [`panic!`][panic]s with a -->
<!-- message you passed it. A `panic!` like this will cause our program to crash, -->
<!-- displaying the message. -->
これらの `Result` 型の目的は、エラーハンドリング情報をエンコードすることです。
`Result` 型の値には、他の型と同じように、メソッドが定義されています。
今回の場合 `io::Result` に[`expect()`メソッド][expect]が定義されており、それは、呼び出された値が成功を表すものでなければ、与えたメッセージと共に[`panic!`][panic]します。
`panic!` は、メッセージを表示してプログラムをクラッシュさせます。

[expect]: ../std/result/enum.Result.html#method.expect
[panic]: error-handling.html

<!-- If we leave off calling this method, our program will compile, but -->
<!-- we’ll get a warning: -->
このメソッドを呼び出さずにいると、プログラムはコンパイルできますが、警告が出ます。

```bash
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
src/main.rs:10:5: 10:39 warning: unused result which must be used,
#[warn(unused_must_use)] on by default
src/main.rs:10     io::stdin().read_line(&mut guess);
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

<!-- Rust warns us that we haven’t used the `Result` value. This warning comes from -->
<!-- a special annotation that `io::Result` has. Rust is trying to tell you that -->
<!-- you haven’t handled a possible error. The right way to suppress the error is -->
<!-- to actually write error handling. Luckily, if we want to crash if there’s -->
<!-- a problem, we can use `expect()`. If we can recover from the -->
<!-- error somehow, we’d do something else, but we’ll save that for a future -->
<!-- project. -->
Rustは `Result` 値を使っていないことを警告します。警告は `io::Result` が持つ特別なアノテーションに由来します。
Rustはエラーの可能性があるのに、処理していないことを教えてくれるのです。
警告を出さないためには、実際にエラー処理を書くのが正しやり方です。
幸運にも、問題があった時にそのままクラッシュさせたいなら、`expect()` が使えます。
どうにかしてエラーから回復したいなら、別のことをしないといけません。
しかしそれは、将来のプロジェクトに取っておきましょう。

<!-- There’s only one line of this first example left: -->
最初の例も残すところあと1行です。


```rust,ignore
    println!("You guessed: {}", guess);
}
```

<!-- This prints out the string we saved our input in. The `{}`s are a placeholder, -->
<!-- and so we pass it `guess` as an argument. If we had multiple `{}`s, we would -->
<!-- pass multiple arguments: -->
これは入力を保持している文字列を表示します。 `{}` はプレースホルダで、引数として `guess` を渡しています。
複数の `{}` があれば、複数を引数を渡すことになります。

```rust
let x = 5;
let y = 10;

println!("x and y: {} and {}", x, y);
```

<!-- Easy. -->
簡単ですね。

<!-- Anyway, that’s the tour. We can run what we have with `cargo run`: -->
いずれにせよ、一巡り終えました。これまでのものを `cargo run` で実行できます。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/debug/guessing_game`
Guess the number!
Please input your guess.
6
You guessed: 6
```

<!-- All right! Our first part is done: we can get input from the keyboard, -->
<!-- and then print it back out. -->
これでよし！ 最初の部分は終わりました。キーボードからの入力を取得して、出力を返すところまでできました。

<!-- # Generating a secret number -->
# 秘密の数を生成する

<!-- Next, we need to generate a secret number. Rust does not yet include random -->
<!-- number functionality in its standard library. The Rust team does, however, -->
<!-- provide a [`rand` crate][randcrate]. A ‘crate’ is a package of Rust code. -->
<!-- We’ve been building a ‘binary crate’, which is an executable. `rand` is a -->
<!-- ‘library crate’, which contains code that’s intended to be used with other -->
<!-- programs. -->
次に秘密の数を生成しましょう。Rustの標準ライブラリには乱数の機能がまだありません。
ですが、Rustチームは[`rand` クレート][randcrate]を提供しています。
「クレート」はRustのコードをパッケージ化したものです。今まで作ってきたのは、実行可能な「バイナリクレート」です。
`rand` は「ライブラリクレート」で、他のプログラムから使われることを意図したコードが入っています。

[randcrate]: https://crates.io/crates/rand

<!-- Using external crates is where Cargo really shines. Before we can write -->
<!-- the code using `rand`, we need to modify our `Cargo.toml`. Open it up, and -->
<!-- add these few lines at the bottom: -->
外部のクレートを使う時にこそ、Cargoが活きてきます。 `rand` を使う前に `Cargo.toml` を修正する必要があります。
`Cargo.toml` を開いて、その末尾に以下の行を追加しましょう。

```toml
[dependencies]

rand="0.3.0"
```

<!-- The `[dependencies]` section of `Cargo.toml` is like the `[package]` section: -->
<!-- everything that follows it is part of it, until the next section starts. -->
<!-- Cargo uses the dependencies section to know what dependencies on external -->
<!-- crates you have, and what versions you require. In this case, we’ve specified version `0.3.0`, -->
<!-- which Cargo understands to be any release that’s compatible with this specific version. -->
<!-- Cargo understands [Semantic Versioning][semver], which is a standard for writing version -->
<!-- numbers. A bare number like above is actually shorthand for `^0.3.0`, -->
<!-- meaning "anything compatible with 0.3.0". -->
<!-- If we wanted to use only `0.3.0` exactly, we could say `rand="=0.3.0"` -->
<!-- (note the two equal signs). -->
<!-- And if we wanted to use the latest version we could use `*`. -->
<!-- We could also use a range of versions. -->
<!-- [Cargo’s documentation][cargodoc] contains more details. -->
`Cargo.toml` の `[dependencies]` (依存)セクションは `[package]` セクションに似ています。
後続の行は、次のセクションが始まるまでそのセクションに属します。
Cargoはどの外部クレートのどのバージョンに依存するのかの情報を取得するのに、dependenciesセクションを使います。
今回のケースではバージョン`0.3.0`を指定していますが、Cargoは指定されたバージョンと互換性のあるバージョンだと解釈します。
Cargoはバージョン記述の標準、[セマンティックバージョニング][semver]を理解します。
上記のように、単にバージョンを書くのは、実は `^0.3.0` の略記になっており、「0.3.0と互換性のあるもの」という意味になります。
もし正確に `0.3.0` だけを使いたいなら `rand="=0.3.0"` (等号が2つあることに注意してください)と書きます。
さらに最新版を使いたいなら `*` を使います。また、バージョンの範囲を使うこともできます。
[Cargoのドキュメント][cargodoc]に、さらなる詳細があります。

[semver]: http://semver.org
[cargodoc]: http://doc.crates.io/crates-io.html

<!-- Now, without changing any of our code, let’s build our project: -->
さて、コードは変更せずにプロジェクトをビルドしてみましょう。

```bash
$ cargo build
    Updating registry `https://github.com/rust-lang/crates.io-index`
 Downloading rand v0.3.8
 Downloading libc v0.1.6
   Compiling libc v0.1.6
   Compiling rand v0.3.8
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
```

<!-- (You may see different versions, of course.) -->
(もちろん、別のバージョンが表示される可能性もあります)

<!-- Lots of new output! Now that we have an external dependency, Cargo fetches the -->
<!-- latest versions of everything from the registry, which is a copy of data from -->
<!-- [Crates.io][cratesio]. Crates.io is where people in the Rust ecosystem -->
<!-- post their open source Rust projects for others to use. -->
いろいろと新しい出力がありました。
外部依存ができたので、Cargoはそれぞれの最新版についての情報を、レジストリという、[Crates.io][cratesio]からコピーしたデータから取得します。
Crates.ioは、Rustのエコシステムに参加している人たちが、オープンソースのRustプロジェクトを投稿し、共有するための場所です。

[cratesio]: https://crates.io

<!-- After updating the registry, Cargo checks our `[dependencies]` and downloads -->
<!-- any we don’t have yet. In this case, while we only said we wanted to depend on -->
<!-- `rand`, we’ve also grabbed a copy of `libc`. This is because `rand` depends on -->
<!-- `libc` to work. After downloading them, it compiles them, and then compiles -->
<!-- our project. -->
レジストリをアップデートした後に、Cargoは `[dependencies]` を確認し、まだ手元にないものがあればダウンロードします。
今回のケースでは `rand` に依存するとだけ書きましたが、 `libc` も取得されています。これは `rand` が動作するのに `libc` に依存するためです。
ダウンロードが終わったら、それらをコンパイルし、続いてプロジェクトをコンパイルします。

<!-- If we run `cargo build` again, we’ll get different output: -->
もう一度 `cargo build` を走らせると、異なった出力になります。

```bash
$ cargo build
```

<!-- That’s right, no output! Cargo knows that our project has been built, and that -->
<!-- all of its dependencies are built, and so there’s no reason to do all that -->
<!-- stuff. With nothing to do, it simply exits. If we open up `src/main.rs` again, -->
<!-- make a trivial change, and then save it again, we’ll only see one line: -->
そうです、何も出力されないのです。
Cargoはプロジェクトがビルドされていて、依存もビルドされていることを知っているので、それらを繰り返さないのです。
何もすることがなければそのまま終了します。もし `src/main.rs` を少し変更して保存したら、次のように表示されます。

```bash
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
```

<!-- So, we told Cargo we wanted any `0.3.x` version of `rand`, and so it fetched the latest -->
<!-- version at the time this was written, `v0.3.8`. But what happens when next -->
<!-- week, version `v0.3.9` comes out, with an important bugfix? While getting -->
<!-- bugfixes is important, what if `0.3.9` contains a regression that breaks our -->
<!-- code? -->
Cargoには `rand` の `0.3.x` を使うと伝えたので、執筆時点の最新版 `v0.3.8` を取得しました。
ですがもし来週 `v0.3.9` が出て、重要なバグがフィクスされたらどうなるのでしょう？
バグフィクスを取り込むのは重要ですが、 `0.3.9` にコードが動かなくなるようなリグレッションがあったらどうしましょう？

<!-- The answer to this problem is the `Cargo.lock` file you’ll now find in your -->
<!-- project directory. When you build your project for the first time, Cargo -->
<!-- figures out all of the versions that fit your criteria, and then writes them -->
<!-- to the `Cargo.lock` file. When you build your project in the future, Cargo -->
<!-- will see that the `Cargo.lock` file exists, and then use that specific version -->
<!-- rather than do all the work of figuring out versions again. This lets you -->
<!-- have a repeatable build automatically. In other words, we’ll stay at `0.3.8` -->
<!-- until we explicitly upgrade, and so will anyone who we share our code with, -->
<!-- thanks to the lock file. -->
この問題への答えは、プロジェクトのディレクトリにある `Cargo.lock` です。
プロジェクトを最初にビルドした時に、Cargoは基準を満たす全てのバージョンを探索し、 `Cargo.lock` ファイルに書き出します。
その後のビルドでは、Cargoはまず `Cargo.lock` ファイルがあるか確認し、再度バージョンを探索することなく、そこで指定されたバージョンを使います。
これで自動的に再現性のあるビルドが手に入ります。
言い換えると、明示的にアップグレードしない限り、私たちは `0.3.8` を使い続けますし、ロックファイルのおかげで、コードを共有する人たちも `0.3.8` を使い続けます。

<!-- What about when we _do_ want to use `v0.3.9`? Cargo has another command, -->
<!-- `update`, which says ‘ignore the lock, figure out all the latest versions that -->
<!-- fit what we’ve specified. If that works, write those versions out to the lock -->
<!-- file’. But, by default, Cargo will only look for versions larger than `0.3.0` -->
<!-- and smaller than `0.4.0`. If we want to move to `0.4.x`, we’d have to update -->
<!-- the `Cargo.toml` directly. When we do, the next time we `cargo build`, Cargo -->
<!-- will update the index and re-evaluate our `rand` requirements. -->
では `v0.3.9` を _使いたい_ 時はどうすればいいのでしょうか？
Cargoには別のコマンド `update` があり、次のことを意味します：「ロックを無視して、指定したバージョンを満たす全ての最新版を探しなさい。それに成功したら、ロックファイルに書きなさい」
しかし、デフォルトではCargoは `0.3.0` より大きく、 `0.4.0` より小さいバージョンを探しにいきます。
`0.4.x` より大きなバージョンを使いたいなら直接 `Cargo.toml` を更新する必要があります。
そうしたら、次に `cargo build` をする時に、Cargoはインデックスをアップデートして、`rand` の要件を再評価します。

<!-- There’s a lot more to say about [Cargo][doccargo] and [its -->
<!-- ecosystem][doccratesio], but for now, that’s all we need to know. Cargo makes -->
<!-- it really easy to re-use libraries, and so Rustaceans tend to write smaller -->
<!-- projects which are assembled out of a number of sub-packages. -->
[Cargo][doccargo]と[そのエコシステム][doccratesio]については、説明することがまだ色々あるのですが、今のところは、これらのことだけを知っておけば十分です。
Cargoのおかげでライブラリの再利用は本当に簡単になりますし、Rustaceanは他のパッケージをいくつも使った小さなライブラリをよく書きます。

[doccargo]: http://doc.crates.io
[doccratesio]: http://doc.crates.io/crates-io.html

<!-- Let’s get on to actually _using_ `rand`. Here’s our next step: -->
`rand` を実際に _使う_ ところに進みましょう。次のステップはこれです。

```rust,ignore
extern crate rand;

use std::io;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("failed to read line");

    println!("You guessed: {}", guess);
}

```

> 訳注:
>
> * The secret number is: {}: 秘密の数字は: {}です

<!-- The first thing we’ve done is change the first line. It now says -->
<!-- `extern crate rand`. Because we declared `rand` in our `[dependencies]`, we -->
<!-- can use `extern crate` to let Rust know we’ll be making use of it. This also -->
<!-- does the equivalent of a `use rand;` as well, so we can make use of anything -->
<!-- in the `rand` crate by prefixing it with `rand::`. -->
1つ目の変更は最初の行です。 `extern crate rand` としました。
`rand` を `[dependencies]` に宣言したので、 `extern crate` でそれを使うことをRustに伝えています。
これはまた、 `use rand;` と同じこともしますので、 `rand` にあるものは `rand::` と前置すれば使えるようになります。

<!-- Next, we added another `use` line: `use rand::Rng`. We’re going to use a -->
<!-- method in a moment, and it requires that `Rng` be in scope to work. The basic -->
<!-- idea is this: methods are defined on something called ‘traits’, and for the -->
<!-- method to work, it needs the trait to be in scope. For more about the -->
<!-- details, read the [traits][traits] section. -->
次にもう1行 `use` を追加しました。 `use rand::Rng` です。
この後すぐ、あるメソッドを使うのですが、それが動作するには `Rng` をスコープに入れる必要があるのです。
基本的な考え方は次の通りです。このメソッドは「トレイト」と呼ばれるもので定義されており、動作させるために、該当するトレイトをスコープに入れる必要があるのです。
詳しくは[トレイト][traits]セクションを読んでください。

[traits]: traits.html

<!-- There are two other lines we added, in the middle: -->
中ほどにもう2行足してあります。

```rust,ignore
    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);
```

<!-- We use the `rand::thread_rng()` function to get a copy of the random number -->
<!-- generator, which is local to the particular [thread][concurrency] of execution -->
<!-- we’re in. Because we `use rand::Rng`’d above, it has a `gen_range()` method -->
<!-- available. This method takes two arguments, and generates a number between -->
<!-- them. It’s inclusive on the lower bound, but exclusive on the upper bound, -->
<!-- so we need `1` and `101` to get a number ranging from one to a hundred. -->
`rand::thread_rng()` を使って、いま現在の実行[スレッド][concurrency]に対してローカルな、乱数生成器のコピーを取得しています。
上で `use rand::Rng` したので、生成器は `gen_range()` メソッドを使えます。
このメソッドは2つの引数を取り、その間の数を1つ生成します。
下限は含みますが、上限は含まないので、1から100までの数を生成するには `1` と `101` を渡す必要があります。

[concurrency]: concurrency.html

<!-- The second line prints out the secret number. This is useful while -->
<!-- we’re developing our program, so we can easily test it out. But we’ll be -->
<!-- deleting it for the final version. It’s not much of a game if it prints out -->
<!-- the answer when you start it up! -->
2行目は秘密の数字を表示します。
これは開発する時には有用で、簡単に動作確認できます。
もちろん最終版では削除します。
最初に答えを見せたら、ゲームじゃなくなってしまいます！

<!-- Try running our new program a few times: -->
更新したプログラムを、何度か実行してみましょう。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 7
Please input your guess.
4
You guessed: 4
$ cargo run
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 83
Please input your guess.
5
You guessed: 5
```

<!-- Great! Next up: comparing our guess to the secret number. -->
うまくいきました。次は予想値と秘密の数を比較します。


<!-- # Comparing guesses -->
# 予想値と比較する

<!-- Now that we’ve got user input, let’s compare our guess to the secret number. -->
<!-- Here’s our next step, though it doesn’t quite compile yet: -->
ユーザーの入力を受け取れるようになったので、秘密の数と比較しましょう。
まだコンパイルできませんが、これが次のステップです。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("failed to read line");

    println!("You guessed: {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less    => println!("Too small!"),
        Ordering::Greater => println!("Too big!"),
        Ordering::Equal   => println!("You win!"),
    }
}
```

> 訳注:
>
> * Too small!: 小さすぎます！
> * Too big!: 大きすぎます！
> * You win!: あなたの勝ちです！


<!-- A few new bits here. The first is another `use`. We bring a type called -->
<!-- `std::cmp::Ordering` into scope. Then, five new lines at the bottom that use -->
<!-- it: -->
いくつか新しいことがあります。まず `use` が増えました。
`std::cmp::Ordering` という型をスコープに導入しています。
また、それを使うためのコードを末尾に5行追加しました。

```rust,ignore
match guess.cmp(&secret_number) {
    Ordering::Less    => println!("Too small!"),
    Ordering::Greater => println!("Too big!"),
    Ordering::Equal   => println!("You win!"),
}
```

<!-- The `cmp()` method can be called on anything that can be compared, and it -->
<!-- takes a reference to the thing you want to compare it to. It returns the -->
<!-- `Ordering` type we `use`d earlier. We use a [`match`][match] statement to -->
<!-- determine exactly what kind of `Ordering` it is. `Ordering` is an -->
<!-- [`enum`][enum], short for ‘enumeration’, which looks like this: -->
`cmp()` は比較可能な全てのものに対して呼べるメソッドで、引数として、比較したい相手の参照を取ります。
そして、先ほど `use` した、`Ordering` 型の値を返します。
[`match`][match] 文を使って、正確に `Ordering` のどれであるかを判断しています。
`Ordering` は [`enum` (列挙型)][enum] で、enumは「enumeration(列挙)」の略です。
このようなものです。

```rust
enum Foo {
    Bar,
    Baz,
}
```

[match]: match.html
[enum]: enums.html

<!-- With this definition, anything of type `Foo` can be either a -->
<!-- `Foo::Bar` or a `Foo::Baz`. We use the `::` to indicate the -->
<!-- namespace for a particular `enum` variant. -->
この定義だと、 `Foo` 型のものは `Foo::Bar` あるいは `Foo::Baz` のいずれかです。
`::` を使って `enum` のバリアントの名前空間を指定します。

<!-- The [`Ordering`][ordering] `enum` has three possible variants: `Less`, `Equal`, -->
<!-- and `Greater`. The `match` statement takes a value of a type, and lets you -->
<!-- create an ‘arm’ for each possible value. Since we have three types of -->
<!-- `Ordering`, we have three arms: -->
[`Ordering`][ordering] `enum` は3つのバリアントを持ちます。 `Less` 、 `Equal` 、 `Greater` です。
`match` 文ではある型の値を取って、それぞれの可能な値に対する「腕」を作れます。
`Ordering` には3種類あるので、3つの腕を作っています。

```rust,ignore
match guess.cmp(&secret_number) {
    Ordering::Less    => println!("Too small!"),
    Ordering::Greater => println!("Too big!"),
    Ordering::Equal   => println!("You win!"),
}
```

[ordering]: ../std/cmp/enum.Ordering.html

<!-- If it’s `Less`, we print `Too small!`, if it’s `Greater`, `Too big!`, and if -->
<!-- `Equal`, `You win!`. `match` is really useful, and is used often in Rust. -->
`Less` なら `Too small!` を、 `Greater` なら `Too big!` を、 `Equal` なら `You win!` を表示します。
`match` はとても便利で、Rustでよく使われます。

<!-- I did mention that this won’t quite compile yet, though. Let’s try it: -->
これはコンパイルが通らないと言いました。試してみましょう。

```bash
$ cargo build
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
src/main.rs:28:21: 28:35 error: mismatched types:
 expected `&collections::string::String`,
    found `&_`
(expected struct `collections::string::String`,
    found integral variable) [E0308]
src/main.rs:28     match guess.cmp(&secret_number) {
                                   ^~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `guessing_game`.
```

<!-- Whew! This is a big error. The core of it is that we have ‘mismatched types’. -->
<!-- Rust has a strong, static type system. However, it also has type inference. -->
<!-- When we wrote `let guess = String::new()`, Rust was able to infer that `guess` -->
<!-- should be a `String`, and so it doesn’t make us write out the type. And with -->
<!-- our `secret_number`, there are a number of types which can have a value -->
<!-- between one and a hundred: `i32`, a thirty-two-bit number, or `u32`, an -->
<!-- unsigned thirty-two-bit number, or `i64`, a sixty-four-bit number or others. -->
<!-- So far, that hasn’t mattered, and so Rust defaults to an `i32`. However, here, -->
<!-- Rust doesn’t know how to compare the `guess` and the `secret_number`. They -->
<!-- need to be the same type. Ultimately, we want to convert the `String` we -->
<!-- read as input into a real number type, for comparison. We can do that -->
<!-- with two more lines. Here’s our new program: -->
うわ、大きなエラーです。核心になっているのは「型の不一致」です。
Rustには強い静的な型システムがあり、また、型推論もあります。
`let guess = String::new()` と書いた時、Rustは `guess` が文字列であるはずだと推論できるので、わざわざ型を書かなくてもよいのです。
また、`secret_number` では、1から100までの数値を表せる型として、いくつかの候補があり、例えば、32bit数の `i32` 、符号なし32bit数の `u32` 、64bit数の `i64` などが該当します。
これまで、そのどれであっても良かったため、Rustはデフォルトの `i32` としてました。
しかしここで、Rustは `guess` と `secret_number` の比較のしかたが分からないのです。
これらは同じ型である必要があります。
ということは、私たちたちは本当は、入力として読み取った `String` を、比較のために実数の型にしたかったわけです。
それは2行追加すればできます。
新しいプログラムです。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    println!("Please input your guess.");

    let mut guess = String::new();

    io::stdin().read_line(&mut guess)
        .expect("failed to read line");

    let guess: u32 = guess.trim().parse()
        .expect("Please type a number!");

    println!("You guessed: {}", guess);

    match guess.cmp(&secret_number) {
        Ordering::Less    => println!("Too small!"),
        Ordering::Greater => println!("Too big!"),
        Ordering::Equal   => println!("You win!"),
    }
}
```

<!-- The new two lines: -->
新しい2行はこれです。

```rust,ignore
    let guess: u32 = guess.trim().parse()
        .expect("Please type a number!");
```

<!-- Wait a minute, I thought we already had a `guess`? We do, but Rust allows us -->
<!-- to ‘shadow’ the previous `guess` with a new one. This is often used in this -->
<!-- exact situation, where `guess` starts as a `String`, but we want to convert it -->
<!-- to an `u32`. Shadowing lets us re-use the `guess` name, rather than forcing us -->
<!-- to come up with two unique names like `guess_str` and `guess`, or something -->
<!-- else. -->
ちょっと待ってください、既に `guess` を定義してありますよね？
たしかにそうですが、Rustでは以前の `guess` の定義を新しいもので「覆い隠す」ことができるのです(訳注: このように隠すことをシャドーイングといいます)。
まさにこのように、最初 `String` であった `guess` を `u32` に変換したい、というような状況でよく使われます。
シャドーイングのおかげで `guess_str` と `guess` のように別々の名前を考える必要はなくなり、 `guess` の名前を再利用できます。

<!-- We bind `guess` to an expression that looks like something we wrote earlier: -->
`guess` を先に書いたような値に束縛します。

```rust,ignore
guess.trim().parse()
```

<!-- Here, `guess` refers to the old `guess`, the one that was a `String` with our -->
<!-- input in it. The `trim()` method on `String`s will eliminate any white space at -->
<!-- the beginning and end of our string. This is important, as we had to press the -->
<!-- ‘return’ key to satisfy `read_line()`. This means that if we type `5` and hit -->
<!-- return, `guess` looks like this: `5\n`. The `\n` represents ‘newline’, the -->
<!-- enter key. `trim()` gets rid of this, leaving our string with only the `5`. The -->
<!-- [`parse()` method on strings][parse] parses a string into some kind of number. -->
<!-- Since it can parse a variety of numbers, we need to give Rust a hint as to the -->
<!-- exact type of number we want. Hence, `let guess: u32`. The colon (`:`) after -->
<!-- `guess` tells Rust we’re going to annotate its type. `u32` is an unsigned, -->
<!-- thirty-two bit integer. Rust has [a number of built-in number types][number], -->
<!-- but we’ve chosen `u32`. It’s a good default choice for a small positive number. -->
ここでの `guess` は、古い `guess` を指しており、入力を保持する `String` です。
`String` の `trim()` メソッドは、文字列の最初と最後にある空白を取り除きます。
`read_line()` を満たすには「リターン」キーを押す必要があるので、これは重要です。
つまり `5` と入力してリターンを押したら、 `guess` は `5\n` のようになっています。
`\n` は「改行」、つまり、エンターキーを表しています。
`trim()` することで、`5` だけを残してこれを取り除けます。
[文字列の `parse()` メソッド][parse]は、文字列を何かの数値へとパースします。
様々な数値をパースできるので、Rustに正確にどの型の数値が欲しいのかを伝える必要があります。
なので `let guess: u32` と書いたのです。
`guess` の後のコロン(`:`)は型注釈を付けようとしていることをRustに伝えます。
`u32` は符号なし32bit整数です。
Rustには [様々なビルトインの数値型][number] がありますが、今回は `u32` を選びました。
小さな正整数にはちょうどいいデフォルトとなる選択肢です。

[parse]: ../std/primitive.str.html#method.parse
[number]: primitive-types.html#numeric-types

<!-- Just like `read_line()`, our call to `parse()` could cause an error. What if -->
<!-- our string contained `A👍%`? There’d be no way to convert that to a number. As -->
<!-- such, we’ll do the same thing we did with `read_line()`: use the `expect()` -->
<!-- method to crash if there’s an error. -->
`read_line()` と同じように、 `parse()` の呼び出しでもエラーが起こり得ます。
文字列に `A👍%` が含まれていたらどうなるでしょう？ それは数値には変換できません。
ですから `read_line()` と同じように `expect()` を使って、エラーがあったらクラッシュするようにします。

<!-- Let’s try our program out! -->
プログラムを試してみましょう。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/guessing_game`
Guess the number!
The secret number is: 58
Please input your guess.
  76
You guessed: 76
Too big!
```

<!-- Nice! You can see I even added spaces before my guess, and it still figured -->
<!-- out that I guessed 76. Run the program a few times, and verify that guessing -->
<!-- the number works, as well as guessing a number too small. -->
ばっちりです。予想値の前にスペースも入れてみましたが、それでも私が76と予想したんだと、ちゃんと理解してくれました。
何度か動かしてみて、当たりが動くこと、小さい数字も動くことを確認してみてください。

<!-- Now we’ve got most of the game working, but we can only make one guess. Let’s -->
<!-- change that by adding loops! -->
ゲームが完成に近づいてきましたが、まだ、1回しか予想できません。
ループを使って書き換えましょう。

<!-- # Looping -->
# ループ

<!-- The `loop` keyword gives us an infinite loop. Let’s add that in: -->
`loop` キーワードで無限ループが得られます。追加しましょう。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .expect("failed to read line");

        let guess: u32 = guess.trim().parse()
            .expect("Please type a number!");

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal   => println!("You win!"),
        }
    }
}
```

<!-- And try it out. But wait, didn’t we just add an infinite loop? Yup. Remember -->
<!-- our discussion about `parse()`? If we give a non-number answer, we’ll `panic!` -->
<!-- and quit. Observe: -->
試してみましょう。え？でも待ってください、無限ループを追加しましたよね。
そうです。でも `parse()` に関する議論を覚えてますか？ 数字でない答えを入力すると `panic!` して終了するのでした。
見ててください。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/guessing_game`
Guess the number!
The secret number is: 59
Please input your guess.
45
You guessed: 45
Too small!
Please input your guess.
60
You guessed: 60
Too big!
Please input your guess.
59
You guessed: 59
You win!
Please input your guess.
quit
thread '<main>' panicked at 'Please type a number!'
```

<!-- Ha! `quit` actually quits. As does any other non-number input. Well, this is -->
<!-- suboptimal to say the least. First, let’s actually quit when you win the game: -->
はいこの通り、たしかに `quit` で終了しました。他の数字でないものを入れても同じです。
でもこれは、お世辞にも良いやり方とは言えませんね。
まず、ゲームに勝ったら本当に終了するようにしましょう。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .expect("failed to read line");

        let guess: u32 = guess.trim().parse()
            .expect("Please type a number!");

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal   => {
                println!("You win!");
                break;
            }
        }
    }
}
```

<!-- By adding the `break` line after the `You win!`, we’ll exit the loop when we -->
<!-- win. Exiting the loop also means exiting the program, since it’s the last -->
<!-- thing in `main()`. We have only one more tweak to make: when someone inputs a -->
<!-- non-number, we don’t want to quit, we want to ignore it. We can do that -->
<!-- like this: -->
`You win!` の後に `break` を加えることで、ゲームに勝った時にループを抜けます。
ループを抜けることは同時に、それが `main()` の最後の要素なので、プログラムが終了することも意味します。
もう1つ修正します。数値でない入力をした時に終了するのではなく、無視させましょう。
それはこのようにできます。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    println!("The secret number is: {}", secret_number);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .expect("failed to read line");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal   => {
                println!("You win!");
                break;
            }
        }
    }
}
```

<!-- These are the lines that changed: -->
変更はこれです。


```rust,ignore
let guess: u32 = match guess.trim().parse() {
    Ok(num) => num,
    Err(_) => continue,
};
```

<!-- This is how you generally move from ‘crash on error’ to ‘actually handle the -->
<!-- error’, by switching from `expect()` to a `match` statement. A `Result` is -->
<!-- returned by `parse()`, this is an `enum`  like `Ordering`, but in this case, -->
<!-- each variant has some data associated with it: `Ok` is a success, and `Err` is a -->
<!-- failure. Each contains more information: the successfully parsed integer, or an -->
<!-- error type. In this case, we `match` on `Ok(num)`, which sets the name `num` to -->
<!-- the unwrapped `Ok` value (the integer), and then we  return it on the -->
<!-- right-hand side. In the `Err` case, we don’t care what kind of error it is, so -->
<!-- we just use the catch all `_` instead of a name. This catches everything that -->
<!-- isn't `Ok`, and `continue` lets us move to the next iteration of the loop; in -->
<!-- effect, this enables us to ignore all errors and continue with our program. -->
このように、「エラーならクラッシュ」から「実際に戻り値のエラーをハンドルすること」へ移行する一般的な方法は、`expect()` を `match` 文に変更することです。
`parse()` は `Result` を返します。
これは `Ordering` と同じような `enum` ですが、今回はそれぞれのバリアントにデータが関連付いています。
`Ok` は成功で、 `Err` は失敗です。それぞれには追加の情報もあります。パースに成功した整数、あるいはエラーの種類です。
このケースでは `Ok(num)` に対して `match` していて、これは `Ok` をアンラップして得られた値(整数値)を `num` という名前に設定します。続く右側では、その値をそのまま返しています。
`Err` の場合、エラーの種類は気にしにないので、名前ではなく、任意の値にマッチする `_` を使いました。
こうすれば `Ok` 以外の全てをキャッチすることができ、`continue` によって、loop の次の繰り返しに進みます。
こうして全てのエラーを無視し、プログラムの実行を続けることが可能になるのです。

<!-- Now we should be good! Let’s try: -->
これでいいはずです。試してみましょう。

```bash
$ cargo run
   Compiling guessing_game v0.1.0 (file:///home/you/projects/guessing_game)
     Running `target/guessing_game`
Guess the number!
The secret number is: 61
Please input your guess.
10
You guessed: 10
Too small!
Please input your guess.
99
You guessed: 99
Too big!
Please input your guess.
foo
Please input your guess.
61
You guessed: 61
You win!
```

<!-- Awesome! With one tiny last tweak, we have finished the guessing game. Can you -->
<!-- think of what it is? That’s right, we don’t want to print out the secret -->
<!-- number. It was good for testing, but it kind of ruins the game. Here’s our -->
<!-- final source: -->
素晴らしい！
最後にほんの少し修正して、数当てゲームの制作を終えましょう。
なんだか分かりますか？ そうです、秘密の数字は表示したくありません。
テストには便利でしたが、ゲームを台無しにしてしまいます。
これが最終的なソースコードです。

```rust,ignore
extern crate rand;

use std::io;
use std::cmp::Ordering;
use rand::Rng;

fn main() {
    println!("Guess the number!");

    let secret_number = rand::thread_rng().gen_range(1, 101);

    loop {
        println!("Please input your guess.");

        let mut guess = String::new();

        io::stdin().read_line(&mut guess)
            .expect("failed to read line");

        let guess: u32 = match guess.trim().parse() {
            Ok(num) => num,
            Err(_) => continue,
        };

        println!("You guessed: {}", guess);

        match guess.cmp(&secret_number) {
            Ordering::Less    => println!("Too small!"),
            Ordering::Greater => println!("Too big!"),
            Ordering::Equal   => {
                println!("You win!");
                break;
            }
        }
    }
}
```

<!-- # Complete! -->
# 終わりに

<!-- At this point, you have successfully built the Guessing Game! Congratulations! -->
数当てゲームが遂に完成しました！ お疲れ様でした！

<!-- This first project showed you a lot: `let`, `match`, methods, associated -->
<!-- functions, using external crates, and more. Our next project will show off -->
<!-- even more. -->
<!-- 訳注：最後の文が "Our next project will show off ..." となっていますが、プログラムの作成ではなく、「シンタックスとセマンティクス」なので、以下のように変更しました。 -->
このプロジェクトでは、様々なものをお見せしました。
`let` 、 `match` 、メソッド、関連関数、外部クレートの使い方、などなど。
次の章では、それぞれについて、さらに深く学んでいきましょう。
