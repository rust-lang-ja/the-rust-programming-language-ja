% コンパイラプラグイン
<!-- % Compiler Plugins -->

<!-- # Introduction -->
# イントロダクション

<!-- `rustc` can load compiler plugins, which are user-provided libraries that -->
<!-- extend the compiler's behavior with new syntax extensions, lint checks, etc. -->
`rustc` はコンパイラプラグイン、ユーザの提供する構文拡張や構文チェックなどのコンパイラの振舞を拡張するライブラリをロード出来ます。

<!-- A plugin is a dynamic library crate with a designated *registrar* function that -->
<!-- registers extensions with `rustc`. Other crates can load these extensions using -->
<!-- the crate attribute `#![plugin(...)]`.  See the -->
<!-- `rustc_plugin` documentation for more about the -->
<!-- mechanics of defining and loading a plugin. -->
プラグインとは `rustc` に拡張を登録するための、指定された *登録用* 関数を持った動的ライブラリのクレートです。
他のクレートはこれらのプラグインを `#![plugin(...)]` クレートアトリビュートでロード出来ます。
プラグインの定義、ロードの仕組みについて詳しくは `rustc_plugin` を参照して下さい。

<!-- If present, arguments passed as `#![plugin(foo(... args ...))]` are not -->
<!-- interpreted by rustc itself.  They are provided to the plugin through the -->
<!-- `Registry`'s `args` method. -->
`#![plugin(foo(... args ...))]` のように渡された引数があるなら、それらはrustc自身によっては解釈されません。
`Registry` の`args` メソッドを通じてプラグインに渡されます。

<!-- In the vast majority of cases, a plugin should *only* be used through -->
<!-- `#![plugin]` and not through an `extern crate` item.  Linking a plugin would -->
<!-- pull in all of libsyntax and librustc as dependencies of your crate.  This is -->
<!-- generally unwanted unless you are building another plugin.  The -->
<!-- `plugin_as_library` lint checks these guidelines. -->
ほとんどの場合で、プラグインは `#![plugin]` を通じて *のみ* 使われるべきで、 `extern crate` を通じて使われるべきではありません。
プラグインをリンクするとlibsyntaxとlibrustcの全てをクレートの依存に引き込んでしまいます。
これは別のプラグインを作っているのでもない限り一般的には望まぬ挙動です。
`plugin_as_library` チェッカによってこのガイドラインは検査されます。

<!-- The usual practice is to put compiler plugins in their own crate, separate from -->
<!-- any `macro_rules!` macros or ordinary Rust code meant to be used by consumers -->
<!-- of a library. -->
普通の慣行ではコンパイラプラグインはそれ専用のクレートに置かれて、 `macro_rules!` マクロやコンシューマが使うライブラリのコードとは分けられます。

<!-- # Syntax extensions -->
# 構文拡張

<!-- Plugins can extend Rust's syntax in various ways. One kind of syntax extension -->
<!-- is the procedural macro. These are invoked the same way as [ordinary -->
<!-- macros](macros.html), but the expansion is performed by arbitrary Rust -->
<!-- code that manipulates syntax trees at -->
<!-- compile time. -->
プラグインはRustの構文を様々な方法で拡張出来ます。構文拡張の1つに手続的マクロがあります。
これらは[普通のマクロ](macros.html)と同じように実行されますが展開は任意の構文木をコンパイル時に操作するRustのコードが行います。

