% Nightly Rust
<!-- % Nightly Rust -->

<!-- Rust provides three distribution channels for Rust: nightly, beta, and stable. -->
<!-- Unstable features are only available on nightly Rust. For more details on this -->
<!-- process, see ‘[Stability as a deliverable][stability]’. -->
Rustにはnightly、beta、stableという3種類の配布用チャンネルがあります。不安定なフィーチャはnightlyのRustでのみ使えます。詳細は「 [配布物の安定性][stability] 」をご覧ください。

[stability]: http://blog.rust-lang.org/2014/10/30/Stability.html

<!-- To install nightly Rust, you can use `rustup.sh`: -->
nightlyのRustをインストールするには `rustup.sh` を使って以下のようにします。

```bash
$ curl -s https://static.rust-lang.org/rustup.sh | sh -s -- --channel=nightly
```

<!-- If you're concerned about the [potential insecurity][insecurity] of using `curl -->
<!-- | sh`, please keep reading and see our disclaimer below. And feel free to -->
<!-- use a two-step version of the installation and examine our installation script: -->
もし `curl | sh` の使用による [潜在的な危険性][insecurity] を気にする場合は、以下に免責条項がありますので読み進めてください。また、以下のように2段階のインストール方法を用い、インストールスクリプトを精査しても構いません。

```bash
$ curl -f -L https://static.rust-lang.org/rustup.sh -O
$ sh rustup.sh --channel=nightly
```

[insecurity]: http://curlpipesh.tumblr.com

<!-- If you're on Windows, please download either the [32-bit installer][win32] or -->
<!-- the [64-bit installer][win64] and run it. -->
Windowsの場合は [32bit版インストーラ][win32] あるいは [64bit版インストーラ][win64] をダウンロードして実行してください。

[win32]: https://static.rust-lang.org/dist/rust-nightly-i686-pc-windows-gnu.msi
[win64]: https://static.rust-lang.org/dist/rust-nightly-x86_64-pc-windows-gnu.msi

<!-- ## Uninstalling -->
## アンインストール

<!-- If you decide you don't want Rust anymore, we'll be a bit sad, but that's okay. -->
<!-- Not every programming language is great for everyone. Just run the uninstall -->
<!-- script: -->
もしRustが不要だと判断した場合、残念ですが仕方がありません。万人に気に入られるプログラミング言語ばかりとは限らないのです。アンインストールするには以下を実行します。

```bash
$ sudo /usr/local/lib/rustlib/uninstall.sh
```

<!-- If you used the Windows installer, just re-run the `.msi` and it will give you -->
<!-- an uninstall option. -->
Windows用のインストーラを使用した場合は、 `.msi` を再実行しアンインストールオプションを選択してください。

<!-- Some people, and somewhat rightfully so, get very upset when we tell you to -->
<!-- `curl | sh`. Basically, when you do this, you are trusting that the good -->
<!-- people who maintain Rust aren't going to hack your computer and do bad things. -->
<!-- That's a good instinct! If you're one of those people, please check out the -->
<!-- documentation on [building Rust from Source][from-source], or [the official -->
<!-- binary downloads][install-page]. -->
`curl | sh` を行うように書いたことについて、(当然のことですが)戸惑った方がいるかもしれません。基本的に `curl | sh` を行うということは、Rustをメンテナンスしている善良な人々がコンピュータのハッキングなど何か悪いことをしたりしないと信用する、ということです。ですので戸惑った方はよい直感を持っているといえます。そのような方は [ソースコードからのRustビルド][from-source] あるいは [公式バイナリのダウンロード][install-page] を確認してください。

[from-source]: https://github.com/rust-lang/rust#building-from-source
[install-page]: https://www.rust-lang.org/install.html

<!-- Oh, we should also mention the officially supported platforms: -->
ここで公式にサポートするプラットフォームについても述べておきます。

<!-- * Windows (7, 8, Server 2008 R2) -->
<!-- * Linux (2.6.18 or later, various distributions), x86 and x86-64 -->
<!-- * OSX 10.7 (Lion) or greater, x86 and x86-64 -->
* Windows (7、8、Server 2008 R2)
* Linux (2.6.18以上の様々なディストリビューション)、x86 及び x86-64
* OSX 10.7 (Lion)以上、x86 及び x86-64

<!-- We extensively test Rust on these platforms, and a few others, too, like -->
<!-- Android. But these are the ones most likely to work, as they have the most -->
<!-- testing. -->
Rustではこれらのプラットフォームの他、Androidなどいくつかのプラットフォームについても幅広いテストが行われています。しかし、テストが行われているということは、ほとんどの場合動くだろう、ということに過ぎません。

<!-- Finally, a comment about Windows. Rust considers Windows to be a first-class -->
<!-- platform upon release, but if we're honest, the Windows experience isn't as -->
<!-- integrated as the Linux/OS X experience is. We're working on it! If anything -->
<!-- does not work, it is a bug. Please let us know if that happens. Each and every -->
<!-- commit is tested against Windows just like any other platform. -->
最後にWindowsについて述べておきます。RustはWindowsをリリースする上での1級プラットフォームだと考えています。しかし、正直なところ、Windowsでの使い勝手はLinux/OS Xのそれと同等というわけではありません。(そうなるように努力しています!) もしうまく動かないことがあれば、それはバグですのでお知らせください。全てのコミットは他のプラットフォームと同様にWindowsに対してもテストされています。

<!-- If you've got Rust installed, you can open up a shell, and type this: -->
Rustのインストールが終われば、シェルを開いて以下のように入力してください。

```bash
$ rustc --version
```

<!-- You should see the version number, commit hash, commit date and build date: -->
バージョン番号、コミットハッシュ、コミット日時、ビルド日時が表示されるはずです。

```bash
rustc 1.0.0-nightly (f11f3e7ba 2015-01-04) (built 2015-01-06)
```

<!-- If you did, Rust has been installed successfully! Congrats! -->
これでRustのインストールはうまくいきました!おめでとう!

<!-- This installer also installs a copy of the documentation locally, so you can -->
<!-- read it offline. On UNIX systems, `/usr/local/share/doc/rust` is the location. -->
<!-- On Windows, it's in a `share/doc` directory, inside wherever you installed Rust -->
<!-- to. -->
インストーラはドキュメントのローカルコピーもインストールするので、オフラインでも読むことが出来ます。UNIXシステムでは `/usr/local/share/doc/rust` に、WindowsではRustをインストールしたディレクトリの `share\doc` ディレクトリに配置されます。

<!-- If not, there are a number of places where you can get help. The easiest is -->
<!-- [the #rust IRC channel on irc.mozilla.org][irc], which you can access through -->
<!-- [Mibbit][mibbit]. Click that link, and you'll be chatting with other Rustaceans -->
<!-- (a silly nickname we call ourselves), and we can help you out. Other great -->
<!-- resources include [the user’s forum][users], and [Stack Overflow][stackoverflow]. -->
もし上手くいかないなら様々な場所で助けを得られます。最も簡単なのは[Mibbit][mibbit]からアクセス出来る[irc.mozilla.orgにある#rustチャネル][irc]です。リンクをクリックしたら他の助けを求めれるRustacean達(我々のことをふざけてこう呼ぶのです)とチャット出来ます。他には[ユーザフォーラム][users]や[Stack Overflow][stackoverflow]などがあります。
[irc]: irc://irc.mozilla.org/#rust
[mibbit]: http://chat.mibbit.com/?server=irc.mozilla.org&channel=%23rust
[users]: https://users.rust-lang.org/
[stackoverflow]: http://stackoverflow.com/questions/tagged/rust
