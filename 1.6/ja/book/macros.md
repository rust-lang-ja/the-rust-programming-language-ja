% マクロ
<!-- % Macros -->

<!-- By now you’ve learned about many of the tools Rust provides for abstracting and -->
<!-- reusing code. These units of code reuse have a rich semantic structure. For -->
<!-- example, functions have a type signature, type parameters have trait bounds, -->
<!-- and overloaded functions must belong to a particular trait. -->
Rustが提供している多くのコードの再利用や抽象化に利用できるツールを学びました。
それらのコードの再利用のユニットは豊富な意味論的構造を持っています。
例えば、関数は型シグネチャ、型パラメータはトレイト境界、オーバーロードされた関数はトレイトに所属していなければならない等です。

<!-- This structure means that Rust’s core abstractions have powerful compile-time -->
<!-- correctness checking. But this comes at the price of reduced flexibility. If -->
<!-- you visually identify a pattern of repeated code, you may find it’s difficult -->
<!-- or cumbersome to express that pattern as a generic function, a trait, or -->
<!-- anything else within Rust’s semantics. -->
このような構造はRustのコアの抽象化が強力なコンパイル時の正確性のチェックを持っているという事を意味しています。
しかし、それは柔軟性の減少というコストを払っています。
もし、視覚的に繰り返しているコードのパターンを発見した時に、
それらをジェネリックな関数やトレイトや、他のRustのセマンティクスとして表現することが困難であると気がつくかもしれません。

<!-- Macros allow us to abstract at a syntactic level. A macro invocation is -->
<!-- shorthand for an "expanded" syntactic form. This expansion happens early in -->
<!-- compilation, before any static checking. As a result, macros can capture many -->
<!-- patterns of code reuse that Rust’s core abstractions cannot. -->
マクロは構文レベルでの抽象化をすることを可能にします。
マクロ呼出は「展開された」構文への短縮表現です。
展開はコンパイルの初期段階、すべての静的なチェックが実行される前に行われます。
その結果として、マクロはRustのコアの抽象化では不可能な多くのパターンのコードの再利用を可能としています。


<!-- The drawback is that macro-based code can be harder to understand, because -->
<!-- fewer of the built-in rules apply. Like an ordinary function, a well-behaved -->
<!-- macro can be used without understanding its implementation. However, it can be -->
<!-- difficult to design a well-behaved macro!  Additionally, compiler errors in -->
<!-- macro code are harder to interpret, because they describe problems in the -->
<!-- expanded code, not the source-level form that developers use. -->
マクロベースのコードの欠点は、組み込みルールの少なさに由来するそのコードの理解のしづらさです。
普通の関数と同じように、良いマクロはその実装について理解しなくても使うことができます。
しかしながら、そのような良いマクロを設計するのは困難です！
加えて、マクロコード中のコンパイルエラーは開発者が書いたソールレベルではなく、
展開した結果のコードの中の問題について書かれているために、とても理解しづらいです。


<!-- These drawbacks make macros something of a "feature of last resort". That’s not -->
<!-- to say that macros are bad; they are part of Rust because sometimes they’re -->
<!-- needed for truly concise, well-abstracted code. Just keep this tradeoff in -->
<!-- mind. -->
これらの欠点はマクロを「最終手段となる機能」にしています。
これは、マクロが良くないものだと言っているわけではありません、マクロはRustの一部です、
なぜならばマクロを使うことで簡潔になったり、適切な抽象化が可能になる場面がしばしば存在するからです。
ただ、このトレードオフを頭に入れておいて欲しいのです。

<!-- # Defining a macro -->
# マクロを定義する

<!-- You may have seen the `vec!` macro, used to initialize a [vector][vector] with -->
<!-- any number of elements. -->
`vec!` マクロを見たことがあるでしょう、 [ベクタ][vector] を任意の要素で初期化するために使われていました。

[vector]: vectors.html

```rust
let x: Vec<u32> = vec![1, 2, 3];
# assert_eq!(x, [1, 2, 3]);
```

<!-- This can’t be an ordinary function, because it takes any number of arguments. -->
<!-- But we can imagine it as syntactic shorthand for -->
`vec!` は通常の関数として定義することはできません、なぜなら `vec!` は任意の個数の引数を取るためです。
しかし、 `vec!` を以下のコードの構文上の短縮形であると考えることができます:

```rust
let x: Vec<u32> = {
    let mut temp_vec = Vec::new();
    temp_vec.push(1);
    temp_vec.push(2);
    temp_vec.push(3);
    temp_vec
};
# assert_eq!(x, [1, 2, 3]);
```

<!-- We can implement this shorthand, using a macro: [^actual] -->
このような短縮形をマクロ: [^actual] を用いることで実装することができます

<!-- [^actual]: The actual definition of `vec!` in libcollections differs from the -->
<!--           one presented here, for reasons of efficiency and reusability. -->
[^actual]: `vec!` のlibcollectionsにおける実際の実装と、ここで示したコードは効率性や再利用性のために異なります。

```rust
macro_rules! vec {
    ( $( $x:expr ),* ) => {
        {
            let mut temp_vec = Vec::new();
            $(
                temp_vec.push($x);
            )*
            temp_vec
        }
    };
}
# fn main() {
#     assert_eq!(vec![1,2,3], [1, 2, 3]);
# }
```

<!-- Whoa, that’s a lot of new syntax! Let’s break it down. -->
ワオ！たくさんの新しい構文が現れました！細かく見ていきましょう。

```ignore
macro_rules! vec { ... }
```

