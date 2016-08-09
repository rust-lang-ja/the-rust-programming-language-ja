% クレートとモジュール
<!-- % Crates and Modules -->

<!-- When a project starts getting large, it’s considered good software
engineering practice to split it up into a bunch of smaller pieces, and then
fit them together. It is also important to have a well-defined interface, so
that some of your functionality is private, and some is public. To facilitate
these kinds of things, Rust has a module system. -->
プロジェクトが大きくなり始めた際に、コードを小さなまとまりに分割しそれらでプロジェクトを組み立てるのはソフトウェア工学における優れた慣例だと考えられています。幾つかの機能をプライベートとし、また幾つかをパブリックとできるように、はっきりと定義されたインターフェースも重要となります。こういった事柄を容易にするため、Rustはモジュールシステムを有しています。

<!-- # Basic terminology: Crates and Modules -->
# 基本的な用語: クレートとモジュール

<!-- Rust has two distinct terms that relate to the module system: ‘crate’ and
‘module’. A crate is synonymous with a ‘library’ or ‘package’ in other
languages. Hence “Cargo” as the name of Rust’s package management tool: you
ship your crates to others with Cargo. Crates can produce an executable or a
library, depending on the project. -->
Rustはモジュールシステムに関連する「クレート」(crate)と「モジュール」(module)という2つの用語を明確に区別しています。クレートは他の言語における「ライブラリ」や「パッケージ」と同じ意味です。このことからRustのパッケージマネジメントツールの名前を「Cargo」としています。（訳注: crateとは枠箱のことであり、cargoは船荷を指します）Cargoを使ってクレートを出荷し他のユーザに公開するわけです。クレートは実行形式かライブラリをプロジェクトに応じて作成できます。

<!-- Each crate has an implicit *root module* that contains the code for that crate.
You can then define a tree of sub-modules under that root module. Modules allow
you to partition your code within the crate itself. -->
各クレートは自身のコードが入っている *ルートモジュール* (root module)を暗黙的に持っています。そしてルートモジュール下にはサブモジュールの木が定義できます。モジュールによりクレート内でコードを分割できます。

<!-- As an example, let’s make a *phrases* crate, which will give us various phrases
in different languages. To keep things simple, we’ll stick to ‘greetings’ and
‘farewells’ as two kinds of phrases, and use English and Japanese (日本語) as
two languages for those phrases to be in. We’ll use this module layout: -->
例として、 *phrases* クレートを作ってみます。これに異なる言語で幾つかのフレーズを入れます。問題の単純さを保つために、2種類のフレーズ「greetings」と「farewells」のみとし、これらフレーズを表すための2つの言語として英語と日本語を使うことにします。モジュールのレイアウトは以下のようになります。

```text
                                    +-----------+
                                +---| greetings |
                                |   +-----------+
                  +---------+   |
              +---| english |---+
              |   +---------+   |   +-----------+
              |                 +---| farewells |
+---------+   |                     +-----------+
| phrases |---+
+---------+   |                     +-----------+
              |                 +---| greetings |
              |   +----------+  |   +-----------+
              +---| japanese |--+
                  +----------+  |
                                |   +-----------+
                                +---| farewells |
                                    +-----------+
```

<!-- In this example, `phrases` is the name of our crate. All of the rest are
modules.  You can see that they form a tree, branching out from the crate
*root*, which is the root of the tree: `phrases` itself. -->
この例において、 `phrases` がクレートの名前で、それ以外の全てはモジュールです。それらが木の形をしており、クレートの *ルート* から枝分かれしていることが分かります。そして木のルートは `phrases` それ自身です。

<!-- Now that we have a plan, let’s define these modules in code. To start,
generate a new crate with Cargo: -->
ここまでで計画は立ちましたから、これらモジュールをコードで定義しましょう。始めるために、Cargoで新しいクレートを生成します。

```bash
$ cargo new phrases
$ cd phrases
```

<!-- If you remember, this generates a simple project for us: -->
聡明な読者ならご記憶かと思いますがCargoが単純なプロジェクトを生成してくれます。

