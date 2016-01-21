% はじめよう

This first chapter of the book will get us going with Rust and its tooling.
First, we’ll install Rust. Then, the classic ‘Hello World’ program. Finally,
we’ll talk about Cargo, Rust’s build system and package manager.

この一番最初の章でRustとツールを準備します。
最初にRustをインストールします。そしてお決まりの「Hello World」をやります。
最後にRustのパッケージマネージャのCargoについて話します。

# Rustのインストール

The first step to using Rust is to install it. Generally speaking, you’ll need
an Internet connection to run the commands in this section, as we’ll be
downloading Rust from the internet.

Rustを使い始める最初のステップはインストールです。
この章のコマンドでインターネットからRustのダウンロードをするのでインターネットへの接続が必要でしょう。

We’ll be showing off a number of commands using a terminal, and those lines all
start with `$`. We don't need to type in the `$`s, they are there to indicate
the start of each command. We’ll see many tutorials and examples around the web
that follow this convention: `$` for commands run as our regular user, and `#`
for commands we should be running as an administrator.

コマンドを色々出しますが、それらは全て`$`から始まります。`$`を入力する必要はありません。
`$`はただコマンドの先頭を示しているだけです。
これから、Web上でも「`$`で始まるものは一般ユーザで実行し`#`で始まるものは管理者権限で実行する」というルールに従ったチュートリアルや例をよく見ることになります。

## プラットフォームのサポート

The Rust compiler runs on, and compiles to, a great number of platforms, though
not all platforms are equally supported. Rust's support levels are organized
into three tiers, each with a different set of guarantees.

Rustのコンパイラは個々の違いはあるものの様々なプラットフォーム上で動き、様々なプラットフォームへとコンパイル出来ます。
Rustのサポートレベルは3段階に分かれていて、それぞれ違う保証をします。

Platforms are identified by their "target triple" which is the string to inform
the compiler what kind of output should be produced. The columns below indicate
whether the corresponding component works on the specified platform.

プラットフォームはその「ターゲットトリプル」というどの種類のアウトプットを出すべきかをコンパイラに伝える文字列で識別されます。
下記の表は対応するコンポーネントがそのプラットフォームで動作するかを示します。

### 段階1

Tier 1 platforms can be thought of as "guaranteed to build and work".
Specifically they will each satisfy the following requirements:

段階1のプラットフォームは「ビルド出来るし動くことを保証する」ものと思えます。
特に以下の要求それぞれを満たします。

* Automated testing is set up to run tests for the platform.
* Landing changes to the `rust-lang/rust` repository's master branch is gated on
  tests passing.
* Official release artifacts are provided for the platform.
* Documentation for how to use and how to build the platform is available.

* 自動テストがそのプラットフォーム上で走るようセットアップされている
* `rust-lang/rust`レポジトリのmasterブランチへの変更はテストが通ってからされる
* 公式のリリースがそのプラットフォーム向けに提供される
* 使用方法及びビルド方法のドキュメントがある


|  Target                       | std |rustc|cargo| notes                      |
|-------------------------------|-----|-----|-----|----------------------------|
| `x86_64-pc-windows-msvc`      |  ✓  |  ✓  |  ✓  | 64-bit MSVC (Windows 7+)   |
| `i686-pc-windows-gnu`         |  ✓  |  ✓  |  ✓  | 32-bit MinGW (Windows 7+)  |
| `x86_64-pc-windows-gnu`       |  ✓  |  ✓  |  ✓  | 64-bit MinGW (Windows 7+)  |
| `i686-apple-darwin`           |  ✓  |  ✓  |  ✓  | 32-bit OSX (10.7+, Lion+)  |
| `x86_64-apple-darwin`         |  ✓  |  ✓  |  ✓  | 64-bit OSX (10.7+, Lion+)  |
| `i686-unknown-linux-gnu`      |  ✓  |  ✓  |  ✓  | 32-bit Linux (2.6.18+)     |
| `x86_64-unknown-linux-gnu`    |  ✓  |  ✓  |  ✓  | 64-bit Linux (2.6.18+)     |

### 段階 2

Tier 2 platforms can be thought of as "guaranteed to build". Automated tests
are not run so it's not guaranteed to produce a working build, but platforms
often work to quite a good degree and patches are always welcome! Specifically,
these platforms are required to have each of the following:

段階2のプラットフォームは「ビルドを保証する」ものと思えます。
自動テストは走っておらず、ビルド出来たとしてもちゃんと動く保証はありませんが大抵ほぼ動きますしパッチはいつでも歓迎しています!
特に、以下が要求されています。


* Automated building is set up, but may not be running tests.
* Landing changes to the `rust-lang/rust` repository's master branch is gated on
  platforms **building**. Note that this means for some platforms only the
  standard library is compiled, but for others the full bootstrap is run.
* Official release artifacts are provided for the platform.

* 自動ビルドはセットアップされているがテストは走っていない
* `rust-lang/rust`レポジトリのmasterブランチへの変更は **ビルドが** 通ってからされる。
  これは標準ライブラリしかコンパイル出来ないものもあれば完全なブートストラップまで出来るものもあるということに注意してください。
* 公式のリリースがそのプラットフォーム向けに提供される



|  Target                       | std |rustc|cargo| notes                      |
|-------------------------------|-----|-----|-----|----------------------------|
| `i686-pc-windows-msvc`        |  ✓  |  ✓  |  ✓  | 32-bit MSVC (Windows 7+)   |
| `x86_64-unknown-linux-musl`   |  ✓  |     |     | 64-bit Linux with MUSL     |
| `arm-linux-androideabi`       |  ✓  |     |     | ARM Android                |
| `arm-unknown-linux-gnueabi`   |  ✓  |  ✓  |     | ARM Linux (2.6.18+)        |
| `arm-unknown-linux-gnueabihf` |  ✓  |  ✓  |     | ARM Linux (2.6.18+)        |
| `aarch64-unknown-linux-gnu`   |  ✓  |     |     | ARM64 Linux (2.6.18+)      |
| `mips-unknown-linux-gnu`      |  ✓  |     |     | MIPS Linux (2.6.18+)       |
| `mipsel-unknown-linux-gnu`    |  ✓  |     |     | MIPS (LE) Linux (2.6.18+)  |

### 段階3

Tier 3 platforms are those which Rust has support for, but landing changes is
not gated on the platform either building or passing tests. Working builds for
these platforms may be spotty as their reliability is often defined in terms of
community contributions. Additionally, release artifacts and installers are not
provided, but there may be community infrastructure producing these in
unofficial locations.

段階3のプラットフォームはサポートはされているものの、テストやビルドによる変更の管理は行なっていないものたちです。
コミュニティの貢献の観点で信頼性が定義されるのでビルドが通るかはまちまちです。
さらに、リリースやインストーラは提供されません。
しかしコミュニティが非公式な場所にリリースやインストーラを作れるインフラを持っているかもしれません。


|  Target                       | std |rustc|cargo| notes                      |
|-------------------------------|-----|-----|-----|----------------------------|
| `i686-linux-android`          |  ✓  |     |     | 32-bit x86 Android         |
| `aarch64-linux-android`       |  ✓  |     |     | ARM64 Android              |
| `powerpc-unknown-linux-gnu`   |  ✓  |     |     | PowerPC Linux (2.6.18+)    |
| `i386-apple-ios`              |  ✓  |     |     | 32-bit x86 iOS             |
| `x86_64-apple-ios`            |  ✓  |     |     | 64-bit x86 iOS             |
| `armv7-apple-ios`             |  ✓  |     |     | ARM iOS                    |
| `armv7s-apple-ios`            |  ✓  |     |     | ARM iOS                    |
| `aarch64-apple-ios`           |  ✓  |     |     | ARM64 iOS                  |
| `i686-unknown-freebsd`        |  ✓  |  ✓  |     | 32-bit FreeBSD             |
| `x86_64-unknown-freebsd`      |  ✓  |  ✓  |     | 64-bit FreeBSD             |
| `x86_64-unknown-openbsd`      |  ✓  |  ✓  |     | 64-bit OpenBSD             |
| `x86_64-unknown-netbsd`       |  ✓  |  ✓  |     | 64-bit NetBSD              |
| `x86_64-unknown-bitrig`       |  ✓  |  ✓  |     | 64-bit Bitrig              |
| `x86_64-unknown-dragonfly`    |  ✓  |  ✓  |     | 64-bit DragonFlyBSD        |
| `x86_64-rumprun-netbsd`       |  ✓  |     |     | 64-bit NetBSD Rump Kernel  |
| `i686-pc-windows-msvc` (XP)   |  ✓  |     |     | Windows XP support         |
| `x86_64-pc-windows-msvc` (XP) |  ✓  |     |     | Windows XP support         |