<!-- This says we’re defining a macro named `vec`, much as `fn vec` would define a -->
<!-- function named `vec`. In prose, we informally write a macro’s name with an -->
<!-- exclamation point, e.g. `vec!`. The exclamation point is part of the invocation -->
<!-- syntax and serves to distinguish a macro from an ordinary function. -->
これは、新しいマクロ `vec` を定義していることを意味しています、`vec` という関数を定義するときに `fn vec` と書くのと同じです。
非公式ですが、実際には、マクロ名をエクスクラメーションマーク(!) と共に記述します、例えば: `vec!` のように示します。
エクスクラメーションマークはマクロ呼び出しの構文の一部で、マクロと通常の関数の区別をつけるためのものです。

<!-- ## Matching -->
## マッチング

<!-- The macro is defined through a series of rules, which are pattern-matching -->
<!-- cases. Above, we had -->
マクロは、幾つかのパターンマッチのケースを利用したルールに従って定義されています、
上のコード中では、以下の様なパターンが見られました:

```ignore
( $( $x:expr ),* ) => { ... };
```

<!-- This is like a `match` expression arm, but the matching happens on Rust syntax -->
<!-- trees, at compile time. The semicolon is optional on the last (here, only) -->
<!-- case. The "pattern" on the left-hand side of `=>` is known as a ‘matcher’. -->
<!-- These have [their own little grammar] within the language. -->
これは `match` 式の腕に似ていますが、Rustの構文木に対してコンパイル時にマッチします。
セミコロンはケースの末尾でだけ使うことのでき、省略可能です。
`=>` の左辺にある「パターン」は「マッチャー」として知られています。
マッチャーは [小さなマッチャー独自の構文][their own little grammar] を持っています。

[their own little grammar]: ../reference.html#macros

<!-- The matcher `$x:expr` will match any Rust expression, binding that syntax tree -->
<!-- to the ‘metavariable’ `$x`. The identifier `expr` is a ‘fragment specifier’; -->
<!-- the full possibilities are enumerated later in this chapter. -->
<!-- Surrounding the matcher with `$(...),*` will match zero or more expressions, -->
<!-- separated by commas. -->
マッチャー `$x:expr` は任意のRustの式にマッチし、マッチした構文木を「メタ変数」 `$x` に束縛します。
識別子 `expr` は「フラグメント指定子」です。全てのフラグメント指定子の一覧はこの章で後ほど紹介します。
マッチャーを `$(...),*` で囲むと0個以上のコンマで句切られた式にマッチします。

<!-- Aside from the special matcher syntax, any Rust tokens that appear in a matcher -->
<!-- must match exactly. For example, -->
特別なマッチャー構文は別にして、マッチャー中に登場するその他の任意のトークンはそれ自身に正確にマッチする必要があります。
例えば:

```rust
macro_rules! foo {
    (x => $e:expr) => (println!("mode X: {}", $e));
    (y => $e:expr) => (println!("mode Y: {}", $e));
}

fn main() {
    foo!(y => 3);
}
```

<!-- will print -->
上のコードは以下の様な出力をします

```text
mode Y: 3
```

<!-- With -->
また、以下のようなコードでは

```rust,ignore
foo!(z => 3);
```

<!-- we get the compiler error -->
以下の様なコンパイルエラーが発生します

```text
error: no rules expected the token `z`
```

<!-- ## Expansion -->
## 展開

<!-- The right-hand side of a macro rule is ordinary Rust syntax, for the most part. -->
<!-- But we can splice in bits of syntax captured by the matcher. From the original -->
<!-- example: -->
マクロルールの右辺は大部分が通常のRustの構文です。
しかし、マッチャーによってキャプチャされた構文を繋げる事ができます。
最初に示した `vec!` の例を見てみましょう:

```ignore
$(
    temp_vec.push($x);
)*
```

<!-- Each matched expression `$x` will produce a single `push` statement in the -->
<!-- macro expansion. The repetition in the expansion proceeds in "lockstep" with -->
<!-- repetition in the matcher (more on this in a moment). -->
`$x` にマッチしたそれぞれの式はマクロ展開中に `push` 文を生成します。
マクロ展開中の繰り返しはマッチャー中の繰り返しと足並みを揃えて実行されます(これについてはもう少し説明します)。

<!-- Because `$x` was already declared as matching an expression, we don’t repeat -->
<!-- `:expr` on the right-hand side. Also, we don’t include a separating comma as -->
<!-- part of the repetition operator. Instead, we have a terminating semicolon -->
<!-- within the repeated block. -->
`$x` が既に式にマッチすると宣言されているために、`=>` の右辺では `:expr` を繰り返しません。
また、区切りのコンマは繰り返し演算子の一部には含めません。
そのかわり、繰り返しブロックをセミコロンを用いて閉じます。

<!-- Another detail: the `vec!` macro has *two* pairs of braces on the right-hand -->
<!-- side. They are often combined like so: -->
そのほかの詳細としては: `vec!` マクロは *2つ* の括弧のペアを右辺に含みます。
それらの括弧はよく以下のように合せられます:

```ignore
macro_rules! foo {
    () => {{
        ...
    }}
}
```

<!-- The outer braces are part of the syntax of `macro_rules!`. In fact, you can use -->
<!-- `()` or `[]` instead. They simply delimit the right-hand side as a whole. -->
外側の括弧は `macro_rules!` 構文の一部です。事実、`()` や `[]` をかわりに使うことができます。
括弧は単純に右辺を区切るために利用されています。

<!--  The inner braces are part of the expanded syntax. Remember, the `vec!` macro is -->
<!--  used in an expression context. To write an expression with multiple statements, -->
<!--  including `let`-bindings, we use a block. If your macro expands to a single -->
<!--  expression, you don’t need this extra layer of braces. -->
内側の括弧は展開結果の一部です。
`vec!` マクロは式を必要としているコンテキストで利用されていることを思いだしてください。
複数の文や、 `let` 束縛を含む式を書きたいときにはブロックを利用します。
もし、マクロが単一の式に展開されるときは、追加の括弧は必要ありません。

