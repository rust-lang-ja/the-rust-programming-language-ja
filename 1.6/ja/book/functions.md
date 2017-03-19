% 関数
<!-- % Functions -->

<!--Every Rust program has at least one function, the `main` function:-->
Rustのプログラムには全て、少なくとも1つの関数、 `main` 関数があります。

```rust
fn main() {
}
```

<!--This is the simplest possible function declaration. As we mentioned before,-->
<!--`fn` says ‘this is a function’, followed by the name, some parentheses because-->
<!--this function takes no arguments, and then some curly braces to indicate the-->
<!--body. Here’s a function named `foo`:-->
これは評価可能な関数定義の最も単純なものです。
前に言ったように、 `fn` は「これは関数です」ということを示します。この関数には引数がないので、名前と丸括弧が続きます。そして、その本文を表す波括弧が続きます。
これが `foo` という名前の関数です。

```rust
fn foo() {
}
```

<!--So, what about taking arguments? Here’s a function that prints a number:-->
それでは、引数を取る場合はどうでしょうか。
これが数値を出力する関数です。

```rust
fn print_number(x: i32) {
    println!("x is: {}", x);
}
```

<!--Here’s a complete program that uses `print_number`:-->
これが `print_number` を使う完全なプログラムです。

```rust
fn main() {
    print_number(5);
}

fn print_number(x: i32) {
    println!("x is: {}", x);
}
```

<!--As you can see, function arguments work very similar to `let` declarations:-->
<!--you add a type to the argument name, after a colon.-->
見てのとおり、関数の引数は `let` 宣言と非常によく似た動きをします。
引数の名前にコロンに続けて型を追加します。

<!--Here’s a complete program that adds two numbers together and prints them:-->
これが2つの数値を足して結果を出力する完全なプログラムです。

```rust
fn main() {
    print_sum(5, 6);
}

fn print_sum(x: i32, y: i32) {
    println!("sum is: {}", x + y);
}
```

<!--You separate arguments with a comma, both when you call the function, as well-->
<!--as when you declare it.-->
関数を呼び出すときも、それを宣言したときと同様に、引数をコンマで区切ります。

<!--Unlike `let`, you _must_ declare the types of function arguments. This does-->
<!--not work:-->
`let` と異なり、あなたは関数の引数の型を宣言 _しなければなりません_ 。
これは動きません。

```rust,ignore
fn print_sum(x, y) {
    println!("sum is: {}", x + y);
}
```

<!--You get this error:-->
このエラーが発生します。

```text
expected one of `!`, `:`, or `@`, found `)`
fn print_number(x, y) {
```

<!--This is a deliberate design decision. While full-program inference is possible,-->
<!--languages which have it, like Haskell, often suggest that documenting your-->
<!--types explicitly is a best-practice. We agree that forcing functions to declare-->
<!--types while allowing for inference inside of function bodies is a wonderful-->
<!--sweet spot between full inference and no inference.-->
これはよく考えられた設計上の決断です。
プログラムのすべての箇所で型推論をするという設計も可能ですが、一方で、そのように型推論を行なうHaskellのような言語でも、ドキュメント目的で型を明示するのはよい習慣だと言われています。
私たちの意見は、関数の型を明示することは強制しつつ、関数本体では型を推論するようにすることが、すべての箇所で型推論をするのとまったく型推論をしないことの間のすばらしいスイートスポットである、というところで一致しています。

<!--What about returning a value? Here’s a function that adds one to an integer:-->
戻り値についてはどうでしょうか。
これが整数に1を加える関数です。

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}
```

<!--Rust functions return exactly one value, and you declare the type after an-->
<!--‘arrow’, which is a dash (`-`) followed by a greater-than sign (`>`). The last-->
<!--line of a function determines what it returns. You’ll note the lack of a-->
<!--semicolon here. If we added it in:-->
Rustの関数はちょうど1つだけの値を返します。そして、ダッシュ（ `-` ）の後ろに大なりの記号（ `>` ）を続けた「矢印」の後にその型を宣言します。
関数の最後の行が何を返すのかを決定します。
ここにセミコロンがないことに気が付くでしょう。
もしそれを追加すると、こうなります。

```rust,ignore
fn add_one(x: i32) -> i32 {
    x + 1;
}
```

<!--We would get an error:-->
エラーが発生するでしょう。

```text
error: not all control paths return a value
fn add_one(x: i32) -> i32 {
     x + 1;
}

