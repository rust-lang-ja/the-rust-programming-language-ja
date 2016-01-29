% 高度なリンキング
<!-- % Advanced Linking -->

<!-- The common cases of linking with Rust have been covered earlier in this book, -->
<!-- but supporting the range of linking possibilities made available by other -->
<!-- languages is important for Rust to achieve seamless interaction with native -->
<!-- libraries. -->
Rustにおけるリンクの一般的なケースについては本書の前の方で説明しましたが、他言語から利用できるような幅広いリンクをサポートすることは、ネイティブライブラリとのシームレスな相互利用を実現するために、Rustにとって重要です。

<!-- # Link args -->
# リンク引数

<!-- There is one other way to tell `rustc` how to customize linking, and that is via -->
<!-- the `link_args` attribute. This attribute is applied to `extern` blocks and -->
<!-- specifies raw flags which need to get passed to the linker when producing an -->
<!-- artifact. An example usage would be: -->
どのようにリンクをカスタマイズするかを`rustc`に指示するために、1つの方法があります。それは、`link_args`アトリビュートを使うことです。
このアトリビュートは`extern`ブロックに適用され、生成物を作るときにリンカに渡したいフラグをそのまま指定します。
使い方の例は次のようになります。

``` no_run
#![feature(link_args)]

#[link_args = "-foo -bar -baz"]
extern {}
# fn main() {}
```

<!-- Note that this feature is currently hidden behind the `feature(link_args)` gate -->
<!-- because this is not a sanctioned way of performing linking. Right now `rustc` -->
<!-- shells out to the system linker (`gcc` on most systems, `link.exe` on MSVC), -->
<!-- so it makes sense to provide extra command line -->
<!-- arguments, but this will not always be the case. In the future `rustc` may use -->
<!-- LLVM directly to link native libraries, in which case `link_args` will have no -->
<!-- meaning. You can achieve the same effect as the `link_args` attribute with the -->
<!-- `-C link-args` argument to `rustc`. -->
これはリンクを実行するための認められた方法ではないため、この機能は現在`feature(link_args)`ゲートによって隠されているということに注意しましょう。
今は`rustc`がシステムリンカ（多くのシステムでは`gcc`、MSVCでは`link.exe`）に渡すので、追加のコマンドライン引数を提供することには意味がありますが、それが今後もそうだとは限りません。
将来、`rustc`がネイティブライブラリをリンクするためにLLVMを直接使うようになるかもしれませんし、そのような場合には`link_args`は意味がなくなるでしょう。
`rustc`に`-C link-args`引数をつけることで、`link_args`アトリビュートと同じような効果を得ることができます。

<!-- It is highly recommended to *not* use this attribute, and rather use the more -->
<!-- formal `#[link(...)]` attribute on `extern` blocks instead. -->
このアトリビュートは使わ *ない* ことが強く推奨されているので、代わりにもっと正式な`#[link(...)]`アトリビュートを`extern`ブロックに使いましょう。

<!-- # Static linking -->
# スタティックリンク

<!-- Static linking refers to the process of creating output that contains all -->
<!-- required libraries and so doesn't need libraries installed on every system where -->
<!-- you want to use your compiled project. Pure-Rust dependencies are statically -->
<!-- linked by default so you can use created binaries and libraries without -->
<!-- installing Rust everywhere. By contrast, native libraries -->
<!-- (e.g. `libc` and `libm`) are usually dynamically linked, but it is possible to -->
<!-- change this and statically link them as well. -->
スタティックリンクとは全ての必要なライブラリを含めた成果物を生成する手順のことで、そうすればコンパイルされたプロジェクトを使いたいシステム全てにライブラリをインストールする必要がなくなります。
Rustのみで構築された依存関係はデフォルトでスタティックリンクされます。そのため、Rustをインストールしなくても、作成されたバイナリやライブラリを使うことができます。
対照的に、ネイティブライブラリ（例えば`libc`や`libm`）はダイナミックリンクされるのが普通です。しかし、これを変更してそれらを同様にスタティックリンクすることも可能です。

<!-- Linking is a very platform-dependent topic, and static linking may not even be -->
<!-- possible on some platforms! This section assumes some basic familiarity with -->
<!-- linking on your platform of choice. -->
リンクは非常にプラットフォームに依存した話題であり、スタティックリンクのできないプラットフォームすらあるかもしれません!
このセクションは選んだプラットフォームにおけるリンクについての基本が理解できていることを前提とします。

<!-- ## Linux -->
## Linux

<!-- By default, all Rust programs on Linux will link to the system `libc` along with -->
<!-- a number of other libraries. Let's look at an example on a 64-bit Linux machine -->
<!-- with GCC and `glibc` (by far the most common `libc` on Linux): -->
デフォルトでは、Linux上の全てのRustのプログラムはシステムの`libc`とその他のいくつものライブラリとリンクされます。
GCCと`glibc`（Linuxにおける最も一般的な`libc`）を使った64ビットLinuxマシンでの例を見てみましょう。