<!-- Note that we never *declared* that the macro produces an expression. In fact, -->
<!-- this is not determined until we use the macro as an expression. With care, you -->
<!-- can write a macro whose expansion works in several contexts. For example, -->
<!-- shorthand for a data type could be valid as either an expression or a pattern. -->
マクロが式を生成すると *宣言* した事はないという点に注意してください。
事実、それはマクロを式として利用するまでは決定されません。
注意深くすれば、複数のコンテキストで適切に展開されるマクロを書く事ができます。
例えば、データ型の短縮形は、式としてもパターンとしても正しく動作します。

<!-- ## Repetition -->
## 繰り返し

<!-- The repetition operator follows two principal rules: -->
繰り返し演算子は以下の2つの重要なルールに従います:

<!-- 1. `$(...)*` walks through one "layer" of repetitions, for all of the `$name`s -->
<!--    it contains, in lockstep, and -->
<!-- 2. each `$name` must be under at least as many `$(...)*`s as it was matched -->
<!--    against. If it is under more, it’ll be duplicated, as appropriate. -->
1. `$(...)*` は繰り返しの一つの「レイヤー」上で動作し、 レイヤーが含んでいる `$name` について足並みを揃えて動作します。
2. それぞれの `$name` はマッチしたときと同じ個数の `$(...)*` の内側になければなりません。
    もし更に多くの `$(...)*` の中に表われた際には適切に複製されます。

<!-- This baroque macro illustrates the duplication of variables from outer -->
<!-- repetition levels. -->
以下の複雑なマクロは一つ外の繰り返しのレベルから値を複製している例です:

```rust
macro_rules! o_O {
    (
        $(
            $x:expr; [ $( $y:expr ),* ]
        );*
    ) => {
        &[ $($( $x + $y ),*),* ]
    }
}

fn main() {
    let a: &[i32]
        = o_O!(10; [1, 2, 3];
               20; [4, 5, 6]);

    assert_eq!(a, [11, 12, 13, 24, 25, 26]);
}
```

<!-- That’s most of the matcher syntax. These examples use `$(...)*`, which is a -->
<!-- "zero or more" match. Alternatively you can write `$(...)+` for a "one or -->
<!-- more" match. Both forms optionally include a separator, which can be any token -->
<!-- except `+` or `*`. -->
上のコードはほとんどのマッチャーの構文を利用しています。
この例では0個以上にマッチする `$(...)*` を利用しています、
1つ以上にマッチさせたい場合は `$(...)+` を代りに利用する事ができます。
また、どちらも補助的に区切りを指定する事ができます。区切りには、 `+` と `*` 以外の任意のトークンを指定することが可能です。

<!-- This system is based on -->
<!-- "[Macro-by-Example](https://www.cs.indiana.edu/ftp/techreports/TR206.pdf)" -->
<!-- (PDF link). -->
このシステムは:
"[Macro-by-Example](https://www.cs.indiana.edu/ftp/techreports/TR206.pdf)"
(PDFリンク) に基づいています。

<!-- # Hygiene -->
# 健全性

<!-- Some languages implement macros using simple text substitution, which leads to -->
<!-- various problems. For example, this C program prints `13` instead of the -->
<!-- expected `25`. -->
いくつかの言語に組込まれているマクロは単純なテキストの置換を用いています、しかしこれは多くの問題を発生させます。
例えば、以下のC言語のプログラムは期待している `25` の代りに `13` と出力します:

```text
#define FIVE_TIMES(x) 5 * x

int main() {
    printf("%d\n", FIVE_TIMES(2 + 3));
    return 0;
}
```

<!-- After expansion we have `5 * 2 + 3`, and multiplication has greater precedence -->
<!-- than addition. If you’ve used C macros a lot, you probably know the standard -->
<!-- idioms for avoiding this problem, as well as five or six others. In Rust, we -->
<!-- don’t have to worry about it. -->
展開した結果は `5 * 2 + 3` となり、乗算は加算よりも優先度が高くなります。
もしC言語のマクロを頻繁に利用しているなら、この問題を避けるためのイディオムを5、6個は知っているでしょう。
Rustではこのような問題を恐れる必要はありません。

```rust
macro_rules! five_times {
    ($x:expr) => (5 * $x);
}

fn main() {
    assert_eq!(25, five_times!(2 + 3));
}
```

<!-- The metavariable `$x` is parsed as a single expression node, and keeps its -->
<!-- place in the syntax tree even after substitution. -->
メタ変数 `$x` は一つの式の頂点としてパースされ、構文木上の位置は置換されたあとも保存されます。

<!-- Another common problem in macro systems is ‘variable capture’. Here’s a C -->
<!-- macro, using [a GNU C extension] to emulate Rust’s expression blocks. -->
他のマクロシステムで良くみられる問題は、「変数のキャプチャ」です。
以下のC言語のマクロは [GNU C拡張][a GNU C extension] をRustの式のブロックをエミュレートするために利用しています。

[a GNU C extension]: https://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html

```text
#define LOG(msg) ({ \
    int state = get_log_state(); \
    if (state > 0) { \
        printf("log(%d): %s\n", state, msg); \
    } \
})
```

<!-- Here’s a simple use case that goes terribly wrong: -->
以下はこのマクロを利用したときにひどい事になる単純な利用例です:

```text
const char *state = "reticulating splines";
LOG(state)
```

<!-- This expands to -->
このコードは以下のように展開されます

