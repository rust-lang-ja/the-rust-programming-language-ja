%No stdlib
<!-- % No stdlib -->

<!-- Rust’s standard library provides a lot of useful functionality, but assumes -->
<!-- support for various features of its host system: threads, networking, heap -->
<!-- allocation, and others. There are systems that do not have these features, -->
<!-- however, and Rust can work with those too! To do so, we tell Rust that we -->
<!-- don’t want to use the standard library via an attribute: `#![no_std]`. -->
Rustの標準ライブラリはたくさんの有用な機能を提供していますが、スレッド、ネットワーク、ヒープ割り当てなど、さまざまな機能についてホストシステムのサポートがあることを前提としています。しかし、それらの機能を持たないシステムは存在しますし、Rustはそういったシステム上でも動作します。そのためには、アトリビュート `#![no_std]` を使って標準ライブラリを使用しないことを示します。

<!-- > Note: This feature is technically stable, but there are some caveats. For -->
<!-- > one, you can build a `#![no_std]` _library_ on stable, but not a _binary_. -->
<!-- > For details on libraries without the standard library, see [the chapter on -->
<!-- > `#![no_std]`](using-rust-without-the-standard-library.html) -->
> 注記: このフィーチャは技術的には安定していますが、いくつかの注意点があります。例えば、 `#![no_std]` を含んだ _ライブラリ_ は安定版でビルドできますが、 _バイナリ_ はそうではありません。標準ライブラリを使用しないバイナリのついての詳細は [標準ライブラリ無しでRustを使う](using-rust-without-the-standard-library.html)

<!-- Obviously there's more to life than just libraries: one can use -->
<!-- `#[no_std]` with an executable, controlling the entry point is -->
<!-- possible in two ways: the `#[start]` attribute, or overriding the -->
<!-- default shim for the C `main` function with your own. -->
当然のことですが、ライブラリだけが全てではなく、実行可能形式においても `#[no_std]` は使用できます。このときエントリポイントを指定する方法は2種類あり、1つは `#[start]` アトリビュート、もう1つはCの `main` 関数の上書きです。

<!-- The function marked `#[start]` is passed the command line parameters -->
<!-- in the same format as C: -->
`#[start]` のついた関数へはCと同じフォーマットでコマンドライン引数が渡されます。

```rust
# #![feature(libc)]
#![feature(lang_items)]
#![feature(start)]
#![no_std]

# //// Pull in the system libc library for what crt0.o likely requires
// crt0.oが必要としていると思われるシステムのlibcライブラリを参照します。
extern crate libc;

# //// Entry point for this program
// このプログラムのエントリ・ポイントです
#[start]
fn start(_argc: isize, _argv: *const *const u8) -> isize {
    0
}

# //// These functions and traits are used by the compiler, but not
# //// for a bare-bones hello world. These are normally
# //// provided by libstd.
// これらの関数とトレイトは必要最小限のhello worldのようなプログラムが
// 使うのではなく、コンパイラが使います。通常これらはlibstdにより提供されます。
#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] fn panic_fmt() -> ! { loop {} }
# #[lang = "eh_unwind_resume"] extern fn rust_eh_unwind_resume() {}
# #[no_mangle] pub extern fn rust_eh_register_frames () {}
# #[no_mangle] pub extern fn rust_eh_unregister_frames () {}
# // fn main() {} tricked you, rustdoc!
```

<!-- To override the compiler-inserted `main` shim, one has to disable it -->
<!-- with `#![no_main]` and then create the appropriate symbol with the -->
<!-- correct ABI and the correct name, which requires overriding the -->
<!-- compiler's name mangling too: -->
コンパイラによって挿入される `main` を上書きするには、まず `#![no_main]` によってコンパイラによる挿入を無効にします。そのうえで、正しいABIとコンパイラの名前修飾を上書きするための正しい名前を備えた適切なシンボルを作成します。

```rust
# #![feature(libc)]
#![feature(lang_items)]
#![feature(start)]
#![no_std]
#![no_main]

extern crate libc;

# //#[no_mangle] // ensure that this symbol is called `main` in the output
#[no_mangle] // 出力結果においてこのシンボル名が `main` になることを保証します。

pub extern fn main(argc: i32, argv: *const *const u8) -> i32 {
    0
}

#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] fn panic_fmt() -> ! { loop {} }
# #[lang = "eh_unwind_resume"] extern fn rust_eh_unwind_resume() {}
# #[no_mangle] pub extern fn rust_eh_register_frames () {}
# #[no_mangle] pub extern fn rust_eh_unregister_frames () {}
# // fn main() {} tricked you, rustdoc!
```


<!-- The compiler currently makes a few assumptions about symbols which are available -->
<!-- in the executable to call. Normally these functions are provided by the standard -->
<!-- library, but without it you must define your own. -->
今のところ、コンパイラは実行可能形式においていくつかのシンボルが呼び出し可能であるという前提を置いています。通常、これらの関数は標準ライブラリが提供しますが、それを使わない場合自分で定義しなければなりません。

<!-- The first of these two functions, `eh_personality`, is used by the -->
<!-- failure mechanisms of the compiler. This is often mapped to GCC's -->
<!-- personality function (see the -->
<!-- [libstd implementation](../std/rt/unwind/index.html) for more -->
<!-- information), but crates which do not trigger a panic can be assured -->
<!-- that this function is never called. The second function, `panic_fmt`, is -->
<!-- also used by the failure mechanisms of the compiler. -->
2つある関数のうち1つ目は `eh_personality` で、コンパイラの失敗機構に使われます。これはしばしばGCCのpersonality関数に割り当てられますが（詳細は[libstd実装](../std/rt/unwind/index.html)を参照してください）、パニックを発生させないクレートではこの関数は呼ばれないことが保証されています。2つ目の関数は `panic_fmt` で、こちらもコンパイラの失敗機構のために使われます。