help: consider removing this semicolon:
     x + 1;
          ^
```

<!--This reveals two interesting things about Rust: it is an expression-based-->
<!--language, and semicolons are different from semicolons in other ‘curly brace-->
<!--and semicolon’-based languages. These two things are related.-->
これはRustについて2つの興味深いことを明らかにします。それが式ベースの言語であること、そしてセミコロンが他の「波括弧とセミコロン」ベースの言語でのセミコロンとは違っているということです。
これら2つのことは関連します。

<!--## Expressions vs. Statements-->
## 式対文

<!--Rust is primarily an expression-based language. There are only two kinds of-->
<!--statements, and everything else is an expression.-->
Rustは主として式ベースの言語です。
文には2種類しかなく、その他の全ては式です。

<!--So what's the difference? Expressions return a value, and statements do not.-->
<!--That’s why we end up with ‘not all control paths return a value’ here: the-->
<!--statement `x + 1;` doesn’t return a value. There are two kinds of statements in-->
<!--Rust: ‘declaration statements’ and ‘expression statements’. Everything else is-->
<!--an expression. Let’s talk about declaration statements first.-->
ではその違いは何でしょうか。
式は値を返しますが、文は返しません。
それが「not all control paths return a value」で終わった理由です。文 `x + 1;` は値を返さないからです。
Rustには2種類の文があります。「宣言文」と「式文」です。
その他の全ては式です。
まずは宣言文について話しましょう。

<!--In some languages, variable bindings can be written as expressions, not just-->
<!--statements. Like Ruby:-->
いくつかの言語では、変数束縛を文としてだけではなく、式として書くことができます。
Rubyではこうなります。

```ruby
x = y = 5
```

<!--In Rust, however, using `let` to introduce a binding is _not_ an expression. The-->
<!--following will produce a compile-time error:-->
しかし、Rustでは束縛を導入するための `let` の使用は式では _ありません_ 。
次の例はコンパイルエラーを起こします。

```ignore
# // let x = (let y = 5); // expected identifier, found keyword `let`
let x = (let y = 5); // 識別子を期待していましたが、キーワード `let` が見付かりました
```

<!--The compiler is telling us here that it was expecting to see the beginning of-->
<!--an expression, and a `let` can only begin a statement, not an expression.-->
ここでコンパイラは次のことを教えています。式の先頭を検出することが期待されていたところ、 `let` は式ではなく文の先頭にしかなれないということです。

<!--Note that assigning to an already-bound variable (e.g. `y = 5`) is still an-->
<!--expression, although its value is not particularly useful. Unlike other-->
<!--languages where an assignment evaluates to the assigned value (e.g. `5` in the-->
<!--previous example), in Rust the value of an assignment is an empty tuple `()`-->
<!--because the assigned value can have [just one owner](ownership.html), and any-->
<!--other returned value would be too surprising:-->
次のことに注意しましょう。既に束縛されている変数（例えば、 `y = 5` ）への割当ては、その値が特に役に立つものではなかったとしてもやはり式です。割当てが割り当てられる値（例えば、前の例では `5` ）を評価する他の言語とは異なり、Rustでは割当ての値は空のタプル `()` です。なぜなら、割り当てられる値には [単一の所有者](ownership.html) しかおらず、他のどんな値を返したとしても予想外の出来事になってしまうからです。


```rust
let mut y = 5;