```bash
$ tree .
.
├── Cargo.toml
└── src
    └── lib.rs

1 directory, 2 files
```

<!-- `src/lib.rs` is our crate root, corresponding to the `phrases` in our diagram
above. -->
`src/lib.rs` はクレートのルートであり、先程の図における `phrases` に相当します。

<!-- # Defining Modules -->
# モジュールを定義する

<!-- To define each of our modules, we use the `mod` keyword. Let’s make our
`src/lib.rs` look like this: -->
それぞれのモジュールを定義するために、 `mod` キーワードを使います。 `src/lib.rs` を以下のようにしましょう。

```rust
mod english {
    mod greetings {
    }

    mod farewells {
    }
}

mod japanese {
    mod greetings {
    }

    mod farewells {
    }
}
```

<!-- After the `mod` keyword, you give the name of the module. Module names follow
the conventions for other Rust identifiers: `lower_snake_case`. The contents of
each module are within curly braces (`{}`). -->
`mod` キーワードの後、モジュールの名前を与えます。モジュール名はRustの他の識別子の慣例に従います。つまり `lower_snake_case` です。各モジュールの内容は波括弧( `{}` )の中に書きます。

<!-- Within a given `mod`, you can declare sub-`mod`s. We can refer to sub-modules
with double-colon (`::`) notation: our four nested modules are
`english::greetings`, `english::farewells`, `japanese::greetings`, and
`japanese::farewells`. Because these sub-modules are namespaced under their
parent module, the names don’t conflict: `english::greetings` and
`japanese::greetings` are distinct, even though their names are both
`greetings`. -->
与えられた `mod` 内で、サブ `mod` を定義することができます。サブモジュールは2重コロン( `::` )記法で参照できます。ネストされた4つのモジュールは `english::greetings` 、 `english::farewells` 、 `japanese::greetings` 、そして `japanese::farewells` です。これらサブモジュールは親モジュール配下の名前空間になるため、名前は競合しません。つまり `english::greetings` と `japanese::greetings` は例え両名が `greetings` であったとしても、明確に区別されます。

<!-- Because this crate does not have a `main()` function, and is called `lib.rs`,
Cargo will build this crate as a library: -->
このクレートは `main()` 関数を持たず、 `lib.rs` と名付けられているため、Cargoはこのクレートをライブラリとしてビルドします。

```bash
$ cargo build
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
$ ls target/debug
build  deps  examples  libphrases-a7448e02a0468eaa.rlib  native
```

<!-- `libphrases-hash.rlib` is the compiled crate. Before we see how to use this
crate from another crate, let’s break it up into multiple files. -->
`libphrases-hash.rlib` はコンパイルされたクレートです。このクレートを他のクレートから使う方法を見る前に、複数のファイルに分割してみましょう。

<!-- # Multiple File Crates -->
# 複数のファイルによるクレート

<!-- If each crate were just one file, these files would get very large. It’s often
easier to split up crates into multiple files, and Rust supports this in two
ways. -->
各クレートがただ1つのファイルからなるのであれば、これらファイルは非常に大きくなってしまうでしょう。クレートを複数のファイルに分けた方が楽になるため、Rustは2つの方法でこれをサポートしています。

<!-- Instead of declaring a module like this: -->
以下のようなモジュールを宣言する代わりに、

```rust,ignore
mod english {
# //    // contents of our module go here
    // モジュールの内容はここに
}
```

<!-- We can instead declare our module like this: -->
以下のようなモジュールが宣言できます。

```rust,ignore
mod english;
```

<!-- If we do that, Rust will expect to find either a `english.rs` file, or a
`english/mod.rs` file with the contents of our module. -->
こうすると、Rustは `english.rs` ファイルか、 `english/mod.rs` ファイルのどちらかにモジュールの内容があるだろうと予想します。

