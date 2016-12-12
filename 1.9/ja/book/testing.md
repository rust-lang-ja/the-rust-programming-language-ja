% テスト
<!-- % Testing -->

<!-- &gt; Program testing can be a very effective way to show the presence of bugs, but -->
<!-- &gt; it is hopelessly inadequate for showing their absence. -->
<!-- &gt; -->
<!-- &gt; Edsger W. Dijkstra, "The Humble Programmer" (1972) -->
> プログラムのテストはバグの存在を示すためには非常に効率的な方法ですが、バグの不存在を示すためには絶望的に不十分です。
> エドガー・W・ダイクストラ、『謙虚なプログラマ』（1972）

<!--Let's talk about how to test Rust code. What we will not be talking about is-->
<!--the right way to test Rust code. There are many schools of thought regarding-->
<!--the right and wrong way to write tests. All of these approaches use the same-->
<!--basic tools, and so we'll show you the syntax for using them.-->
Rustのコードをテストする方法について話しましょう。
ここではRustのコードをテストする正しい方法について議論するつもりはありません。
テストを書くための正しい方法、誤った方法に関する流派はたくさんあります。
それらの方法は全て、同じ基本的なツールを使うので、それらのツールを使うための文法をお見せしましょう。

<!--# The `test` attribute-->
# `test` アトリビュート

<!--At its simplest, a test in Rust is a function that's annotated with the `test`-->
<!--attribute. Let's make a new project with Cargo called `adder`:-->
Rustでの一番簡単なテストは、 `test` アトリビュートの付いた関数です。
`adder` という名前の新しいプロジェクトをCargoで作りましょう。

```bash
$ cargo new adder
$ cd adder
```

<!--Cargo will automatically generate a simple test when you make a new project.-->
<!--Here's the contents of `src/lib.rs`:-->
新しいプロジェクトを作ると、Cargoは自動的に簡単なテストを生成します。
これが `src/lib.rs` の内容です。

```rust
# fn main() {}
#[test]
fn it_works() {
}
```

<!--Note the `#[test]`. This attribute indicates that this is a test function. It-->
<!--currently has no body. That's good enough to pass! We can run the tests with-->
<!--`cargo test`:-->
`#[test]` に注意しましょう。
このアトリビュートは、この関数がテスト関数であるということを示します。
今のところ、その関数には本文がありません。
成功させるためにはそれで十分なのです!
テストは `cargo test` で実行することができます。

