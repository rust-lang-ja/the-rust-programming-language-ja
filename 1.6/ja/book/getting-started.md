% はじめよう

この一番最初の章でRustとツールの使い方をやっていきます。
最初にRustをインストールします。そしてお決まりの「Hello World」をやります。
最後にRustのビルドシステム兼パッケージマネージャのCargoについて話します。

# Rustのインストール

Rustを使い始める最初のステップはインストールです。
このセクションのコマンドでインターネットからRustのダウンロードをするのでインターネットへの接続が必要でしょう。

コマンドを色々提示しますが、それらは全て`$`から始まります。`$`を入力する必要はありません。
`$`はただコマンドの先頭を示しているだけです。
これから、Web上でも「`$`で始まるものは一般ユーザで実行し`#`で始まるものは管理者権限で実行する」というルールに従ったチュートリアルや例をよく見ることになります。

## プラットフォームのサポート

Rustのコンパイラは等しくサポートされている訳ではありませんが様々なプラットフォーム上で動き、様々なプラットフォームへとコンパイル出来ます。
Rustのサポートレベルは3階級に分かれていて、それぞれ違う保証をします。

プラットフォームはその「ターゲットトリプル」というどの種類のアウトプットを生成すべきかをコンパイラに伝える文字列で識別されます。
下記の表は対応するコンポーネントがそのプラットフォームで動作するかを示します。

### 1級

1級のプラットフォームは「ビルド出来かつ動くことを保証する」ものと思えます。
特に以下の要求それぞれを満たします。

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

### 2級

段階2のプラットフォームは「ビルドを保証する」ものと思えます。
自動テストは走っておらず、ビルド出来たとしてもちゃんと動く保証はありませんが大抵ほぼ動きますしパッチはいつでも歓迎しています!
特に、以下が要請されています。

* 自動ビルドはセットアップされているがテストは走っていないかもしれない
* `rust-lang/rust`レポジトリのmasterブランチへの変更は **ビルドが** 通ってからされる。
  これは標準ライブラリしかコンパイル出来ないものもあれば完全なブートストラップまで出来るものもあることを意味するということに注意してください。
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

### 3級

3級のプラットフォームはサポートはされているものの、テストやビルドによる変更の管理は行なっていないものたちです。
コミュニティの貢献度で信頼性が定義されるのでビルドが通るかはまちまちです。
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

このテーブルは時間と共に拡張されるかもしれないことに注意して下さい。
これからの全ての3級のプラットフォームは網羅してないのです!


## LinuxまたはMacにインストールする

LinuxかMacを使っているなら以下を入力するだけです

```bash
$ curl -sSf https://static.rust-lang.org/rustup.sh | sh
```

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

[訳注]:


```text
Rustへようこそ。

このスクリプトはRustコンパイラとそのパッケジマネージャCargoをダウンロードし、/usr/local
へとインストールします。--prefix=<path> オプションを使うことで他の場所へインストール
出来ます。

インストーラは「sudo」下で走るのでパスワードを尋きます。もし'sudo'を使ってほしくないなら
--disable-sudo フラグを渡します。

You may uninstall later by running /usr/local/lib/rustlib/uninstall.sh,
or by running this script again with the --uninstall flag.

/usr/local/lib/rustlib/uninstall.shを実行するかこのスクリプトに--uninstallフラグを
付けて実行することで後程アインストール出来ます。

続けますか? (y/N)
```

ここで「はい」の意味で`y`を押しましょう。そして以後のプロンプトに従って下さい。

## Windowsにインストール

Windowsを使っているなら適切な[インストーラ][install-page]をダウンロードして下さい。

[install-page]: https://www.rust-lang.org/install.html

## アンインストール

Rustのアンイストールはインストールと同じくらい簡単です。
LinuxかMacならアンインストールスクリプトを使って下さい。

```bash
$ sudo /usr/local/lib/rustlib/uninstall.sh
```

Windowsのインストーラを使ったなら`.msi`をもう一度実行すればアンインストールのオプショが出てきます。

## トラブルシューティング

既にRustをインストールしているならシェルを開いて以下を打ちましょう。

```bash
$ rustc --version
```

バージョン番号、コミットハッシュ、そしてコミット日時が表示される筈です。

表示されたならRustはちゃんとインストールされています!おめでとう!