<!-- Note that in these files, you don’t need to re-declare the module: that’s
already been done with the initial `mod` declaration. -->
それらのファイルの中でモジュールの再宣言を行う必要がないことに気をつけて下さい。先の `mod` 宣言にてそれは済んでいます。

<!-- Using these two techniques, we can break up our crate into two directories and
seven files: -->
これら2つのテクニックを用いて、クレートを2つのディレクトリと7つのファイルに分解できます。

```bash
$ tree .
.
├── Cargo.lock
├── Cargo.toml
├── src
│   ├── english
│   │   ├── farewells.rs
│   │   ├── greetings.rs
│   │   └── mod.rs
│   ├── japanese
│   │   ├── farewells.rs
│   │   ├── greetings.rs
│   │   └── mod.rs
│   └── lib.rs
└── target
    └── debug
        ├── build
        ├── deps
        ├── examples
        ├── libphrases-a7448e02a0468eaa.rlib
        └── native
```

<!-- `src/lib.rs` is our crate root, and looks like this: -->
`src/lib.rs` はクレートのルートで、以下のようになっています。

```rust,ignore
mod english;
mod japanese;
```

<!-- These two declarations tell Rust to look for either `src/english.rs` and
`src/japanese.rs`, or `src/english/mod.rs` and `src/japanese/mod.rs`, depending
on our preference. In this case, because our modules have sub-modules, we’ve
chosen the second. Both `src/english/mod.rs` and `src/japanese/mod.rs` look
like this: -->
これら2つの宣言はRustへ書き手の好みに合わせて `src/english.rs` と `src/japanese.rs` 、または `src/english/mod.rs` と `src/japanese/mod.rs` のどちらかを見よと伝えています。今回の場合、サブモジュールがあるため私たちは後者を選択しました。 `src/english/mod.rs` と `src/japanese/mod.rs` は両方とも以下のようになっています。

```rust,ignore
mod greetings;
mod farewells;
```

<!-- Again, these declarations tell Rust to look for either
`src/english/greetings.rs`, `src/english/farewells.rs`,
`src/japanese/greetings.rs` and `src/japanese/farewells.rs` or
`src/english/greetings/mod.rs`, `src/english/farewells/mod.rs`,
`src/japanese/greetings/mod.rs` and
`src/japanese/farewells/mod.rs`. Because these sub-modules don’t have
their own sub-modules, we’ve chosen to make them
`src/english/greetings.rs`, `src/english/farewells.rs`,
`src/japanese/greetings.rs` and `src/japanese/farewells.rs`. Whew! -->
繰り返すと、これら宣言はRustへ `src/english/greetings.rs` 、 `src/english/farewells.rs` 、 `src/japanese/greetings.rs` 、 `src/japanese/farewells.rs` 、または `src/english/greetings/mod.rs` 、 `src/english/farewells/mod.rs` 、 `src/japanese/greetings/mod.rs` 、 `src/japanese/farewells/mod.rs` のどちらかを見よと伝えています。これらサブモジュールは自身配下のサブモジュールを持たないため、私たちは `src/english/greetings.rs` 、 `src/english/farewells.rs` 、 `src/japanese/greetings.rs` 、 `src/japanese/farewells.rs` を選びました。ヒュー！

<!-- The contents of `src/english/greetings.rs`,
`src/english/farewells.rs`, `src/japanese/greetings.rs` and
`src/japanese/farewells.rs` are all empty at the moment. Let’s add
some functions. -->
`src/english/greetings.rs` 、 `src/english/farewells.rs` 、 `src/japanese/greetings.rs` 、 `src/japanese/farewells.rs` の中身は現在全て空です。幾つか関数を追加しましょう。

<!-- Put this in `src/english/greetings.rs`: -->
`src/english/greetings.rs` に以下を入力します。

```rust
fn hello() -> String {
    "Hello!".to_string()
}
```

<!-- Put this in `src/english/farewells.rs`: -->
`src/english/farewells.rs` に以下を入力します。

```rust
fn goodbye() -> String {
    "Goodbye.".to_string()
}
```