<!-- Let's write a plugin -->
<!-- [`roman_numerals.rs`](https://github.com/rust-lang/rust/tree/master/src/test/auxiliary/roman_numerals.rs) -->
<!-- that implements Roman numeral integer literals. -->
ローマ数字リテラルを実装する[`roman_numerals.rs`](https://github.com/rust-lang/rust/tree/master/src/test/auxiliary/roman_numerals.rs)を書いてみましょう。


```ignore
#![crate_type="dylib"]
#![feature(plugin_registrar, rustc_private)]

extern crate syntax;
extern crate rustc;
extern crate rustc_plugin;

use syntax::codemap::Span;
use syntax::parse::token;
use syntax::ast::TokenTree;
use syntax::ext::base::{ExtCtxt, MacResult, DummyResult, MacEager};
# // use syntax::ext::build::AstBuilder;  // trait for expr_usize
use syntax::ext::build::AstBuilder;  // expr_usizeのトレイト
use rustc_plugin::Registry;

fn expand_rn(cx: &mut ExtCtxt, sp: Span, args: &[TokenTree])
        -> Box<MacResult + 'static> {

    static NUMERALS: &'static [(&'static str, usize)] = &[
        ("M", 1000), ("CM", 900), ("D", 500), ("CD", 400),
        ("C",  100), ("XC",  90), ("L",  50), ("XL",  40),
        ("X",   10), ("IX",   9), ("V",   5), ("IV",   4),
        ("I",    1)];

    if args.len() != 1 {
        cx.span_err(
            sp,
            &format!("argument should be a single identifier, but got {} arguments", args.len()));
        return DummyResult::any(sp);
    }

    let text = match args[0] {
        TokenTree::Token(_, token::Ident(s, _)) => s.to_string(),
        _ => {
            cx.span_err(sp, "argument should be a single identifier");
            return DummyResult::any(sp);
        }
    };

    let mut text = &*text;
    let mut total = 0;
    while !text.is_empty() {
        match NUMERALS.iter().find(|&&(rn, _)| text.starts_with(rn)) {
            Some(&(rn, val)) => {
                total += val;
                text = &text[rn.len()..];
            }
            None => {
                cx.span_err(sp, "invalid Roman numeral");
                return DummyResult::any(sp);
            }
        }
    }

    MacEager::expr(cx.expr_usize(sp, total))
}

#[plugin_registrar]
pub fn plugin_registrar(reg: &mut Registry) {
    reg.register_macro("rn", expand_rn);
}
```

<!-- Then we can use `rn!()` like any other macro: -->
`rn!()` マクロを他の任意のマクロと同じように使えます。

```ignore
#![feature(plugin)]
#![plugin(roman_numerals)]

fn main() {
    assert_eq!(rn!(MMXV), 2015);
}
```

<!-- The advantages over a simple `fn(&str) -> u32` are: -->
単純な `fn(&str) -> u32` に対する利点は

<!-- * The (arbitrarily complex) conversion is done at compile time. -->
<!-- * Input validation is also performed at compile time. -->
<!-- * It can be extended to allow use in patterns, which effectively gives -->
<!--   a way to define new literal syntax for any data type. -->
* （任意に複雑な）変換がコンパイル時に行なわれる
* 入力バリデーションもコンパイル時に行なわれる
* パターンで使えるように拡張出来るので、実質的に任意のデータ型に対して新たなリテラル構文を与えられる

<!-- In addition to procedural macros, you can define new -->
<!-- [`derive`](../reference.html#derive)-like attributes and other kinds of -->
<!-- extensions.  See `Registry::register_syntax_extension` and the `SyntaxExtension` -->
<!-- enum.  For a more involved macro example, see -->
<!-- [`regex_macros`](https://github.com/rust-lang/regex/blob/master/regex_macros/src/lib.rs). -->
手続き的マクロに加えて[`derive`](../reference.html#derive)ライクなアトリビュートや他の拡張を書けます。
`Registry::register_syntax_extension` や `SyntaxExtension` 列挙型を参照して下さい。
もっと複雑なマクロの例は[`regex_macros`](https://github.com/rust-lang/regex/blob/master/regex_macros/src/lib.rs)を参照して下さい。

<!-- ## Tips and tricks -->
## ヒントと小技

<!-- Some of the [macro debugging tips](macros.html#debugging-macro-code) are applicable. -->
[マクロデバッグのヒント](macros.html#debugging-macro-code)のいくつかが使えます。

<!-- You can use `syntax::parse` to turn token trees into -->
<!-- higher-level syntax elements like expressions: -->
`syntax::parse`を使うことでトークン木を式などの高レベルな構文要素に変換出来ます。

```ignore
fn expand_foo(cx: &mut ExtCtxt, sp: Span, args: &[TokenTree])
        -> Box<MacResult+'static> {

    let mut parser = cx.new_parser_from_tts(args);

    let expr: P<Expr> = parser.parse_expr();
```

<!-- Looking through [`libsyntax` parser -->
<!-- code](https://github.com/rust-lang/rust/blob/master/src/libsyntax/parse/parser.rs) -->
<!-- will give you a feel for how the parsing infrastructure works. -->
[`libsyntax` のパーサのコード](https://github.com/rust-lang/rust/blob/master/src/libsyntax/parse/parser.rs)を見るとパーサの基盤がどのように機能しているかを感られるでしょう。

<!-- Keep the `Span`s of everything you parse, for better error reporting. You can -->
<!-- wrap `Spanned` around your custom data structures. -->
パースしたものの `Span` は良いエラー報告のために保持しておきましょう。
自分で作ったデータ構造に対しても `Spanned` でラップ出来ます。

<!-- Calling `ExtCtxt::span_fatal` will immediately abort compilation. It's better to -->
<!-- instead call `ExtCtxt::span_err` and return `DummyResult` so that the compiler -->
<!-- can continue and find further errors. -->
`ExtCtxt::span_fatal` を呼ぶとコンパイルは即座に中断されます。
`ExtCtxt::span_err` を呼んで `DummyResult` を返せばコンパイラはさらなるエラーを発見できるのでその方が良いでしょう。

<!-- To print syntax fragments for debugging, you can use `span_note` together with -->
<!-- `syntax::print::pprust::*_to_string`. -->
構文の断片を表示するには `span_note` と `syntax::print::pprust::*_to_string` を使えば出来ます。

<!-- The example above produced an integer literal using `AstBuilder::expr_usize`. -->
<!-- As an alternative to the `AstBuilder` trait, `libsyntax` provides a set of -->
<!-- quasiquote macros. They are undocumented and very rough around the edges. -->
<!-- However, the implementation may be a good starting point for an improved -->
<!-- quasiquote as an ordinary plugin library. -->
上記の例では `AstBuilder::expr_usize` を使って整数リテラルを作りました。
`AstBuilder` トレイトの代替として `libsyntax` は準クォートマクロを提供しています。
ドキュメントがない上に荒削りです。しかしながらその実装は改良版の普通のプラグインライブラリのとっかかりにはほど良いでしょう。

<!-- # Lint plugins -->
# 構文チェックプラグイン

<!-- Plugins can extend [Rust's lint -->
<!-- infrastructure](../reference.html#lint-check-attributes) with additional checks for -->
<!-- code style, safety, etc. Now let's write a plugin [`lint_plugin_test.rs`](https://github.com/rust-lang/rust/blob/master/src/test/auxiliary/lint_plugin_test.rs) -->
<!-- that warns about any item named `lintme`. -->
プラグインによって[Rustの構文チェック基盤](../reference.html#lint-check-attributes)を拡張してコーディングスタイル、安全性などを検査するようにできます。では[`lint_plugin_test.rs`](https://github.com/rust-lang/rust/blob/master/src/test/auxiliary/lint_plugin_test.rs)プラグインを書いてみましょう。
`lintme` という名前のアイテムについて警告を出すものです。


```ignore
#![feature(plugin_registrar)]
#![feature(box_syntax, rustc_private)]

extern crate syntax;

# // Load rustc as a plugin to get macros
// macroを使うためにrustcをプラグインとして読み込む
#[macro_use]
extern crate rustc;
extern crate rustc_plugin;

use rustc::lint::{EarlyContext, LintContext, LintPass, EarlyLintPass,
                  EarlyLintPassObject, LintArray};
use rustc_plugin::Registry;
use syntax::ast;

declare_lint!(TEST_LINT, Warn, "Warn about items named 'lintme'");

struct Pass;

impl LintPass for Pass {
    fn get_lints(&self) -> LintArray {
        lint_array!(TEST_LINT)
    }
}

impl EarlyLintPass for Pass {
    fn check_item(&mut self, cx: &EarlyContext, it: &ast::Item) {
        if it.ident.name.as_str() == "lintme" {
            cx.span_lint(TEST_LINT, it.span, "item is named 'lintme'");
        }
    }
}

#[plugin_registrar]
pub fn plugin_registrar(reg: &mut Registry) {
    reg.register_early_lint_pass(box Pass as EarlyLintPassObject);
}
```

<!-- Then code like -->
そしたらこのようなコードは

```ignore
#![plugin(lint_plugin_test)]

fn lintme() { }
```

<!-- will produce a compiler warning: -->
コンパイラの警告を発生させます。

```txt
foo.rs:4:1: 4:16 warning: item is named 'lintme', #[warn(test_lint)] on by default
foo.rs:4 fn lintme() { }
         ^~~~~~~~~~~~~~~
```

<!-- The components of a lint plugin are: -->
構文チェックプラグインのコンポーネントは

<!-- * one or more `declare_lint!` invocations, which define static `Lint` structs; -->
* 1回以上の `declare_lint!` の実行。それによって `Lint` 構造体が定義されます。

<!-- * a struct holding any state needed by the lint pass (here, none); -->
* 構文チェックパスで必要となる状態を保持する構造体（ここでは何もない）

<!-- * a `LintPass` -->
<!--   implementation defining how to check each syntax element. A single -->
<!--   `LintPass` may call `span_lint` for several different `Lint`s, but should -->
<!--   register them all through the `get_lints` method. -->
* それぞれの構文要素をどうやってチェックするかを定めた `LintPass` の実装。
  単一の `LintPass` は複数回 `span_lint` をいくつかの異なる `Lint` に対して呼ぶかもしれませんが、全て `get_lints`を通じて登録すべきです。

<!-- Lint passes are syntax traversals, but they run at a late stage of compilation -->
<!-- where type information is available. `rustc`'s [built-in -->
<!-- lints](https://github.com/rust-lang/rust/blob/master/src/librustc/lint/builtin.rs) -->
<!-- mostly use the same infrastructure as lint plugins, and provide examples of how -->
<!-- to access type information. -->
構文チェックパスは構文巡回ですが、型情報が得られる、コンパイルの終盤で走ります。 `rustc` の[組み込み構文チェック](https://github.com/rust-lang/rust/blob/master/src/librustc/lint/builtin.rs)は殆どプラグインと同じ基盤を使っており、どうやって型情報にアクセスするかの例になっています。

<!-- Lints defined by plugins are controlled by the usual [attributes and compiler -->
<!-- flags](../reference.html#lint-check-attributes), e.g. `#[allow(test_lint)]` or -->
<!-- `-A test-lint`. These identifiers are derived from the first argument to -->
<!-- `declare_lint!`, with appropriate case and punctuation conversion. -->
プラグインによって定義されたLintは普通の[アトリビュートとコンパイラフラグ](../reference.html#lint-check-attributes)例えば `#[allow(test_lint)]` や `-A test-lint` によってコントロールされます。
これらの識別子は `declare_lint!` の第一引数に由来しており、適切な名前に変換されます。

<!-- You can run `rustc -W help foo.rs` to see a list of lints known to `rustc`, -->
<!-- including those provided by plugins loaded by `foo.rs`. -->
`rustc -W help foo.rs` を走らせることで `rustc` の知っている、及び `foo.rs` 内で定義されたコンパイラ構文チェックをロード出来ます。