```text
const char *state = "reticulating splines";
int state = get_log_state();
if (state > 0) {
    printf("log(%d): %s\n", state, state);
}
```

<!-- The second variable named `state` shadows the first one.  This is a problem -->
<!-- because the print statement should refer to both of them. -->
2番目の変数 `state` は1つめの `state` を隠してしまいます。
この問題は、print文が両方の変数を参照する必要があるために起こります。

<!-- The equivalent Rust macro has the desired behavior. -->
Rustにおける同様のマクロは期待する通りの動作をします。

```rust
# fn get_log_state() -> i32 { 3 }
macro_rules! log {
    ($msg:expr) => {{
        let state: i32 = get_log_state();
        if state > 0 {
            println!("log({}): {}", state, $msg);
        }
    }};
}

fn main() {
    let state: &str = "reticulating splines";
    log!(state);
}
```

<!-- This works because Rust has a [hygienic macro system]. Each macro expansion -->
<!-- happens in a distinct ‘syntax context’, and each variable is tagged with the -->
<!-- syntax context where it was introduced. It’s as though the variable `state` -->
<!-- inside `main` is painted a different "color" from the variable `state` inside -->
<!-- the macro, and therefore they don’t conflict. -->
このマクロはRustが [健全なマクロシステム][hygienic macro system] を持っているためです。
それぞれのマクロ展開は分離された「構文コンテキスト」で行なわれ、
それぞれの変数はその変数が導入された構文コンテキストでタグ付けされます。
これは、 `main` 中の `state` がマクロの中の `state` とは異なる「色」で塗られているためにコンフリクトしないという風に考える事ができます。

[hygienic macro system]: https://en.wikipedia.org/wiki/Hygienic_macro

<!-- This also restricts the ability of macros to introduce new bindings at the -->
<!-- invocation site. Code such as the following will not work: -->
この健全性のシステムはマクロが新しい束縛を呼出時に導入する事を制限します。
以下のようなコードは動作しません:

```rust,ignore
macro_rules! foo {
    () => (let x = 3);
}

fn main() {
    foo!();
    println!("{}", x);
}
```

<!-- Instead you need to pass the variable name into the invocation, so it’s tagged -->
<!-- with the right syntax context. -->
代りに変数名を呼出時に渡す必要があります、
呼出時に渡す事で正しい構文コンテキストでタグ付けされます。

```rust
macro_rules! foo {
    ($v:ident) => (let $v = 3);
}

fn main() {
    foo!(x);
    println!("{}", x);
}
```

<!-- This holds for `let` bindings and loop labels, but not for [items][items]. -->
<!-- So the following code does compile: -->
このルールは `let` 束縛やループについても同様ですが、 [アイテム][items] については適用されません。
そのため、以下のコードはコンパイルが通ります:

```rust
macro_rules! foo {
    () => (fn x() { });
}

fn main() {
    foo!();
    x();
}
```

[items]: ../reference.html#items

<!-- # Recursive macros -->
# 再帰的マクロ

<!-- A macro’s expansion can include more macro invocations, including invocations -->
<!-- of the very same macro being expanded.  These recursive macros are useful for -->
<!-- processing tree-structured input, as illustrated by this (simplistic) HTML -->
<!-- shorthand: -->
マクロの展開は、展開中のマクロ自身も含めたその他のマクロ呼出しを含んでいることが可能です。
そのような再帰的なマクロは、以下の(単純化した)HTMLの短縮形のような、木構造を持つ入力の処理に便利です:

```rust
# #![allow(unused_must_use)]
macro_rules! write_html {
    ($w:expr, ) => (());

    ($w:expr, $e:tt) => (write!($w, "{}", $e));

    ($w:expr, $tag:ident [ $($inner:tt)* ] $($rest:tt)*) => {{
        write!($w, "<{}>", stringify!($tag));
        write_html!($w, $($inner)*);
        write!($w, "</{}>", stringify!($tag));
        write_html!($w, $($rest)*);
    }};
}

fn main() {
#   // FIXME(#21826)
    use std::fmt::Write;
    let mut out = String::new();

    write_html!(&mut out,
        html[
            head[title["Macros guide"]]
            body[h1["Macros are the best!"]]
        ]);

    assert_eq!(out,
        "<html><head><title>Macros guide</title></head>\
         <body><h1>Macros are the best!</h1></body></html>");
}
```

<!-- # Debugging macro code -->
# マクロをデバッグする

<!-- To see the results of expanding macros, run `rustc --pretty expanded`. The -->
<!-- output represents a whole crate, so you can also feed it back in to `rustc`, -->
<!-- which will sometimes produce better error messages than the original -->
<!-- compilation. Note that the `--pretty expanded` output may have a different -->
<!-- meaning if multiple variables of the same name (but different syntax contexts) -->
<!-- are in play in the same scope. In this case `--pretty expanded,hygiene` will -->
<!-- tell you about the syntax contexts. -->
マクロの展開結果を見るには、 `rustc --pretty expanded` を実行して下さい。
出力結果はクレートの全体を表しています、そのため出力結果を再び `rustc` に与えることができます、
そのようにすると時々、直接コンパイルした場合よりもより良いエラーメッセージを得ることができます。
しかし、 `--pretty expanded`  は同じ名前の変数(構文コンテキストは異なる)が同じスコープに複数存在する場合、
出力結果のコード自体は、元のコードと意味が変わってくる場合があります。
そのようになってしまう場合、 `--pretty expanded,hygiene` のようにすることで、構文コンテキストについて知ることができます。