<!-- Put this in `src/japanese/greetings.rs`: -->
`src/japanese/greetings.rs` に以下を入力します。

```rust
fn hello() -> String {
    "こんにちは".to_string()
}
```

<!-- Of course, you can copy and paste this from this web page, or type
something else. It’s not important that you actually put ‘konnichiwa’ to learn
about the module system. -->
勿論、このwebページからコピー&ペーストしたり、他の何かをタイプしても構いません。モジュールシステムを学ぶのに「konnichiwa」と入力するのは重要なことではありません。

<!-- Put this in `src/japanese/farewells.rs`: -->
`src/japanese/farewells.rs` に以下を入力します。

```rust
fn goodbye() -> String {
    "さようなら".to_string()
}
```

<!-- (This is ‘Sayōnara’, if you’re curious.) -->
（英語だと「Sayōnara」と表記するようです、御参考まで。）

<!-- Now that we have some functionality in our crate, let’s try to use it from
another crate. -->
ここまででクレートに幾つかの機能が実装されました、それでは他のクレートから使ってみましょう。

<!-- # Importing External Crates -->
# 外部クレートのインポート

<!-- We have a library crate. Let’s make an executable crate that imports and uses
our library. -->
前節でライブラリクレートができました。インポートしこのライブラリを用いた実行形式クレートを作成しましょう。

<!-- Make a `src/main.rs` and put this in it (it won’t quite compile yet): -->
`src/main.rs` を作成し配置します。（このコンパイルはまだ通りません）

```rust,ignore
extern crate phrases;

fn main() {
    println!("Hello in English: {}", phrases::english::greetings::hello());
    println!("Goodbye in English: {}", phrases::english::farewells::goodbye());

    println!("Hello in Japanese: {}", phrases::japanese::greetings::hello());
    println!("Goodbye in Japanese: {}", phrases::japanese::farewells::goodbye());
}
```

<!-- The `extern crate` declaration tells Rust that we need to compile and link to
the `phrases` crate. We can then use `phrases` modules in this one. As we
mentioned earlier, you can use double colons to refer to sub-modules and the
functions inside of them. -->
`extern crate` 宣言はRustにコンパイルして `phrases` クレートをリンクせよと伝えます。するとこのクレート内で `phrases` モジュールが使えます。先に述べていたように、2重コロンでサブモジュールとその中の関数を参照できます。

<!-- (Note: when importing a crate that has dashes in its name "like-this", which is
not a valid Rust identifier, it will be converted by changing the dashes to
underscores, so you would write `extern crate like_this;`.) -->
（注意: Rustの識別子として適切でない「like-this」のような、名前の中にダッシュが入ったクレートをインポートする場合、ダッシュがアンダースコアへ変換されるため `extern crate like_this;` と記述します。）

<!-- Also, Cargo assumes that `src/main.rs` is the crate root of a binary crate,
rather than a library crate. Our package now has two crates: `src/lib.rs` and
`src/main.rs`. This pattern is quite common for executable crates: most
functionality is in a library crate, and the executable crate uses that
library. This way, other programs can also use the library crate, and it’s also
a nice separation of concerns. -->
また、Cargoは `src/main.rs` がライブラリクレートではなくバイナリクレートのルートだと仮定します。パッケージには今2つのクレートがあります。 `src/lib.rs` と `src/main.rs` です。ほとんどの機能をライブラリクレート内に置き、実行形式クレートから利用するのがよくあるパターンです。この方法なら他のプログラムがライブラリクレートを使うこともできますし、素敵な関心の分離(separation of concerns)にもなります。

<!-- This doesn’t quite work yet, though. We get four errors that look similar to
this: -->
けれどこのままではまだ動作しません。以下に似た4つのエラーが発生します。

```bash
$ cargo build
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
src/main.rs:4:38: 4:72 error: function `hello` is private
src/main.rs:4     println!("Hello in English: {}", phrases::english::greetings::hello());
                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
note: in expansion of format_args!
<std macros>:2:25: 2:58 note: expansion site
<std macros>:1:1: 2:62 note: in expansion of print!
<std macros>:3:1: 3:54 note: expansion site
<std macros>:1:1: 3:58 note: in expansion of println!
phrases/src/main.rs:4:5: 4:76 note: expansion site
```