# // let x = (y = 6);  // x has the value `()`, not `6`
let x = (y = 6);  // xは値 `()` を持っており、 `6` ではありません
```

<!--The second kind of statement in Rust is the *expression statement*. Its-->
<!--purpose is to turn any expression into a statement. In practical terms, Rust's-->
<!--grammar expects statements to follow other statements. This means that you use-->
<!--semicolons to separate expressions from each other. This means that Rust-->
<!--looks a lot like most other languages that require you to use semicolons-->
<!--at the end of every line, and you will see semicolons at the end of almost-->
<!--every line of Rust code you see.-->
Rustでの2種類目の文は *式文* です。
これの目的は式を文に変換することです。
実際にはRustの文法は文の後には他の文が続くことが期待されています。
これはそれぞれの式を区切るためにセミコロンを使うということを意味します。
これはRustが全ての行末にセミコロンを使うことを要求する他の言語のほとんどとよく似ていること、そして見られるRustのコードのほとんど全ての行末で、セミコロンが見られるということを意味します。

<!--What is this exception that makes us say "almost"? You saw it already, in this-->
<!--code:-->
「ほとんど」と言ったところの例外は何でしょうか。
この例で既に見ています。

```rust
fn add_one(x: i32) -> i32 {
    x + 1
}
```

<!--Our function claims to return an `i32`, but with a semicolon, it would return-->
<!--`()` instead. Rust realizes this probably isn’t what we want, and suggests-->
<!--removing the semicolon in the error we saw before.-->
この関数は `i32` を返そうとしていますが、セミコロンを付ければ、それは代わりに `()` を返します。
Rustはこの挙動がおそらく求めているものではないということを理解するので、前に見たエラーの中で、セミコロンを削除することを提案するのです。

<!--## Early returns-->
## 早期リターン

<!--But what about early returns? Rust does have a keyword for that, `return`:-->
しかし、早期リターンについてはどうでしょうか。
Rustはそのためのキーワード `return` を持っています。

```rust
fn foo(x: i32) -> i32 {
    return x;

#    // we never run this code!
    // このコードは走りません!
    x + 1
}
```

<!--Using a `return` as the last line of a function works, but is considered poor-->
<!--style:-->
`return` を関数の最後の行で使っても動きますが、それはよろしくないスタイルだと考えられています。

```rust
fn foo(x: i32) -> i32 {
    return x + 1;
}
```

<!--The previous definition without `return` may look a bit strange if you haven’t-->
<!--worked in an expression-based language before, but it becomes intuitive over-->
<!--time.-->
あなたがこれまで式ベースの言語を使ったことがなければ、 `return` のない前の定義の方がちょっと変に見えるかもしれません。しかし、それは時間とともに直観的に感じられるようになります。

<!--## Diverging functions-->
## 発散する関数

<!--Rust has some special syntax for ‘diverging functions’, which are functions that-->
<!--do not return:-->
Rustには「発散する関数」、すなわち値を返さない関数のための特別な構文がいくつかあります。

```rust
fn diverges() -> ! {
    panic!("This function never returns!");
}
```

<!--`panic!` is a macro, similar to `println!()` that we’ve already seen. Unlike-->
<!--`println!()`, `panic!()` causes the current thread of execution to crash with-->
<!--the given message. Because this function will cause a crash, it will never-->
<!--return, and so it has the type ‘`!`’, which is read ‘diverges’.-->
`panic!` は既に見てきた `println!` と同様にマクロです。
`println!` とは違って、 `panic!` は実行中の現在のスレッドを与えられたメッセージとともにクラッシュさせます。
この関数はクラッシュを引き起こすので、決して値を返しません。そのため、この関数は「 `!` 」型を持つのです。「 `!` 」は「発散する（diverges）」と読みます。

<!--If you add a main function that calls `diverges()` and run it, you’ll get-->
<!--some output that looks like this:-->
もし `diverges()` を呼び出すメイン関数を追加してそれを実行するならば、次のようなものが出力されるでしょう。

```text
thread ‘<main>’ panicked at ‘This function never returns!’, hello.rs:2
```

<!--If you want more information, you can get a backtrace by setting the-->
<!--`RUST_BACKTRACE` environment variable:-->
もしもっと情報を得たいと思うのであれば、 `RUST_BACKTRACE` 環境変数をセットすることでバックトレースを得ることができます。

```text
$ RUST_BACKTRACE=1 ./diverges
thread '<main>' panicked at 'This function never returns!', hello.rs:2
stack backtrace:
   1:     0x7f402773a829 - sys::backtrace::write::h0942de78b6c02817K8r
   2:     0x7f402773d7fc - panicking::on_panic::h3f23f9d0b5f4c91bu9w
   3:     0x7f402773960e - rt::unwind::begin_unwind_inner::h2844b8c5e81e79558Bw
   4:     0x7f4027738893 - rt::unwind::begin_unwind::h4375279447423903650
   5:     0x7f4027738809 - diverges::h2266b4c4b850236beaa
   6:     0x7f40277389e5 - main::h19bb1149c2f00ecfBaa
   7:     0x7f402773f514 - rt::unwind::try::try_fn::h13186883479104382231
   8:     0x7f402773d1d8 - __rust_try
   9:     0x7f402773f201 - rt::lang_start::ha172a3ce74bb453aK5w
  10:     0x7f4027738a19 - main
  11:     0x7f402694ab44 - __libc_start_main
  12:     0x7f40277386c8 - <unknown>
  13:                0x0 - <unknown>