Windowsを使っていて、表示されないなら%PATHI%システム変数にRustが入っているか確認して下さい。
入っていなければもう一度インストーラを実行し、「Change,
repair, or remove installation」ページのの「Change」を選択し、「Add to PATH」がローカルのハードドライブにインストールされていることを確認して下さい。

もし上手くいかないなら様々な場所で助けを得られます。
最も簡単なのは[Mibbit][mibbit]からアクセス出来る[irc.mozilla.orgにある#rustチャネル][irc]です。
リンクをクリックしたら他の助けを求めれるRustacean達(我々のことをふざけてこう呼ぶのです)とチャット出来ます。
他には[ユーザフォーラム][users]や[Stack Overflow][stackoverflow]などがあります。

[訳注] TODO:日本語で会話出来るリソースを探す

[irc]: irc://irc.mozilla.org/#rust
[mibbit]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
[users]: https://users.rust-lang.org/
[stackoverflow]: http://stackoverflow.com/questions/tagged/rust

インストーラはドキュメントのコピーもローカルにインストールしますので、オフラインで読めます。
UNIXシステムでは`/usr/local/share/doc/rust`にあります。
WindowsではRustをインストールした所の`share/doc`ディレクトリにあります。


# Hello, world!

Rustをインストールしたので最初のRustのプログラムを書いていきましょう。
新しい言語を学ぶ時に「Hello, world!」とスクリーンに表示する小さなプログラムを書くのが伝統で、このセクションでもそれに従います。

このように小さなプログラムから始める利点はコンパイラがインストールされていて、正しく動くことを素早く確認出来ることです。
情報をスクリーンに表示することも非常によくやることなので早い内に練習しておくのが良いです。


> 留意: 本書はコマンドラインをある程度使えることを仮定しています。Rust本体はコードの編集やツール群、
> コードの置き場には特に要求を設けませんのでコマンドラインよりIDEを好むならそうしても構いません。
> Rustを念頭に置いて作られたIDE、[SolidOak]を試してみるといいかもしれません。
> コミュニティにより多数の拡張が開発されていますし、Rustチームも[様々なエディタ]向けにプラグインを用意しています。
> このチュートリアルではエディタやIDEの設定は扱いませんのでそれぞれに合ったドキュメントを参照して下さい。


[SolidOak]: https://github.com/oakes/SolidOak
[様々なエディタ]: https://github.com/rust-lang/rust/blob/master/src/etc/CONFIGS.md

## プロジェクトファイルを作る

まず、Rustのコードを書くファイルを用意します。
Rustはコードがどこにあるかは気にしませんが本書を進めるにあたってホームディレクトリ下に
*projects* ディレクトリを作って全てのプロジェクトをそのディレクトリ下に入れることをお勧めます。
ターミナルを開いて以下のコマンドで今回のプロジェクトのディレクトリを作りましょう。

```bash
$ mkdir ~/projects
$ cd ~/projects
$ mkdir hello_world
$ cd hello_world
```

> 留意: WindowsでかつPowerShellを使っていないのなら `~`は上手く動かないかもしれません。
> 使っているシェルのドキュメントをあたってみて下さい。

## Rustのコードを書いて走らせる

次に、新しいソースファイルを作り、それを *main.rs* としましょう。
Rustのファイルは常に *.rs* 拡張子で終わります。ファイル名に1つ以上の単語を使うならアンダースコアで区切りましょう。
例えば、 *helloworld.rs* ではなく *hello_world.rs* を使うことになります。

それでは作った *main.rs* を開いて以下のコードを打ちましょう。

```rust
fn main() {
    println!("Hello, world!");
}
```

ファイルを保存して、ターミナルのウィンドウに戻ります。LinuxかOSXでは以下のコマンドを入力します。


```bash
$ rustc main.rs
$ ./main
Hello, world!
```

Windowsでは`main`の代わりに`main.exe`を打ちます。使っているOSに関わらず、`Hello, world!`の文字列がターミナルに印字されるのを目にする筈です。
目にしたなら、おめでとうございます！あなたは正式にRustのプログラムを記述しました。これであなたもRustプログラマです！ようこそ。


## Rustプログラムの解剖

さて、「Hello, world!」プログラムで何が起きていたのがつぶさに見ていきましょう。
パズルの最初のピースがこれです。


```rust
fn main() {

}
```

これら行はRustの *関数* を定義します。`main`関数は特別です。全てのRustプログラムの開始点になります。
最初の行は「引数を取らず、返り値も返さない関数`main`を宣言します」といっています。
引数があれば、括弧(`(`と`)`)の中に入りますし、今回はこの関数から何も値を返さないので返り値の型を完全に省略出来ます。

さらに、関数の本体部がくるくる括弧(`{`と`}`)で括られていることに留意して下さい。
Rustは全ての関数の本体部にくるくる括弧を要請します。
関数宣言と同じ行に1スペース空けて開きくるくる括弧を置くのが良いスタイルとされます。


`main()`関数の中では

```rust
    println!("Hello, world!");
```

この行が今回の小さなプログラムの全てを担っています。これがテキストをスクリーンに印字するのです。
ここに重要な詳細がいくつもあります。1つ目はインデントが4スペースであり、タブでない点です。

2つ目の重要な部分は`println!()`の行です。これはRustのメタプログラミング機構、 *[マクロ]* の呼び出しです。
もし関数を呼び出しているのなら、`println()`のようになります(! がありません)。
Rustのマクロについては後程詳細に議論しますが、今のところ`!`を見たら普通の関数ではなくマクロを呼び出していることを意味するということだけ知っておいて下さい。


[マクロ]: macros.html

次は 文字列の`"Hello, world"`です。
システムプログラミング言語では文字列は驚くほど複雑なトピックで、これは *[静的に確保された]* 文字列です。
文字列をスクリーンに印字してくれる`println!`にこれを引数として渡します。簡単ですね！

[静的に確保された]: the-stack-and-the-heap.html

件の行はセミコロン(`;`)で終わります。Rustは *[式指向言語]* で、ほとんどのものは文ではなく式になります。
`;`は式が終わり、次の式が始まることを示します。Rustのコードのほとんどの行は`;`で終わります。

[式指向言語]: glossary.html#式指向言語

## コンパイルと実行は別の手順

「Rustのプログラムを書いて走らせる」で、新しく作ったプログラムをどうやって実行するか示しました。
それぞれを分解して手順毎に見ていきましょう。

Rustのプログラムを走らせる前に、コンパイルする必要があります。
Rustのコンパイラはこのように`rustc`と入力してソースファイルの名前を渡してあげることで使えます。

```bash
$ rustc main.rs
```

CまたはC++のバックグラウンドを持つならこれが`gcc`や`clang`に似ていことに気付くでしょう。
コンパイルが成功したら、Rustは実行可能バイナリを吐いている筈です。
LinuxかOSXなら以下のように`ls`コマンドで確認出来ます。


```bash
$ ls
main  main.rs
```

Windowsなら、こうなります。


```bash
$ dir
main.exe  main.rs
```

2つのファイルがあるといっています。`.rs`拡張子を持ったソースコードと実行可能ファイル(Windowsでは`main.exe`、それ以外では`main`)。
ここからあとは`main`または`main.exe`のファイルをこのように実行するだけです。


```bash
$ ./main  # あるいはWindowsならmain.exe
```

もし *main.rs* が「Hello, world!」プログラムなら、これで`Hello, world!`とターミナルに印字することでしょう。

もしRubyやPython、JavaScriptなどの動的な言語から来たのならコンパイルと実行が別の手順になっていることに馴れないでしょう。
Rustは、プログラムをコンパイルして、それを別の誰かに渡したら、Rustがなくても動く、 *事前コンパイル* 言語です。
他方別の誰かに`.rb`や`.py`、`.js`を渡したら(それぞれ)Ruby、PythonあるいはJavaScriptの実装が必要になりますが、コンパイルにも実行にも1つのコマンドで事足ります。
全ては言語設計上のトレードオフです。

単純なプログラムなら単に`rustc`でコンパイルすれば十分ですがプロジェクトが大きくなるにつれてプロジェクトの全てのオプションを管理したり他の人やプロジェクトと容易に共有出来るようにしたくなるでしょう。
次は現実世界のRustプログラムを書く手助けになるCargoというツールを紹介します。

# Hello, Cargo!

CargoはRustのビルドシステムであり、パッケージマネージャでありRustaceanはCargoをRustプロジェクトの管理にも使います。
Cargoは3つのものを管理します、則ち、コードのビルド、コードが依存するライブラリのダウンロード、そしてそれらのライブラリのビルド。
それに依存するのでコードが必要とするライブラリを「依存」と呼びます。

最も簡単なRustのプログラムは依存を持たないのでここではCargoの1つめの機能だけを使います。
もっと複雑なRustのコードを書くにつれて、依存を追加したくなるでしょうが、Cargoを使えばそれがとても簡単に出来ます。

ほとんどもほとんどのRustのプロジェクトがCargoを使うのでこれ以後はCargoを使うものと仮定します。
公式のインストーラを使ったならCargoはRustに同梱されています。
他の手段でRustをインストールしたなら、以下のコマンドでCargoがインストールされているか確認出来ます。

```bash
$ cargo --version
```

バージョン番号を確認出来たなら、良かった！「`コマンドが見つかりません`」などのエラーが出たなら
Rustをインストールしたシステムのドキュメントを見て、Cargoが別になっているか判断しましょう。


## Corgoへ変換する

Hello WorldプログラムをCargoに変換しましょう。
プロジェクトをCargo化するには3つのことをする必要があります。

1. ソースファイルを正しいディレクトリに置く
2. 古い実行可能ファイル(Windowsなら`main.exe`、他では`main`)を消し、新しいものを作る
3. Cargoの設定ファイルを作る

やっていきましょう!

### 新しい実行可能ファイルとソースディレクトリを作る

まず、ターミナルに戻って、 *hello_world* ディレクトリに行き、次のコマンドを打ちます。

```bash
$ mkdir src
$ mv main.rs src/main.rs
$ rm main  # Windowsなら'del main.exe'になります
```

Cargoはソースファイルが *src* ディレクトリにあるものとして動くので、まずそうしましょう。
READMEやライセンス情報、他のコードに関係ないものはプロジェクト(このケースでは *hello_world*)直下に残したままになります。
こうすることでCargoを使えばプロジェクトを綺麗に整頓された状態を保てます。
すべてのものには場所があり、すべてが自身の場所に収まります。

では、 *main.rs* を *src* ディレクトリにコピーして、`rustc`でコンパイルして作ったファイルを削除します。
これまで通り、Windowsなら`main`を`main.exe`に読み替えて下さい。

今回の例では実行可能ファイルを作るので`main.rs`の名前を引き続き使います。
もしライブラリを作りたいなら`lib.rs`という名前にすることになります。
この規約はCargoでプロジェクトを正しくコンパイルするのに使われていますが、望むなら上書きすることも出来ます。


### 設定ファイルを作る

次に、 *hello_world* ディレクトリ下にファイルを作ります。それを`Cargo.toml`とします。

ちゃんと`Cargo.toml`の`C`が大文字になっていることを確認しましょう、そうしないとCargoが設定ファイルと認識出来なくなります。

このファイルは *[TOML]* (Tom's Obvious, Minimal Language ([訳注] Tomの理解しやすい、極小な言語) ) フォーマットで書かれます。
TOMLはINIに似ていますがいくつかの素晴しい機能が追加されていて、Cargoの設定フォーマットとして使わています。

[TOML]: https://github.com/toml-lang/toml

ファイル内に以下の情報を打ち込みます。


```toml
[package]

name = "hello_world"
version = "0.0.1"
authors = [ "あなたの名前 <you@example.com>" ]
```

最初の行、`[package]`は下に続く記述がパッケージの設定であることを示します。
さらなる情報をこのファイルに追加する時には他のセクションを追加することになりますが、今のところパッケージの設定しかしていません。

残りの3行はCargoがプログラムをコンパイルする時に必要な情報です。プログラムの名前、バージョン、そして著者です。

これらの情報を *Cargo.toml* ファイルに追加し終わったら、保存して設定ファイルの作成は終了です。

## Cargoプロジェクトのビルドと実行

*Cargo.toml* をプロジェクトのルートディレクトリに置いたら、Hello Worldプログラムのビルドと実行の準備が整っている筈です!
以下のコマンドを入力しましょう。

```bash
$ cargo build
   Compiling hello_world v0.0.1 (file:///home/yourname/projects/hello_world)
$ ./target/debug/hello_world
Hello, world!
```

ババーン!全てが上手くいったら、もう一度`Hello, world!`がターミナルに印字される筈です。

`cargo build`でプロジェクトをビルドして`./target/debug/hello_world`でそれを実行したのですが、実は次のように`cargo run`一発でそれらを実行出来ます。

```bash
$ cargo run
     Running `target/debug/hello_world`
Hello, world!
```

この例でプロジェクトを再度ビルドしてないことに注意して下さい。
Cargoはファイルが変更されていないことが分かるのでバイナリの実行だけを行います。
ソースコードを修正していたら、Cargoは実行する前にプロジェクトを再度ビルドし、あなたはこのようなものを目にしたでしょう。

```bash
$ cargo run
   Compiling hello_world v0.0.1 (file:///home/yourname/projects/hello_world)
     Running `target/debug/hello_world`
Hello, world!
```

Cargoはプロジェクトのファイルのどれかが変更されていないか確認し、最後にビルドしてから変更されたファイルがあるときにだけプロジェクトを再度ビルドします。

単純なプロジェクトではCargoを使っても単に`rustc`を使うのとさほど変わないでしょうが将来において役に立つでしょう。
特に、他の言語に於ける「library」や「package」にあたる、クレートを使い始めた時によく当て嵌ります。
複数のクレートで構成された複雑なプロジェクトではCargoにビルドを任せた方がとても簡単になります。
Cargoを使えば`cargo build`を実行するだけで正しく動いてくれます。

## リリースビルド

最終的にプロジェクトのリリース準備が整ったら`cargo build --release`を使うことで最適化を掛けてプロジェクトをコンパイル出来ます。
最適化を掛けることでRustのコードは速くなりますが、コンパイル時間は長くなります。
こういう訳で、開発向けとユーザへ配布する最終版プログラムを作る時向けの2つの違うプロファイルが存在するのです。

このコマンドを走らせると *Cargo.lock* という新しいファイルも出来ます。
それの中身はこのようになっています。


```toml
[root]
name = "hello_world"
version = "0.0.1"
```

Cargoは *Cargo.lock* でアプリケーションの依存を追跡します。
これはHello Worldプロジェクトの *Cargo.lock* ファイルです。
このプロジェクトは依存を持たないのでファイルの中身はほとんどありません。
実際には自身でこのファイルに触ることはありません。Cargoに任せてしまいます。

出来ました!ここまでついて来たならCargoで`hello_world`をビルドする所まで出来た筈です。

このプロジェクトはとてもシンプルですがこれからRustを使っていく上で実際に使うことになるツール類を色々使っています。
実際、事実上全てのRustプロジェクトで以下のコマンドの変形を使うことになります。

```bash
$ git clone someurl.com/foo
$ cd foo
$ cargo build
```

## 新たなCargoプロジェクを作る簡単な方法

新たなプロジェクトを始めるのに先の手順を毎回踏む必要はありません!
Cargoで即座に開発を始められる骨組だけのプロジェクトを素早く作ることが出来ます。

Cargoで新たなプロジェクトを始めるには、`cargo new`をコマンドラインに入力します。

```bash
$ cargo new hello_world --bin
```

ライブラリではなく実行可能アプリケーションを作りたいのでこのコマンドは`--bin`を渡しています。
実行可能ファイルはよく *バイナリ* と呼ばれます(なのでUnixシステムでは`/usr/bin/`に入っています)。

Cargoは2つのファイルと1つのディレクトリ、`Cargo.toml`と *main.rs* の入った *src* ディレクトリを生成します。
上で作ったのと全く同じ、見たことのある構成ですね。

これさえあれば始められます。まず、`Cargo.toml`を開きます。このようになっている筈です。

```toml
[package]

name = "hello_world"
version = "0.1.0"
authors = ["あなたの名前 <you@example.com>"]
```

Cargoは引数と`git`の設定を基に *Cargo.toml* に適当な値を埋めます。
Cargoが`hello_world`ディレクトリを`git`レポジトリとして初期化していることにも気付くでしょう。

Here’s what should be in `src/main.rs`:

`src/main.rs`の中身はこのようになっている筈です。

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargoが「Hello World!」を生成したのでコードを書き始められます!

> 留意: Cargoについて詳しく見たいなら、公式の[Cargoガイド]を見ましょう。全ての機能が網羅してあります。

[Cargoガイド]: http://doc.crates.io/guide.html

# 終わりに

この章はこれ以後の本書、そしてあなたがRustを書いていく上で役に立つ基本を扱いました。
ツールについては一歩踏み出したのでRust言語自体を扱っていきます。

2つの選択肢があります。
[Rustを学ぶ][learnrust]でプロジェクトをやるか、[シンタックスとセマンティクス][syntax]で下から進んでいくかです。
経験豊富なシステムプログラマなら「Rustを学ぶ」が好みでしょうが、動的なバックグラウンドを持つ人なら他方が馴染むでしょう。
違う人同士違う学び方をするのです!自分に合ったものを選びましょう。


[learnrust]: learn-rust.html
[syntax]: syntax-and-semantics.html