<!-- By default, everything is private in Rust. Let’s talk about this in some more
depth. -->
デフォルトでは、Rustにおける全てがプライベートです。それではもっと詳しく説明しましょう。

<!-- # Exporting a Public Interface -->
# パブリックなインターフェースのエクスポート

<!-- Rust allows you to precisely control which aspects of your interface are
public, and so private is the default. To make things public, you use the `pub`
keyword. Let’s focus on the `english` module first, so let’s reduce our `src/main.rs`
to only this: -->
Rustはインターフェースのパブリックである部分をきっちりと管理します。そのためプライベートがデフォルトです。パブリックにするためには `pub` キーワードを使います。まずは `english` モジュールに焦点を当てたいので、 `src/main.rs` をこれだけに減らしましょう。

```rust,ignore
extern crate phrases;

fn main() {
    println!("Hello in English: {}", phrases::english::greetings::hello());
    println!("Goodbye in English: {}", phrases::english::farewells::goodbye());
}
```

<!-- In our `src/lib.rs`, let’s add `pub` to the `english` module declaration: -->
`src/lib.rs` 内にて、 `english` モジュールの宣言に `pub` を加えましょう。

```rust,ignore
pub mod english;
mod japanese;
```

<!-- And in our `src/english/mod.rs`, let’s make both `pub`: -->
また `src/english/mod.rs` にて、両方とも `pub` にしましょう。

```rust,ignore
pub mod greetings;
pub mod farewells;
```

<!-- In our `src/english/greetings.rs`, let’s add `pub` to our `fn` declaration: -->
`src/english/greetings.rs` にて、 `fn` の宣言に `pub` を加えましょう。

```rust,ignore
pub fn hello() -> String {
    "Hello!".to_string()
}
```

<!-- And also in `src/english/farewells.rs`: -->
また `src/english/farewells.rs` にもです。

```rust,ignore
pub fn goodbye() -> String {
    "Goodbye.".to_string()
}
```

<!-- Now, our crate compiles, albeit with warnings about not using the `japanese`
functions: -->
これでクレートはコンパイルできますが、 `japanese` 関数が使われていないという旨の警告が発生します。

```bash
$ cargo run
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
src/japanese/greetings.rs:1:1: 3:2 warning: function is never used: `hello`, #[warn(dead_code)] on by default
src/japanese/greetings.rs:1 fn hello() -> String {
src/japanese/greetings.rs:2     "こんにちは".to_string()
src/japanese/greetings.rs:3 }
src/japanese/farewells.rs:1:1: 3:2 warning: function is never used: `goodbye`, #[warn(dead_code)] on by default
src/japanese/farewells.rs:1 fn goodbye() -> String {
src/japanese/farewells.rs:2     "さようなら".to_string()
src/japanese/farewells.rs:3 }
     Running `target/debug/phrases`
Hello in English: Hello!
Goodbye in English: Goodbye.
```

<!-- `pub` also applies to `struct`s and their member fields. In keeping with Rust’s
tendency toward safety, simply making a `struct` public won't automatically
make its members public: you must mark the fields individually with `pub`. -->
`pub` は `struct` や そのメンバのフィールドにも使えます。Rustの安全性に対する傾向に合わせ、単に `struct` をパブリックにしてもそのメンバまでは自動的にパブリックになりません。個々のフィールドに `pub` を付ける必要があります。

<!-- Now that our functions are public, we can use them. Great! However, typing out
`phrases::english::greetings::hello()` is very long and repetitive. Rust has
another keyword for importing names into the current scope, so that you can
refer to them with shorter names. Let’s talk about `use`. -->
関数がパブリックになり、呼び出せるようになりました。素晴らしい！けれども `phrases::english::greetings::hello()` を打つのは非常に長くて退屈ですね。Rustにはもう1つ、現在のスコープに名前をインポートするキーワードがあるので、それを使えば短い名前で参照できます。では `use` について説明しましょう。