Note that this table can be expanded over time, this isn't the exhaustive set of
tier 3 platforms that will ever be!

このテーブルはしたいだいに拡大するかもしれないことに注意して下さい。
全ての段階3のプラットフォームは知り尽せないのです!


## LinuxまたはMacにインストールする

If we're on Linux or a Mac, all we need to do is open a terminal and type this:

LinuxかMacを使っているなら以下を入力するだけです

```bash
$ curl -sSf https://static.rust-lang.org/rustup.sh | sh
```

This will download a script, and stat the installation. If it all goes well,
you’ll see this appear:

このコマンドでスクリプトをダウンロードしインストールを始めます。
全て上手くいったら以下が表示される筈です。



```text
Welcome to Rust.

This script will download the Rust compiler and its package manager, Cargo, and
install them to /usr/local. You may install elsewhere by running this script
with the --prefix=<path> option.

The installer will run under ‘sudo’ and may ask you for your password. If you do
not want the script to run ‘sudo’ then pass it the --disable-sudo flag.

You may uninstall later by running /usr/local/lib/rustlib/uninstall.sh,
or by running this script again with the --uninstall flag.

Continue? (y/N)
```

From here, press `y` for ‘yes’, and then follow the rest of the prompts.

ここで「はい」の意味で`y`を押しましょう。そして以後のプロンプトに従って下さい。

## Windowsにインストール

If you're on Windows, please download the appropriate [installer][install-page].

Windowsを使っているなら適切な[インストーラ][install-page]をダウンロードして下さい。

[install-page]: https://www.rust-lang.org/install.html

## アンインストール

Uninstalling Rust is as easy as installing it. On Linux or Mac, run
the uninstall script:

Rustのアンイストールはインストールと同じくらい簡単です。
LinuxかMacならアンインストールスクリプトを使って下さい。

```bash
$ sudo /usr/local/lib/rustlib/uninstall.sh
```

If we used the Windows installer, we can re-run the `.msi` and it will give us
an uninstall option.

Windowsのインストーラを使ったなら`.msi`をもう一度実行すればアンインストールのオプショが出てきます。

## トラブルシューティング

If we've got Rust installed, we can open up a shell, and type this:

既にRustをインストールしているならシェルを開いて以下を打ちましょう。

```bash
$ rustc --version
```

You should see the version number, commit hash, and commit date.

バージョン番号、コミットハッシュ、そしてコミット日時が表示される筈です。

If you do, Rust has been installed successfully! Congrats!

表示されたならRustはちゃんとインストールされています!おめでとう!

If you don't and you're on Windows, check that Rust is in your %PATH% system
variable. If it isn't, run the installer again, select "Change" on the "Change,
repair, or remove installation" page and ensure "Add to PATH" is installed on
the local hard drive.

Windowsを使っていて、表示されないなら%PATHI%システム変数にRustが入っているか確認して下さい。
入っていなければもう一度インストーラを実行し、「Change,
repair, or remove installation」ページのの「Change」を選択し、「Add to PATH」がローカルのハードドライブにインストールされていることを確認して下さい。