<!-- `rustc` provides two syntax extensions that help with macro debugging. For now, -->
<!-- they are unstable and require feature gates. -->
`rustc` はマクロのデバッグを補助する２つの構文拡張を提供しています。
今のところは、それらの構文は不安定であり、フィーチャーゲートを必要としています。

<!-- * `log_syntax!(...)` will print its arguments to standard output, at compile -->
<!--   time, and "expand" to nothing. -->
* `log_syntax!(...)` は与えられた引数をコンパイル時に標準入力に出力し、展開結果は何も生じません。

<!-- * `trace_macros!(true)` will enable a compiler message every time a macro is -->
<!--   expanded. Use `trace_macros!(false)` later in expansion to turn it off. -->
* `trace_macros!(true)` はマクロが展開されるたびにコンパイラがメッセージを出力するように設定できます、
  `trace_macros!(false)` を展開の終わりごろに用いることで、メッセージの出力をオフにできます。

<!-- # Syntactic requirements -->
# 構文的な要求

<!-- Even when Rust code contains un-expanded macros, it can be parsed as a full -->
<!-- [syntax tree][ast]. This property can be very useful for editors and other -->
<!-- tools that process code. It also has a few consequences for the design of -->
<!-- Rust’s macro system. -->
Rustのコードに展開されていないマクロが含まれていても、 [構文木][ast] としてパースすることができます。
このような特性はテキストエディタや、その他のコードを処理するツールにとって非常に便利です。
また、このような特性はRustのマクロシステムの設計にも影響を及ぼしています。

[ast]: glossary.html#abstract-syntax-tree

<!-- One consequence is that Rust must determine, when it parses a macro invocation, -->
<!-- whether the macro stands in for -->
一つの影響としては、マクロ呼出をパースした時、マクロが以下のどれを意味しているかを判定する必要があります:

<!-- * zero or more items, -->
<!-- * zero or more methods, -->
<!-- * an expression, -->
<!-- * a statement, or -->
<!-- * a pattern. -->
* 0個以上のアイテム
* 0個以上のメソッド
* 式
* 文
* パターン

<!-- A macro invocation within a block could stand for some items, or for an -->
<!-- expression / statement. Rust uses a simple rule to resolve this ambiguity. A -->
<!-- macro invocation that stands for items must be either -->
ブロック中でのマクロ呼出は、幾つかのアイテムや、一つの式 / 文 に対応します。
Rustはこの曖昧性を判定するためにRustは単純なルールを利用します。
アイテムに対応しているマクロ呼出は以下のどちらかでなければなりません

<!-- * delimited by curly braces, e.g. `foo! { ... }`, or -->
<!-- * terminated by a semicolon, e.g. `foo!(...);` -->
* 波括弧で区切られている 例: `foo! { ... }`
* セミコロンで終了している 例: `foo!(...);`

<!-- Another consequence of pre-expansion parsing is that the macro invocation must -->
<!-- consist of valid Rust tokens. Furthermore, parentheses, brackets, and braces -->
<!-- must be balanced within a macro invocation. For example, `foo!([)` is -->
<!-- forbidden. This allows Rust to know where the macro invocation ends. -->
その他の展開前にパース可能である事による制約はマクロ呼出は正しいRustトークンで構成されている必要があるというものです。
そのうえ、括弧や、角カッコ、波括弧はマクロ呼出し中でバランスしてなければなりません。
例えば: `foo!([)` は禁止されています。
これによってRustはマクロ呼出しがどこで終わっているかを知ることができます。

<!-- More formally, the macro invocation body must be a sequence of ‘token trees’. -->
<!-- A token tree is defined recursively as either -->
もっと厳密に言うと、マクロ呼出しの本体は「トークンの木」のシーケンスである必要があります。
トークンの木は以下のいずれかの条件により再帰的に定義されています

<!-- * a sequence of token trees surrounded by matching `()`, `[]`, or `{}`, or -->
<!-- * any other single token. -->
* マッチャー、 `()` 、 `[]` または `{}` で囲まれたトークンの木、あるいは、
* その他の単一のトークン

<!-- Within a matcher, each metavariable has a ‘fragment specifier’, identifying -->
<!-- which syntactic form it matches. -->
マッチャー内部ではそれぞれのメタ変数はマッチする構文を指定する「フラグメント指定子」を持っています。

<!-- * `ident`: an identifier. Examples: `x`; `foo`. -->
<!-- * `path`: a qualified name. Example: `T::SpecialA`. -->
<!-- * `expr`: an expression. Examples: `2 + 2`; `if true { 1 } else { 2 }`; `f(42)`. -->
<!-- * `ty`: a type. Examples: `i32`; `Vec<(char, String)>`; `&T`. -->
<!-- * `pat`: a pattern. Examples: `Some(t)`; `(17, 'a')`; `_`. -->
<!-- * `stmt`: a single statement. Example: `let x = 3`. -->
<!-- * `block`: a brace-delimited sequence of statements. Example: -->
<!--   `{ log(error, "hi"); return 12; }`. -->
<!-- * `item`: an [item][item]. Examples: `fn foo() { }`; `struct Bar;`. -->
<!-- * `meta`: a "meta item", as found in attributes. Example: `cfg(target_os = "windows")`. -->
<!-- * `tt`: a single token tree. -->
* `ident`: 識別子。 例: `x`; `foo`
* `path`: 修飾された名前。例: `T::SpecialA`
* `expr`: 式。 例: `2 + 2`; `if true { 1 } else { 2 }`; `f(42)`
* `ty`: 型。 例: `i32`; `Vec<(char, String)>`; `&T`
* `pat`: パターン。 例: `Some(t)`; `(17, 'a')`; `_`
* `stmt`: 単一の文。 例: `let x = 3`
* `block`: 波括弧で区切られた文のシーケンス。 例: `{ log(error, "hi"); return 12 }`
* `item`: [アイテム][item]。 例: `fn foo() { }`; `struct Bar;`
* `meta`: アトリビュートで見られるような「メタアイテム」。 例: `cfg(target_os = "windows")`
* `tt`: 単一のトークンの木