<!-- # Importing Modules with `use` -->
# `use` でモジュールをインポートする

<!-- Rust has a `use` keyword, which allows us to import names into our local scope.
Let’s change our `src/main.rs` to look like this: -->
Rustには `use` キーワードがあり、ローカルスコープの中に名前をインポートできます。 `src/main.rs` を以下のように変えてみましょう。

```rust,ignore
extern crate phrases;

use phrases::english::greetings;
use phrases::english::farewells;

fn main() {
    println!("Hello in English: {}", greetings::hello());
    println!("Goodbye in English: {}", farewells::goodbye());
}
```

<!-- The two `use` lines import each module into the local scope, so we can refer to
the functions by a much shorter name. By convention, when importing functions, it’s
considered best practice to import the module, rather than the function directly. In
other words, you _can_ do this: -->
2つの `use` の行はローカルスコープの中に各モジュールをインポートしているため、とても短い名前で関数を参照できます。慣習では関数をインポートする場合、関数を直接インポートするよりもモジュール単位でするのがベストプラクティスだと考えられています。言い換えれば、こうすることも _できる_ わけです。

```rust,ignore
extern crate phrases;

use phrases::english::greetings::hello;
use phrases::english::farewells::goodbye;

fn main() {
    println!("Hello in English: {}", hello());
    println!("Goodbye in English: {}", goodbye());
}
```

<!-- But it is not idiomatic. This is significantly more likely to introduce a
naming conflict. In our short program, it’s not a big deal, but as it grows, it
becomes a problem. If we have conflicting names, Rust will give a compilation
error. For example, if we made the `japanese` functions public, and tried to do
this: -->
しかしこれは慣用的ではありません。名前の競合を引き起こす可能性が非常に高まるからです。この短いプログラムだと大したことではありませんが、長くなるにつれ問題になります。名前が競合するとコンパイルエラーになります。例えば、 `japanese` 関数をパブリックにして、以下を試してみます。

```rust,ignore
extern crate phrases;

use phrases::english::greetings::hello;
use phrases::japanese::greetings::hello;

fn main() {
    println!("Hello in English: {}", hello());
    println!("Hello in Japanese: {}", hello());
}
```

<!-- Rust will give us a compile-time error: -->
Rustはコンパイル時にエラーを起こします。

```text
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
src/main.rs:4:5: 4:40 error: a value named `hello` has already been imported in this module [E0252]
src/main.rs:4 use phrases::japanese::greetings::hello;
                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
error: aborting due to previous error
Could not compile `phrases`.
```

<!-- If we’re importing multiple names from the same module, we don’t have to type it out
twice. Instead of this: -->
同じモジュールから複数の名前をインポートする場合、二度同じ文字を打つ必要はありません。以下の代わりに、

```rust,ignore
use phrases::english::greetings;
use phrases::english::farewells;
```

<!-- We can use this shortcut: -->
このショートカットが使えます。

```rust,ignore
use phrases::english::{greetings, farewells};
```

<!-- ## Re-exporting with `pub use` -->
## `pub use` による再エクスポート

<!-- You don’t only use `use` to shorten identifiers. You can also use it inside of your crate
to re-export a function inside another module. This allows you to present an external
interface that may not directly map to your internal code organization. -->
`use` は識別子を短くするためだけに用いるのではありません。他のモジュール内の関数を再エクスポートするためにクレートの中で使うこともできます。これを使って内部のコード構成そのままではない外部向けインターフェースを提供できます。

<!-- Let’s look at an example. Modify your `src/main.rs` to read like this: -->
例を見てみましょう。 `src/main.rs` を以下のように変更します。