```

<!--`RUST_BACKTRACE` also works with Cargo’s `run` command:-->
`RUST_BACKTRACE` はCargoの `run` コマンドでも使うことができます。

```text
$ RUST_BACKTRACE=1 cargo run
     Running `target/debug/diverges`
thread '<main>' panicked at 'This function never returns!', hello.rs:2
stack backtrace:
   1:     0x7f402773a829 - sys::backtrace::write::h0942de78b6c02817K8r
   2:     0x7f402773d7fc - panicking::on_panic::h3f23f9d0b5f4c91bu9w
   3:     0x7f402773960e - rt::unwind::begin_unwind_inner::h2844b8c5e81e79558Bw
   4:     0x7f4027738893 - rt::unwind::begin_unwind::h4375279447423903650
   5:     0x7f4027738809 - diverges::h2266b4c4b850236beaa
   6:     0x7f40277389e5 - main::h19bb1149c2f00ecfBaa
   7:     0x7f402773f514 - rt::unwind::try::try_fn::h13186883479104382231
   8:     0x7f402773d1d8 - __rust_try
   9:     0x7f402773f201 - rt::lang_start::ha172a3ce74bb453aK5w
  10:     0x7f4027738a19 - main
  11:     0x7f402694ab44 - __libc_start_main
  12:     0x7f40277386c8 - <unknown>
  13:                0x0 - <unknown>
```

<!--A diverging function can be used as any type:-->
発散する関数は任意の型としても使えます。

```should_panic
# fn diverges() -> ! {
#    panic!("This function never returns!");
# }
let x: i32 = diverges();
let x: String = diverges();
```

<!--## Function pointers-->
## 関数ポインタ

<!--We can also create variable bindings which point to functions:-->
関数を指示する変数束縛を作ることもできます。

```rust
let f: fn(i32) -> i32;
```

<!--`f` is a variable binding which points to a function that takes an `i32` as-->
<!--an argument and returns an `i32`. For example:-->
`f` は `i32` を引数として受け取り、 `i32` を返す関数を指示する変数束縛です。
例えばこうです。

```rust
fn plus_one(i: i32) -> i32 {
    i + 1
}

// without type inference
let f: fn(i32) -> i32 = plus_one;

// with type inference
let f = plus_one;
```

<!--We can then use `f` to call the function:-->
そして、その関数を呼び出すために `f` を使うことができます。

```rust
# fn plus_one(i: i32) -> i32 { i + 1 }
# let f = plus_one;
let six = f(5);
```