<!-- There are additional rules regarding the next token after a metavariable: -->
またメタ変数の次のトークンについて以下のルールが存在します:

<!-- * `expr` variables may only be followed by one of: `=> , ;` -->
<!-- * `ty` and `path` variables may only be followed by one of: `=> , : = > as` -->
<!-- * `pat` variables may only be followed by one of: `=> , = if in` -->
<!-- * Other variables may be followed by any token. -->
* `expr` 変数は `=> , ;` のどれか一つのみが次に現れます
* `ty` と `path` 変数は `=> , : = > as` のどれか一つのみが次に現れます
* `pat` 変数は `=> , = if in` のどれか一つのみが次に現れます
* その他の変数は任意のトークンが次に現れます

<!-- These rules provide some flexibility for Rust’s syntax to evolve without -->
<!-- breaking existing macros. -->
これらのルールは既存のマクロを破壊すること無くRustの構文を拡張するための自由度を与えます。

<!-- The macro system does not deal with parse ambiguity at all. For example, the -->
<!-- grammar `$($t:ty)* $e:expr` will always fail to parse, because the parser would -->
<!-- be forced to choose between parsing `$t` and parsing `$e`. Changing the -->
<!-- invocation syntax to put a distinctive token in front can solve the problem. In -->
<!-- this case, you can write `$(T $t:ty)* E $e:exp`. -->
マクロシステムはパースの曖昧さについてな何も対処しません。
例えば、 `$($t:ty)* $e:expr` は常にパースが失敗します、
なぜならパーサーは `$t` をパースするか、 `$e` をパースするかを選ぶことを強制されるためです。
呼出構文を変更して識別可能なトークンを先頭につけることでこの問題は回避することができます。
そのようにする場合、例えば `$(T $t:ty)* E $e:exp` のように書くことができます。

[item]: ../reference.html#items

<!-- # Scoping and macro import/export -->
# スコープとマクロのインポート/エクスポート

<!-- Macros are expanded at an early stage in compilation, before name resolution. -->
<!-- One downside is that scoping works differently for macros, compared to other -->
<!-- constructs in the language. -->
マクロはコンパイルの早い段階、名前解決が行われる前に展開されます。
一つの悪い側面としては、言語中のその他の構造とは異なり、マクロではスコープが少し違って動作するということです。


<!-- Definition and expansion of macros both happen in a single depth-first, -->
<!-- lexical-order traversal of a crate’s source. So a macro defined at module scope -->
<!-- is visible to any subsequent code in the same module, which includes the body -->
<!-- of any subsequent child `mod` items. -->
マクロの定義と展開はクレートの字面上の順序どおりに単一の深さ優先探索で行われます。
そのため、モジュールスコープで定義されたマクロは、
後続する子供の `mod` アイテムも含む、同じモジュール中のコードから見えます。

<!-- A macro defined within the body of a single `fn`, or anywhere else not at -->
<!-- module scope, is visible only within that item. -->
`fn` の本体の中やその他のモジュールのスコープでない箇所で定義されたマクロはそのアイテム中でしか見えません。

<!-- If a module has the `macro_use` attribute, its macros are also visible in its -->
<!-- parent module after the child’s `mod` item. If the parent also has `macro_use` -->
<!-- then the macros will be visible in the grandparent after the parent’s `mod` -->
<!-- item, and so forth. -->
もし、モジュールが `macro_use` アトリビュートを持っていた場合、
それらのマクロは子供の `mod` アイテムの後で、親モジュールからも見えます。
もし親モジュールが同様に `macro_use` アトリビュートを持っていた場合、 親の親モジュールから親の `mod` アイテムが終わった後に見えます。
その後についても同様です。

<!-- The `macro_use` attribute can also appear on `extern crate`. In this context -->
<!-- it controls which macros are loaded from the external crate, e.g. -->
また、 `macro_use` アトリビュートは `extern create` の上でも利用することができます。
そのようにした場合、 `macro_use` アトリビュートは外部のクレートからどのマクロをロードするのかを指定します。
以下がその例です:

```rust,ignore
#[macro_use(foo, bar)]
extern crate baz;
```

<!-- If the attribute is given simply as `#[macro_use]`, all macros are loaded. If -->
<!-- there is no `#[macro_use]` attribute then no macros are loaded. Only macros -->
<!-- defined with the `#[macro_export]` attribute may be loaded. -->
もしアトリビュートが単純に `#[macro_use]` という形で指定されていた場合、全てのマクロがロードされます。
もし、 `#[macro_use]` が指定されていなかった場合、 `#[macro_export]` アトリビュートとともに定義されているマクロ以外は、
どのマクロもロードされません。

<!-- To load a crate’s macros without linking it into the output, use `#[no_link]` -->
<!-- as well. -->
クレートのマクロを出力にリンクさせずにロードするには、 `#[no_link]` を利用して下さい。

<!-- An example: -->
一例としては:

```rust
macro_rules! m1 { () => (()) }

# // // visible here: m1
// ここで見えるのは: m1

mod foo {
# //    // visible here: m1
    // ここで見えるのは: m1

    #[macro_export]
    macro_rules! m2 { () => (()) }

# //    // visible here: m1, m2
    // ここで見えるのは: m1、m2
}

# // // visible here: m1
// ここで見えるのは: m1

macro_rules! m3 { () => (()) }

# // // visible here: m1, m3
// ここで見えるのは: m1、m3

#[macro_use]
mod bar {
# //    // visible here: m1, m3
    // ここで見えるのは: m1、m3

    macro_rules! m4 { () => (()) }

# //    // visible here: m1, m3, m4
    // ここで見えるのは: m1、m3、m4
}

# // // visible here: m1, m3, m4
// ここで見えるのは: m1、m3、m4
# fn main() { }
```