```bash
$ cargo test
   Compiling adder v0.0.1 (file:///home/you/projects/adder)
     Running target/adder-91b3e234d4ed382a

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

<!--Cargo compiled and ran our tests. There are two sets of output here: one-->
<!--for the test we wrote, and another for documentation tests. We'll talk about-->
<!--those later. For now, see this line:-->
Cargoはテストをコンパイルし、実行しました。
ここでは2種類の結果が出力されています。1つは書かれたテストについてのもの、もう1つはドキュメンテーションテストについてのものです。
それらについては後で話しましょう。
とりあえず、この行を見ましょう。

```text
test it_works ... ok
```

<!--Note the `it_works`. This comes from the name of our function:-->
`it_works` に注意しましょう。
これは関数の名前に由来しています。

```rust
fn it_works() {
# }
```

<!--We also get a summary line:-->
次のようなサマリも出力されています。

```text
test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured
```

<!--So why does our do-nothing test pass? Any test which doesn't `panic!` passes,-->
<!--and any test that does `panic!` fails. Let's make our test fail:-->
なぜ何も書いていないテストがこのように成功するのでしょうか。
`panic!` しないテストは全て成功で、 `panic!` するテストは全て失敗なのです。
テストを失敗させましょう。

```rust
# fn main() {}
#[test]
fn it_works() {
    assert!(false);
}
```

<!--`assert!` is a macro provided by Rust which takes one argument: if the argument-->
<!--is `true`, nothing happens. If the argument is `false`, it `panic!`s. Let's run-->
<!--our tests again:-->
`assert!` はRustが提供するマクロで、1つの引数を取ります。引数が `true` であれば何も起きません。
引数が `false` であれば `panic!` します。
テストをもう一度実行しましょう。

```bash
$ cargo test
   Compiling adder v0.0.1 (file:///home/you/projects/adder)
     Running target/adder-91b3e234d4ed382a

running 1 test
test it_works ... FAILED

failures:

---- it_works stdout ----
        thread 'it_works' panicked at 'assertion failed: false', /home/steve/tmp/adder/src/lib.rs:3



failures:
    it_works

test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured

thread '<main>' panicked at 'Some tests failed', /home/steve/src/rust/src/libtest/lib.rs:247
```

<!--Rust indicates that our test failed:-->
Rustは次のとおりテストが失敗したことを示しています。

```text
test it_works ... FAILED
```

<!--And that's reflected in the summary line:-->
そして、それはサマリにも反映されます。

```text
test result: FAILED. 0 passed; 1 failed; 0 ignored; 0 measured
```

<!--We also get a non-zero status code. We can use `$?` on OS X and Linux:-->
ステータスコードも非0になっています。
OS XやLinuxでは `$?` を使うことができます。

```bash
$ echo $?
101
```

<!--On Windows, if you’re using `cmd`:-->
Windowsでは、 `cmd` を使っていればこうです。

```bash
> echo %ERRORLEVEL%
```

<!--And if you’re using PowerShell:-->
そして、PowerShellを使っていればこうです。

```bash
> echo $LASTEXITCODE # the code itself
> echo $? # a boolean, fail or succeed
```

<!--This is useful if you want to integrate `cargo test` into other tooling.-->
これは `cargo test` を他のツールと統合したいときに便利です。

<!--We can invert our test's failure with another attribute: `should_panic`:-->
もう1つのアトリビュート、 `should_panic` を使ってテストの失敗を反転させることができます。

```rust
# fn main() {}
#[test]
#[should_panic]
fn it_works() {
    assert!(false);
}
```

<!--This test will now succeed if we `panic!` and fail if we complete. Let's try it:-->
今度は、このテストが `panic!` すれば成功で、完走すれば失敗です。
試しましょう。

```bash
$ cargo test
   Compiling adder v0.0.1 (file:///home/you/projects/adder)
     Running target/adder-91b3e234d4ed382a

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

<!--Rust provides another macro, `assert_eq!`, that compares two arguments for-->
<!--equality:-->
Rustはもう1つのマクロ、 `assert_eq!` を提供しています。これは2つの引数の等価性を調べます。

```rust
# fn main() {}
#[test]
#[should_panic]
fn it_works() {
    assert_eq!("Hello", "world");
}
```

<!--Does this test pass or fail? Because of the `should_panic` attribute, it-->
<!--passes:-->
このテストは成功でしょうか、失敗でしょうか。
`should_panic` アトリビュートがあるので、これは成功です。

```bash
$ cargo test
   Compiling adder v0.0.1 (file:///home/you/projects/adder)
     Running target/adder-91b3e234d4ed382a

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

<!--`should_panic` tests can be fragile, as it's hard to guarantee that the test-->
<!--didn't fail for an unexpected reason. To help with this, an optional `expected`-->
<!--parameter can be added to the `should_panic` attribute. The test harness will-->
<!--make sure that the failure message contains the provided text. A safer version-->
<!--of the example above would be:-->
`should_panic` を使ったテストは脆いテストです。なぜなら、テストが予想外の理由で失敗したのではないということを保証することが難しいからです。
これを何とかするために、 `should_panic` アトリビュートにはオプションで `expected` パラメータを付けることができます。
テストハーネスが、失敗したときのメッセージに与えられたテキストが含まれていることを確かめてくれます。
前述の例のもっと安全なバージョンはこうなります。

```rust
# fn main() {}
#[test]
#[should_panic(expected = "assertion failed")]
fn it_works() {
    assert_eq!("Hello", "world");
}
```

<!--That's all there is to the basics! Let's write one 'real' test:-->
基本はそれだけです!
「リアルな」テストを書いてみましょう。

```rust,ignore
# fn main() {}
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[test]
fn it_works() {
    assert_eq!(4, add_two(2));
}
```

<!--This is a very common use of `assert_eq!`: call some function with-->
<!--some known arguments and compare it to the expected output.-->
これは非常に一般的な `assert_eq!` の使い方です。いくつかの関数に結果の分かっている引数を渡して呼び出し、期待した結果と比較します。

<!--# The `ignore` attribute-->
# `ignore` アトリビュート

<!--Sometimes a few specific tests can be very time-consuming to execute. These-->
<!--can be disabled by default by using the `ignore` attribute:-->
ときどき、特定のテストの実行に非常に時間が掛かることがあります。
そのようなテストは、 `ignore` アトリビュートを使ってデフォルトでは無効にすることができます。

```rust
# fn main() {}
#[test]
fn it_works() {
    assert_eq!(4, add_two(2));
}

#[test]
#[ignore]
fn expensive_test() {
#   // code that takes an hour to run
    // 実行に1時間掛かるコード
}
```

<!--Now we run our tests and see that `it_works` is run, but `expensive_test` is-->
<!--not:-->
テストを実行すると、 `it_works` が実行されることを確認できますが、今度は `expensive_test` は実行されません。

```bash
$ cargo test
   Compiling adder v0.0.1 (file:///home/you/projects/adder)
     Running target/adder-91b3e234d4ed382a

running 2 tests
test expensive_test ... ignored
test it_works ... ok

test result: ok. 1 passed; 0 failed; 1 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

<!--The expensive tests can be run explicitly using `cargo test -- --ignored`:-->
無効にされた高コストなテストは `cargo test -- --ignored` を使って明示的に実行することができます。

```bash
$ cargo test -- --ignored
     Running target/adder-91b3e234d4ed382a

running 1 test
test expensive_test ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

<!--The `--ignored` argument is an argument to the test binary, and not to Cargo,-->
<!--which is why the command is `cargo test -- --ignored`.-->
`--ignored` アトリビュートはテストバイナリの引数であって、Cargoのものではありません。
コマンドが `cargo test -- --ignored` となっているのはそういうことです。

<!--# The `tests` module-->
# `tests` モジュール

<!--There is one way in which our existing example is not idiomatic: it's-->
<!--missing the `tests` module. The idiomatic way of writing our example-->
<!--looks like this:-->
今までの例における手法は、慣用的ではありません。 `tests` モジュールがないからです。
今までの例の慣用的な書き方はこのようになります。

```rust,ignore
# fn main() {}
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::add_two;

    #[test]
    fn it_works() {
        assert_eq!(4, add_two(2));
    }
}
```

<!--There's a few changes here. The first is the introduction of a `mod tests` with-->
<!--a `cfg` attribute. The module allows us to group all of our tests together, and-->
<!--to also define helper functions if needed, that don't become a part of the rest-->
<!--of our crate. The `cfg` attribute only compiles our test code if we're-->
<!--currently trying to run the tests. This can save compile time, and also ensures-->
<!--that our tests are entirely left out of a normal build.-->
ここでは、いくつかの変更点があります。
まず、 `cfg` アトリビュートの付いた `mod tests` を導入しました。
このモジュールを使うと、全てのテストをグループ化することができます。また、必要であれば、ヘルパ関数を定義し、それをクレートの一部に含まれないようにすることもできます。
 `cfg` アトリビュートによって、テストを実行しようとしているときにだけテストコードがコンパイルされるようになります。
これは、コンパイル時間を節約し、テストが通常のビルドに全く影響しないことを保証してくれます。

<!--The second change is the `use` declaration. Because we're in an inner module,-->
<!--we need to bring our test function into scope. This can be annoying if you have-->
<!--a large module, and so this is a common use of globs. Let's change our-->
<!--`src/lib.rs` to make use of it:-->
2つ目の変更点は、 `use` 宣言です。
ここは内部モジュールの中なので、テスト関数をスコープの中に持ち込む必要があります。
モジュールが大きい場合、これは面倒かもしれないので、ここがグロブの一般的な使い所です。
`src/lib.rs` をグロブを使うように変更しましょう。

```rust,ignore
# fn main() {}
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(4, add_two(2));
    }
}
```

<!--Note the different `use` line. Now we run our tests:-->
`use` 行が変わったことに注意しましょう。
さて、テストを実行します。

```bash
$ cargo test
    Updating registry `https://github.com/rust-lang/crates.io-index`
   Compiling adder v0.0.1 (file:///home/you/projects/adder)
     Running target/adder-91b3e234d4ed382a

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

<!--It works!-->
動きます!

<!--The current convention is to use the `tests` module to hold your "unit-style"-->
<!--tests. Anything that tests one small bit of functionality makes sense to-->
<!--go here. But what about "integration-style" tests instead? For that, we have-->
<!--the `tests` directory.-->
現在の慣習では、 `tests` モジュールは「ユニット」テストを入れるために使うことになっています。
単一の小さな機能の単位をテストするものは全て、ここに入れる意味があります。
しかし、「結合」テストはどうでしょうか。
結合テストのためには、 `tests` ディレクトリがあります。

<!--# The `tests` directory-->
# `tests` ディレクトリ

<!--To write an integration test, let's make a `tests` directory, and-->
<!--put a `tests/lib.rs` file inside, with this as its contents:-->
結合テストを書くために、 `tests` ディレクトリを作りましょう。そして、その中に次の内容の `tests/lib.rs` ファイルを置きます。

```rust,ignore
extern crate adder;

# fn main() {}
#[test]
fn it_works() {
    assert_eq!(4, adder::add_two(2));
}
```

<!--This looks similar to our previous tests, but slightly different. We now have-->
<!--an `extern crate adder` at the top. This is because the tests in the `tests`-->
<!--directory are an entirely separate crate, and so we need to import our library.-->
<!--This is also why `tests` is a suitable place to write integration-style tests:-->
<!--they use the library like any other consumer of it would.-->
これは前のテストと似ていますが、少し違います。
今回は、 `extern crate adder` を先頭に書いています。
これは、 `tests` ディレクトリの中のテストが全く別のクレートであるため、ライブラリをインポートしなければならないからです。
これは、なぜ `tests` が結合テストを書くのに適切な場所なのかという理由でもあります。そこにあるテストは、そのライブラリを他のプログラムと同じようなやり方で使うからです。

<!--Let's run them:-->
テストを実行しましょう。

```bash
$ cargo test
   Compiling adder v0.0.1 (file:///home/you/projects/adder)
     Running target/adder-91b3e234d4ed382a

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

     Running target/lib-c18e7d3494509e74

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured
```

<!--Now we have three sections: our previous test is also run, as well as our new-->
<!--one.-->
今度は3つのセクションが出力されました。新しいテストが実行され、前に書いたテストも同様に実行されます。

<!--That's all there is to the `tests` directory. The `tests` module isn't needed-->
<!--here, since the whole thing is focused on tests.-->
`tests` ディレクトリについてはそれだけです。
`tests` モジュールはここでは必要ありません。全てのものがテストのためのものだからです。

<!--Let's finally check out that third section: documentation tests.-->
最後に、3つ目のセクションを確認しましょう。ドキュメンテーションテストです。

<!--# Documentation tests-->
# ドキュメンテーションテスト

<!--Nothing is better than documentation with examples. Nothing is worse than-->
<!--examples that don't actually work, because the code has changed since the-->
<!--documentation has been written. To this end, Rust supports automatically-->
<!--running examples in your documentation (**note:** this only works in library-->
<!--crates, not binary crates). Here's a fleshed-out `src/lib.rs` with examples:-->
例の付いたドキュメントほどよいものはありません。
ドキュメントを書いた後にコードが変更された結果、実際に動かなくなった例ほど悪いものはありません。
この状況を終わらせるために、Rustはあなたのドキュメント内の例の自動実行をサポートします（ **注意：** これはライブラリクレートの中でのみ動作し、バイナリクレートの中では動作しません）。
これが例を付けた具体的な `src/lib.rs` です。

```rust,ignore
# fn main() {}
# //! The `adder` crate provides functions that add numbers to other numbers.
//! `adder`クレートはある数値を数値に加える関数を提供する
//!
//! # Examples
//!
//! ```
//! assert_eq!(4, adder::add_two(2));
//! ```

# /// This function adds two to its argument.
/// この関数は引数に2を加える
///
/// # Examples
///
/// ```
/// use adder::add_two;
///
/// assert_eq!(4, add_two(2));
/// ```
pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        assert_eq!(4, add_two(2));
    }
}
```

<!--Note the module-level documentation with `//!` and the function-level-->
<!--documentation with `///`. Rust's documentation supports Markdown in comments,-->
<!--and so triple graves mark code blocks. It is conventional to include the-->
<!--`# Examples` section, exactly like that, with examples following.-->
モジュールレベルのドキュメントには `//!` を付け、関数レベルのドキュメントには `///` を付けていることに注意しましょう。
RustのドキュメントはMarkdown形式のコメントをサポートしていて、3連バッククオートはコードブロックを表します。
`# Examples` セクションを含めるのが慣習で、そのとおり、例が後に続きます。