If not, there are a number of places where we can get help. The easiest is
[the #rust IRC channel on irc.mozilla.org][irc], which we can access through
[Mibbit][mibbit]. Click that link, and we'll be chatting with other Rustaceans
(a silly nickname we call ourselves) who can help us out. Other great resources
include [the user’s forum][users], and [Stack Overflow][stackoverflow].

もし上手くいかないなら様々な場所で助けを得られます。
最も簡単なのは[Mibbit][mibbit]からアクセス出来る[the #rust IRC channel on irc.mozilla.org][irc]です。
リンクをクリックしたら他の助けを求めれるRustacean達(我々のことをふざけてこう呼ぶのです)とチャット出来ます。
他には[the user’s forum][users]や[Stack Overflow][stackoverflow]などがあります。

[訳注] TODO:日本語で会話出来るリソースを探す

[irc]: irc://irc.mozilla.org/#rust
[mibbit]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
[users]: https://users.rust-lang.org/
[stackoverflow]: http://stackoverflow.com/questions/tagged/rust

This installer also installs a copy of the documentation locally, so we can
read it offline. On UNIX systems, `/usr/local/share/doc/rust` is the location.
On Windows, it's in a `share/doc` directory, inside the directory to which Rust
was installed.

インストーラはドキュメントのコピーもローカルにインストールしますので、オフラインで読めます。
UNIXでは`/usr/local/share/doc/rust`にあります。
WindowsではRustをインストールした所の`share/doc`ディレクトリにあります。


# Hello, world!

Now that you have Rust installed, we'll help you write your first Rust program.
It's traditional when learning a new language to write a little program to
print the text “Hello, world!” to the screen, and in this section, we'll follow
that tradition.

Rustをインストールしたので最初のRustのプログラムを書いていきましょう。
新しい言語を学ぶ時に「Hello, world!」とスクリーンに表示する小さなプログラムを書くのが伝統で、このセクションでもそれに従います。


The nice thing about starting with such a simple program is that you can
quickly verify that your compiler is installed, and that it's working properly.
Printing information to the screen is also a pretty common thing to do, so
practicing it early on is good.

このように小さなプログラムから始める利点はコンパイラがインストールされていて、正しく動くことを素早く確認出来ることです。
情報をスクリーンに表示することは非常によくやることなので早い内に練習しておくのが良いです。


> Note: This book assumes basic familiarity with the command line. Rust itself
> makes no specific demands about your editing, tooling, or where your code
> lives, so if you prefer an IDE to the command line, that's an option. You may
> want to check out [SolidOak], which was built specifically with Rust in mind.
> There are a number of extensions in development by the community, and the
> Rust team ships plugins for [various editors]. Configuring your editor or
> IDE is out of the scope of this tutorial, so check the documentation for your
> specific setup.

> 留意: 本書はコマンドラインをある程度使えることを仮定しています。Rust本体はコードの編集やツール群、
> コードの置き場には特に要求を設けませんのでコマンドラインよりIDEを好むならそうしても構いません。
> Rustを念頭に置いて作られたIDE、[SolidOak]を試してみるといいかもしれません。
> コミュニティにより多数の拡張が開発されていますし、Rustチームも[様々なエディタ]向けにプラグインを用意しています。
> このチュートリアルではエディタやIDEの設定は扱いませんのでそれぞれに合ったドキュメントを参照して下さい。


[SolidOak]: https://github.com/oakes/SolidOak
[様々なエディタ]: https://github.com/rust-lang/rust/blob/master/src/etc/CONFIGS.md

## プロジェクトファイルを作る

First, make a file to put your Rust code in. Rust doesn't care where your code
lives, but for this book, I suggest making a *projects* directory in your home
directory, and keeping all your projects there. Open a terminal and enter the
following commands to make a directory for this particular project:

まず、Rustのコードを書くファイルを用意します。
Rustはコードがどこにあるかは気にしませんが本書ではホームディレクトリ下に
*projects* ディレクトリを作って全てのプロジェクトをそのディレクトリ下に入れることを勧めます。
ターミナルを開いて以下のコマンドで今回のプロジェクトのディレクトリを作りましょう。

```bash
$ mkdir ~/projects
$ cd ~/projects
$ mkdir hello_world
$ cd hello_world
```

> Note: If you’re on Windows and not using PowerShell, the `~` may not work.
> Consult the documentation for your shell for more details.

> 留意: WindowsでかつPowerShellを使っていないのなら `~`は上手く動かないかもしれません。
> 使っているシェルのドキュメントをあたってみて下さい。

## Rustのコードを書いて走らせる

Next, make a new source file and call it *main.rs*. Rust files always end
in a *.rs* extension. If you’re using more than one word in your filename, use
an underscore to separate them; for example, you'd use *hello_world.rs* rather
than *helloworld.rs*.

次に、新しいソースファイルを作ります。それを *main.rs* としましょう。
Rustのファイルは常に *.rs* 拡張子で終わります。ファイル名に1つ以上の単語を使うならアンダースコアで区切りましょう。
例えば、 *helloworld.rs* ではなく *hello_world.rs* を使うことになります。

Now open the *main.rs* file you just created, and type the following code:

では作った *main.rs* を開いて以下のコードを打ち込みましょう。

```rust
fn main() {
    println!("Hello, world!");
}
```

Save the file, and go back to your terminal window. On Linux or OSX, enter the
following commands:

ファイルを保存して、ターミナルのウィンドウに戻ります。LinuxかOSXでは以下のコマンドを打ちます。


```bash
$ rustc main.rs
$ ./main
Hello, world!
```

In Windows, replace `main` with `main.exe`. Regardless of your operating
system, you should see the string `Hello, world!` print to the terminal. If you
did, then congratulations! You've officially written a Rust program. That makes
you a Rust programmer! Welcome.

Windowsでは`main`の代わりに`main.exe`を打ちます。使っているOSに関わらず、`Hello, world!`の文字列を目にする筈です。
目にしたなら、おめでとうございます！あなたは正式にRustのプログラムを記述しました。これであなたもRustプログラマです！ようこそ。


## Rustプログラムの解剖

Now, let’s go over what just happened in your "Hello, world!" program in
detail. Here's the first piece of the puzzle:

さて、「Hello, world!」プログラムで何が起きていたのがつぶさに見ていきましょう。
パズルの最初のピースがこれです。


```rust
fn main() {

}
```

These lines define a *function* in Rust. The `main` function is special: it's
the beginning of every Rust program. The first line says, “I’m declaring a
function named `main` that takes no arguments and returns nothing.” If there
were arguments, they would go inside the parentheses (`(` and `)`), and because
we aren’t returning anything from this function, we can omit the return type
entirely.

これら行はRustの *関数* を定義します。`main`関数は特別です。全てのRustプログラムの開始点になります。
最初の行は「引数を取らず、返り値も返さない関数`main`を宣言します」といっています。
引数があれば、括弧(`(`と`)`)の中に入りますし、今回はこの関数から何も値を返さないので返り値の型を完全に省略出来ます。

Also note that the function body is wrapped in curly braces (`{` and `}`). Rust
requires these around all function bodies. It's considered good style to put
the opening curly brace on the same line as the function declaration, with one
space in between.

さらに、関数の本体部がくるくる括弧(`{`と`}`)で括られていることに留意して下さい。
Rustは全ての関数の本体部にくるくる括弧を要請します。
関数宣言と同じ行に1スペース空けて開きくるくる括弧を置くのが良いスタイルとされます。


Inside the `main()` function:

`main()`関数の中では

```rust
    println!("Hello, world!");
```

This line does all of the work in this little program: it prints text to the
screen. There are a number of details that are important here. The first is
that it’s indented with four spaces, not tabs.

この行はが今回の小さなプログラムの全てを担っています。これがテキストをスクリーンに印字するのです。
ここで重要な詳細がいくつもあります。1つ目はインデントが4スペースであり、タブでない点です。

The second important part is the `println!()` line. This is calling a Rust
*[macro]*, which is how metaprogramming is done in Rust. If it were calling a
function instead, it would look like this: `println()` (without the !). We'll
discuss Rust macros in more detail later, but for now you only need to
know that when you see a `!` that means that you’re calling a macro instead of
a normal function.

2つ目の重要な部分は`println!()`の行です。これはRustのメタプログラミング機構、 *[マクロ]* の呼び出しです。
もし関数を呼び出しているのなら、`println()`のようになります(! がありません)。
Rustのマクロについては後程詳細に議論しますが、今のところ`!`を見たら普通の関数ではなくマクロを呼んでいることを意味するということを知っておいて下さい。


[マクロ]: macros.html

Next is `"Hello, world!"` which is a *string*. Strings are a surprisingly
complicated topic in a systems programming language, and this is a *[statically
allocated]* string. We pass this string as an argument to `println!`, which
prints the string to the screen. Easy enough!

次は 文字列の`"Hello, world"`です。
システムプログラミング言語では文字列は驚くほど複雑なトピックで、これは *[静的に確保された]* 文字列です。
文字列をスクリーンに印字してくれる`println!`にこれを引数として渡します。簡単ですね！

[静的に確保された]: the-stack-and-the-heap.html

The line ends with a semicolon (`;`). Rust is an *[expression-oriented
language]*, which means that most things are expressions, rather than
statements. The `;` indicates that this expression is over, and the next one is
ready to begin. Most lines of Rust code end with a `;`.

件の行はセミコロン(`;`)で終わります。Rustは *[式指向言語]* で、ほとんどのものは文ではなく式になります。
`;`は式が終わり、次の式が始まることを示します。Rustのコードのほとんどの行は`;`で終わります。

[式指向言語]: glossary.html#expression-oriented-language

## コンパイルと実行は別の手順

In "Writing and Running a Rust Program", we showed you how to run a newly
created program. We'll break that process down and examine each step now.

「Rustのプログラムを書いて走らせる」で、新しく作ったプログラムをどうやって実行するか示しました。
それぞれを分解して手順毎に見ていきましょう。


Before running a Rust program, you have to compile it. You can use the Rust
compiler by entering the `rustc` command and passing it the name of your source
file, like this:

Rustのプログラムを走らせる前に、コンパイルする必要があります。
Rustのコンパイラは以下のように`rustc`と入力してソースファイルの名前を渡してあげることで使えます。

```bash
$ rustc main.rs
```

If you come from a C or C++ background, you'll notice that this is similar to
`gcc` or `clang`. After compiling successfully, Rust should output a binary
executable, which you can see on Linux or OSX by entering the `ls` command in
your shell as follows:

CまたはC++のバックグラウンドを持つなら`gcc`や`clang`に似ていことに気付くでしょう。
コンパイルが成功したら、Rustは実行可能バイナリを吐いている筈です。
LinuxかOSXなら以下のように`ls`コマンドで確認出来ます。


```bash
$ ls
main  main.rs
```

On Windows, you'd enter:
Windowsなら、こうなります。


```bash
$ dir
main.exe  main.rs
```

This shows we have two files: the source code, with an `.rs` extension, and the
executable (`main.exe` on Windows, `main` everywhere else). All that's left to
do from here is run the `main` or `main.exe` file, like this:

2つのファイルがあるといっています。`.rs`拡張子を持ったソースコードと実行可能ファイル(Windowsでは`main.exe`、それ以外では`main`)。
ここからあとは`main`または`main.exe`のファイルをこのように実行するだけです。


```bash
$ ./main  # あるいはWindowsならmain.exe
```

If *main.rs* were your "Hello, world!" program, this would print `Hello,
world!` to your terminal.

もし *main.rs* が「Hello, world!」プログラムなら、これで`Hello, world!`とターミナルに印字されることでしょう。

If you come from a dynamic language like Ruby, Python, or JavaScript, you may
not be used to compiling and running a program being separate steps. Rust is an
*ahead-of-time compiled* language, which means that you can compile a program,
give it to someone else, and they can run it even without Rust installed. If
you give someone a `.rb` or `.py` or `.js` file, on the other hand, they need
to have a Ruby, Python, or JavaScript implementation installed (respectively),
but you only need one command to both compile and run your program. Everything
is a tradeoff in language design.

もしRubyやPython、JavaScriptなどの動的な言語から来たのならコンパイルと実行が別の手順になっていることに馴れないでしょう。
Rustは、プログラムをコンパイルしてそれを別の誰かに渡したらRustがなくても動く、 *事前コンパイル* 言語です。
他方別の誰かに`.rb`や`.py`、`.js`を渡したら(それぞれ)Ruby、PythonあるいはJavaScriptの実装が必要になりますが、コンパイルにも実行にも1つのコマンドで事足ります。
全ては言語設計上のトレードオフです。

Just compiling with `rustc` is fine for simple programs, but as your project
grows, you'll want to be able to manage all of the options your project has,
and make it easy to share your code with other people and projects. Next, I'll
introduce you to a tool called Cargo, which will help you write real-world Rust
programs.

単純なプログラムなら単に`rustc`でコンパイルすれば十分ですがプロジェクトが大きくなるにつれてプロジェクトの全てのオプションを管理したり他の人やプロジェクトと容易に共有出来るようにしたくなるでしょう。
次は現実的なRustプログラムを書く手助けになるCargoというツールを紹介します。

# Hello, Cargo!

Cargo is Rust’s build system and package manager, and Rustaceans use Cargo to
manage their Rust projects. Cargo manages three things: building your code,
downloading the libraries your code depends on, and building those libraries.
We call libraries your code needs ‘dependencies’ since your code depends on
them.

CargoはRustのビルドシステムであり、パッケージマネージャでありRustaceanはCargoをRustプロジェクトの管理にも使います。
Cargoは3つのものを管理します、則ち、コードのビルド、コードが依存するライブラリのダウンロード、そしてそれらのライブラリのビルド。
コードが必要とするライブラリをそれに依存するので「依存」と呼びます。

The simplest Rust programs don’t have any dependencies, so right now, you'd
only use the first part of its functionality. As you write more complex Rust
programs, you’ll want to add dependencies, and if you start off using Cargo,
that will be a lot easier to do.

最も簡単なRustのプログラムは依存を持たないのでここではCargoの1つめの機能だけを使います。
もっと複雑なRustのコードを書くにつれて、依存を追加したくなるでしょうが、Cargoを使えばそれがとても簡単に出来ます。

As the vast, vast majority of Rust projects use Cargo, we will assume that
you’re using it for the rest of the book. Cargo comes installed with Rust
itself, if you used the official installers. If you installed Rust through some
other means, you can check if you have Cargo installed by typing:

ほとんどもほとんどのRustのプロジェクトがCargoを使うのでこれ以後はCargoを使うものと仮定します。
公式のインストーラを使ったならCargoはRustに同梱されています。
他の手段でRustをインストールしたなら、以下のコマンドでCargoがインストールされているか確認出来ます。

```bash
$ cargo --version
```

Into a terminal. If you see a version number, great! If you see an error like
‘`command not found`’, then you should look at the documentation for the system
in which you installed Rust, to determine if Cargo is separate.

バージョン番号を確認出来たなら、良かった！`コマンドが見つかりません`などのエラーが出たなら
Rustをインストールしたシステムのドキュメントを見て、Cargoが分離されているか判断しましょう。


## Converting to Cargo

Let’s convert the Hello World program to Cargo. To Cargo-fy a project, you need
to do three things:

1. Put your source file in the right directory.
2. Get rid of the old executable (`main.exe` on Windows, `main` everywhere else)
   and make a new one.
3. Make a Cargo configuration file.

Let's get started!

### Creating a new Executable and Source Directory

First, go back to your terminal, move to your *hello_world* directory, and
enter the following commands:

```bash
$ mkdir src
$ mv main.rs src/main.rs
$ rm main  # or 'del main.exe' on Windows
```

Cargo expects your source files to live inside a *src* directory, so do that
first. This leaves the top-level project directory (in this case,
*hello_world*) for READMEs, license information, and anything else not related
to your code. In this way, using Cargo helps you keep your projects nice and
tidy. There's a place for everything, and everything is in its place.

Now, copy *main.rs* to the *src* directory, and delete the compiled file you
created with `rustc`. As usual, replace `main` with `main.exe` if you're on
Windows.

This example retains `main.rs` as the source filename because it's creating an
executable. If you wanted to make a library instead, you'd name the file
`lib.rs`. This convention is used by Cargo to successfully compile your
projects, but it can be overridden if you wish.

### Creating a Configuration File

Next, create a new file inside your *hello_world* directory, and call it
`Cargo.toml`.

Make sure to capitalize the `C` in `Cargo.toml`, or Cargo won't know what to do
with the configuration file.

This file is in the *[TOML]* (Tom's Obvious, Minimal Language) format. TOML is
similar to INI, but has some extra goodies, and is used as Cargo’s
configuration format.

[TOML]: https://github.com/toml-lang/toml

Inside this file, type the following information:

```toml
[package]

name = "hello_world"
version = "0.0.1"
authors = [ "Your name <you@example.com>" ]
```

The first line, `[package]`, indicates that the following statements are
configuring a package. As we add more information to this file, we’ll add other
sections, but for now, we only have the package configuration.

The other three lines set the three bits of configuration that Cargo needs to
know to compile your program: its name, what version it is, and who wrote it.

Once you've added this information to the *Cargo.toml* file, save it to finish
creating the configuration file.

## Building and Running a Cargo Project

With your *Cargo.toml* file in place in your project's root directory, you
should be ready to build and run your Hello World program! To do so, enter the
following commands:

```bash
$ cargo build
   Compiling hello_world v0.0.1 (file:///home/yourname/projects/hello_world)
$ ./target/debug/hello_world
Hello, world!
```

Bam! If all goes well, `Hello, world!` should print to the terminal once more.

You just built a project with `cargo build` and ran it with
`./target/debug/hello_world`, but you can actually do both in one step with
`cargo run` as follows:

```bash
$ cargo run
     Running `target/debug/hello_world`
Hello, world!
```

Notice that this example didn’t re-build the project. Cargo figured out that
the file hasn’t changed, and so it just ran the binary. If you'd modified your
source code, Cargo would have rebuilt the project before running it, and you
would have seen something like this:

```bash
$ cargo run
   Compiling hello_world v0.0.1 (file:///home/yourname/projects/hello_world)
     Running `target/debug/hello_world`
Hello, world!
```

Cargo checks to see if any of your project’s files have been modified, and only
rebuilds your project if they’ve changed since the last time you built it.

With simple projects, Cargo doesn't bring a whole lot over just using `rustc`,
but it will become useful in future. This is especially true when you start
using crates; these are synonymous with a ‘library’ or ‘package’ in other
programming languages. For complex projects composed of multiple crates, it’s
much easier to let Cargo coordinate the build. Using Cargo, you can run `cargo
build`, and it should work the right way.

## Building for Release

When your project is finally ready for release, you can use `cargo build
--release` to compile your project with optimizations. These optimizations make
your Rust code run faster, but turning them on makes your program take longer
to compile. This is why there are two different profiles, one for development,
and one for building the final program you’ll give to a user.

Running this command also causes Cargo to create a new file called
*Cargo.lock*, which looks like this:

```toml
[root]
name = "hello_world"
version = "0.0.1"
```

Cargo uses the *Cargo.lock* file to keep track of dependencies in your
application. This is the Hello World project's *Cargo.lock* file. This project
doesn't have dependencies, so the file is a bit sparse. Realistically, you
won't ever need to touch this file yourself; just let Cargo handle it.

That’s it! If you've been following along, you should have successfully built
`hello_world` with Cargo.

Even though the project is simple, it now uses much of the real tooling you’ll
use for the rest of your Rust career. In fact, you can expect to start
virtually all Rust projects with some variation on the following commands:

```bash
$ git clone someurl.com/foo
$ cd foo
$ cargo build
```

## Making A New Cargo Project the Easy Way

You don’t have to go through that previous process every time you want to start
a new project! Cargo can quickly make a bare-bones project directory that you
can start developing in right away.

To start a new project with Cargo, enter `cargo new` at the command line:

```bash
$ cargo new hello_world --bin
```

This command passes `--bin` because the goal is to get straight to making an
executable application, as opposed to a library. Executables are often called
*binaries* (as in `/usr/bin`, if you’re on a Unix system).

Cargo has generated two files and one directory for us: a `Cargo.toml` and a
*src* directory with a *main.rs* file inside. These should look familliar,
they’re exactly what we created by hand, above.

This output is all you need to get started. First, open `Cargo.toml`. It should
look something like this:

```toml
[package]

name = "hello_world"
version = "0.1.0"
authors = ["Your Name <you@example.com>"]
```

Cargo has populated *Cargo.toml* with reasonable defaults based on the arguments
you gave it and your `git` global configuration. You may notice that Cargo has
also initialized the `hello_world` directory as a `git` repository.

Here’s what should be in `src/main.rs`:

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargo has generated a "Hello World!" for you, and you’re ready to start coding!

> Note: If you want to look at Cargo in more detail, check out the official [Cargo
guide], which covers all of its features.

[Cargo guide]: http://doc.crates.io/guide.html

# Closing Thoughts

This chapter covered the basics that will serve you well through the rest of
this book, and the rest of your time with Rust. Now that you’ve got the tools
down, we'll cover more about the Rust language itself.

You have two options: Dive into a project with ‘[Learn Rust][learnrust]’, or
start from the bottom and work your way up with ‘[Syntax and
Semantics][syntax]’. More experienced systems programmers will probably prefer
‘Learn Rust’, while those from dynamic backgrounds may enjoy either. Different
people learn differently! Choose whatever’s right for you.

[learnrust]: learn-rust.html
[syntax]: syntax-and-semantics.html