```rust,ignore
extern crate phrases;

use phrases::english::{greetings,farewells};
use phrases::japanese;

fn main() {
    println!("Hello in English: {}", greetings::hello());
    println!("Goodbye in English: {}", farewells::goodbye());

    println!("Hello in Japanese: {}", japanese::hello());
    println!("Goodbye in Japanese: {}", japanese::goodbye());
}
```

<!-- Then, modify your `src/lib.rs` to make the `japanese` mod public: -->
そして、 `src/lib.rs` の `japanese` モジュールをパブリックに変更します。

```rust,ignore
pub mod english;
pub mod japanese;
```

<!-- Next, make the two functions public, first in `src/japanese/greetings.rs`: -->
続いて、2つの関数をパブリックにします。始めに `src/japanese/greetings.rs` を、

```rust,ignore
pub fn hello() -> String {
    "こんにちは".to_string()
}
```

<!-- And then in `src/japanese/farewells.rs`: -->
そして `src/japanese/farewells.rs` を、

```rust,ignore
pub fn goodbye() -> String {
    "さようなら".to_string()
}
```

<!-- Finally, modify your `src/japanese/mod.rs` to read like this: -->
最後に、 `src/japanese/mod.rs` を以下のように変更します。

```rust,ignore
pub use self::greetings::hello;
pub use self::farewells::goodbye;

mod greetings;
mod farewells;
```

<!-- The `pub use` declaration brings the function into scope at this part of our
module hierarchy. Because we’ve `pub use`d this inside of our `japanese`
module, we now have a `phrases::japanese::hello()` function and a
`phrases::japanese::goodbye()` function, even though the code for them lives in
`phrases::japanese::greetings::hello()` and
`phrases::japanese::farewells::goodbye()`. Our internal organization doesn’t
define our external interface. -->
`pub use` 宣言は関数をモジュール階層 `phrases::japanese` のスコープへ持ち込みます。`japanese` モジュールの中で `pub use` したため、 `phrases::japanese::greetings::hello()` と `phrases::japanese::farewells::goodbye()` にコードがあるのにも関わらず、 `phrases::japanese::hello()` 関数と `phrases::japanese::goodbye()` 関数が使えるようになります。内部の構成で外部向けのインターフェースが決まるわけではありません。

<!-- Here we have a `pub use` for each function we want to bring into the
`japanese` scope. We could alternatively use the wildcard syntax to include
everything from `greetings` into the current scope: `pub use self::greetings::*`. -->
`pub use` によって各関数を `japanese` スコープの中に持ち込めるようになりました。 `greetings` から現在のスコープへ全てをインクルードする代わりに、 `pub use self::greetings::*` とすることでワイルドカード構文が使えます。

<!-- What about the `self`? Well, by default, `use` declarations are absolute paths,
starting from your crate root. `self` makes that path relative to your current
place in the hierarchy instead. There’s one more special form of `use`: you can
`use super::` to reach one level up the tree from your current location. Some
people like to think of `self` as `.` and `super` as `..`, from many shells’
display for the current directory and the parent directory. -->
`self` とはなんでしょう? ええっと、デフォルトでは、 `use` 宣言はクレートのルートから始まる絶対パスです。 `self` は代わりに現在位置からの相対パスにします。 `use` にはもう1つ特別な形式があり、現在位置から1つ上へのアクセスに `use super::` が使えます。多くのシェルにおけるカレントディレクトリと親ディレクトリの表示になぞらえ、 `.` が `self` で、 `..` が `super` であるという考え方を好む人もそれなりにいます。

<!-- Outside of `use`, paths are relative: `foo::bar()` refers to a function inside
of `foo` relative to where we are. If that’s prefixed with `::`, as in
`::foo::bar()`, it refers to a different `foo`, an absolute path from your
crate root. -->
`use` でなければ、パスは相対です。`foo::bar()` は私達のいる場所から相対的に `foo` の内側の関数を参照します。 `::foo::bar()` のように `::` から始まるのであれば、クレートのルートからの絶対パスで、先程とは異なる `foo` を参照します。

<!-- This will build and run: -->
これはビルドして実行できます。