<!--Let's run the tests again:-->
テストをもう一度実行しましょう。

```bash
$ cargo test
   Compiling adder v0.0.1 (file:///home/steve/tmp/adder)
     Running target/adder-91b3e234d4ed382a

running 1 test
test tests::it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

     Running target/lib-c18e7d3494509e74

running 1 test
test it_works ... ok

test result: ok. 1 passed; 0 failed; 0 ignored; 0 measured

   Doc-tests adder

running 2 tests
test add_two_0 ... ok
test _0 ... ok

test result: ok. 2 passed; 0 failed; 0 ignored; 0 measured
```

<!--Now we have all three kinds of tests running! Note the names of the-->
<!--documentation tests: the `_0` is generated for the module test, and `add_two_0`-->
<!--for the function test. These will auto increment with names like `add_two_1` as-->
<!--you add more examples.-->
今回は全ての種類のテストを実行しています!
ドキュメンテーションテストの名前に注意しましょう。 `_0` はモジュールテストのために生成された名前で、 `add_two_0` は関数テストのために生成された名前です。
例を追加するにつれて、それらの名前は `add_two_1` というような形で数値が増えていきます。

<!--We haven’t covered all of the details with writing documentation tests. For more,-->
<!-- please see the [Documentation chapter](documentation.html). -->
まだドキュメンテーションテストの書き方の詳細について、全てをカバーしてはいません。
詳しくは [ドキュメントの章](documentation.html) を見てください。