``` text
$ cat example.rs
fn main() {}
$ rustc example.rs
$ ldd example
        linux-vdso.so.1 =>  (0x00007ffd565fd000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fa81889c000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fa81867e000)
        librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007fa818475000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fa81825f000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fa817e9a000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fa818cf9000)
        libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fa817b93000)
```

<!-- Dynamic linking on Linux can be undesirable if you wish to use new library -->
<!-- features on old systems or target systems which do not have the required -->
<!-- dependencies for your program to run. -->
古いシステムで新しいライブラリの機能を使いたいときや、実行するプログラムに必要な依存関係を満たさないシステムをターゲットにしたいときは、Linuxにおけるダイナミックリンクは望ましくないかもしれません。

<!-- Static linking is supported via an alternative `libc`, [`musl`](http://www.musl-libc.org). You can compile -->
<!-- your own version of Rust with `musl` enabled and install it into a custom -->
<!-- directory with the instructions below: -->
スタティックリンクは代わりの`libc`である[`musl`](http://www.musl-libc.org/)によってサポートされています。
以下の手順に従い、`musl`を有効にした独自バージョンのRustをコンパイルして独自のディレクトリにインストールすることができます。

```text
$ mkdir musldist
$ PREFIX=$(pwd)/musldist
$
$ # Build musl
$ curl -O http://www.musl-libc.org/releases/musl-1.1.10.tar.gz
$ tar xf musl-1.1.10.tar.gz
$ cd musl-1.1.10/
musl-1.1.10 $ ./configure --disable-shared --prefix=$PREFIX
musl-1.1.10 $ make
musl-1.1.10 $ make install
musl-1.1.10 $ cd ..
$ du -h musldist/lib/libc.a
2.2M    musldist/lib/libc.a
$
$ # Build libunwind.a
$ curl -O http://llvm.org/releases/3.7.0/llvm-3.7.0.src.tar.xz
$ tar xf llvm-3.7.0.src.tar.xz
$ cd llvm-3.7.0.src/projects/
llvm-3.7.0.src/projects $ curl http://llvm.org/releases/3.7.0/libunwind-3.7.0.src.tar.xz | tar xJf -
llvm-3.7.0.src/projects $ mv libunwind-3.7.0.src libunwind
llvm-3.7.0.src/projects $ mkdir libunwind/build
llvm-3.7.0.src/projects $ cd libunwind/build
llvm-3.7.0.src/projects/libunwind/build $ cmake -DLLVM_PATH=../../.. -DLIBUNWIND_ENABLE_SHARED=0 ..
llvm-3.7.0.src/projects/libunwind/build $ make
llvm-3.7.0.src/projects/libunwind/build $ cp lib/libunwind.a $PREFIX/lib/
llvm-3.7.0.src/projects/libunwind/build $ cd ../../../../
$ du -h musldist/lib/libunwind.a
164K    musldist/lib/libunwind.a
$
$ # Build musl-enabled rust
$ git clone https://github.com/rust-lang/rust.git muslrust
$ cd muslrust
muslrust $ ./configure --target=x86_64-unknown-linux-musl --musl-root=$PREFIX --prefix=$PREFIX
muslrust $ make
muslrust $ make install
muslrust $ cd ..
$ du -h musldist/bin/rustc
12K     musldist/bin/rustc
```

<!-- You now have a build of a `musl`-enabled Rust! Because we've installed it to a -->
<!-- custom prefix we need to make sure our system can find the binaries and appropriate -->
<!-- libraries when we try and run it: -->
これで`musl`が有効になったRustのビルドが手に入りました!
独自のプレフィックスを付けてインストールしたので、試しに実行するときにはシステムがバイナリと適切なライブラリを見付けられることを確かめなければなりません。

```text
$ export PATH=$PREFIX/bin:$PATH
$ export LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
```

<!-- Let's try it out! -->
試してみましょう!

```text
$ echo 'fn main() { println!("hi!"); panic!("failed"); }' > example.rs
$ rustc --target=x86_64-unknown-linux-musl example.rs
$ ldd example
        not a dynamic executable
$ ./example
hi!
thread '<main>' panicked at 'failed', example.rs:1
```

<!-- Success! This binary can be copied to almost any Linux machine with the same -->
<!-- machine architecture and run without issues. -->
成功しました!
このバイナリは同じマシンアーキテクチャであればほとんど全てのLinuxマシンにコピーして問題なく実行することができます。

<!-- `cargo build` also permits the `--target` option so you should be able to build -->
<!-- your crates as normal. However, you may need to recompile your native libraries -->
<!-- against `musl` before they can be linked against. -->
`cargo build`も`--target`オプションを受け付けるので、あなたのクレートも普通にビルドできるはずです。
ただし、リンクする前にネイティブライブラリを`musl`向けにリコンパイルする必要はあるかもしれません。
