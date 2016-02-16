% エラーハンドリング
<!-- % Error Handling -->

<!-- Like most programming languages, Rust encourages the programmer to handle -->
<!-- errors in a particular way. Generally speaking, error handling is divided into -->
<!-- two broad categories: exceptions and return values. Rust opts for return -->
<!-- values. -->
他のほとんどのプログラミング言語と同様、Rustはプログラマに、ある決まった作法でエラーを扱うことを促します。
一般的にエラーハンドリングは、例外、もしくは、戻り値を使ったものの、大きく2つに分類されます。
Rustでは戻り値を使います。

<!-- 用語集候補：return value -->

<!-- In this chapter, we intend to provide a comprehensive treatment of how to deal -->
<!-- with errors in Rust. More than that, we will attempt to introduce error handling -->
<!-- one piece at a time so that you'll come away with a solid working knowledge of -->
<!-- how everything fits together. -->
この章では、Rustでのエラーハンドリングに関わる包括的な扱い方を提示しようと思います。
単にそれだけではなく、エラーハンドリングのやり方を、ひとつひとつ、順番に積み上げていきます。
こうすることで、全体がどう組み合わさっているのかの理解が進み、より実用的な知識が身につくでしょう。

<!-- When done naïvely, error handling in Rust can be verbose and annoying. This -->
<!-- chapter will explore those stumbling blocks and demonstrate how to use the -->
<!-- standard library to make error handling concise and ergonomic. -->
もし素朴なやり方を用いたなら、Rustにおけるエラーハンドリングは、冗長で面倒なものになり得ます。
この章では、エラーを処理する上でどのような課題があるかを吟味し、標準ライブラリを使うと、それがいかにシンプルでエルゴノミック（人間にとって扱いやすいもの）に変わるのかを紹介します。

<!-- 用語集候補：ergonomic -->

<!-- # Table of Contents -->
# 目次

<!-- This chapter is very long, mostly because we start at the very beginning with -->
<!-- sum types and combinators, and try to motivate the way Rust does error handling -->
<!-- incrementally. As such, programmers with experience in other expressive type -->
<!-- systems may want to jump around. -->
この章はとても長くなります。
というのは、直和型(sum type) とコンビネータから始めることで、Restにおけるエラーハンドリングを徐々に改善していくための動機を与えるからです。
このような構成ですので、もしすでに他の表現力豊かな型システムの経験があるプログラマでしたら、あちこち拾い読みしたくなるかもしれません。

<!-- 用語集候補：combinator -->

<!-- 翻訳メモ：sum type -->
<!-- https://www.quora.com/What-is-a-sum-type -->
<!-- http://d-poppo.nazo.cc/blog/2015/01/union-types/ -->