```bash
$ cargo run
   Compiling phrases v0.0.1 (file:///home/you/projects/phrases)
     Running `target/debug/phrases`
Hello in English: Hello!
Goodbye in English: Goodbye.
Hello in Japanese: こんにちは
Goodbye in Japanese: さようなら
```

<!-- ## Complex imports -->
## 複合的なインポート

<!-- Rust offers several advanced options that can add compactness and
convenience to your `extern crate` and `use` statements. Here is an example: -->
`extern crate` 及び `use` 文に対し、Rustは簡潔さと利便性を付加できる上級者向けオプションを幾つか提供しています。以下が例になります。

```rust,ignore
extern crate phrases as sayings;

use sayings::japanese::greetings as ja_greetings;
use sayings::japanese::farewells::*;
use sayings::english::{self, greetings as en_greetings, farewells as en_farewells};

fn main() {
    println!("Hello in English; {}", en_greetings::hello());
    println!("And in Japanese: {}", ja_greetings::hello());
    println!("Goodbye in English: {}", english::farewells::goodbye());
    println!("Again: {}", en_farewells::goodbye());
    println!("And in Japanese: {}", goodbye());
}
```

<!-- What's going on here? -->
何が起きているでしょう?

<!-- First, both `extern crate` and `use` allow renaming the thing that is being
imported. So the crate is still called "phrases", but here we will refer
to it as "sayings". Similarly, the first `use` statement pulls in the
`japanese::greetings` module from the crate, but makes it available as
`ja_greetings` as opposed to simply `greetings`. This can help to avoid
ambiguity when importing similarly-named items from different places. -->
第一に、インポートされているものを `extern crate` と `use` 双方でリネームしています。そのため 「phrases」という名前のクレートであっても、ここでは「sayings」として参照することになります。同様に、始めの `use` 文はクレートから `japanese::greetings` を引き出していますが、単純な `greetings` ではなく `ja_greetings` で利用できるようにしています。これは異なる場所から同じ名前のアイテムをインポートする際、曖昧さを回避するのに役立ちます。

<!-- The second `use` statement uses a star glob to bring in all public symbols from
the `sayings::japanese::farewells` module. As you can see we can later refer to
the Japanese `goodbye` function with no module qualifiers. This kind of glob
should be used sparingly. It’s worth noting that it only imports the public
symbols, even if the code doing the globbing is in the same module. -->
第二の `use` 文では `sayings::japanese::farewells` モジュールから全てのパブリックなシンボルを持ってくるためにスターグロブを使っています。ご覧の通り、最後にモジュールの修飾無しで日本語の `goodbye` 関数を参照できています。この類のグロブは慎重に使うべきです。スターグロブにはパブリックなシンボルをインポートするだけの機能しかありません、例えグロブするコードが同一のモジュール内であったとしてもです。

<!-- The third `use` statement bears more explanation. It's using "brace expansion"
globbing to compress three `use` statements into one (this sort of syntax
may be familiar if you've written Linux shell scripts before). The
uncompressed form of this statement would be: -->
第三の `use` 文はもっと詳しい説明が必要です。これは3つの `use` 文を1つに圧縮するグロブ「中括弧展開」を用いています（以前にLinuxのシェルスクリプトを書いたことがあるなら、この類の構文は慣れていることでしょう）。この文を展開した形式は以下のようになります。

```rust,ignore
use sayings::english;
use sayings::english::greetings as en_greetings;
use sayings::english::farewells as en_farewells;
```

<!-- As you can see, the curly brackets compress `use` statements for several items
under the same path, and in this context `self` refers back to that path.
Note: The curly brackets cannot be nested or mixed with star globbing. -->
ご覧の通り、波括弧は同一パス下にある幾つかのアイテムに対する `use` 文を圧縮します。また、この文脈における `self` はパスの1つ手前を参照します。（訳注: `sayings::english::{self}` の `self` が指す1つ手前は `sayings::english` です）注意: 波括弧はネストできず、スターグロブと混ぜるとこともできません。