<!-- When this library is loaded with `#[macro_use] extern crate`, only `m2` will -->
<!-- be imported. -->
ライブラリが `#[macro_use]` と共に外部のクレートをロードした場合、 `m2` だけがインポートされます。

<!-- The Rust Reference has a [listing of macro-related -->
<!-- attributes](../reference.html#macro-related-attributes). -->
Rustのリファレンスは [マクロに関連するアトリビュートの一覧](../reference.html#macro-related-attributes) を掲載しています。

<!-- # The variable `$crate` -->
# `$crate` 変数

<!-- A further difficulty occurs when a macro is used in multiple crates. Say that -->
<!-- `mylib` defines -->
さらなる困難はマクロが複数のクレートで利用された時に発生します。
`mylib` が以下のように定義されているとしましょう

```rust
pub fn increment(x: u32) -> u32 {
    x + 1
}

#[macro_export]
macro_rules! inc_a {
    ($x:expr) => ( ::increment($x) )
}

#[macro_export]
macro_rules! inc_b {
    ($x:expr) => ( ::mylib::increment($x) )
}
# fn main() { }
```

<!-- `inc_a` only works within `mylib`, while `inc_b` only works outside the -->
<!-- library. Furthermore, `inc_b` will break if the user imports `mylib` under -->
<!-- another name. -->
`inc_a` は `mylib` の中でだけ動作します、かたや `inc_b` は `mylib` の外部でだけ動作します。
さらにいえば、 `inc_b` はユーザーが `mylib` を異なる名前でインポートした際には動作しません。

<!-- Rust does not (yet) have a hygiene system for crate references, but it does -->
<!-- provide a simple workaround for this problem. Within a macro imported from a -->
<!-- crate named `foo`, the special macro variable `$crate` will expand to `::foo`. -->
<!-- By contrast, when a macro is defined and then used in the same crate, `$crate` -->
<!-- will expand to nothing. This means we can write -->
Rustは(まだ)健全なクレートの参照の仕組みを持っていません、
しかし、この問題に対する簡単な対処方法を提供しています。
`foo`というクレートからインポートされたマクロ中において、
特別なマクロ変数 `$create` は `::foo` に展開されます。
対照的に、マクロが同じクレートの中で定義され利用された場合、
`$create` は何にも展開されません。これはつまり以下のように書けることを意味しています:

```rust
#[macro_export]
macro_rules! inc {
    ($x:expr) => ( $crate::increment($x) )
}
# fn main() { }
```

<!-- to define a single macro that works both inside and outside our library. The -->
<!-- function name will expand to either `::increment` or `::mylib::increment`. -->
これは、ライブラリの中でも外でも動作するマクロを定義しています。
関数の名前は `::increment` または `::mylib::increment` に展開されます。


<!-- To keep this system simple and correct, `#[macro_use] extern crate ...` may -->
<!-- only appear at the root of your crate, not inside `mod`. This ensures that -->
<!-- `$crate` is a single identifier. -->
このシステムを簡潔で正しく保つために、 `#[macro_use] extern crate ...` はクレートのルートにしか登場せず、
`mod` の中には現れません。これは `$crate` が単一の識別子を持つことを確実にします。


<!-- # The deep end -->
# 最難関部

<!-- The introductory chapter mentioned recursive macros, but it did not give the -->
<!-- full story. Recursive macros are useful for another reason: Each recursive -->
<!-- invocation gives you another opportunity to pattern-match the macro’s -->
<!-- arguments. -->
入門のチャプターで再帰的なマクロについて言及しました、しかしそのチャプターでは詳細について話していませんでした。
再帰的なマクロが便利な他の理由は、それぞれの再帰的な呼出はマクロに与えられた引数にたいしてパターンマッチを行える可能性を与えてくれることです。

<!-- As an extreme example, it is possible, though hardly advisable, to implement -->
<!-- the [Bitwise Cyclic Tag](https://esolangs.org/wiki/Bitwise_Cyclic_Tag) automaton -->
<!-- within Rust’s macro system. -->
極端な例としては、 望ましくはありませんが、 [Bitwise Cyclic Tag](https://esolangs.org/wiki/Bitwise_Cyclic_Tag) のオートマトンをRustのマクロで実装する事が可能です。

```rust
macro_rules! bct {
    // cmd 0:  d ... => ...
    (0, $($ps:tt),* ; $_d:tt)
        => (bct!($($ps),*, 0 ; ));
    (0, $($ps:tt),* ; $_d:tt, $($ds:tt),*)
        => (bct!($($ps),*, 0 ; $($ds),*));

    // cmd 1p:  1 ... => 1 ... p
    (1, $p:tt, $($ps:tt),* ; 1)
        => (bct!($($ps),*, 1, $p ; 1, $p));
    (1, $p:tt, $($ps:tt),* ; 1, $($ds:tt),*)
        => (bct!($($ps),*, 1, $p ; 1, $($ds),*, $p));

    // cmd 1p:  0 ... => 0 ...
    (1, $p:tt, $($ps:tt),* ; $($ds:tt),*)
        => (bct!($($ps),*, 1, $p ; $($ds),*));

# //    // halt on empty data string
    // 空のデータ文字列で停止します
    ( $($ps:tt),* ; )
        => (());
}
```

<!-- Exercise: use macros to reduce duplication in the above definition of the -->
<!-- `bct!` macro. -->
演習: マクロを使って上の `bct!` マクロの定義の重複している部分を減らしてみましょう。

<!-- # Common macros -->
# よく見られるマクロ

<!-- Here are some common macros you’ll see in Rust code. -->
以下は、Rustコード中でよく見られるマクロたちです。

## panic!

<!-- This macro causes the current thread to panic. You can give it a message -->
<!-- to panic with: -->
このマクロは現在のスレッドをパニック状態にします。
パニック時のメッセージを指定することができます。

```rust,no_run
panic!("oh no!");
```

## vec!

<!-- The `vec!` macro is used throughout the book, so you’ve probably seen it -->
<!-- already. It creates `Vec<T>`s with ease: -->
`vec!` マクロはこの本のなかで使われてきましたので、 すでに見たことがあるでしょう。
`vec!` マクロは `Vec<T>` を簡単に作成できます:

```rust
let v = vec![1, 2, 3, 4, 5];
```

<!-- It also lets you make vectors with repeating values. For example, a hundred -->
<!-- zeroes: -->
また、値の繰り返しのベクタを作成することも可能です。
たとえば、以下は100個の0を含むベクタの例です:

```rust
let v = vec![0; 100];
```

<!-- ## assert! and assert_eq! -->
## assert! と assert_eq!

<!-- These two macros are used in tests. `assert!` takes a boolean. `assert_eq!` -->
<!-- takes two values and checks them for equality. `true` passes, `false` `panic!`s. -->
<!-- Like this: -->
この２つのマクロはテスト時に利用されています。
`assert!` は真偽値を引数に取ります。
`assert_eq!` は２つの等価性をチェックする値を引数に取ります。
`true` ならばパスし、 `false` だった場合 `panic!` を起こします:

```rust,no_run
# // // A-ok!
// Okです！

assert!(true);
assert_eq!(5, 3 + 2);

# // // nope :(
// 駄目だぁ :(

assert!(5 < 3);
assert_eq!(5, 3);
```

## try!

<!-- `try!` is used for error handling. It takes something that can return a -->
<!-- `Result<T, E>`, and gives `T` if it’s a `Ok<T>`, and `return`s with the -->
<!-- `Err(E)` if it’s that. Like this: -->
`try!` はエラーハンドリングのために利用されています。
`try!` は `Result<T, E>` を返す何らかの物を引数に取り、もし `Result<T, E>` が `Ok<T>` だった場合 `T` を返し、
そうでなく `Err(E)` だった場合はそれを `return` します。
例えば以下のように利用します:

```rust,no_run
use std::fs::File;

fn foo() -> std::io::Result<()> {
    let f = try!(File::create("foo.txt"));

    Ok(())
}
```

<!-- This is cleaner than doing this: -->
このコードは以下のコードよりも綺麗です:

```rust,no_run
use std::fs::File;

fn foo() -> std::io::Result<()> {
    let f = File::create("foo.txt");

    let f = match f {
        Ok(t) => t,
        Err(e) => return Err(e),
    };

    Ok(())
}
```

## unreachable!

<!-- This macro is used when you think some code should never execute: -->
このマクロはあるコードが絶対に実行されるべきでないと考えている時に利用します。

```rust
if false {
    unreachable!();
}
```

<!-- Sometimes, the compiler may make you have a different branch that you know -->
<!-- will never, ever run. In these cases, use this macro, so that if you end -->
<!-- up wrong, you’ll get a `panic!` about it. -->
時々、コンパイラーによって絶対に呼び出されるはずがないと考えているブランチを作成することになる時があります。
そういった時には、このマクロを利用しましょう、そうすることでもし何か誤ってしまった時に、 `panic!` で知ることができます。

```rust
let x: Option<i32> = None;

match x {
    Some(_) => unreachable!(),
    None => println!("I know x is None!"),
}
```

## unimplemented!

<!-- The `unimplemented!` macro can be used when you’re trying to get your functions -->
<!-- to typecheck, and don’t want to worry about writing out the body of the -->
<!-- function. One example of this situation is implementing a trait with multiple -->
<!-- required methods, where you want to tackle one at a time. Define the others -->
<!-- as `unimplemented!` until you’re ready to write them. -->
`unimplemented!` マクロはもし関数の本体の実装はしていないが、型チェックだけは行いたいという時に利用します。
このような状況の一つの例としては複数のメソッドを必要としているトレイトのメソッドの一つを実装しようと試みている時などです。
残りのメソッドたちの実装に取り掛かれるようになるまで `unimplemented!` として定義しましょう。

<!-- # Procedural macros -->
# 手続きマクロ

<!-- If Rust’s macro system can’t do what you need, you may want to write a -->
<!-- [compiler plugin](compiler-plugins.html) instead. Compared to `macro_rules!` -->
<!-- macros, this is significantly more work, the interfaces are much less stable, -->
<!-- and bugs can be much harder to track down. In exchange you get the -->
<!-- flexibility of running arbitrary Rust code within the compiler. Syntax -->
<!-- extension plugins are sometimes called ‘procedural macros’ for this reason. -->
もしRustのマクロシステムでは必要としていることができない場合、
[コンパイラプラグイン](compiler-plugins.html) を代わりに書きたくなるでしょう。
コンパイラプラグインは `macro_rules!` マクロとくらべて、更に多くの作業が必要になり、
インタフェースはかなり不安定であり、バグはさらに追跡が困難になります。
引き換えに、任意のコードをコンパイラ中で実行できるという自由度を得ることができます。
構文拡張プラグインがしばしば「手続きマクロ」と呼ばれるのはこのためです。