<!-- * [The Basics](#the-basics) -->
<!--     * [Unwrapping explained](#unwrapping-explained) -->
<!--     * [The `Option` type](#the-option-type) -->
<!--         * [Composing `Option<T>` values](#composing-optiont-values) -->
<!--     * [The `Result` type](#the-result-type) -->
<!--         * [Parsing integers](#parsing-integers) -->
<!--         * [The `Result` type alias idiom](#the-result-type-alias-idiom) -->
<!--     * [A brief interlude: unwrapping isn't evil](#a-brief-interlude-unwrapping-isnt-evil) -->
<!-- * [Working with multiple error types](#working-with-multiple-error-types) -->
<!--     * [Composing `Option` and `Result`](#composing-option-and-result) -->
<!--     * [The limits of combinators](#the-limits-of-combinators) -->
<!--     * [Early returns](#early-returns) -->
<!--     * [The `try!` macro](#the-try-macro) -->
<!--     * [Defining your own error type](#defining-your-own-error-type) -->
<!-- * [Standard library traits used for error handling](#standard-library-traits-used-for-error-handling) -->
<!--     * [The `Error` trait](#the-error-trait) -->
<!--     * [The `From` trait](#the-from-trait) -->
<!--     * [The real `try!` macro](#the-real-try-macro) -->
<!--     * [Composing custom error types](#composing-custom-error-types) -->
<!--     * [Advice for library writers](#advice-for-library-writers) -->
<!-- * [Case study: A program to read population data](#case-study-a-program-to-read-population-data) -->
<!--     * [Initial setup](#initial-setup) -->
<!--     * [Argument parsing](#argument-parsing) -->
<!--     * [Writing the logic](#writing-the-logic) -->
<!--     * [Error handling with `Box<Error>`](#error-handling-with-boxerror) -->
<!--     * [Reading from stdin](#reading-from-stdin) -->
<!--     * [Error handling with a custom type](#error-handling-with-a-custom-type) -->
<!--     * [Adding functionality](#adding-functionality) -->
<!--  [The short story](#the-short-story) -->

* [基礎](#the-basics)
    * [アンラップ(unwrap) とは](#unwrapping-explained)
    * [`Option` 型](#the-option-type)
        * [`Option<T>` 値で構成する](#composing-optiont-values)
    * [`Result` 型](#the-result-type)
        * [整数をパースする](#parsing-integers)
        * [`Result` 型エイリアスを用いたイディオム](#the-result-type-alias-idiom)
    * [小休止：アンラップは悪ではない](#a-brief-interlude-unwrapping-isnt-evil)
* [複数のエラー型を扱う](#working-with-multiple-error-types)
    * [`Option` と `Result` で構成する](#composing-option-and-result)
    * [コンビネータの限界](#the-limits-of-combinators)
    * [早期のリターン](#early-returns)
    * [`try!` マクロ](#the-try-macro)
    * [独自のエラー型を定義する](#defining-your-own-error-type)
* [標準ライブラリのトレイトによるエラー処理](#standard-library-traits-used-for-error-handling)
    * [`Error` トレイト](#the-error-trait)
    * [`From` トレイト](#the-from-trait)
    * [本当の `try!` マクロ](#the-real-try-macro)
    * [独自のエラー型で構成する](#composing-custom-error-types)
    * [ライブラリ作者たちへのアドバイス](#advice-for-library-writers)
* [ケーススタディ：人口データを読み込むプログラム](#case-study-a-program-to-read-population-data)
    * [最初のセットアップ](#initial-setup)
    * [引数のパース](#argument-parsing)
    * [ロジックを書く](#writing-the-logic)
    * [`Box<Error>` によるエラー処理](#error-handling-with-boxerror)
    * [標準入力から読み込む](#reading-from-stdin)
    * [独自のエラー型によるエラー処理](#error-handling-with-a-custom-type)
    * [機能を追加する](#adding-functionality)
* [簡単な説明（まとめ）](#the-short-story)

<!-- # The Basics -->
<span id="the-basics"></span>
# 基礎

<!-- You can think of error handling as using *case analysis* to determine whether -->
<!-- a computation was successful or not. As you will see, the key to ergonomic error -->
<!-- handling is reducing the amount of explicit case analysis the programmer has to -->
<!-- do while keeping code composable. -->
エラーハンドリングとは、ある処理が成功したかどうかを *ケース分析* に基づいて判断するものだと考えられます。
これから見ていくように、エラーハンドリングをエルゴノミックにするために重要なのは、プログラマがコードを合成可能(composable) に保ったまま、明示的なケース分析の回数を、いかに減らしていくかということです。

<!-- Keeping code composable is important, because without that requirement, we -->
<!-- could [`panic`](../std/macro.panic!.html) whenever we -->
<!-- come across something unexpected. (`panic` causes the current task to unwind, -->
<!-- and in most cases, the entire program aborts.) Here's an example: -->
コードを合成可能に保つのは重要です。
なぜなら、もしこの要求がなかったら、想定外のことが起こる度に [`panic`](../std/macro.panic!.html) することを選ぶかもしれないからです。
（`panic` は現タスクを巻き戻し(unwind) して、ほとんどの場合、プログラム全体をアボートします。）

```rust,should_panic
# // Guess a number between 1 and 10.
# // If it matches the number we had in mind, return true. Else, return false.
// 1から10までの数字を予想します。
// もし予想した数字に一致したらtrueを返し、そうでなけれは、falseを返します。
fn guess(n: i32) -> bool {
    if n < 1 || n > 10 {
        panic!("Invalid number: {}", n);
    }
    n == 5
}

fn main() {
    guess(11);
}
```

> 訳注：文言の意味は
>
> * Invalid number: {}：無効な数字です: {}
>
> ですが、エディタの設定などによっては、ソースコード中の
> コメント以外の場所に日本語を使うとコンパイルできないことがあるので、
> 英文のままにしてあります。

<!-- If you try running this code, the program will crash with a message like this: -->
このコードを実行すると、プログラムがクラッシュして、以下のようなメッセージが表示されます。

```text
thread '<main>' panicked at 'Invalid number: 11', src/bin/panic-simple.rs:5
```

<!-- Here's another example that is slightly less contrived. A program that accepts -->
<!-- an integer as an argument, doubles it and prints it. -->
次は、もう少し自然な例です。
このプログラムは引数として整数を受け取り、2倍した後に表示します。

<span id="code-unwrap-double"></span>

```rust,should_panic
use std::env;

fn main() {
    let mut argv = env::args();
    let arg: String = argv.nth(1).unwrap(); // エラー1
    let n: i32 = arg.parse().unwrap(); // エラー2
    println!("{}", 2 * n);
}
```

<!-- If you give this program zero arguments (error 1) or if the first argument -->
<!-- isn't an integer (error 2), the program will panic just like in the first -->
<!-- example. -->
もし、このプログラムに引数を与えなかったら（エラー1）、あるいは、最初の引数が整数でなかったら（エラー2）、このプログラムは、最初の例と同じようにパニックするでしょう。

<!-- You can think of this style of error handling as similar to a bull running -->
<!-- through a china shop. The bull will get to where it wants to go, but it will -->
<!-- trample everything in the process. -->
このようなスタイルのエラーハンドリングは、まるで、陶器店の中を駆け抜ける雄牛のようなものです。
雄牛は自分の行きたいところへたどり着くでしょう。
でも彼は、途中にある、あらゆるものを蹴散らしてしまいます。

<!-- ## Unwrapping explained -->
<span id="unwrapping-explained"></span>
## アンラップ(unwrap) とは

<!-- In the previous example, we claimed -->
<!-- that the program would simply panic if it reached one of the two error -->
<!-- conditions, yet, the program does not include an explicit call to `panic` like -->
<!-- the first example. This is because the -->
<!-- panic is embedded in the calls to `unwrap`. -->
先ほどの例で、プログラムが2つのエラー条件のいずれかを満たした時に、パニックすると言いました。
でもこのプログラムは、最初の例とは違って明示的に `panic` を呼び出してはいません。
実はパニックは `unwrap` の呼び出しの中に埋め込まれているのです。

<!-- To “unwrap” something in Rust is to say, “Give me the result of the -->
<!-- computation, and if there was an error, just panic and stop the program.” -->
<!-- It would be better if we just showed the code for unwrapping because it is so -->
<!-- simple, but to do that, we will first need to explore the `Option` and `Result` -->
<!-- types. Both of these types have a method called `unwrap` defined on them. -->
Rustでなにかを「アンラップする」時、こう言っているのと同じです。
「計算結果を取り出しなさい。もしエラーになっていたのなら、パニックを起こしてプログラムを終了させなさい。」
アンラップのコードはとてもシンプルなので、多分、それを見せたほうが早いでしょう。
でもそのためには、まず `Option` と `Result` 型について調べる必要があります。
どちらの型にも `unwrap` という名前のメソッドが定義されています。

<!-- ### The `Option` type -->
<span id="the-option-type"></span>
### `Option` 型

<!-- The `Option` type is [defined in the standard library][5]: -->
`Option` 型は [標準ライブラリで定義されています][5]：

```rust
enum Option<T> {
    None,
    Some(T),
}
```

<!-- The `Option` type is a way to use Rust's type system to express the -->
<!-- *possibility of absence*. Encoding the possibility of absence into the type -->
<!-- system is an important concept because it will cause the compiler to force the -->
<!-- programmer to handle that absence. Let's take a look at an example that tries -->
<!-- to find a character in a string: -->
`Option` 型は、Rustの型システムを使って *不在の可能性* を示すためのものです。
不在の可能性を型システムにエンコードすることは、重要なコンセプトです。
なぜなら、その不在に対処することを、コンパイラがプログラマに強制させるからです。
では、文字列から文字を検索する例を見てみましょう。

<span id="code-option-ex-string-find"></span>

```rust
# // Searches `haystack` for the Unicode character `needle`. If one is found, the
# // byte offset of the character is returned. Otherwise, `None` is returned.
// `haystack`（干し草の山）からUnicode文字 `needle`（縫い針）を検索します。
// もし見つかったら、文字のバイトオフセットを返します。見つからなければ、`None` を
// 返します。
fn find(haystack: &str, needle: char) -> Option<usize> {
    for (offset, c) in haystack.char_indices() {
        if c == needle {
            return Some(offset);
        }
    }
    None
}
```

<!-- Notice that when this function finds a matching character, it doesn't just -->
<!-- return the `offset`. Instead, it returns `Some(offset)`. `Some` is a variant or -->
<!-- a *value constructor* for the `Option` type. You can think of it as a function -->
<!-- with the type `fn<T>(value: T) -> Option<T>`. Correspondingly, `None` is also a -->
<!-- value constructor, except it has no arguments. You can think of `None` as a -->
<!-- function with the type `fn<T>() -> Option<T>`. -->
この関数がマッチする文字を見つけた時、単に `offset` を返すだけではないことに注目してください。
その代わりに `Some(offset)` を返します。
`Some` は `Option` 型の *値コンストラクタ* の一つです。
これは `fn<T>(value: T) -> Option<T>` という型の関数だと考えることもできます。
これに対応して `None` もまた値コンストラクタですが、こちらには引数がありません。
`None` は `fn<T>() -> Option<T>` という型の関数だと考えることもできます。

<!-- This might seem like much ado about nothing, but this is only half of the -->
<!-- story. The other half is *using* the `find` function we've written. Let's try -->
<!-- to use it to find the extension in a file name. -->
何もないことを表すのに、ずいぶん大げさだと感じるかもしれません。
でもこれはまだ、話の半分に過ぎません。
残りの半分は、いま書いた `find` 関数を *使う* 場面です。
これを使って、ファイル名から拡張子を見つけてみましょう。

```rust
# fn find(_: &str, _: char) -> Option<usize> { None }
fn main() {
    let file_name = "foobar.rs";
    match find(file_name, '.') {
        None => println!("No file extension found."),
        Some(i) => println!("File extension: {}", &file_name[i+1..]),
    }
}
```

> 訳注：
>
> * No file extension found：ファイル拡張子は見つかりませんでした
> * File extension: {}：ファイル拡張子：{}

<!-- This code uses [pattern matching][1] to do *case -->
<!-- analysis* on the `Option<usize>` returned by the `find` function. In fact, case -->
<!-- analysis is the only way to get at the value stored inside an `Option<T>`. This -->
<!-- means that you, as the programmer, must handle the case when an `Option<T>` is -->
<!-- `None` instead of `Some(t)`. -->
このコードは `find` 関数が返した `Option<usize>` の *ケース分析* に、 [パターンマッチ][1] を使っています。
実のところ、ケース分析が、`Option<T>` に格納された値を取り出すための唯一の方法なのです。
これは、`Option<T>` が `Some(t)` ではなく `None` だった時、プログラマであるあなたが、このケースに対処しなければならないことを意味します。

<!-- But wait, what about `unwrap`,which we used [`previously`](#code-unwrap-double)? -->
<!-- There was no case analysis there! Instead, the case analysis was put inside the -->
<!-- `unwrap` method for you. You could define it yourself if you want: -->
でも、ちょっと待ってください。 [さっき](#code-unwrap-double) 使った `unwrap` はどうだったでしょうか？
ケース分析はどこにもありませんでした！
実はケース分析は `unwrap` メソッドの中に埋め込まれていたのです。
もし望むなら、このように自分で定義することもできます：

<span id="code-option-def-unwrap"></span>

```rust
enum Option<T> {
    None,
    Some(T),
}

impl<T> Option<T> {
    fn unwrap(self) -> T {
        match self {
            Option::Some(val) => val,
            Option::None =>
              panic!("called `Option::unwrap()` on a `None` value"),
        }
    }
}
```

> 訳注：
>
> called `Option::unwrap()` on a `None` value：<br/>
> `None` な値に対して `Option:unwpal()` が呼ばれました

<!-- The `unwrap` method *abstracts away the case analysis*. This is precisely the thing -->
<!-- that makes `unwrap` ergonomic to use. Unfortunately, that `panic!` means that -->
<!-- `unwrap` is not composable: it is the bull in the china shop. -->
`unwrap` メソッドは *ケース分析を抽象化します* 。このことは確かに `unwrap` をエルゴノミックにしています。
しかし残念なことに、そこにある `panic!` が意味するものは、`unwrap` が合成可能ではない、つまり、陶器店の中の雄牛だということです。

<!--- ### Composing `Option<T>` values -->
<span id="composing-optiont-values"></span>
### `Option<T>` 値で構成する

<!-- In an [example from before](#code-option-ex-string-find), -->
<!-- we saw how to use `find` to discover the extension in a file name. Of course, -->
<!-- not all file names have a `.` in them, so it's possible that the file name has -->
<!-- no extension. This *possibility of absence* is encoded into the types using -->
<!-- `Option<T>`. In other words, the compiler will force us to address the -->
<!-- possibility that an extension does not exist. In our case, we just print out a -->
<!-- message saying as such. -->
[先ほどの例](#code-option-ex-string-find) では、ファイル名から拡張子を見つけるために `find` をどのように使うかを見ました。
当然ながら全てのファイル名に `.` があるわけではなく、拡張子のないファイル名もあり得ます。
このような *不在の可能性* は `Option<T>` を使うことによって、型の中にエンコードされています。
すなわち、コンパイラは、拡張子が存在しない可能性に対処することを、私たちに強制してくるわけです。
今回は単に、そうなったことを告げるメッセージを表示するようにしました。

<!-- Getting the extension of a file name is a pretty common operation, so it makes -->
<!-- sense to put it into a function: -->
ファイル名から拡張子を取り出すことは一般的な操作ですので、それを関数にすることは理にかなっています。

```rust
# fn find(_: &str, _: char) -> Option<usize> { None }
# // Returns the extension of the given file name, where the extension is defined
# // as all characters proceeding the first `.`.
# // If `file_name` has no `.`, then `None` is returned.
// 与えられたファイル名の拡張子を返す。拡張子の定義は、最初の
// `.` に続く、全ての文字である。
// もし `file_name` に `.` がなければ、`None` が返される。
fn extension_explicit(file_name: &str) -> Option<&str> {
    match find(file_name, '.') {
        None => None,
        Some(i) => Some(&file_name[i+1..]),
    }
}
```

<!-- (pro-tip: don't use this code. Use the -->
<!-- [`extension`](../std/path/struct.Path.html#method.extension) -->
<!-- method in the standard library instead.) -->
（プロ向けのヒント：このコードは使わず、代わりに標準ライブラリの
[`extension`](../std/path/struct.Path.html#method.extension)
メソッドを使ってください）

<!-- The code stays simple, but the important thing to notice is that the type of -->
<!-- `find` forces us to consider the possibility of absence. This is a good thing -->
<!-- because it means the compiler won't let us accidentally forget about the case -->
<!-- where a file name doesn't have an extension. On the other hand, doing explicit -->
<!-- case analysis like we've done in `extension_explicit` every time can get a bit -->
<!-- tiresome. -->
このコードはいたってシンプルですが、ひとつだけ注目して欲しいのは、`find` の型が不在の可能性について考慮することを強制していることです。
これは良いことです。なぜなら、コンパイラが私たちに、ファイル名が拡張子を持たないケースを、うっかり忘れないようにしてくれるからです。
しかし一方で、 `extension_explicit` でしたような明示的なケース分析を毎回続けるのは、なかなか面倒です。

<!-- In fact, the case analysis in `extension_explicit` follows a very common -->
<!-- pattern: *map* a function on to the value inside of an `Option<T>`, unless the -->
<!-- option is `None`, in which case, just return `None`. -->
実は `extension_explicit` でのケース分析は、ごく一般的なパターンである、`Option<T>` への *map* の適用に当てはめられます。
これは、もしオプションが `None` なら `None` を返し、そうでなけれは、オプションの中の値に関数を適用する、というパターンです。

<!-- Rust has parametric polymorphism, so it is very easy to define a combinator -->
<!-- that abstracts this pattern: -->
Rustはパラメトリック多相をサポートしていますので、このパターンを抽象化するためのコンビネータが簡単に定義できます：

<span id="code-option-map"></span>

```rust
fn map<F, T, A>(option: Option<T>, f: F) -> Option<A> where F: FnOnce(T) -> A {
    match option {
        None => None,
        Some(value) => Some(f(value)),
    }
}
```

<!-- Indeed, `map` is [defined as a method][2] on `Option<T>` in the standard library. -->
もちろん `map` は、標準のライブラリの `Option<T>` で [メソッドとして定義されています][2]。

<!-- Armed with our new combinator, we can rewrite our `extension_explicit` method -->
<!-- to get rid of the case analysis: -->
新しいコンビネータを手に入れましたので、 `extension_explicit` メソッドを書き直して、ケース分析を省きましょう：

```rust
# fn find(_: &str, _: char) -> Option<usize> { None }
# // Returns the extension of the given file name, where the extension is defined
# // as all characters proceeding the first `.`.
# // If `file_name` has no `.`, then `None` is returned.
// 与えられたファイル名の拡張子を返す。拡張子の定義は、最初の
// `.` に続く、全ての文字である。
// もし `file_name` に `.` がなければ、`None` が返される。
fn extension(file_name: &str) -> Option<&str> {
    find(file_name, '.').map(|i| &file_name[i+1..])
}
```

<!-- One other pattern we commonly find is assigning a default value to the case -->
<!-- when an `Option` value is `None`. For example, maybe your program assumes that -->
<!-- the extension of a file is `rs` even if none is present. As you might imagine, -->
<!-- the case analysis for this is not specific to file extensions - it can work -->
<!-- with any `Option<T>`: -->
もう一つの共通のパターンは、`Option` の値が `None` だった時のデフォルト値を与えることです。
例えばファイルの拡張子がない時は、それを `rs` とみなすようなプログラムを書きたくなるかもしれません。
ご想像の通り、このようなケース分析はファイルの拡張子に特有のものではありません。
どんな `Option<T>` でも使えるでしょう：

```rust
fn unwrap_or<T>(option: Option<T>, default: T) -> T {
    match option {
        None => default,
        Some(value) => value,
    }
}
```

<!-- The trick here is that the default value must have the same type as the value -->
<!-- that might be inside the `Option<T>`. Using it is dead simple in our case: -->
ここでの仕掛けは、`Option<T>` に入れる値と同じ型になるよう、デフォルト値の型を制限していることです。
これを使うのは、すごく簡単です：

```rust
# fn find(haystack: &str, needle: char) -> Option<usize> {
#     for (offset, c) in haystack.char_indices() {
#         if c == needle {
#             return Some(offset);
#         }
#     }
#     None
# }
#
# fn extension(file_name: &str) -> Option<&str> {
#     find(file_name, '.').map(|i| &file_name[i+1..])
# }
fn main() {
    assert_eq!(extension("foobar.csv").unwrap_or("rs"), "csv");
    assert_eq!(extension("foobar").unwrap_or("rs"), "rs");
}
```

<!-- (Note that `unwrap_or` is [defined as a method][3] on `Option<T>` in the -->
<!-- standard library, so we use that here instead of the free-standing function we -->
<!-- defined above. Don't forget to check out the more general [`unwrap_or_else`][4] -->
<!-- method.) -->
（`unwrap_or` は、標準のライブラリの `Option<T>` で、 [メソッドとして定義されています][3] ので、いま定義したフリースタンディングな関数の代わりに、そちらを使いましょう。）

<!-- There is one more combinator that we think is worth paying special attention to: -->
<!-- `and_then`. It makes it easy to compose distinct computations that admit the -->
<!-- *possibility of absence*. For example, much of the code in this section is -->
<!-- about finding an extension given a file name. In order to do this, you first -->
<!-- need the file name which is typically extracted from a file *path*. While most -->
<!-- file paths have a file name, not *all* of them do. For example, `.`, `..` or -->
<!-- `/`. -->
もうひとつ注目すべきコンビネータがあります。それは `and_then` です。これを使うと *不在の可能性* を考慮しながら、別々の処理を簡単に組み合わせることができます。
例えば、この節のほとんどのコードは、与えられたファイル名について拡張子を見つけだします。
そのためには、まずファイル *パス* から取り出したファイル名が必要です。
大抵のパスにはファイル名がありますが、 *全て* がというわけではありません。
例えば `.`, `..`, `/` などは例外です。

<!-- So, we are tasked with the challenge of finding an extension given a file -->
<!-- *path*. Let's start with explicit case analysis: -->
つまり、与えられたファイル *パス* から拡張子を見つけ出せるか、トライしなければなりません。
まず明示的なケース分析から始めましょう：


```rust
# fn extension(file_name: &str) -> Option<&str> { None }
fn file_path_ext_explicit(file_path: &str) -> Option<&str> {
    match file_name(file_path) {
        None => None,
        Some(name) => match extension(name) {
            None => None,
            Some(ext) => Some(ext),
        }
    }
}

fn file_name(file_path: &str) -> Option<&str> {
#  // implementation elided
  // 実装は省略
  unimplemented!()
}
```

<!-- You might think that we could just use the `map` combinator to reduce the case -->
<!-- analysis, but its type doesn't quite fit. Namely, `map` takes a function that -->
<!-- does something only with the inner value. The result of that function is then -->
<!-- *always* [rewrapped with `Some`](#code-option-map). Instead, we need something -->
<!-- like `map`, but which allows the caller to return another `Option`. Its generic -->
<!-- implementation is even simpler than `map`: -->
ケース分析を減らすために単に `map` コンビネータを使えばいいと思うかもしれませんが、型にうまく適合しません。
なぜなら `map` が引数にとる関数は、中の値だけに適用されるからです。
そして関数が返した値は *必ず* [`Some` でラップされ直します](#code-option-map) 。
つまりこの代わりに、 `map` に似ていながら、呼び出し元が別の `Option` を返せるしくみが必要です。
これの汎用的な実装は `map` よりもシンプルです：

```rust
fn and_then<F, T, A>(option: Option<T>, f: F) -> Option<A>
        where F: FnOnce(T) -> Option<A> {
    match option {
        None => None,
        Some(value) => f(value),
    }
}
```

<!-- Now we can rewrite our `file_path_ext` function without explicit case analysis: -->
では、明示的なケース分析を省くように、 `file_path_ext` を書き直しましょう：

```rust
# fn extension(file_name: &str) -> Option<&str> { None }
# fn file_name(file_path: &str) -> Option<&str> { None }
fn file_path_ext(file_path: &str) -> Option<&str> {
    file_name(file_path).and_then(extension)
}
```

<!-- The `Option` type has many other combinators [defined in the standardy
<!-- library][5]. It is a good idea to skim this list and familiarize -->
<!-- yourself with what's available—they can often reduce case analysis -->
<!-- for you. Familiarizing yourself with these combinators will pay -->
<!-- dividends because many of them are also defined (with similar -->
<!-- semantics) for `Result`, which we will talk about next. -->
`Option` 型には、他にもたくさんのコンビネータが [標準ライブラリで定義されています][5] 。
それらの一覧をざっと眺めて、なにがあるか知っておくといいでしょう。
大抵の場合、ケース分析を減らすのに役立ちます。
それらのコンビネータに慣れるための努力は、すぐに報われるでしょう。
なぜなら、そのほとんどは次に話す `Result` 型でも、（よく似たセマンティクスで）定義されているからです。

<!-- Combinators make using types like `Option` ergonomic because they reduce -->
<!-- explicit case analysis. They are also composable because they permit the caller -->
<!-- to handle the possibility of absence in their own way. Methods like `unwrap` -->
<!-- remove choices because they will panic if `Option<T>` is `None`. -->
コンビネータは明示的なケース分析を減らしてくれるので、 `Option` のような型をエルゴノミックにします。
またこれらは *不在の可能性* を、呼び出し元がそれに合った方法で扱えるようにするので、合成可能だといえます。
`unwrap` のようなメソッドは、 `Option<T>` が `None` の時にパニックを起こすので、このような選択の機会を与えません。

<!-- ## The `Result` type -->
<span id="the-result-type"></span>
## `Result` 型

<!-- The `Result` type is also -->
<!-- [defined in the standard library][6]: -->
`Result` 型も [標準ライブラリで定義されています][6] 。

<span id="code-result-def"></span>

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

<!-- The `Result` type is a richer version of `Option`. Instead of expressing the -->
<!-- possibility of *absence* like `Option` does, `Result` expresses the possibility -->
<!-- of *error*. Usually, the *error* is used to explain why the execution of some -->
<!-- computation failed. This is a strictly more general form of `Option`. Consider -->
<!-- the following type alias, which is semantically equivalent to the real -->
<!-- `Option<T>` in every way: -->
`Result` 型は `Option` 型の豪華版です。
`Option` のように *不在* の可能性を示す代わりに、`Result` は *エラー* になる可能性を示します。
通常 *エラー* は、なぜ処理が実行に失敗したのかを説明するために用いられます。
これは厳密には `Option` をさらに一般化した形式だといえます。
以下のような型エイリアスがあるとしましょう。
これは全てにおいて、本物の `Option<T>` と等しいセマンティクスを持ちます。

```rust
type Option<T> = Result<T, ()>;
```

<!-- This fixes the second type parameter of `Result` to always be `()` (pronounced -->
<!-- “unit” or “empty tuple”). Exactly one value inhabits the `()` type: `()`. (Yup, -->
<!-- the type and value level terms have the same notation!) -->
これは `Result` の2番目の型引数を `()` （「ユニット」または「空タプル」と発音します）に固定したものです。
`()` 型のただ一つの値は `()` です。
（そうなんです。型レベルと値レベルの用語が、全く同じ表記法を持ちます!）

<!-- 用語集候補：type parameter　型引数、型パラメータ、unit　ユニット、empty tuple　空タプル -->

<!-- The `Result` type is a way of representing one of two possible outcomes in a -->
<!-- computation. By convention, one outcome is meant to be expected or “`Ok`” while -->
<!-- the other outcome is meant to be unexpected or “`Err`”. -->
`Result` 型は、処理の結果がとりうる2つの可能性のうち、1つを表すための方法です。
慣例に従い、一方が期待されている結果、つまり「`Ok`」となり、もう一方が予想外の結果、つまり「`Err`」になります。

<!-- Just like `Option`, the `Result` type also has an -->
<!-- [`unwrap` method -->
<!-- defined][7] -->
<!-- in the standard library. Let's define it: -->
`Option` と全く同じように、`Result` 型も標準ライブラリで [`unwrap` メソッドが定義されています][7] 。

```rust
# enum Result<T, E> { Ok(T), Err(E) }
impl<T, E: ::std::fmt::Debug> Result<T, E> {
    fn unwrap(self) -> T {
        match self {
            Result::Ok(val) => val,
            Result::Err(err) =>
              panic!("called `Result::unwrap()` on an `Err` value: {:?}", err),
        }
    }
}
```

> 訳注：
>
> called `Result::unwrap()` on an `Err` value: {:?}"：<br/>
> `Err` 値 {:?} に対して `Result::unwrap()` が呼ばれました

<!-- This is effectively the same as our [definition for -->
<!-- `Option::unwrap`](#code-option-def-unwrap), except it includes the -->
<!-- error value in the `panic!` message. This makes debugging easier, but -->
<!-- it also requires us to add a [`Debug`][8] constraint on the `E` type -->
<!-- parameter (which represents our error type). Since the vast majority -->
<!-- of types should satisfy the `Debug` constraint, this tends to work out -->
<!-- in practice. (`Debug` on a type simply means that there's a reasonable -->
<!-- way to print a human readable description of values with that type.) -->
これは実質的には私たちの [`Option::unwrap` の定義](#code-option-def-unwrap) と同じですが、 `panic!` メッセージにエラーの値が含まれているところが異なります。
これはデバッグをより簡単にしますが、一方で、（エラーの型を表す）型パラメータ `E` に [`Debug`][8] 制約を付けることが求められます。
大半の型は `Debug` 制約を満たしているので、実際のところ、うまくいく傾向にあります。
（`Debug` が型に付くということは、単にその型の値が、人間が読める形式で表示できることを意味しています。）

<!-- OK, let's move on to an example. -->
では、例を見ていきましょう。

<!-- ### Parsing integers -->
<span id="parsing-integers"></span>
### 整数をパースする

<!-- The Rust standard library makes converting strings to integers dead simple. -->
<!-- It's so easy in fact, that it is very tempting to write something like the -->
<!-- following: -->
Rustの標準ライブラリを使うと、文字列を整数に変換することが、すごく簡単にできます。
あまりにも簡単なので、実際のところ、以下のように書きたいという誘惑に負けることがあります：

```rust
fn double_number(number_str: &str) -> i32 {
    2 * number_str.parse::<i32>().unwrap()
}

fn main() {
    let n: i32 = double_number("10");
    assert_eq!(n, 20);
}
```

<!-- At this point, you should be skeptical of calling `unwrap`. For example, if -->
<!-- the string doesn't parse as a number, you'll get a panic: -->
すでにあなたは、`unwrap` を呼ぶことについて懐疑的になっているはずです。
例えば、文字列が数字としてパースできなければ、パニックが起こります。

```text
thread '<main>' panicked at 'called `Result::unwrap()` on an `Err` value: ParseIntError { kind: InvalidDigit }', /home/rustbuild/src/rust-buildbot/slave/beta-dist-rustc-linux/build/src/libcore/result.rs:729
```

<!-- This is rather unsightly, and if this happened inside a library you're -->
<!-- using, you might be understandably annoyed. Instead, we should try to -->
<!-- handle the error in our function and let the caller decide what to -->
<!-- do. This means changing the return type of `double_number`. But to -->
<!-- what? Well, that requires looking at the signature of the [`parse` -->
<!-- method][9] in the standard library: -->
これは少し目障りです。
もしあなたが使っているライブラリの中でこれが起こされたら、イライラするに違いありません。
代わりに、私たちの関数の中でエラーを処理し、呼び出し元にどうするのかを決めさせるべきです。
そのためには、`double_number` の戻り値の型（リターン型）を変更しなければなりません。
でも、一体何に？
ええと、これはつまり、標準ライブラリの [`parse` メソッド][9] のシグニチャを見ろということです。

```rust,ignore
impl str {
    fn parse<F: FromStr>(&self) -> Result<F, F::Err>;
}
```

<!-- Hmm. So we at least know that we need to use a `Result`. Certainly, it's -->
<!-- possible that this could have returned an `Option`. After all, a string either -->
<!-- parses as a number or it doesn't, right? That's certainly a reasonable way to -->
<!-- go, but the implementation internally distinguishes *why* the string didn't -->
<!-- parse as an integer. (Whether it's an empty string, an invalid digit, too big -->
<!-- or too small.) Therefore, using a `Result` makes sense because we want to -->
<!-- provide more information than simply “absence.” We want to say *why* the -->
<!-- parsing failed. You should try to emulate this line of reasoning when faced -->
<!-- with a choice between `Option` and `Result`. If you can provide detailed error -->
<!-- information, then you probably should. (We'll see more on this later.) -->
うむ。最低でも `Result` を使わないといけないことはわかりました。
もちろん、これが `Option` を戻すようにすることも可能だったでしょう。
結局のところ、文字列が数字としてパースできたかどうかが知りたいわけですよね？
それも悪いやり方ではありませんが、実装の内側では *なぜ* 文字列が整数としてパースできなかったを、ちゃんと区別しています。
（空の文字列だったのか、有効な数字でなかったのか、大きすぎたり、小さすぎたりしたのか。）
従って、`Result` を使ってより多くの情報を提供するほうが、単に「不在」を示すことよりも理にかなっています。
今後、もし `Option` と `Result` のどちらを選ぶという事態に遭遇した時は、このような理由付けのやり方を真似てみてください。
もし詳細なエラー情報を提供できるのなら、多分、それをしたほうがいいでしょう。
（後ほど別の例もお見せます。）

<!-- OK, but how do we write our return type? The `parse` method as defined -->
<!-- above is generic over all the different number types defined in the -->
<!-- standard library. We could (and probably should) also make our -->
<!-- function generic, but let's favor explicitness for the moment. We only -->
<!-- care about `i32`, so we need to [find its implementation of -->
<!-- `FromStr`](../std/primitive.i32.html) (do a `CTRL-F` in your browser -->
<!-- for “FromStr”) and look at its [associated type][10] `Err`. We did -->
<!-- this so we can find the concrete error type. In this case, it's -->
<!-- [`std::num::ParseIntError`](../std/num/struct.ParseIntError.html). -->
<!-- Finally, we can rewrite our function: -->
それでは、リターン型をどう書きましょうか？
上の `parse` メソッドは一般化されているので、標準ライブラリにある、あらゆる数値型について定義されています。
この関数を同じように一般化することもできますが（そして、そうするべきでしょうが）、今は明快さを優先しましょう。
`i32` だけを扱うことにしますので、それの [`FromStr` の実装がどうなっているか探しましょう](../std/primitive.i32.html) 。
（ブラウザで `CTRL-F` を押して「FromStr」を探します。）
そして [関連型（associated type）][10] から `Err` を見つけます。
こうすれば、具体的なエラー型が見つかります。
この場合、それは [`std::num::ParseIntError`](../std/num/struct.ParseIntError.html) です。
これでようやく関数を書き直せます：

```rust
use std::num::ParseIntError;

fn double_number(number_str: &str) -> Result<i32, ParseIntError> {
    match number_str.parse::<i32>() {
        Ok(n) => Ok(2 * n),
        Err(err) => Err(err),
    }
}

fn main() {
    match double_number("10") {
        Ok(n) => assert_eq!(n, 20),
        Err(err) => println!("Error: {:?}", err),
    }
}
```

<!-- This is a little better, but now we've written a lot more code! The case -->
<!-- analysis has once again bitten us. -->
これで少し良くなりましたが、たくさんのコードを書いてしまいました！
ケース分析に、またしてもやられたわけです。

<!-- Combinators to the rescue! Just like `Option`, `Result` has lots of combinators -->
<!-- defined as methods. There is a large intersection of common combinators between -->
<!-- `Result` and `Option`. In particular, `map` is part of that intersection: -->
コンビネータに助けを求めましょう！
ちょうど `Option` と同じように `Result` にもたくさんのコンビネータが、メソッドとして定義されています。
`Result` と `Option` の間では、共通のコンビネータが数多く存在します。
例えば `map` も共通なものの一つです：

```rust
use std::num::ParseIntError;

fn double_number(number_str: &str) -> Result<i32, ParseIntError> {
    number_str.parse::<i32>().map(|n| 2 * n)
}

fn main() {
    match double_number("10") {
        Ok(n) => assert_eq!(n, 20),
        Err(err) => println!("Error: {:?}", err),
    }
}
```

<!-- The usual suspects are all there for `Result`, including -->
<!-- [`unwrap_or`](../std/result/enum.Result.html#method.unwrap_or) and -->
<!-- [`and_then`](../std/result/enum.Result.html#method.and_then). -->
<!-- Additionally, since `Result` has a second type parameter, there are -->
<!-- combinators that affect only the error type, such as -->
<!-- [`map_err`](../std/result/enum.Result.html#method.map_err) (instead of -->
<!-- `map`) and [`or_else`](../std/result/enum.Result.html#method.or_else) -->
<!-- (instead of `and_then`). -->
`Result` でいつも候補にあがるのは [`unwrap_or`](../std/result/enum.Result.html#method.unwrap_or) と [`and_then`](../std/result/enum.Result.html#method.and_then) です。
さらに `Result` は2つ目の型パラメータを取りますので、エラー型だけに影響を与える [`map_err`](../std/result/enum.Result.html#method.map_err) （`map` に相当）と [`or_else`](../std/result/enum.Result.html#method.or_else) （`and_then` に相当）もあります。

<!-- ### The `Result` type alias idiom -->
<span id="the-result-type-alias-idiom"></span>
### `Result` 型エイリアスを用いたイディオム

<!-- In the standard library, you may frequently see types like -->
<!-- `Result<i32>`. But wait, [we defined `Result`](#code-result-def) to -->
<!-- have two type parameters. How can we get away with only specifying -->
<!-- one? The key is to define a `Result` type alias that *fixes* one of -->
<!-- the type parameters to a particular type. Usually the fixed type is -->
<!-- the error type. For example, our previous example parsing integers -->
<!-- could be rewritten like this: -->
標準ライブラリでは `Result<i32>` のような型をよく見ると思います。
でも、待ってください。
2つの型パラメータを取るように [`Result` を定義したはずです](#code-result-def) 。
どうして、1つだけを指定して済んだのでしょう？
種を明かすと、`Result` の型エイリアスを定義して、一方の型パラメータを特定の型に *固定* したのです。
通常はエラー型のほうを固定します。
例えば、先ほどの整数のパースの例は、こう書き換えることもできます。

```rust
use std::num::ParseIntError;
use std::result;

type Result<T> = result::Result<T, ParseIntError>;

fn double_number(number_str: &str) -> Result<i32> {
    unimplemented!();
}
```

<!-- Why would we do this? Well, if we have a lot of functions that could return -->
<!-- `ParseIntError`, then it's much more convenient to define an alias that always -->
<!-- uses `ParseIntError` so that we don't have to write it out all the time. -->
なぜ、こうするのでしょうか？
もし `ParseIntError` を返す関数をたくさん定義するとしたら、常に `ParseIntError` を使うエイリアスを定義したほうが便利だからです。
こうすれば、同じことを何度も書かずに済みます。

<!-- The most prominent place this idiom is used in the standard library is -->
<!-- with [`io::Result`](../std/io/type.Result.html). Typically, one writes -->
<!-- `io::Result<T>`, which makes it clear that you're using the `io` -->
<!-- module's type alias instead of the plain definition from -->
<!-- `std::result`. (This idiom is also used for -->
<!-- [`fmt::Result`](../std/fmt/type.Result.html).) -->
標準ライブラリで、このイディオムが際立って多く使われている場所では、[`io::Result`](../std/io/type.Result.html) を用いています。
それらは通常 `io::Result<T>` のように書かれ、`std::result` のプレーンな定義の代わりに `io` モジュールの型エイリアスを使っていることが、明確にわかるようになっています。

<!-- ## A brief interlude: unwrapping isn't evil -->
<span id="a-brief-interlude-unwrapping-isnt-evil"></span>
## 小休止：アンラップは悪ではない

<!-- If you've been following along, you might have noticed that I've taken a pretty -->
<!-- hard line against calling methods like `unwrap` that could `panic` and abort -->
<!-- your program. *Generally speaking*, this is good advice. -->
これまでの説明を読んだあなたは、 `unwrap` のような `panic` を起こし、プログラムをアボートするようなメソッドについて、私がきっぱりと否定する方針をとっていたことに気づいたかもしれません。
*一般的には* これは良いアドバイスです。

<!-- However, `unwrap` can still be used judiciously. What exactly justifies use of -->
<!-- `unwrap` is somewhat of a grey area and reasonable people can disagree. I'll -->
<!-- summarize some of my *opinions* on the matter. -->
しかしながら `unwrap` を使うのが懸命なこともあります。
どんな場合が `unwrap` の使用を正当化できるのかについては、グレーな部分があり、人によって意見が分かれます。
ここで、この問題についての、私の *個人的な意見* をまとめたいと思います。

<!-- * **In examples and quick 'n' dirty code.** Sometimes you're writing examples -->
<!--   or a quick program, and error handling simply isn't important. Beating the -->
<!--   convenience of `unwrap` can be hard in such scenarios, so it is very -->
<!--   appealing. -->
* **即興で書いたサンプルコード。**
  サンプルコードや簡単なプログラムを書いていて、エラーハンドリングが単に重要でないこともあります。
  このような時に `unwrap` の便利さは、とても魅力的に映るでしょう。
  これに打ち勝つのは難しいことです。

<!-- * **When panicking indicates a bug in the program.** When the invariants of -->
<!--   your code should prevent a certain case from happening (like, say, popping -->
<!--   from an empty stack), then panicking can be permissible. This is because it -->
<!--   exposes a bug in your program. This can be explicit, like from an `assert!` -->
<!--   failing, or it could be because your index into an array was out of bounds. -->
* **パニックがプログラムのバグの兆候となる時。**
  コードの中の不変的な条件が、ある特定のケースの発生を未然に防ぐ時（例えば、空のスタックから取り出そうとしたなど）、パニックを起こしても差し支えありません。
  なぜなら、そうすることでプログラムに潜むバグが明るみに出るからです。
  これは `assert!` の失敗のような明示的な要因によるものだったり、配列のインデックスが境界から外れたからだったりします。

<!-- This is probably not an exhaustive list. Moreover, when using an -->
<!-- `Option`, it is often better to use its -->
<!-- [`expect`](../std/option/enum.Option.html#method.expect) -->
<!-- method. `expect` does exactly the same thing as `unwrap`, except it -->
<!-- prints a message you give to `expect`. This makes the resulting panic -->
<!-- a bit nicer to deal with, since it will show your message instead of -->
<!-- “callaed unwrap on a `None` value.” -->
これは多分、完全なリストではないでしょう。
さらに `Option` を使う時は、ほとんどの場合で [`expect`](../std/option/enum.Option.html#method.expect) メソッドを使う方がいいでしょう。
`expect` は `unwrap` とほぼ同じことをしますが、 `expect` では与えられたメッセージを表示するところが異なります。
この方が結果として起こったパニックを、少し扱いやすいものにします。
なぜなら「 `None` な値に対してアンラップが呼ばれました」というメッセージの代わりに、指定したメッセージが表示されるからです。

<!-- My advice boils down to this: use good judgment. There's a reason why the words -->
<!-- “never do X” or “Y is considered harmful” don't appear in my writing. There are -->
<!-- trade offs to all things, and it is up to you as the programmer to determine -->
<!-- what is acceptable for your use cases. My goal is only to help you evaluate -->
<!-- trade offs as accurately as possible. -->
私のアドバイスを突き詰めると、よく見極めなさい、ということです。
私の書いた文章の中に「決して、Xをしてはならない」とか「Yは有害だと考えよう」といった言葉が現れないのには、れっきとした理由があります。
あるユースケースでこれが容認できるかどうかは、プログラマであるあなたの判断に委ねられます。
私が目指していることは、あなたがトレードオフをできるかぎり正確に評価できるよう、手助けをすることなのです。

<!-- Now that we've covered the basics of error handling in Rust, and -->
<!-- explained unwrapping, let's start exploring more of the standard -->
<!-- library. -->
これでRustにおけるエラーハンドリングの基礎をカバーできました。
また、アンラップについても解説しました。
では標準ライブラリをもっと探索しましょう。

<!-- # Working with multiple error types -->
<span id="working-with-multiple-error-types"></span>
# 複数のエラー型を扱う

<!-- Thus far, we've looked at error handling where everything was either an
<!-- `Option<T>` or a `Result<T, SomeError>`. But what happens when you have both an
<!-- `Option` and a `Result`? Or what if you have a `Result<T, Error1>` and a
<!-- `Result<T, Error2>`? Handling *composition of distinct error types* is the next
<!-- challenge in front of us, and it will be the major theme throughout the rest of
<!-- this chapter. -->
これまで見てきたエラーハンドリングは、単体の `Option<T>` または `Result<T, SomeError>` だけで構成されていました。
ではもし `Option` と `Result` の両方があったらどうなるでしょうか？
あるいは、`Result<T, Error1>` と `Result<T, Error2>` があったら？
*異なるエラー型の組み合わせ* を処理することが、いま目の前にある次の課題です。
またこれが、この章の残りの大半に共通する、主要なテーマとなります。

<!-- ## Composing `Option` and `Result` -->
<span id="composing-option-and-result"></span>
## `Option` と `Result` で構成する

<!-- So far, I've talked about combinators defined for `Option` and combinators -->
<!-- defined for `Result`. We can use these combinators to compose results of -->
<!-- different computations without doing explicit case analysis. -->
これまで話してきたのは `Option` のために定義されたコンビネータと、 `Result` のために定義されたコンビネータについてでした。
これらのコンビネータを使うと、様々な処理の結果を明示的なケース分析なしに組み合わせることができました。

<!-- Of course, in real code, things aren't always as clean. Sometimes you have a -->
<!-- mix of `Option` and `Result` types. Must we resort to explicit case analysis, -->
<!-- or can we continue using combinators? -->
もちろん現実のコードは、いつもこんなにクリーンではありません。
時には `Option` と `Result` 型が混在していることもあるでしょう。
そんな時は、明確なケース分析に頼るしかないのでしょうか？
それとも、コンビネータを使い続けることができるのでしょうか？

<!-- For now, let's revisit one of the first examples in this chapter: -->
ここで、この章の最初の方にあった例に戻ってみましょう：

```rust,should_panic
use std::env;

fn main() {
    let mut argv = env::args();
    let arg: String = argv.nth(1).unwrap(); // エラー1
    let n: i32 = arg.parse().unwrap(); // エラー2
    println!("{}", 2 * n);
}
```

<!-- Given our new found knowledge of `Option`, `Result` and their various -->
<!-- combinators, we should try to rewrite this so that errors are handled properly -->
<!-- and the program doesn't panic if there's an error. -->
これまでに獲得した知識、つまり `Option`、`Result` と、それらのコンビネータに関する知識を総動員して、これを書き換えましょう。
エラーを的確に処理し、もしエラーが起こっても、プログラムがパニックしないようにするのです。

<!-- The tricky aspect here is that `argv.nth(1)` produces an `Option` while -->
<!-- `arg.parse()` produces a `Result`. These aren't directly composable. When faced -->
<!-- with both an `Option` and a `Result`, the solution is *usually* to convert the -->
<!-- `Option` to a `Result`. In our case, the absence of a command line parameter -->
<!-- (from `env::args()`) means the user didn't invoke the program correctly. We -->
<!-- could just use a `String` to describe the error. Let's try: -->
ここでの問題は `argv.nth(1)` が `Option` を返すのに、 `arg.parse()` は `Result` を返すことです。
これらを直接合成することはできません。
`Option` と `Result` の両方に出会った時の *通常の* 解決策は `Option` を `Result` に変換することです。
この例で（`env::args()` が）コマンドライン引数を返さなかったということは、ユーザーがプログラムを正しく起動しなかったことを意味します。
エラーの理由を示すために、単純に `String` を使うこともできます。
試してみましょう：

<span id="code-error-double-string"></span>

```rust
use std::env;

fn double_arg(mut argv: env::Args) -> Result<i32, String> {
    argv.nth(1)
        .ok_or("Please give at least one argument".to_owned())
        .and_then(|arg| arg.parse::<i32>().map_err(|err| err.to_string()))
        .map(|n| 2 * n)
}

fn main() {
    match double_arg(env::args()) {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {}", err),
    }
}
```

> 訳注：
>
> Please give at least one argument：最低１つの引数を指定してください。

<!-- There are a couple new things in this example. The first is the use of the -->
<!-- [`Option::ok_or`](../std/option/enum.Option.html#method.ok_or) -->
<!-- combinator. This is one way to convert an `Option` into a `Result`. The -->
<!-- conversion requires you to specify what error to use if `Option` is `None`. -->
<!-- Like the other combinators we've seen, its definition is very simple: -->
この例では、いくつかの新しいことがあります。
ひとつ目は [`Option::ok_or`](../std/option/enum.Option.html#method.ok_or) コンビネータを使ったことです。
これは `Option` を `Result` へ変換する方法の一つです。
変換には `Option` が `None` の時に使われるエラーを指定する必要があります。
他のコンビネータと同様に、その定義はとてもシンプルです：

```rust
fn ok_or<T, E>(option: Option<T>, err: E) -> Result<T, E> {
    match option {
        Some(val) => Ok(val),
        None => Err(err),
    }
}
```

<!-- The other new combinator used here is -->
<!-- [`Result::map_err`](../std/result/enum.Result.html#method.map_err). -->
<!-- This is just like `Result::map`, except it maps a function on to the *error* -->
<!-- portion of a `Result` value. If the `Result` is an `Ok(...)` value, then it is -->
<!-- returned unmodified. -->
ここで使った、もう一つの新しいコンビネータは [`Result::map_err`](../std/result/enum.Result.html#method.map_err) です。
これは `Result::map` に似ていますが、 `Result` 値の *エラー* の部分に対して関数をマップするところが異なります。
もし `Result` の値が `Ok(...)` だったら、そのまま変更せずに返します。

<!-- We use `map_err` here because it is necessary for the error types to remain -->
<!-- the same (because of our use of `and_then`). Since we chose to convert the -->
<!-- `Option<String>` (from `argv.nth(1)`) to a `Result<String, String>`, we must -->
<!-- also convert the `ParseIntError` from `arg.parse()` to a `String`. -->
`map_err` を使った理由は、（`and_then` の用法により）エラーの型を同じに保つ必要があったからです。
ここでは（`argv.nth(1)`が返した） `Option<String>` を `Result<String, String>` に変換することを選んだため、`arg.parse()` が返した `ParseIntError` も `String` に変換しなければならなかったわけです。

<!-- ## The limits of combinators -->
<span id="the-limits-of-combinators"></span>
## コンビネータの限界

<!-- Doing IO and parsing input is a very common task, and it's one that I -->
<!-- personally have done a lot of in Rust. Therefore, we will use (and continue to -->
<!-- use) IO and various parsing routines to exemplify error handling. -->
入出力と共に入力をパースすることは、非常によく行われます。
そして私がRustを使って個人的にやってきたことのほとんども、これに該当しています。
ですから、ここでは（そして、この後も） IOと様々なパースを行うルーチンを、エラーハンドリングの例として扱っていきます。

<!-- Let's start simple. We are tasked with opening a file, reading all of its -->
<!-- contents and converting its contents to a number. Then we multiply it by `2` -->
<!-- and print the output. -->
まずは簡単なものから始めましょう。
ここでのタスクは、ファイルを開き、その内容を全て読み込み、1つの数値に変換することです。
そしてそれに `2` を掛けて、結果を表示します。

<!-- Although I've tried to convince you not to use `unwrap`, it can be useful -->
<!-- to first write your code using `unwrap`. It allows you to focus on your problem -->
<!-- instead of the error handling, and it exposes the points where proper error -->
<!-- handling need to occur. Let's start there so we can get a handle on the code, -->
<!-- and then refactor it to use better error handling. -->
いままで `unwrap` を使わないよう説得してきたわけですが、最初にコードを書くときには `unwrap` が便利に使えます。
こうすることで、エラーハンドリングではなく、本来解決すべき課題に集中できます。
それと同時に `unwrap` は、的確なエラーハンドリングが必要とされる場所を教えてくれます。
ここから始ることをコーディングへの取っ掛かりとしましょう。
その後、リファクタリングによって、エラーハンドリングを改善していきます。

```rust,should_panic
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> i32 {
    let mut file = File::open(file_path).unwrap(); // エラー1
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap(); // エラー2
    let n: i32 = contents.trim().parse().unwrap(); // エラー3
    2 * n
}

fn main() {
    let doubled = file_double("foobar");
    println!("{}", doubled);
}
```

<!-- (N.B. The `AsRef<Path>` is used because those are the -->
<!-- [same bounds used on -->
<!-- `std::fs::File::open`](../std/fs/struct.File.html#method.open). -->
<!-- This makes it ergonomic to use any kind of string as a file path.) -->
（備考： `AsRef<Path>` を使ったのは、[`std::fs::File::open` で使われているものと同じ境界](../std/fs/struct.File.html#method.open) だからです。
ファイルパスとして、どんな文字列でも受け付けるので、エルゴノミックになります。）

<!-- There are three different errors that can occur here: -->
ここでは3種類のエラーが起こる可能性があります：

<!-- 1. A problem opening the file. -->
<!-- 2. A problem reading data from the file. -->
<!-- 3. A problem parsing the data as a number. -->
1. ファイルを開くときの問題
2. ファイルからデータを読み込む時の問題
3. データを数値としてパースするときの問題

<!-- The first two problems are described via the -->
<!-- [`std::io::Error`](../std/io/struct.Error.html) type. We know this -->
<!-- because of the return types of -->
<!-- [`std::fs::File::open`](../std/fs/struct.File.html#method.open) and -->
<!-- [`std::io::Read::read_to_string`](../std/io/trait.Read.html#method.read_to_string). -->
<!-- (Note that they both use the [`Result` type alias -->
<!-- idiom](#the-result-type-alias-idiom) described previously. If you -->
<!-- click on the `Result` type, you'll [see the type -->
<!-- alias](../std/io/type.Result.html), and consequently, the underlying -->
<!-- `io::Error` type.)  The third problem is described by the -->
<!-- [`std::num::ParseIntError`](../std/num/struct.ParseIntError.html) -->
<!-- type. The `io::Error` type in particular is *pervasive* throughout the -->
<!-- standard library. You will see it again and again. -->
最初の2つの問題は、[`std::io::Error`](../std/io/struct.Error.html) 型で記述されます。
これは [`std::fs::File::open`](../std/fs/struct.File.html#method.open) と [`std::io::Read::read_to_string`](../std/io/trait.Read.html#method.read_to_string) のリターン型からわかります。
（ちなみにどちらも、以前紹介した [`Result` 型エイリアスのイディオム](#the-result-type-alias-idiom) を用いています。
`Result` 型のところをクリックすると、いま言った [型エイリアスを見たり](../std/io/type.Result.html)、必然的に、中で使われている `io::Error` 型も見ることになるでしょう。）
3番目の問題は [`std::num::ParseIntError`](../std/num/struct.ParseIntError.html) 型で記述されます。
特にこの `io::Error` 型は標準ライブラリ全体に *深く浸透しています* 。
これからこの型を幾度となく見ることでしょう。

<!-- Let's start the process of refactoring the `file_double` function. To make this -->
<!-- function composable with other components of the program, it should *not* panic -->
<!-- if any of the above error conditions are met. Effectively, this means that the -->
<!-- function should *return an error* if any of its operations fail. Our problem is -->
<!-- that the return type of `file_double` is `i32`, which does not give us any -->
<!-- useful way of reporting an error. Thus, we must start by changing the return -->
<!-- type from `i32` to something else. -->
まず最初に `file_double` 関数をリファクタリングしましょう。
この関数を、この課題の他の構成要素と合成可能にするためには、上記の問題のいずれかに遭遇しても、パニック *しない* ようにしなければなりません。
これは実質的には、なにかの操作に失敗した時に、この関数が *エラーを返すべき* であることを意味します。
ここでの問題は、`file_double` のリターン型が `i32` であるため、エラーの報告には全く役立たないことです。
従ってリターン型を `i32` から別の何かに変えることから始めましょう。

<!-- The first thing we need to decide: should we use `Option` or `Result`? We -->
<!-- certainly could use `Option` very easily. If any of the three errors occur, we -->
<!-- could simply return `None`. This will work *and it is better than panicking*, -->
<!-- but we can do a lot better. Instead, we should pass some detail about the error -->
<!-- that occurred. Since we want to express the *possibility of error*, we should -->
<!-- use `Result<i32, E>`. But what should `E` be? Since two *different* types of -->
<!-- errors can occur, we need to convert them to a common type. One such type is -->
<!-- `String`. Let's see how that impacts our code: -->
最初に決めるべきことは、 `Option` と `Result` のどちらを使うかです。
`Option` なら間違いなく簡単に使えます。
もし3つのエラーのどれかが起こったら、単に `None` を返せばいいのですから。
これはたしかに動きますし、 *パニックを起こすよりは良くなっています* 。
とはいえ、もっと良くすることもだってできます。
`Option` の代わりに、起こったエラーについての詳細を渡すべきでしょう。
ここでは *エラーの可能性* を示したいのですから、`Result<i32, E>` を使うのがよさそうです。
でも `E` を何にしたらいいのでしょうか？
2つの *異なる* 型のエラーが起こりえますので、これらを共通の型に変換する必要があります。
そのような型の一つに `String` があります。
この変更がコードにどんな影響を与えるか見てみましょう：

```rust
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, String> {
    File::open(file_path)
         .map_err(|err| err.to_string())
         .and_then(|mut file| {
              let mut contents = String::new();
              file.read_to_string(&mut contents)
                  .map_err(|err| err.to_string())
                  .map(|_| contents)
         })
         .and_then(|contents| {
              contents.trim().parse::<i32>()
                      .map_err(|err| err.to_string())
         })
         .map(|n| 2 * n)
}

fn main() {
    match file_double("foobar") {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {}", err),
    }
}
```

<!-- This code looks a bit hairy. It can take quite a bit of practice before code -->
<!-- like this becomes easy to write. The way we write it is by *following the -->
<!-- types*. As soon as we changed the return type of `file_double` to -->
<!-- `Result<i32, String>`, we had to start looking for the right combinators. In -->
<!-- this case, we only used three different combinators: `and_then`, `map` and -->
<!-- `map_err`. -->
このコードは、やや難解になってきました。
このようなコードを簡単に書けるようになるまでには、結構な量の練習が必要かもしれません。
こういうもの書くときは *型に導かれる* ようにします。
`file_double` のリターン型を `Result<i32, String>` に変更したらすぐに、それに合ったコンビネータを探し始めるのです。
この例では `and_then`, `map`, `map_err` の、3種類のコンビネータだけを使いました。

<!-- `and_then` is used to chain multiple computations where each computation could -->
<!-- return an error. After opening the file, there are two more computations that -->
<!-- could fail: reading from the file and parsing the contents as a number. -->
<!-- Correspondingly, there are two calls to `and_then`. -->
`and_then` は、エラーを返すかもしれない処理同士を繋いでいくために使います。
ファイルを開いた後に、失敗するかもしれない処理が2つあります：
ファイルからの読み込む所と、内容を数値としてパースする所です。
これに対応して `and_then` も2回呼ばれています。

<!-- `map` is used to apply a function to the `Ok(...)` value of a `Result`. For -->
<!-- example, the very last call to `map` multiplies the `Ok(...)` value (which is -->
<!-- an `i32`) by `2`. If an error had occurred before that point, this operation -->
<!-- would have been skipped because of how `map` is defined. -->
`map` は `Result` の値が `Ok(...)` の時に関数を適用するために使います。
例えば、一番最後の `map` の呼び出しは、`Ok(...)` の値（`i32` 型）に `2` を掛けます。
もし、これより前にエラーが起きたなら、この操作は `map` の定義に従ってスキップされます。

<!-- `map_err` is the trick that makes all of this work. `map_err` is just like -->
<!-- `map`, except it applies a function to the `Err(...)` value of a `Result`. In -->
<!-- this case, we want to convert all of our errors to one type: `String`. Since -->
<!-- both `io::Error` and `num::ParseIntError` implement `ToString`, we can call the -->
<!-- `to_string()` method to convert them. -->
`map_err` は全体をうまく動かすための仕掛けです。
`map_err` は `map` に似ていますが、 `Result` の値が `Err(...)` の時に関数を適用するところが異なります。
今回の場合は、全てのエラーを `String` という同一の型に変換する予定でした。
`io::Error` と `num::ParseIntError` の両方が `ToString` を実装していたので、 `to_string()` メソッドを呼ぶことで変換できました。

<!-- With all of that said, the code is still hairy. Mastering use of combinators is -->
<!-- important, but they have their limits. Let's try a different approach: early -->
<!-- returns. -->
説明し終わった後でも、このコードは難解なままです。
コンビネータの使い方をマスターすることは重要ですが、コンビネータには限界もあるのです。
次は、早期のリターンと呼ばれる、別のアプローチを試してみましょう。

<!-- ## Early returns -->
<span id="early-returns"></span>
## 早期のリターン

<!-- I'd like to take the code from the previous section and rewrite it using *early -->
<!-- returns*. Early returns let you exit the function early. We can't return early -->
<!-- in `file_double` from inside another closure, so we'll need to revert back to -->
<!-- explicit case analysis. -->
前の節で使ったコードを、 *早期のリターン* を使って書き直してみようと思います。
早期のリターンとは、関数の途中で抜けることを指します。
`file_double` のクロージャの中にいる間は、早期のリターンはできないので、明示的なケース分析までいったん戻る必要があります。

```rust
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, String> {
    let mut file = match File::open(file_path) {
        Ok(file) => file,
        Err(err) => return Err(err.to_string()),
    };
    let mut contents = String::new();
    if let Err(err) = file.read_to_string(&mut contents) {
        return Err(err.to_string());
    }
    let n: i32 = match contents.trim().parse() {
        Ok(n) => n,
        Err(err) => return Err(err.to_string()),
    };
    Ok(2 * n)
}

fn main() {
    match file_double("foobar") {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {}", err),
    }
}
```

<!-- Reasonable people can disagree over whether this code is better that the code -->
<!-- that uses combinators, but if you aren't familiar with the combinator approach, -->
<!-- this code looks simpler to read to me. It uses explicit case analysis with -->
<!-- `match` and `if let`. If an error occurs, it simply stops executing the -->
<!-- function and returns the error (by converting it to a string). -->
このコードが、コンビネータを使ったコードよりも良くなったのかについては、人によって意見が分かれるでしょう。
でも、もしあなたがコンビネータによるアプローチに不慣れだったら、このコードのほうが読みやすいと思うかもしれません。
ここでは明示的なケース分析を `match` と `if let` で行っています。
もしエラーが起きたら関数の実行を打ち切って、エラーを（文字列に変換してから）返します。

<!-- Isn't this a step backwards though? Previously, we said that the key to -->
<!-- ergonomic error handling is reducing explicit case analysis, yet we've reverted -->
<!-- back to explicit case analysis here. It turns out, there are *multiple* ways to -->
<!-- reduce explicit case analysis. Combinators aren't the only way. -->
でもこれって逆行してませんか？
以前は、エラーハンドリングをエルゴノミックにするために、明示的なケース分析を減らすべきだと言っていました。
それなのに、今は明示的なケース分析に戻ってしまっています。
すぐにわかりますが、明示的なケース分析を減らす方法は *複数* あるのです。
コンビネータが唯一の方法ではありません。

<!-- ## The `try!` macro -->
<span id="the-try-macro"></span>
## `try!` マクロ

<!-- A cornerstone of error handling in Rust is the `try!` macro. The `try!` macro -->
<!-- abstracts case analysis just like combinators, but unlike combinators, it also -->
<!-- abstracts *control flow*. Namely, it can abstract the *early return* pattern -->
<!-- seen above. -->
Rustでのエラー処理の基礎となるのは `try!` マクロです。
`try!` マクロはコンビネータと同様、ケース分析を抽象化します。
しかし、コンビネータと異なるのは *制御フロー* も抽象化してくれることです。
つまり、先ほど見た *早期リターン* のパターンを抽象化できるのです。

<!-- Here is a simplified definition of a `try!` macro: -->
`try!` マクロの簡略化した定義はこうなります：

<span id="code-try-def-simple"></span>

```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(err),
    });
}
```

<!-- (The [real definition](../std/macro.try!.html) is a bit more -->
<!-- sophisticated. We will address that later.) -->
（[本当の定義](../std/macro.try!.html) はもっと洗練されています。
後ほど紹介します。）

<!-- Using the `try!` macro makes it very easy to simplify our last example. Since -->
<!-- it does the case analysis and the early return for us, we get tighter code that -->
<!-- is easier to read: -->
`try!` マクロを使うと、最後の例をシンプルにすることが、とても簡単にできます。
ケース分析と早期リターンを肩代わりしてくれますので、コードが締まって読みやすくなります。

```rust
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, String> {
    let mut file = try!(File::open(file_path).map_err(|e| e.to_string()));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents).map_err(|e| e.to_string()));
    let n = try!(contents.trim().parse::<i32>().map_err(|e| e.to_string()));
    Ok(2 * n)
}

fn main() {
    match file_double("foobar") {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {}", err),
    }
}
```

<!-- The `map_err` calls are still necessary given -->
<!-- [our definition of `try!`](#code-try-def-simple). -->
<!-- This is because the error types still need to be converted to `String`. -->
<!-- The good news is that we will soon learn how to remove those `map_err` calls! -->
<!-- The bad news is that we will need to learn a bit more about a couple important -->
<!-- traits in the standard library before we can remove the `map_err` calls. -->
[今の私たちの `try!` の定義](#code-try-def-simple) ですと、 `map_err` は依然として必要です。
なぜなら、今でもエラー型を `String` 型に変換しなければならないからです。
でも、いい知らせがあります。
`map_err` の呼び出しを省く方法をすぐに習うのです！
悪い知らせは、`map_err` を省く前に、標準ライブラリのいくつかの重要なトレイトについて、もう少し学ぶ必要があるということです。

<!-- ## Defining your own error type -->
<span id="defining-your-own-error-type"></span>
## 独自のエラー型を定義する

<!-- Before we dive into some of the standard library error traits, I'd like to wrap -->
<!-- up this section by removing the use of `String` as our error type in the -->
<!-- previous examples. -->
標準ライブラリのいくつかのエラートレイトについて学ぶ前に、これまでの例にあったエラー型における `String` の使用を取り除くことで、この節を締めくくりたいと思います。

<!-- Using `String` as we did in our previous examples is convenient because it's -->
<!-- easy to convert errors to strings, or even make up your own errors as strings -->
<!-- on the spot. However, using `String` for your errors has some downsides. -->
これまでの例では `String` を便利に使ってきました。
なぜなら、エラーは簡単に文字列に変換できますし、エラーが起こったその場で、文字列によるエラーを新たに作ることもできるからです。
しかし `String` を使ってエラーを表すことには欠点もあります。

<!-- The first downside is that the error messages tend to clutter your -->
<!-- code. It's possible to define the error messages elsewhere, but unless -->
<!-- you're unusually disciplined, it is very tempting to embed the error -->
<!-- message into your code. Indeed, we did exactly this in a [previous -->
<!-- example](#code-error-double-string). -->
ひとつ目の欠点は、エラーメッセージがコードのあちこちに散らかる傾向があることです。
エラーメッセージをどこか別の場所でまとめて定義することもできますが、特別に訓練された人でない限りは、エラーメッセージをコードに埋め込むことへの誘惑に負けてしまうでしょう。
実際、私たちは [以前の例](#code-error-double-string) でも、全くこの通りのことをしました。

<!-- The second and more important downside is that `String`s are *lossy*. That is, -->
<!-- if all errors are converted to strings, then the errors we pass to the caller -->
<!-- become completely opaque. The only reasonable thing the caller can do with a -->
<!-- `String` error is show it to the user. Certainly, inspecting the string to -->
<!-- determine the type of error is not robust. (Admittedly, this downside is far -->
<!-- more important inside of a library as opposed to, say, an application.) -->
ふたつ目の、もっと重大な欠点は、 `String` への変換で *情報が欠落* することです。
もし全てのエラーを文字列に変換してしまったら、呼び出し元に渡したエラーが、不透明(opaque) になってしまいます。
呼び出し元が `String` のエラーに対してできる唯一妥当なことは、それをユーザーに表示することだけです。
文字列を解析して、どのタイプのエラーだったか判断するのは、もちろん強固なやり方とはいえません。
（この問題は、ライブラリーの中の方が、他のもの、例えばアプケーションよりも、間違いなく重大なものになるでしょう。）

<!-- For example, the `io::Error` type embeds an -->
<!-- [`io::ErrorKind`](../std/io/enum.ErrorKind.html), -->
<!-- which is *structured data* that represents what went wrong during an IO -->
<!-- operation. This is important because you might want to react differently -->
<!-- depending on the error. (e.g., A `BrokenPipe` error might mean quitting your -->
<!-- program gracefully while a `NotFound` error might mean exiting with an error -->
<!-- code and showing an error to the user.) With `io::ErrorKind`, the caller can -->
<!-- examine the type of an error with case analysis, which is strictly superior -->
<!-- to trying to tease out the details of an error inside of a `String`. -->
例えば `io::Error` 型には [`io::ErrorKind`](../std/io/enum.ErrorKind.html) が埋め込まれます。
これは *構造化されたデータ* で、IO操作において何が失敗したのかを示します。
エラーによって違った対応を取りたいこともあるので、このことは重要です。
（例： あなたのアプリケーションでは `BrokenPipe` エラーは正規の手順を踏んだ終了を意味し、 `NotFound` エラーはエラーコードと共に異常終了して、ユーザーにエラーを表示することを意味するかもしれません。）
`io::ErrorKind` なら、呼び出し元でエラーの種類を調査するために、ケース分析が使えます。
これは `String` の中からエラーの詳細がなんだったのか探りだすことよりも、明らかに優れています。

<!-- Instead of using a `String` as an error type in our previous example of reading -->
<!-- an integer from a file, we can define our own error type that represents errors -->
<!-- with *structured data*. We endeavor to not drop information from underlying -->
<!-- errors in case the caller wants to inspect the details. -->
ファイルから整数値を取り出す例で `String` をエラー型として用いた代わりに、独自のエラー型を定義し、 *構造化データ* によってエラー内容を表すことができます。
呼び出し元が詳細を検査したい時に備え、大元のエラーについての情報を取りこぼさないよう、努力してみましょう。

<!-- The ideal way to represent *one of many possibilities* is to define our own -->
<!-- sum type using `enum`. In our case, an error is either an `io::Error` or a -->
<!-- `num::ParseIntError`, so a natural definition arises: -->
*多くの可能性のうちの一つ* を表す理想的な方法は、 `enum` を使って独自の直和型を定義することです。
このケースでは、エラーは `io::Error` もしくは `num::ParseIntError` でした。
ここから思い浮かぶ自然な定義は：

```rust
use std::io;
use std::num;

# // We derive `Debug` because all types should probably derive `Debug`.
# // This gives us a reasonable human readable description of `CliError` values.
// 全ての型は `Debug` を導出するべきでしょうから、ここでも `Debug` を導出します。
// これにより `CliError` 値について、人間が十分理解できる説明を得られます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}
```

<!-- Tweaking our code is very easy. Instead of converting errors to strings, we -->
<!-- simply convert them to our `CliError` type using the corresponding value -->
<!-- constructor: -->
コードの微調整はいとも簡単です。
エラーを文字列に変換する代わりに、エラーに対応する値コンストラクタを用いて `CliError` 型に変換すればいいのです：

```rust
# #[derive(Debug)]
# enum CliError { Io(::std::io::Error), Parse(::std::num::ParseIntError) }
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, CliError> {
    let mut file = try!(File::open(file_path).map_err(CliError::Io));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents).map_err(CliError::Io));
    let n: i32 = try!(contents.trim().parse().map_err(CliError::Parse));
    Ok(2 * n)
}

fn main() {
    match file_double("foobar") {
        Ok(n) => println!("{}", n),
        Err(err) => println!("Error: {:?}", err),
    }
}
```

<!-- The only change here is switching `map_err(|e| e.to_string())` (which converts -->
<!-- errors to strings) to `map_err(CliError::Io)` or `map_err(CliError::Parse)`. -->
<!-- The *caller* gets to decide the level of detail to report to the user. In -->
<!-- effect, using a `String` as an error type removes choices from the caller while -->
<!-- using a custom `enum` error type like `CliError` gives the caller all of the -->
<!-- conveniences as before in addition to *structured data* describing the error. -->
ここでの変更点は、（エラーを文字列に変換する） `map_err(|e| e.to_string())` を、`map_err(CliError::Io)` や `map_err(CliError::Parse)` へ切り替えたことです。
こうして *呼び出し元* が、ユーザーに対してどの程度の詳細を報告するか決められるようになりました。
`String` をエラー型として用いることは、事実上、呼び出し元からこうした選択肢を奪ってしまいます。
`CliError` のような独自の `enum` エラー型を用いることは、 *構造化データ* によるエラーの説明だけでなく、これまでと同様の使いやすさをもたらします。

<!-- A rule of thumb is to define your own error type, but a `String` error type -->
<!-- will do in a pinch, particularly if you're writing an application. If you're -->
<!-- writing a library, defining your own error type should be strongly preferred so -->
<!-- that you don't remove choices from the caller unnecessarily. -->
目安となる方法は独自のエラー型を定義することですが、 `String` エラー型も、いざという時に役立ちます。
特にアプリケーションを書いている時などはそうです。
もしライブラリを書いているのなら、呼び出し元の選択肢を理由もなく奪わないために、独自のエラー型を定義することを強く推奨します。

<!-- # Standard library traits used for error handling -->
<span id="standard-library-traits-used-for-error-handling"></span>
# 標準ライブラリのトレイトによるエラー処理

<!-- The standard library defines two integral traits for error handling: -->
<!-- [`std::error::Error`](../std/error/trait.Error.html) and -->
<!-- [`std::convert::From`](../std/convert/trait.From.html). While `Error` -->
<!-- is designed specifically for generically describing errors, the `From` -->
<!-- trait serves a more general role for converting values between two -->
<!-- distinct types. -->
標準ライブラリでは、エラーハンドリングに欠かせないトレイトが、2つ定義されています：
[`std::error::Error`](../std/error/trait.Error.html) と [`std::convert::From`](../std/convert/trait.From.html) です。
`Error` はエラーを総称的に説明することに特化して設計されているのに対し、 `From` トレイトはもっと汎用的な、2つの異なる型の間で値を変換する役割を担います。

<!-- ## The `Error` trait -->
<span id="the-error-trait"></span>
## `Error` トレイト

<!-- The `Error` trait is [defined in the standard -->
<!-- library](../std/error/trait.Error.html): -->
`Error` トレイトは [標準ライブラリで定義されています](../std/error/trait.Error.html) ：

```rust
use std::fmt::{Debug, Display};

trait Error: Debug + Display {
#  /// A short description of the error.
  /// エラーの簡単な説明
  fn description(&self) -> &str;

#   /// The lower level cause of this error, if any.
  /// このエラーの一段下のレベルの原因（もしあれば）
  fn cause(&self) -> Option<&Error> { None }
}
```

<!-- This trait is super generic because it is meant to be implemented for *all* -->
<!-- types that represent errors. This will prove useful for writing composable code -->
<!-- as we'll see later. Otherwise, the trait allows you to do at least the -->
<!-- following things: -->
このトレイトはエラーを表す *全て* の型で実装されることを目的としており、ごく一般的なデフォルト実装を持ちます。
この後すぐ見るように、このことが合成可能なコードを書くことに一役買っていることが証明されます。
一方で、このトレイトは最低でも以下のようなカスタマイズを可能にします：

<!-- * Obtain a `Debug` representation of the error. -->
<!-- * Obtain a user-facing `Display` representation of the error. -->
<!-- * Obtain a short description of the error (via the `description` method). -->
<!-- * Inspect the causal chain of an error, if one exists (via the `cause` method). -->
* エラーの `Debug` 表現を取得する
* エラーのユーザー向けの `Display` 表現を取得する
* エラーの簡単な説明を取得する（`cause` メソッドを使用）
* エラーの因果関係のチェーンが提供されているなら、それを調べる（`cause` メソッドを使用）

<!-- The first two are a result of `Error` requiring impls for both `Debug` and -->
<!-- `Display`. The latter two are from the two methods defined on `Error`. The -->
<!-- power of `Error` comes from the fact that all error types impl `Error`, which -->
<!-- means errors can be existentially quantified as a -->
<!-- [trait object](../book/trait-objects.html). -->
<!-- This manifests as either `Box<Error>` or `&Error`. Indeed, the `cause` method -->
<!-- returns an `&Error`, which is itself a trait object. We'll revisit the -->
<!-- `Error` trait's utility as a trait object later. -->
<!-- 訳者メモ：existentially quantified について：http://tnomura9.exblog.jp/15148048/ -->
最初の2つは `Error` が `Debug` と `Display` の実装を必要としていることに由来します。
残りの2つは `Error` が定義している2つのメソッドに由来します。
`Error` の強みは、実際に全てのエラー型が `Error` を実装していることから来ています。
このことは、全てのエラーを1つの [トレイトオブジェクト](../book/trait-objects.html) へ存在量子化(existentially quantify) できることを意味します。
これは `Box<Error>` または `&Error` と書くことで表明できます。
まさに `cause` メソッドは `&Error` を返し、それ自身がトレイトオブジェクトです。
`Error` トレイトのトレイトオブジェクトとしての用例については、後ほど再び取り上げます。

<!-- For now, it suffices to show an example implementing the `Error` trait. Let's -->
<!-- use the error type we defined in the -->
<!-- [previous section](#defining-your-own-error-type): -->
`Error` トレイトの実装例を見せるには十分でしょう。
[前の節](#defining-your-own-error-type) で定義したエラー型を使ってみましょう：

```rust
use std::io;
use std::num;

# // We derive `Debug` because all types should probably derive `Debug`.
# // This gives us a reasonable human readable description of `CliError` values.
// 全ての型は `Debug` を導出するべきでしょうから、ここでも `Debug` を導出します。
// これにより `CliError` 値について、人間が十分理解できる説明を得られます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}
```

<!-- This particular error type represents the possibility of two types of errors -->
<!-- occurring: an error dealing with I/O or an error converting a string to a -->
<!-- number. The error could represent as many error types as you want by adding new -->
<!-- variants to the `enum` definition. -->
このエラー型は2種類のエラー、つまり、IOを扱っている時のエラー、または、文字列を通知に変換するときのエラーが起こる可能性を示しています。
`enum` 定義にバリエーションを加えることで、エラーの種類をいくらでも表現できます。

<!-- Implementing `Error` is pretty straight-forward. It's mostly going to be a lot -->
<!-- explicit case analysis. -->
`Error` を実装するのは実に単純な作業です。
ほとんどの場合は明示的なケース分析の繰り返しになります。

```rust,ignore
use std::error;
use std::fmt;

impl fmt::Display for CliError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
#           // Both underlying errors already impl `Display`, so we defer to
#           // their implementations.
            // 下層のエラーは両方ともすでに `Display` を実装しているので、
            // それらの実装に従います。
            CliError::Io(ref err) => write!(f, "IO error: {}", err),
            CliError::Parse(ref err) => write!(f, "Parse error: {}", err),
        }
    }
}

impl error::Error for CliError {
    fn description(&self) -> &str {
#       // Both underlying errors already impl `Error`, so we defer to their
#       // implementations.
        // 下層のエラーは両方ともすでに `Error` を実装しているので、
        // それらの実装に従います。
        match *self {
            CliError::Io(ref err) => err.description(),
            CliError::Parse(ref err) => err.description(),
        }
    }

    fn cause(&self) -> Option<&error::Error> {
        match *self {
#           // N.B. Both of these implicitly cast `err` from their concrete
#           // types (either `&io::Error` or `&num::ParseIntError`)
#           // to a trait object `&Error`. This works because both error types
#           // implement `Error`.
            // 注意：これらは両方とも `err` を、その具体型（`&io::Error` か
            // `&num::ParseIntError` のいずれか）から、トレイトオブジェクト
            // `&Error` へ暗黙的にキャストします。どちらのエラー型も `Error` を
            // 実装しているので、問題なく動きます。
            CliError::Io(ref err) => Some(err),
            CliError::Parse(ref err) => Some(err),
        }
    }
}
```

<!-- We note that this is a very typical implementation of `Error`: match on your -->
<!-- different error types and satisfy the contracts defined for `description` and -->
<!-- `cause`. -->
これは極めて典型的な `Error` の実装だということに留意してください。
このように、異なるエラー型にマッチさせて、`description` と `cause` のコントラクトを満たします。

<!-- ## The `From` trait -->
<span id="the-from-trait"></span>
## `From` トレイト

<!-- The `std::convert::From` trait is -->
<!-- [defined in the standard -->
<!-- library](../std/convert/trait.From.html): -->
`std::convert::From` は [標準ライブラリで定義されています](../std/convert/trait.From.html) ：

<span id="code-from-def"></span>

```rust
trait From<T> {
    fn from(T) -> Self;
}
```

<!-- Deliciously simple, yes? `From` is very useful because it gives us a generic -->
<!-- way to talk about conversion *from* a particular type `T` to some other type -->
<!-- (in this case, “some other type” is the subject of the impl, or `Self`). -->
<!-- The crux of `From` is the -->
<!-- [set of implementations provided by the standard -->
<!-- library](../std/convert/trait.From.html). -->
嬉しいくらい簡単でしょ？
`From` は、ある特定の型 `T` から違う型へ変換するための汎用的な方法を提供するので大変便利です
（この場合の「違う型」とは実装の対象、つまり `Self` です）。
`From` で最も重要なのは [標準ライブラリで提供される一連の実装です](../std/convert/trait.From.html)。

<!-- Here are a few simple examples demonstrating how `From` works: -->
`From` がどのように動くか、いくつかの例を使って紹介しましょう：

```rust
let string: String = From::from("foo");
let bytes: Vec<u8> = From::from("foo");
let cow: ::std::borrow::Cow<str> = From::from("foo");
```

<!-- OK, so `From` is useful for converting between strings. But what about errors? -->
<!-- It turns out, there is one critical impl: -->
たしかに `From` が文字列を変換するのに便利なことはわかりました。
でもエラーについてはどうでしょうか？
結論から言うと、これが最も重要な実装です：

```rust,ignore
impl<'a, E: Error + 'a> From<E> for Box<Error + 'a>
```

<!-- This impl says that for *any* type that impls `Error`, we can convert it to a -->
<!-- trait object `Box<Error>`. This may not seem terribly surprising, but it is -->
<!-- useful in a generic context. -->
この実装では、 `Error` を実装した *全て* の型は、トレイトオブジェクト `Box<Error>` に変換できると言っています。
これは、あまり驚くほどのものには見えませんが、一般的な状況では有用です。

<!-- Remember the two errors we were dealing with previously? Specifically, -->
<!-- `io::Error` and `num::ParseIntError`. Since both impl `Error`, they work with -->
<!-- `From`: -->
さっき扱った2つのエラーを覚えてますか？
具体的には `io::Error` と `num::ParseIntError` でした。
どちらも `Error` を実装していますので `From` で動きます。

```rust
use std::error::Error;
use std::fs;
use std::io;
use std::num;

# // We have to jump through some hoops to actually get error values.
// エラーの値に本当にたどり着くまで、何段階かのステップが必要です。
let io_err: io::Error = io::Error::last_os_error();
let parse_err: num::ParseIntError = "not a number".parse::<i32>().unwrap_err();

# // OK, here are the conversions.
// では、こちらで変換します。
let err1: Box<Error> = From::from(io_err);
let err2: Box<Error> = From::from(parse_err);
```

<!-- There is a really important pattern to recognize here. Both `err1` and `err2` -->
<!-- have the *same type*. This is because they are existentially quantified types, -->
<!-- or trait objects. In particular, their underlying type is *erased* from the -->
<!-- compiler's knowledge, so it truly sees `err1` and `err2` as exactly the same. -->
<!-- Additionally, we constructed `err1` and `err2` using precisely the same -->
<!-- function call: `From::from`. This is because `From::from` is overloaded on both -->
<!-- its argument and its return type. -->
ここに認識すべき、本当に重要なパターンがあります。
`err1` と `err2` の両方ともが *同じ型* になっているのです。
なぜなら、それらが存在量子型、つまり、トレイトオブジェクトだからです。
特にそれらの背後の型は、コンパイラーの知識から *消去されます* ので、 `err1` と `err2` が本当に同じに見えるのです。
さらに私たちは同じ関数呼び出し `From::from` を使って `err1` と `err2` をコンストラクトしました。
これは `From::from` が引数とリターン型の両方でオーバーライドされているからです。

<!-- This pattern is important because it solves a problem we had earlier: it gives -->
<!-- us a way to reliably convert errors to the same type using the same function. -->
このパターンは重要です。
なぜなら、私たちが以前抱えていた問題を解決するからです。
同じ関数を使って、エラーを同一の型に変換する、確かな方法を提供するからです。

<!-- Time to revisit an old friend; the `try!` macro. -->
いよいよ、私たちの旧友 `try!` マクロを再訪する時が訪れました。

<!-- ## The real `try!` macro -->
<span id="the-real-try-macro"></span>
## 本当の `try!` マクロ

<!-- Previously, we presented this definition of `try!`: -->
以前、`try!` はこのように定義されていると提示されました。

```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(err),
    });
}
```

<!-- This is not its real definition. Its real definition is -->
<!-- [in the standard library](../std/macro.try!.html): -->
これは本当の定義ではありません。
本当の定義は [標準ライブラリの中にあります](../std/macro.try!.html)：

<span id="code-try-def"></span>

```rust
macro_rules! try {
    ($e:expr) => (match $e {
        Ok(val) => val,
        Err(err) => return Err(::std::convert::From::from(err)),
    });
}
```

<!-- There's one tiny but powerful change: the error value is passed through -->
<!-- `From::from`. This makes the `try!` macro a lot more powerful because it gives -->
<!-- you automatic type conversion for free. -->
ここには、たった一つですが、大きな違いがあります：
エラーの値は `From::from` を経て渡されるのです。
これにより `try!` マクロは、はるかに強力になります。
なぜなら、自動的な型変換をただで手に入れられるのですから。

<!-- Armed with our more powerful `try!` macro, let's take a look at code we wrote -->
<!-- previously to read a file and convert its contents to an integer: -->
強力になった `try!` マクロを手に入れたので、以前書いた、ファイルを読み込んで内容を整数値に変換するコードを見直してみましょう：

```rust
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, String> {
    let mut file = try!(File::open(file_path).map_err(|e| e.to_string()));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents).map_err(|e| e.to_string()));
    let n = try!(contents.trim().parse::<i32>().map_err(|e| e.to_string()));
    Ok(2 * n)
}
```

<!-- Earlier, we promised that we could get rid of the `map_err` calls. Indeed, all -->
<!-- we have to do is pick a type that `From` works with. As we saw in the previous -->
<!-- section, `From` has an impl that lets it convert any error type into a -->
<!-- `Box<Error>`: -->
以前 `map_err` の呼び出しを取り除くことができると約束しました。
もちろんです。ここでしなければいけないのは `From` と共に動く型を一つ選ぶことです。
前の節で見たように `From` の実装の一つは、どんなエラー型でも `Box<Error>` に変換できます：

```rust
use std::error::Error;
use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, Box<Error>> {
    let mut file = try!(File::open(file_path));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents));
    let n = try!(contents.trim().parse::<i32>());
    Ok(2 * n)
}
```

<!-- We are getting very close to ideal error handling. Our code has very little -->
<!-- overhead as a result from error handling because the `try!` macro encapsulates -->
<!-- three things simultaneously: -->
理想的なエラーハンドリングまで、あと一歩です。
私たちのコードには、エラーハンドリングを終えた後も、ごくわずかなオーバーヘッドしかありません。
これは `try!` マクロが同時に3つのことをカプセル化するからです：

<!-- 1. Case analysis. -->
<!-- 2. Control flow. -->
<!-- 3. Eraror type conversion. -->
1. ケース分析
2. 制御フロー
3. エラー型の変換

<!-- When all three things are combined, we get code that is unencumbered by -->
<!-- combinators, calls to `unwrap` or case analysis. -->
これら3つが一つになった時、コンビネータ、 `unwrap` の呼び出し、ケース分析などの邪魔者を排除したコードが得られるのです。

<!-- There's one little nit left: the `Box<Error>` type is *opaque*. If we -->
<!-- return a `Box<Error>` to the caller, the caller can't (easily) inspect -->
<!-- underlying error type. The situation is certainly better than `String` -->
<!-- because the caller can call methods like -->
<!-- [`description`](../std/error/trait.Error.html#tymethod.description) -->
<!-- and [`cause`](../std/error/trait.Error.html#method.cause), but the -->
<!-- limitation remains: `Box<Error>` is opaque. (N.B. This isn't entirely -->
<!-- true because Rust does have runtime reflection, which is useful in -->
<!-- some scenarios that are [beyond the scope of this -->
<!-- chapter](https://crates.io/crates/error).) -->
あとひとつ、些細なことが残っています：
`Box<Error>` 型は *不透明(opaque)* なのです。
もし `Box<Error>` を呼び出し元に返すと、呼び出し元では背後のエラー型が何であるかを、（簡単には）調べられません。
この状況は `String` を返すよりは明らかに改善されてます。
なぜなら、呼び出し元では [`description`](../std/error/trait.Error.html#tymethod.description) や [`cause`](../std/error/trait.Error.html#method.cause) といったメソッドを呼ぶこともできるからです。
しかし `Box<Error>` が不透明であるという制限は残ります。
（注意：これは完全な真実ではありません。
なぜならRustでは実行時のリフレクションができるからです。
この方法が有効なシナリオもありますが、[この章で扱う範囲を超えています](https://crates.io/crates/error) ）

<!-- It's time to revisit our custom `CliError` type and tie everything together. -->
では、私たちのカスタムエラー型 `CliErro` に戻って、全てを一つにまとめ上げましょう。

<!-- ## Composing custom error types -->
<span id="composing-custom-error-types"></span>
## 独自のエラー型で構成する

<!-- In the last section, we looked at the real `try!` macro and how it does -->
<!-- automatic type conversion for us by calling `From::from` on the error value. -->
<!-- In particular, we converted errors to `Box<Error>`, which works, but the type -->
<!-- is opaque to callers. -->
最後の説では `try!` マクロの本当の定義を確認し、それが `From::from` をエラーの値に対して呼ぶことで、自動的な型変換をする様子を見ました。
特にそこでは、エラーを `Box<Error>` に変換しました。
これはたしかに動きますが、呼び出し元にとって型が不透明になってしまいました。

<!-- To fix this, we use the same remedy that we're already familiar with: a custom -->
<!-- error type. Once again, here is the code that reads the contents of a file and -->
<!-- converts it to an integer: -->
これを直すために、すでによく知っている改善方法である独自のエラー型を使いましょう。
もう一度、ファイルの内容を読み込んで整数値に変換するコードです：

```rust
use std::fs::File;
use std::io::{self, Read};
use std::num;
use std::path::Path;

# // We derive `Debug` because all types should probably derive `Debug`.
# // This gives us a reasonable human readable description of `CliError` values.
// 全ての型は `Debug` を導出するべきでしょうから、ここでも `Debug` を導出します。
// これにより `CliError` 値について、人間が十分理解できる説明を得られます。
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Parse(num::ParseIntError),
}

fn file_double_verbose<P: AsRef<Path>>(file_path: P) -> Result<i32, CliError> {
    let mut file = try!(File::open(file_path).map_err(CliError::Io));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents).map_err(CliError::Io));
    let n: i32 = try!(contents.trim().parse().map_err(CliError::Parse));
    Ok(2 * n)
}
```

<!-- Notice that we still have the calls to `map_err`. Why? Well, recall the -->
<!-- definitions of [`try!`](#code-try-def) and [`From`](#code-from-def). The -->
<!-- problem is that there is no `From` impl that allows us to convert from error -->
<!-- types like `io::Error` and `num::ParseIntError` to our own custom `CliError`. -->
<!-- Of course, it is easy to fix this! Since we defined `CliError`, we can impl -->
<!-- `From` with it: -->
`map_err` がまだあることに注目してください。
なぜって、 [`try!`](#code-try-def) と [`From`](#code-from-def) の定義を思い出してください。
ここでの問題は `io::Error` や `num::ParseIntError` といったエラー型を、私たち独自の `CliError` に変換できる `From` の実装が無いことです。
もちろん、これは簡単に直せます！
`CliError` を定義したわけですから、それに対して `From` を実装できます：

```rust
# #[derive(Debug)]
# enum CliError { Io(io::Error), Parse(num::ParseIntError) }
use std::io;
use std::num;

impl From<io::Error> for CliError {
    fn from(err: io::Error) -> CliError {
        CliError::Io(err)
    }
}

impl From<num::ParseIntError> for CliError {
    fn from(err: num::ParseIntError) -> CliError {
        CliError::Parse(err)
    }
}
```

<!-- All these impls are doing is teaching `From` how to create a `CliError` from -->
<!-- other error types. In our case, construction is as simple as invoking the -->
<!-- corresponding value constructor. Indeed, it is *typically* this easy. -->
これらの実装がしていることは、`From` に対して、どうやって他のエラー型を元に `CliError` を作るのかを教えてあげることです。
このケースでは、単に対応する値コンストラクタを呼ぶことで構築しています。
本当に *普通は* これくらい簡単にできてしまいます。

<!-- We can finally rewrite `file_double`: -->
これでようやく `file_double` を書き直せます：

```rust
# use std::io;
# use std::num;
# enum CliError { Io(::std::io::Error), Parse(::std::num::ParseIntError) }
# impl From<io::Error> for CliError {
#     fn from(err: io::Error) -> CliError { CliError::Io(err) }
# }
# impl From<num::ParseIntError> for CliError {
#     fn from(err: num::ParseIntError) -> CliError { CliError::Parse(err) }
# }

use std::fs::File;
use std::io::Read;
use std::path::Path;

fn file_double<P: AsRef<Path>>(file_path: P) -> Result<i32, CliError> {
    let mut file = try!(File::open(file_path));
    let mut contents = String::new();
    try!(file.read_to_string(&mut contents));
    let n: i32 = try!(contents.trim().parse());
    Ok(2 * n)
}
```

<!-- The only thing we did here was remove the calls to `map_err`. They are no -->
<!-- longer needed because the `try!` macro invokes `From::from` on the error value. -->
<!-- This works because we've provided `From` impls for all the error types that -->
<!-- could appear. -->
ここでしたのは `map_err` を取り除くことだけです。
それらは `try!` マクロがエラーの値に対して `From::from` を呼ぶので、もう不要になりました。
これで動くのは、起こりうる全てのエラー型に対して `From` の実装を提供したからです。

<!-- If we modified our `file_double` function to perform some other operation, say, -->
<!-- convert a string to a float, then we'd need to add a new variant to our error -->
<!-- type: -->
もし `file_double` 関数を変更して、なにか他の操作、例えば、文字列を浮動小数点数に変換させたい、と思ったら、エラー型のバリエーションを追加するだけです：

```rust
use std::io;
use std::num;

enum CliError {
    Io(io::Error),
    ParseInt(num::ParseIntError),
    ParseFloat(num::ParseFloatError),
}
```

<!-- And add a new `From` impl: -->

```rust
# enum CliError {
#     Io(::std::io::Error),
#     ParseInt(num::ParseIntError),
#     ParseFloat(num::ParseFloatError),
# }

use std::num;

impl From<num::ParseFloatError> for CliError {
    fn from(err: num::ParseFloatError) -> CliError {
        CliError::ParseFloat(err)
    }
}
```

<!-- And that's it! -->
これで完成です！

<!-- ## Advice for library writers -->
<span id="advice-for-library-writers"></span>
## ライブラリ作者たちへのアドバイス

<!-- If your library needs to report custom errors, then you should -->
<!-- probably define your own error type. It's up to you whether or not to -->
<!-- expose its representation (like -->
<!-- [`ErrorKind`](../std/io/enum.ErrorKind.html)) or keep it hidden (like -->
<!-- [`ParseIntError`](../std/num/struct.ParseIntError.html)). Regardless -->
<!-- of how you do it, it's usually good practice to at least provide some -->
<!-- information about the error beyond just its `String` -->
<!-- representation. But certainly, this will vary depending on use cases. -->
もし、あなたのライブラリーがカスタマイズされたエラーを報告しなければならないなら、恐らく、独自のエラー型を定義するべきでしょう。
エラーの表現を表にさらすか（例： [`ErrorKind`](../std/io/enum.ErrorKind.html) ） 、隠しておくか（例： [`ParseIntError`](../std/num/struct.ParseIntError.html) ）は、あなたの自由です。
いずれかに関係なく、最低でも `String` による表現を超えたエラー情報を提供することが、ほとんどの場合、良い方法となるしょう。
しかしこれは疑いなく、ユースケースに大きく依存します。

<!-- At a minimum, you should probably implement the -->
<!-- [`Error`](../std/error/trait.Error.html) -->
<!-- trait. This will give users of your library some minimum flexibility for -->
<!-- [composing errors](#the-real-try-macro). Implementing the `Error` trait also -->
<!-- means that users are guaranteed the ability to obtain a string representation -->
<!-- of an error (because it requires impls for both `fmt::Debug` and -->
<!-- `fmt::Display`). -->
最低でも [`Error`](../std/error/trait.Error.html) トレイトを実装するべきでしょう。
これにより、ライブラリの利用者に [エラーを合成する](#the-real-try-macro) ための、最低ラインの柔軟性を与えます。
`Error` トレイトを実装することは、利用者がエラーの文字列表現を取得できると保証することにもなります（なぜなら、こうすると `fmt::Debug` と `fmt::Display` の実装が必須になるからです）。

<!-- Beyond that, it can also be useful to provide implementations of `From` on your -->
<!-- error types. This allows you (the library author) and your users to -->
<!-- [compose more detailed errors](#composing-custom-error-types). For example, -->
<!-- [`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html) -->
<!-- provides `From` impls for both `io::Error` and `byteorder::Error`. -->
さらには、あなたのエラー型に対して `From` の実装を提供するのも便利かもしれません。
このことは、（ライブラリ作者である）あなたと利用者が、 [より詳細なエラーを合成する](#composing-custom-error-types) ことを可能にします。
例えば [`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html) は `io::Error` と `byteorder::Error` の両方に `From` 実装を提供しています。

<!-- Finally, depending on your tastes, you may also want to define a -->
<!-- [`Result` type alias](#the-result-type-alias-idiom), particularly if your -->
<!-- library defines a single error type. This is used in the standard library -->
<!-- for [`io::Result`](../std/io/type.Result.html) -->
<!-- and [`fmt::Result`](../std/fmt/type.Result.html). -->
最後に、お好みで [`Result` 型エイリアス](#the-result-type-alias-idiom) を定義したくなるかもしれません。
特にライブラリでエラー型を一つだけ定義している時は当てはまります。
この方法は標準ライブラリの [`io::Result`](../std/io/type.Result.html) や [`fmt::Result`](../std/fmt/type.Result.html) で用いられています。

<!-- # Case study: A program to read population data -->
<span id="case-study-a-program-to-read-population-data"></span>
# ケーススタディ：人口データを読み込むプログラム

<!-- This chapter was long, and depending on your background, it might be -->
<!-- rather dense. While there is plenty of example code to go along with -->
<!-- the prose, most of it was specifically designed to be pedagogical. So, -->
<!-- we're going to do something new: a case study. -->
この章は長かったですね。
あなたのバックグラウンドにもよりますが、内容が少し濃すぎたかもしれません。
たくさんのコード例に、単調な説明が添えられる形で進行しましたが、これは主に学習を助けるために、あえてこう構成されていたのでした。
次はなにか新しいことを。
ケーススタディをしましょう。

<!-- For this, we're going to build up a command line program that lets you -->
<!-- query world population data. The objective is simple: you give it a location -->
<!-- and it will tell you the population. Despite the simplicity, there is a lot -->
<!-- that can go wrong! -->
ここでは世界の人口データを問い合わせるための、コマンドラインプログラムを構築します。
目的はシンプルです：プログラムに場所を与えると、人口を教えてくれます。
シンプルにも関わらず、失敗しそうな所がたくさんあります！

<!-- The data we'll be using comes from the [Data Science -->
<!-- Toolkit][11]. I've prepared some data from it for this exercise. You -->
<!-- can either grab the [world population data][12] (41MB gzip compressed, -->
<!-- 145MB uncompressed) or just the [US population data][13] (2.2MB gzip -->
<!-- compressed, 7.2MB uncompressed). -->
ここで使うデータは [データサイエンスツールキット][11] から取得したものです。
これを元に演習で使うデータを準備しましたので、2つのファイルのどちらかをダウンロードしてください：
[世界の人口データ][12] （gzip圧縮時 41MB、解凍時 145MB）と、 [アメリカ合衆国の人口データ][13] （gzip 圧縮時 2.2MB、解凍時 7.2MB）があります。

<!-- Up until now, we've kept the code limited to Rust's standard library. For a real -->
<!-- task like this though, we'll want to at least use something to parse CSV data, -->
<!-- parse the program arguments and decode that stuff into Rust types automatically. For that, we'll use the -->
<!-- [`csv`](https://crates.io/crates/csv), -->
<!-- and [`rustc-serialize`](https://crates.io/crates/rustc-serialize) crates. -->
いままで書いてきたコードでは、Rustの標準ライブラリだけを使うようにしてきました。
今回のような現実のタスクでは、最低でもCSVデータをパースする部分と、プログラムの引数をパースして、自動的にRustの型にデコードする部分になにか使いたいです。
[`csv`](https://crates.io/crates/csv) と [`rustc-serialize`](https://crates.io/crates/rustc-serialize) クレートを使いましょう。

<!-- ## Initial setup -->
<span id="initial-setup"></span>
## 最初のセットアップ

<!-- We're not going to spend a lot of time on setting up a project with -->
<!-- Cargo because it is already covered well in [the Cargo -->
<!-- chapter](../book/hello-cargo.html) and [Cargo's documentation][14]. -->
<!-- 訳者コメント：hello-cargo.htmlがリンク切れのため、リンク先を変更しました。 -->
Cargoを使ってプロジェクトをセットアップしますが、その方法はすでに [Hello, Cargo!](../book/getting-started.html#hello-cargo) と [Cargoのドキュメント][14] でカバーされていますので、ここでは簡単に説明します。

<!-- To get started from scratch, run `cargo new --bin city-pop` and make sure your -->
<!-- `Cargo.toml` looks something like this: -->
何もない状態で `cargo new --bin city-pop` を実行し、 `Cargo.toml` を以下のように編集してください：

```text
[package]
name = "city-pop"
version = "0.1.0"
authors = ["Andrew Gallant <jamslam@gmail.com>"]

[[bin]]
name = "city-pop"

[dependencies]
csv = "0.*"
rustc-serialize = "0.*"
getopts = "0.*"
```

<!-- You should already be able to run: -->
これでもう実行できるはずです：

```text
cargo build --release
./target/release/city-pop
# 出力: Hello, world!
```
<!-- Outputs: Hello, world! -->

<!-- ## Argument parsing -->
<span id="argument-parsing"></span>
## 引数のパース

<!-- Let's get argument parsing out of the way. We won't go into too much -->
<!-- detail on Getopts, but there is [some good documentation][15] -->
<!-- describing it. The short story is that Getopts generates an argument -->
<!-- parser and a help message from a vector of options (The fact that it -->
<!-- is a vector is hidden behind a struct and a set of methods). Once the -->
<!-- parsing is done, we can decode the program arguments into a Rust -->
<!-- struct. From there, we can get information about the flags, for -->
<!-- instance, whether they were passed in, and what arguments they -->
<!-- had. Here's our program with the appropriate `extern crate` -->
<!-- statements, and the basic argument setup for Getopts: -->
引数のパースを実装しましょう。
Getoptsについては、あまり深く説明しませんが、詳細を解説した [ドキュメント][15] があります。
簡単に説明すると、Getoptsはオプションのベクタから、引数のパーサーとヘルプメッセージを生成します（実際には、ベクタは構造体とメソッドの背後に隠れています）。
パースが終わると、プログラムの引数をRustの構造体へとデコードできます。
これにより、例えば、フラグが指定されたかとか、フラグの引数がなんであったかといった、フラグの情報を取り出せるようになります。
プログラムに適切な `extern crate` 文を追加して、Getoptsの基本的な引数を設定すると、こうなります：

```rust,ignore
extern crate getopts;
extern crate rustc_serialize;

use getopts::Options;
use std::env;

fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)));
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();

    let mut opts = Options::new();
    opts.optflag("h", "help", "Show this usage message.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m)  => { m }
	Err(e) => { panic!(e.to_string()) }
    };
    if matches.opt_present("h") {
        print_usage(&program, opts);
	return;
    }
    let data_path = args[1].clone();
    let city = args[2].clone();

	// Do stuff with information
}
```

> 訳注
>
> - Usage: {} [options] <data-path> <city>：使い方：{} [options] <data-path> <city>
> - Show this usage message.：この使い方のメッセージを表示する。

<!-- First, we get a vector of the arguments passed into our program. We -->
<!-- then store the first one, knowing that it is our program's name. Once -->
<!-- that's done, we set up our argument flags, in this case a simplistic -->
<!-- help message flag. Once we have the argument flags set up, we use -->
<!-- `Options.parse` to parse the argument vector (starting from index one, -->
<!-- because index 0 is the program name). If this was successful, we -->
<!-- assign matches to the parsed object, if not, we panic. Once past that, -->
<!-- we test if the user passed in the help flag, and if so print the usage -->
<!-- message. The option help messages are constructed by Getopts, so all -->
<!-- we have to do to print the usage message is tell it what we want it to -->
<!-- print for the program name and template. If the user has not passed in -->
<!-- the help flag, we assign the proper variables to their corresponding -->
<!-- argumaents. -->
このように、まず、このプログラムに渡された引数のベクタを取得します。
次に、最初の要素、つまり、プログラムの名前を格納します。
続いて引数フラグをセットアップしますが、今回はごく簡単なヘルプメッセージフラグが一つあるだけです。
セットアップできたら `Options.parse` を使って引数のベクタをパースします（インデックス0はプログラム名ですので、インデックス1からスタートします）。
もしパースに成功したら、パースしたオブジェクトをマッチで取り出します。
もし失敗したのなら、パニックさせます。
ここまでうまくいったら、ヘルプフラグが指定されたか調べて、もしそうなら使い方のメッセージを表示します。
ヘルプメッセージのオプションはGetoptsによりコンストラクト済みですので、使い方のメッセージを表示するために追加で必要なのは、プログラム名とテンプレートだけです。
もしユーザーがヘルプフラグを指定しなかったなら、変数を用意して、対応する引数の値をセットします。

<!-- ## Writing the logic -->
<span id="writing-the-logic"></span>
## ロジックを書く

<!-- We all write code differently, but error handling is usually the last thing we -->
<!-- want to think about. This isn't great for the overall design of a program, but -->
<!-- it can be useful for rapid prototyping. Because Rust forces us to be explicit -->
<!-- about error handling (by making us call `unwrap`), it is easy to see which -->
<!-- parts of our program can cause errors. -->
コードを書く順番は人それぞれですが、エラーハンドリングは最後に考えることが多いでしょう。
これはプログラム全体の設計にとっては、あまり良いことではありませんが、ラピッドなプロトタイピングでは便利かもしれません。
Rustは私たちにエラーハンドリングが明示的であることを（ `unwrap` を呼ばせることで）強制しますので、プログラムのどの部分がエラーを起こすかは、簡単にわかります。

<!-- In this case study, the logic is really simple. All we need to do is parse the -->
<!-- CSV data given to us and print out a field in matching rows. Let's do it. (Make -->
<!-- sure to add `extern crate csv;` to the top of your file.) -->
このケーススタディでは、ロジックは非常にシンプルです。
やることは、与えられたCSVデータをパースして、マッチした行にあるフィールドを表示するだけです。
やってみましょう。
（ファイルの先頭に `extern crate csv;` を追加することを忘れずに。）

```rust,ignore
# // This struct represents the data in each row of the CSV file.
# // Type based decoding absolves us of a lot of the nitty gritty error
# // handling, like parsing strings as integers or floats.
// この構造体はCSVファイルの各行のデータを表現します。
// 型に基づくデコードは、文字列を整数や浮動小数点数にパースしてしまう
// といった、核心に触れるエラーハンドリングの大半を免除してくれます。
#[derive(Debug, RustcDecodable)]
struct Row {
    country: String,
    city: String,
    accent_city: String,
    region: String,

#    // Not every row has data for the population, latitude or longitude!
#    // So we express them as `Option` types, which admits the possibility of
#    // absence. The CSV parser will fill in the correct value for us.
    // 人口、経度、緯度などのデータは全ての行にあるわけではありません！
    // そこで、これらは不在の可能性を許す `Option` 型で表現します。
    // CSVパーサーは、これらを正しい値で埋めてくれます。
    population: Option<u64>,
    latitude: Option<f64>,
    longitude: Option<f64>,
}

fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)));
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();

    let mut opts = Options::new();
    opts.optflag("h", "help", "Show this usage message.");

    let matches = match opts.parse(&args[1..]) {
        Ok(m)  => { m }
        Err(e) => { panic!(e.to_string()) }
    };

    if matches.opt_present("h") {
        print_usage(&program, opts);
		return;
	}

	let data_file = args[1].clone();
	let data_path = Path::new(&data_file);
	let city = args[2].clone();

	let file = fs::File::open(data_path).unwrap();
	let mut rdr = csv::Reader::from_reader(file);

	for row in rdr.decode::<Row>() {
		let row = row.unwrap();

		if row.city == city {
			println!("{}, {}: {:?}",
				row.city, row.country,
				row.population.expect("population count"));
		}
	}
}
```

> 訳注：
>
> population count：人口のカウント

<!-- Let's outline the errors. We can start with the obvious: the three places that -->
<!-- `unwrap` is called: -->
ここで、エラーの概要を把握しましょう。
まずは明白なところ、つまり `unwrap` が呼ばれている3ヶ所から始めます：

<!-- 1. [`fs::File::open`](../std/fs/struct.File.html#method.open) -->
<!--    can return an -->
<!--    [`io::Error`](../std/io/struct.Error.html). -->
<!-- 2. [`csv::Reader::decode`](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.decode) -->
<!--    decodes one record at a time, and -->
<!--    [decoding a -->
<!--    record](http://burntsushi.net/rustdoc/csv/struct.DecodedRecords.html) -->
<!--    (look at the `Item` associated type on the `Iterator` impl) -->
<!--    can produce a -->
<!--    [`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html). -->
<!-- 3. If `row.population` is `None`, then calling `expect` will panic. -->
1. [`fs::File::open`](../std/fs/struct.File.html#method.open) が [`io::Error`](../std/io/struct.Error.html) を返すかもしれない。
2. [`csv::Reader::decode`](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.decode) は1度に1件のレコードをデコードし、 [レコードのデコード](http://burntsushi.net/rustdoc/csv/struct.DecodedRecords.html) （`Iterator` の impl の `Item` 関連型を見てください）は [`csv::Error`](http://burntsushi.net/rustdoc/csv/enum.Error.html) を生むかもしれない。
3. もし `row.population` が `None` なら、 `expect` の呼び出しはパニックする。

<!-- Are there any others? What if we can't find a matching city? Tools like `grep` -->
<!-- will return an error code, so we probably should too. So we have logic errors -->
<!-- specific to our problem, IO errors and CSV parsing errors. We're going to -->
<!-- explore two different ways to approach handling these errors. -->
他にもありますか？
もし一致する都市が見つからなかったら？
`grep` のようなツールはエラーコードを返しますので、ここでも、そうするべきかもしれません。
つまり、IOエラーとCSVパースエラーの他に、このプログラム特有のエラーロジックがあるわけです。
これらのエラーを扱うために、2つのアプローチを試してみましょう。

<!-- I'd like to start with `Box<Error>`. Later, we'll see how defining our own -->
<!-- error type can be useful. -->
まず `Box<Error>` から始めたいと思います。
その後で、独自のエラー型を定義すると、どのように便利になるかを見てみましょう。

<!-- ## Error handling with `Box<Error>` -->
<span id="error-handling-with-boxerror"></span>
## `Box<Error>` によるエラー処理

<!-- `Box<Error>` is nice because it *just works*. You don't need to define your own -->
<!-- error types and you don't need any `From` implementations. The downside is that -->
<!-- since `Box<Error>` is a trait object, it *erases the type*, which means the -->
<!-- compiler can no longer reason about its underlying type. -->
`Box<Error>` が便利なのは *とにかく動く* からです。
エラー型を定義して `From` を実装する、といったことをする必要がありません。
これの欠点は `Box<Error>` がトレイトオブジェクトなので *型が消去* され、コンパイラーが背後の型を推測できなくなることです。

<!-- [Previously](#the-limits-of-combinators) we started refactoring our code by -->
<!-- changing the type of our function from `T` to `Result<T, OurErrorType>`. In -->
<!-- this case, `OurErrorType` is just `Box<Error>`. But what's `T`? And can we add -->
<!-- a return type to `main`? -->
[以前も](#the-limits-of-combinators) 、コードのリファクタリングを、関数の型を `T` から `Result<T, 私たちのエラー型>` に変更することから始めました。
ここでは `私たちのエラー型` は単に `Box<Error>` です。
でも `T` は何になるでしょう？
それに `main` にリターン型を付けられるのでしょうか？

<!-- The answer to the second question is no, we can't. That means we'll need to -->
<!-- write a new function. But what is `T`? The simplest thing we can do is to -->
<!-- return a list of matching `Row` values as a `Vec<Row>`. (Better code would -->
<!-- return an iterator, but that is left as an exercise to the reader.) -->
2つ目の質問の答えはノーです。できません。
つまり新しい関数を書くことになります。
では `T` は何になるでしょう？
一番簡単にできるのは、マッチした `Row` 値のリストを `Vec<Row>` として返すことです。
（もっと良いコードはイテレータを返すかもしれませんが、その部分は読者の皆さんの練習問題とします。）

<!-- Let's refactor our code into its own function, but keep the calls to `unwrap`. -->
<!-- Note that we opt to handle the possibility of a missing population count by -->
<!-- simply ignoring that row. -->
該当のコードを、専用の関数へとリファクタリングしましょう。
ただし `unwrap` の呼び出しはそのままにします。
また、人口のカウントがない場合は、その行を無視することに留意してください。

```rust,ignore
struct Row {
#     // unchanged
    // 変更なし
}

struct PopulationCount {
    city: String,
    country: String,
#     // This is no longer an `Option` because values of this type are only
#     // constructed if they have a population count.
    // これは `Option` ではなくします。なぜなら、この型の値は
    // 人口のカウントがある時だけ構築されるからです。
    count: u64,
}

fn print_usage(program: &str, opts: Options) {
    println!("{}", opts.usage(&format!("Usage: {} [options] <data-path> <city>", program)));
}

fn search<P: AsRef<Path>>(file_path: P, city: &str) -> Vec<PopulationCount> {
    let mut found = vec![];
    let file = fs::File::open(file_path).unwrap();
    let mut rdr = csv::Reader::from_reader(file);
    for row in rdr.decode::<Row>() {
        let row = row.unwrap();
        match row.population {
#           // None => { } // skip it
            None => { } // スキップする
            Some(count) => if row.city == city {
                found.push(PopulationCount {
                    city: row.city,
                    country: row.country,
                    count: count,
                });
            },
        }
    }
    found
}

fn main() {
	let args: Vec<String> = env::args().collect();
	let program = args[0].clone();

	let mut opts = Options::new();
	opts.optflag("h", "help", "Show this usage message.");

	let matches = match opts.parse(&args[1..]) {
		Ok(m)  => { m }
		Err(e) => { panic!(e.to_string()) }
	};
	if matches.opt_present("h") {
		print_usage(&program, opts);
		return;
	}

	let data_file = args[1].clone();
	let data_path = Path::new(&data_file);
	let city = args[2].clone();
	for pop in search(&data_path, &city) {
		println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
	}
}

```

<!-- While we got rid of one use of `expect` (which is a nicer variant of `unwrap`), -->
<!-- we still should handle the absence of any search results. -->
`expect` （`unwrap` の少し良いバリエーション）の使用を1つ取り除くことができましたが、サーチの結果が無い時のハンドリングは依然として必要です。

<!-- To convert this to proper error handling, we need to do the following: -->
このエラーを適切に処理するためには、以下のようにします：

<!-- 1. Change the return type of `search` to be `Result<Vec<PopulationCount>, -->
<!--    Box<Error>>`. -->
<!-- 2. Use the [`try!` macro](#code-try-def) so that errors are returned to the -->
<!--    caller instead of panicking the program. -->
<!-- 3. Handle the error in `main`. -->
1. `search` のリターン型を `Result<Vec<PopulationCount>, Box<Error>>` に変更する。
2. [`try!` マクロ](#code-try-def) を使用することで、プログラムをパニックする代わりに、エラーを呼び出し元に返す。
3. `main` でエラーをハンドリングする。

<!-- Let's try it: -->
やってみましょう：

```rust,ignore
fn search<P: AsRef<Path>>
         (file_path: P, city: &str)
         -> Result<Vec<PopulationCount>, Box<Error+Send+Sync>> {
    let mut found = vec![];
    let file = try!(fs::File::open(file_path));
    let mut rdr = csv::Reader::from_reader(file);
    for row in rdr.decode::<Row>() {
        let row = try!(row);
        match row.population {
            None => { } // skip it
            Some(count) => if row.city == city {
                found.push(PopulationCount {
                    city: row.city,
                    country: row.country,
                    count: count,
                });
            },
        }
    }
    if found.is_empty() {
        Err(From::from("No matching cities with a population were found."))
    } else {
        Ok(found)
    }
}
```

> 訳注：
>
> No matching cities with a population were found.：<br/>
> 条件に合う人口データ付きの街は見つかりませんでした。

<!-- Instead of `x.unwrap()`, we now have `try!(x)`. Since our function returns a -->
<!-- `Result<T, E>`, the `try!` macro will return early from the function if an -->
<!-- error occurs. -->
`x.unwrap()` の代わりに、今では `try!(x)` があります。
私たちの関数が `Result<T, E>` を返すので、エラーの発生時、 `try!` マクロは関数の途中で戻ります。

<!-- There is one big gotcha in this code: we used `Box<Error + Send + Sync>` -->
<!-- instead of `Box<Error>`. We did this so we could convert a plain string to an -->
<!-- error type. We need these extra bounds so that we can use the -->
<!-- [corresponding `From` -->
<!-- impls](../std/convert/trait.From.html): -->
重要なポイントが一つあります：
`Box<Error>` の代わりに `Box<Error + Send + Sync>` を使いました。
こうすると、プレーンな文字列をエラー型に変換できます。
[この `From` 実装](../std/convert/trait.From.html) を使うために、このような追加の境界が必要でした。

```rust,ignore
# // We are making use of this impl in the code above, since we call `From::from`
# // on a `&'static str`.
// 上のコードでは `&'static str` に対して `From::from` を呼ぶことで、
// こちらの実装を使おうとしています。
impl<'a, 'b> From<&'b str> for Box<Error + Send + Sync + 'a>

# // But this is also useful when you need to allocate a new string for an
# // error message, usually with `format!`.
// もし `format!` などを使ってエラーメッセージのために新しい文字列を
// 割り当てたい場合は、こちらの実装も有用です。
impl From<String> for Box<Error + Send + Sync>
```

<!-- Since `search` now returns a `Result<T, E>`, `main` should use case analysis -->
<!-- when calling `search`: -->
`search` が `Result<T, E>` を返すようになったため、 `main` は `search` を呼ぶ時にケース分析をしなければなりません：

```rust,ignore
...
match search(&data_file, &city) {
    Ok(pops) => {
        for pop in pops {
            println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
        }
    }
    Err(err) => println!("{}", err)
}
...
```

<!-- Now that we've seen how to do proper error handling with `Box<Error>`, let's -->
<!-- try a different approach with our own custom error type. But first, let's take -->
<!-- a quick break from error handling and add support for reading from `stdin`. -->
`Box<Error>` を使った正しいエラーハンドリングについて見ましたので、次は独自のエラー型による別のアプローチを試してみましょう。
でもその前に、少しの間、エラーハンドリングから離れて、 `stdin` からの読み込みをサポートしましょう。

<!-- ## Reading from stdin -->
<span id="reading-from-stdin"></span>
## 標準入力から読み込む

<!-- In our program, we accept a single file for input and do one pass over the -->
<!-- data. This means we probably should be able to accept input on stdin. But maybe -->
<!-- we like the current format too—so let's have both! -->
このプログラムでは、入力としてファイルを1つだけ受け付け、データを1回のパスで処理しています。
これは、標準入力からの入力を受け付けたほうがいいことを意味しているのかもしれません。
でも、いまの方法も捨てがたいので、両方できるようにしましょう！

<!-- Adding support for stdin is actually quite easy. There are only three things we -->
<!-- have to do: -->
標準入力のサポートを追加するのは実に簡単です。
やることは3つだけです：

<!-- 1. Tweak the program arguments so that a single parameter—the -->
<!--    city—can be accepted while the population data is read from stdin. -->
<!-- 2. Modify the program so that an option `-f` can take the file, if it -->
<!--     is not passed into stdin. -->
<!-- 3. Modify the `search` function to take an *optional* file path. When `None`, -->
<!--    it should know to read from stdin. -->
1. プログラムの引数を微修正して、唯一のパラメータとして「都市」を受け付け、人口データは標準入力から読み込むようにする。
2. プログラムを修正して、標準入力経由でファイルが渡されなかった時に、`-f` オプションからファイルを得られるようにする。
3. `search` 関数を修正して、ファイルパスを `オプションで` 受け取れるようにする。もし `None` なら標準入力から読み込む。

<!-- First, here's the new usage: -->
まず、新しい使い方です：

```rust,ignore
fn print_usage(program: &str, opts: Options) {
	println!("{}", opts.usage(&format!("Usage: {} [options] <city>", program)));
}
```
<!-- The next part is going to be only a little harder: -->
次のパートはやや難しくなります：

```rust,ignore
...
let mut opts = Options::new();
opts.optopt("f", "file", "Choose an input file, instead of using STDIN.", "NAME");
opts.optflag("h", "help", "Show this usage message.");
...
let file = matches.opt_str("f");
let data_file = file.as_ref().map(Path::new);

let city = if !matches.free.is_empty() {
	matches.free[0].clone()
} else {
	print_usage(&program, opts);
	return;
};

for pop in search(&data_file, &city) {
	println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
}
...
```

> 訳注：
>
> Choose an input file, instead of using STDIN：<br/>
> STDINを使う代わりに、入力ファイルを選択する。

<!-- In this piece of code, we take `file` (which has the type -->
<!-- `Option<String>`), and convert it to a type that `search` can use, in -->
<!-- this case, `&Option<AsRef<Path>>`. To do this, we take a reference of -->
<!-- file, and map `Path::new` onto it. In this case, `as_ref()` converts -->
<!-- the `Option<String>` into an `Option<&str>`, and from there, we can -->
<!-- execute `Path::new` to the content of the optional, and return the -->
<!-- optional of the new value. Once we have that, it is a simple matter of -->
<!-- getting the `city` argument and executing `search`. -->
このコードでは（`Option<String>` 型の） `file` を受け取り、 `search` が使える型、つまり今回は `&Option<AsRef<Path>>` へ変換します。
そのためには `file` の参照を得て、それに対して `Path::new` をmapします。
このケースでは `as_ref()` が `Option<String>` を `Option<&str>` へ変換しますので、続いて、そのオプション値の中身に対して `Path::new` を実行することで、新しいオプション値を返します。
ここまでできれば、残りは単に `city` 引数を取得して `search` を実行するだけです。

<!-- Modifying `search` is slightly trickier. The `csv` crate can build a -->
<!-- parser out of -->
<!-- [any type that implements `io::Read`](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.from_reader). -->
<!-- But how can we use the same code over both types? There's actually a -->
<!-- couple ways we could go about this. One way is to write `search` such -->
<!-- that it is generic on some type parameter `R` that satisfies -->
<!-- `io::Read`. Another way is to just use trait objects: -->
`search` の修正は少しトリッキーです。
`csv` トレイトは [`io::Read` を実装している型](http://burntsushi.net/rustdoc/csv/struct.Reader.html#method.from_reader) からなら、いずれかを問わず、パーサーを構築できます。
しかし両方の型に同じコードが使えるのでしょうか？
これを実際する方法は2つあります。
ひとつの方法は `search` を `io::Read` を満たす型パラメータ `R` に対するジェネリックとして書くことです。
もうひとつの方法は、以下のように、単なるトレイトオブジェクトを使うことです：

```rust,ignore
fn search<P: AsRef<Path>>
         (file_path: &Option<P>, city: &str)
         -> Result<Vec<PopulationCount>, Box<Error+Send+Sync>> {
    let mut found = vec![];
    let input: Box<io::Read> = match *file_path {
        None => Box::new(io::stdin()),
        Some(ref file_path) => Box::new(try!(fs::File::open(file_path))),
    };
    let mut rdr = csv::Reader::from_reader(input);
    // The rest remains unchanged!
}
```

<!-- ## Error handling with a custom type -->
<span id="error-handling-with-a-custom-type"></span>
## 独自のエラー型によるエラー処理

<!-- Previously, we learned how to -->
<!-- [compose errors using a custom error type](#composing-custom-error-types). -->
<!-- We did this by defining our error type as an `enum` and implementing `Error` -->
<!-- and `From`. -->
以前、どうやって [独自のエラー型を使ってエラーを合成する](#composing-custom-error-types) のか学びました。
その時はエラー型を `enum` 型として定義して、`Error` と `From` を実装することで実現しました。

<!-- Since we have three distinct errors (IO, CSV parsing and not found), let's -->
<!-- define an `enum` with three variants: -->
3つの異なるエラー（IO、CSVのパース、検索結果なし）がありますので `enum` として3つのバリエーションを定義しましょう：

```rust,ignore
#[derive(Debug)]
enum CliError {
    Io(io::Error),
    Csv(csv::Error),
    NotFound,
}
```

<!-- And now for impls on `Display` and `Error`: -->
`Display` と `Error` を実装します：

```rust,ignore
impl fmt::Display for CliError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            CliError::Io(ref err) => err.fmt(f),
            CliError::Csv(ref err) => err.fmt(f),
            CliError::NotFound => write!(f, "No matching cities with a \
                                             population were found."),
        }
    }
}

impl Error for CliError {
    fn description(&self) -> &str {
        match *self {
            CliError::Io(ref err) => err.description(),
            CliError::Csv(ref err) => err.description(),
            CliError::NotFound => "not found",
        }
    }
}
```

<!-- Before we can use our `CliError` type in our `search` function, we need to -->
<!-- provide a couple `From` impls. How do we know which impls to provide? Well, -->
<!-- we'll need to convert from both `io::Error` and `csv::Error` to `CliError`. -->
<!-- Those are the only external errors, so we'll only need two `From` impls for -->
<!-- now: -->
`CliError` を `search` 関数の型に使う前に、いくつかの `From` の実装を用意しなければなりません。
どのエラーについて用意したらいいのでしょう？
ええと `io::Error` と `csv::Error` の両方を `CliError` に変換する必要があります。
外部エラーはこれだけですので、今は2つの `From` 実装だけが必要になるのです：

```rust,ignore
impl From<io::Error> for CliError {
    fn from(err: io::Error) -> CliError {
        CliError::Io(err)
    }
}

impl From<csv::Error> for CliError {
    fn from(err: csv::Error) -> CliError {
        CliError::Csv(err)
    }
}
```

<!-- The `From` impls are important because of how -->
<!-- [`try!` is defined](#code-try-def). In particular, if an error occurs, -->
<!-- `From::from` is called on the error, which in this case, will convert it to our -->
<!-- own error type `CliError`. -->
[`try!` の定義](#code-try-def) のされ方により `From` の実装は重要です。
特に重要なのは、エラーが起こるとエラーの `From::from` が呼ばれることです。
このケースでは、エラーを私たち独自のエラー型 `CliError` へ変換します。

<!-- With the `From` impls done, we only need to make two small tweaks to our -->
<!-- `search` function: the return type and the “not found” error. Here it is in -->
<!-- full: -->
`From` の実装ができましたので、`search` 関数に2つの微修正が必要です：
リターン型と「not found」エラーです。
全体はこうなります：

```rust,ignore
fn search<P: AsRef<Path>>
         (file_path: &Option<P>, city: &str)
         -> Result<Vec<PopulationCount>, CliError> {
    let mut found = vec![];
    let input: Box<io::Read> = match *file_path {
        None => Box::new(io::stdin()),
        Some(ref file_path) => Box::new(try!(fs::File::open(file_path))),
    };
    let mut rdr = csv::Reader::from_reader(input);
    for row in rdr.decode::<Row>() {
        let row = try!(row);
        match row.population {
            None => { } // skip it
            Some(count) => if row.city == city {
                found.push(PopulationCount {
                    city: row.city,
                    country: row.country,
                    count: count,
                });
            },
        }
    }
    if found.is_empty() {
        Err(CliError::NotFound)
    } else {
        Ok(found)
    }
}
```

<!-- No other changes are necessary. -->
これ以外の変更は不要です。

<!-- ## Adding functionality -->
<span id="adding-functionality"></span>
## 機能を追加する

<!-- Writing generic code is great, because generalizing stuff is cool, and -->
<!-- it can then be useful later. But sometimes, the juice isn't worth the -->
<!-- squeeze. Look at what we just did in the previous step: -->
汎用的なコードを書くのは素晴らしいことです。
なぜなら、物事を汎用的にするのはクールですし、後になって役立つかもしれません。
でも時には、その苦労の甲斐がないこともあります。
最後のステップで何をしたか振り返ってみましょう：

<!-- 1. Defined a new error type. -->
<!-- 2. Added impls for `Error`, `Display` and two for `From`. -->
1. 新しいエラー型を定義した。
2. `Error` と `Display` の実装を追加し、2つのエラー対して `From` も実装した。

<!-- The big downside here is that our program didn't improve a whole lot. -->
<!-- There is quite a bit of overhead to representing errors with `enum`s, -->
<!-- especially in short programs like this. -->
ここでの大きな問題は、このプログラムは全体で見ると大して良くならなかったことです。
`enum` でエラーを表現するには、多くの付随する作業が必要です。
特にこのような短いプログラムでは、それが顕著に現れました。

<!-- *One* useful aspect of using a custom error type like we've done here is that -->
<!-- the `main` function can now choose to handle errors differently. Previously, -->
<!-- with `Box<Error>`, it didn't have much of a choice: just print the message. -->
<!-- We're still doing that here, but what if we wanted to, say, add a `--quiet` -->
<!-- flag? The `--quiet` flag should silence any verbose output. -->
ここでしたようなカスタムエラー型を使うのが便利といえる *一つの* 要素は、 `main` 関数がエラーによってどう対処するのかを選択できるようになったことです。
以前の `Box<Error>` では、メッセージを表示する以外、選択の余地はほとんどありませんでした。
いまでもそうですが、例えば、もし `--quiet` フラグを追加したくなったらどうでしょうか？
`--quiet` フラグは詳細な出力を抑止すべきです。

<!-- Right now, if the program doesn't find a match, it will output a message saying -->
<!-- so. This can be a little clumsy, especially if you intend for the program to -->
<!-- be used in shell scripts. -->
いま現在は、プログラムがマッチするものを見つけられなかった時、それを告げるメッセージを表示します。
これは、特にプログラムをシェルスクリプトで使いたい時などは、扱いにくいかもしれません。

<!-- So let's start by adding the flags. Like before, we need to tweak the usage -->
<!-- string and add a flag to the Option variable. Once we've done that, Getopts does the rest: -->
フラグを追加してみましょう。
以前したように、使い方についての文字列を少し修正して、オプション変数にフラグを追加します。
そこまですれば、残りはGetoptsがやってくれます：

```rust,ignore
...
let mut opts = Options::new();
opts.optopt("f", "file", "Choose an input file, instead of using STDIN.", "NAME");
opts.optflag("h", "help", "Show this usage message.");
opts.optflag("q", "quiet", "Silences errors and warnings.");
...
```

<!-- Now we just need to implement our “quiet” functionality. This requires us to -->
<!-- tweak the case analysis in `main`: -->
後は「quiet」機能を実装するだけです。
`main` 関数のケース分析を少し修正します：

```rust,ignore
match search(&args.arg_data_path, &args.arg_city) {
    Err(CliError::NotFound) if args.flag_quiet => process::exit(1),
    Err(err) => panic!("{}", err),
    Ok(pops) => for pop in pops {
        println!("{}, {}: {:?}", pop.city, pop.country, pop.count);
    }
}
```

> 訳注：
>
> Silences errors and warnings.：エラーや警告を抑止します。

<!-- Certainly, we don't want to be quiet if there was an IO error or if the data -->
<!-- failed to parse. Therefore, we use case analysis to check if the error type is -->
<!-- `NotFound` *and* if `--quiet` has been enabled. If the search failed, we still -->
<!-- quit with an exit code (following `grep`'s convention). -->
もちろん、IOエラーが起こったり、データのパースに失敗した時は、エラーを抑止したくはありません。
そこでケース分析を行い、エラータイプが `NotFound` *かつ* `--quiet` が指定されたかを検査しています。
もし検索に失敗したら、今まで通り（ `grep` の動作に倣い）なにも表示せず、exitコードと共に終了します。

<!-- If we had stuck with `Box<Error>`, then it would be pretty tricky to implement -->
<!-- the `--quiet` functionality. -->
もし `Box<Error>` で留まっていたら `--quiet` 機能を実装するのは、かなり面倒だったでしょう。

<!-- This pretty much sums up our case study. From here, you should be ready to go -->
<!-- out into the world and write your own programs and libraries with proper error -->
<!-- handling. -->
これが、このケーススタディの締めくくりとなります。
これからは外の世界に飛び出して、あなた自身のプログラムやライブラリーを、適切なエラーハンドリングと共に書くことができるでしょう。

<!-- # The Short Story -->
<span id="the-short-story"></span>
# 簡単な説明（まとめ）

<!-- Since this chapter is long, it is useful to have a quick summary for error -->
<!-- handling in Rust. These are some good “rules of thumb." They are emphatically -->
<!-- *not* commandments. There are probably good reasons to break every one of these -->
<!-- heuristics! -->
この章は長いので、Rustにおけるエラー処理について簡単にまとめたほうがいいでしょう。
そこには「大まかな法則」が存在しますが、これらは命令的なものでは断固として *ありません* 。
それぞれのヒューリスティックを破るだけの十分な理由もあり得ます！

<!-- * If you're writing short example code that would be overburdened by error -->
<!--   handling, it's probably just fine to use `unwrap` (whether that's -->
<!--   [`Result::unwrap`](../std/result/enum.Result.html#method.unwrap), -->
<!--   [`Option::unwrap`](../std/option/enum.Option.html#method.unwrap) -->
<!--   or preferably -->
<!--   [`Option::expect`](../std/option/enum.Option.html#method.expect)). -->
<!--   Consumers of your code should know to use proper error handling. (If they -->
<!--   don't, send them here!) -->
<!-- * If you're writing a quick 'n' dirty program, don't feel ashamed if you use -->
<!--   `unwrap`. Be warned: if it winds up in someone else's hands, don't be -->
<!--   surprised if they are agitated by poor error messages! -->
<!-- * If you're writing a quick 'n' dirty program and feel ashamed about panicking -->
<!--   anyway, then use either a `String` or a `Box<Error + Send + Sync>` for your -->
<!--   error type (the `Box<Error + Send + Sync>` type is because of the -->
<!--   [available `From` impls](../std/convert/trait.From.html)). -->
<!-- * Otherwise, in a program, define your own error types with appropriate -->
<!--   [`From`](../std/convert/trait.From.html) -->
<!--   and -->
<!--   [`Error`](../std/error/trait.Error.html) -->
<!--   impls to make the [`try!`](../std/macro.try!.html) -->
<!--   macro more ergonomic. -->
<!-- * If you're writing a library and your code can produce errors, define your own -->
<!--   error type and implement the -->
<!--   [`std::error::Error`](../std/error/trait.Error.html) -->
<!--   trait. Where appropriate, implement -->
<!--   [`From`](../std/convert/trait.From.html) to make both -->
<!--   your library code and the caller's code easier to write. (Because of Rust's -->
<!--   coherence rules, callers will not be able to impl `From` on your error type, -->
<!--   so your library should do it.) -->
<!-- * Learn the combinators defined on -->
<!--   [`Option`](../std/option/enum.Option.html) -->
<!--   and -->
<!--   [`Result`](../std/result/enum.Result.html). -->
<!--   Using them exclusively can be a bit tiring at times, but I've personally -->
<!--   found a healthy mix of `try!` and combinators to be quite appealing. -->
<!--   `and_then`, `map` and `unwrap_or` are my favorites. -->
* もし短いサンプルコードを書いていて、エラーハンドリングが重荷になるようなら、 `unwrap` を使っても大丈夫かもしれません（ [`Result::unwrap`](../std/result/enum.Result.html#method.unwrap), [`Option::unwrap`](../std/option/enum.Option.html#method.unwrap), [`Option::expect`](../std/option/enum.Option.html#method.expect) のいずれかが使えます）。
  あなたのコードを参考にする人は、正しいエラーハンドリングについて知っているべきです。（そうでなければ、この章を紹介してください！）
* もし即興のプログラムを書いているなら `unwrap` を使うことに罪悪感を持たなくてもいいでしょう。
  ただし警告があります：もしそれが最終的に他の人たちの手に渡るなら、彼らが貧弱なエラーメッセージに動揺してもおかしくありません。
* これらに該当しないなら、独自のエラー型を定義し、適切な [`From`](../std/convert/trait.From.html) と [`Error`](../std/error/trait.Error.html) を実装することで [`try!`](../std/macro.try!.html) マクロをエルゴノミックにしましょう。
* もしライブラリを書いていて、そのコードがエラーを起こす可能性があるなら、独自のエラー型を定義し、 [`std::error::Error`](../std/error/trait.Error.html) トレイトを実装してください。
  もし必要なら [`From`](../std/convert/trait.From.html) を実装することで、ライブラリ自身と呼び出し元のコードを書きやすくしてください。
  （Rustの調和性規則(coherence rule) により、呼び出し側では、あなたのエラー型に対して `From` を実装することはできません。
  ライブラリでするべきです。）
* [`Option`](../std/option/enum.Option.html) と [`Result`](../std/result/enum.Result.html) で定義されているコンビネータについて学んでください。
  それだけを使うのは大変ですが、 `try!` と コンビネータを適度にミックスすることは、個人的には、とても魅力的な方法だと考えています。
  `and_then`, `map`, `unwrap_or` が私のお気に入りです。

[1]: ../book/patterns.html
[2]: ../std/option/enum.Option.html#method.map
[3]: ../std/option/enum.Option.html#method.unwrap_or
[4]: ../std/option/enum.Option.html#method.unwrap_or_else
[5]: ../std/option/enum.Option.html
[6]: ../std/result/
[7]: ../std/result/enum.Result.html#method.unwrap
[8]: ../std/fmt/trait.Debug.html
[9]: ../std/primitive.str.html#method.parse
[10]: ../book/associated-types.html
[11]: https://github.com/petewarden/dstkdata
[12]: http://burntsushi.net/stuff/worldcitiespop.csv.gz
[13]: http://burntsushi.net/stuff/uscitiespop.csv.gz
[14]: http://doc.crates.io/guide.html
[15]: http://doc.rust-lang.org/getopts/getopts/index.html
