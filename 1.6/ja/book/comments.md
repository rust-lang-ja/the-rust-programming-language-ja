% コメント
<!-- % Comments -->

<!-- Now that we have some functions, it’s a good idea to learn about comments. -->
<!-- Comments are notes that you leave to other programmers to help explain things -->
<!-- about your code. The compiler mostly ignores them. -->
いくつかの関数ができたので、コメントについて学ぶことはよい考えです。
コメントはコードについての何かを説明する助けになるように、他のプログラマに残すメモです。
コンパイラはそれらをほとんど無視します。

<!-- Rust has two kinds of comments that you should care about: *line comments* -->
<!-- and *doc comments*. -->
Rustには気にすべき2種類のコメント、 *行コメント* と *ドキュメンテーションコメント* があります。

```rust
# // Line comments are anything after ‘//’ and extend to the end of the line.
// 行コメントは「//」以降の全ての文字であり、行末まで続く

let x = 5; // this is also a line comment.

# // If you have a long explanation for something, you can put line comments next
# // to each other. Put a space between the // and your comment so that it’s
# // more readable.
// もし何かのために長い説明を書くのであれば、行コメントを複数行に渡って書くこと
// ができる。//とコメントとの間にスペースを置くことで、より読みやすくなる
```

<!-- The other kind of comment is a doc comment. Doc comments use `///` instead of -->
<!-- `//`, and support Markdown notation inside: -->
その他の種類のコメントはドキュメンテーションコメントです。
ドキュメンテーションコメントは`//`の代わりに`///`を使い、その中でMarkdown記法をサポートします。

```rust
# /// Adds one to the number given.
/// 与えられた数値に1を加える
///
/// # Examples
///
/// ```
/// let five = 5;
///
/// assert_eq!(6, add_one(5));
/// # fn add_one(x: i32) -> i32 {
/// #     x + 1
/// # }
/// ```
fn add_one(x: i32) -> i32 {
    x + 1
}
```

<!-- There is another style of doc comment, `//!`, to comment containing items (e.g. -->
<!-- crates, modules or functions), instead of the items following it. Commonly used -->
<!-- inside crates root (lib.rs) or modules root (mod.rs): -->
もう1つのスタイルのドキュメンテーションコメントに`//!`があります。これは、その後に続く要素ではなく、それを含んでいる要素（例えばクレート、モジュール、関数）にコメントを付けます。
一般的にはクレートルート（lib.rs）やモジュールルート（mod.rs）の中で使われます。

```
//! # Rust標準ライブラリ
//!
//! Rust標準ライブラリはポータブルなRustソフトウェアをビルドするために不可欠な
//! ランタイム関数を提供する。
```

<!-- When writing doc comments, providing some examples of usage is very, very -->
<!-- helpful. You’ll notice we’ve used a new macro here: `assert_eq!`. This compares -->
<!-- two values, and `panic!`s if they’re not equal to each other. It’s very helpful -->
<!-- in documentation. There’s another macro, `assert!`, which `panic!`s if the -->
<!-- value passed to it is `false`. -->
ドキュメンテーションコメントを書いているとき、いくつかの使い方の例を提供することは非常に非常に有用です。
ここでは新しいマクロ、`assert_eq!`を使っていることに気付くでしょう。
これは2つの値を比較し、もしそれらが互いに等しくなければ`panic!`します。
これはドキュメントの中で非常に便利です。
もう1つのマクロ、`assert!`は、それに渡された値が`false`であれば`panic!`します。

<!-- You can use the [`rustdoc`](documentation.html) tool to generate HTML documentation -->
<!-- from these doc comments, and also to run the code examples as tests! -->
それらのドキュメンテーションコメントからHTMLドキュメントを生成するため、そしてコード例をテストとして実行するためにも[`rustdoc`](documentation.html)ツールを使うことができます!
