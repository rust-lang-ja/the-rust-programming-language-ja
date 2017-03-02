% Unsafe

<!-- Rust’s main draw is its powerful static guarantees about behavior. But safety -->
<!-- checks are conservative by nature: there are some programs that are actually -->
<!-- safe, but the compiler is not able to verify this is true. To write these kinds -->
<!-- of programs, we need to tell the compiler to relax its restrictions a bit. For -->
<!-- this, Rust has a keyword, `unsafe`. Code using `unsafe` has less restrictions -->
<!-- than normal code does. -->
Rustの主たる魅力は、プログラムの動作についての強力で静的な保証です。
しかしながら、安全性検査は本来保守的なものです。
すなわち、実際には安全なのに、そのことがコンパイラには検証できないプログラムがいくらか存在します。
その類のプログラムを書くためには、制約を少し緩和するようコンパイラに対して伝えることが要ります。
そのために、Rustには `unsafe` というキーワードがあります。
`unsafe` を使ったコードは、普通のコードよりも制約が少なくなります。

<!-- Let’s go over the syntax, and then we’ll talk semantics. `unsafe` is used in -->
<!-- four contexts. The first one is to mark a function as unsafe:  -->
まずシンタックスをみて、それからセマンティクスについて話しましょう。
`unsafe` は4つの場面で使われます。
1つめは、関数がアンセーフであることを印付ける場合です。

```rust
unsafe fn danger_will_robinson() {
#    // scary stuff
    // 恐ろしいもの
}
```

<!-- All functions called from [FFI][ffi] must be marked as `unsafe`, for example. -->
<!-- The second use of `unsafe` is an unsafe block: -->
たとえば、[FFI][ffi]から呼び出されるすべての関数は`unsafe`で印付けることが必要です。
`unsafe`の2つめの用途は、アンセーフブロックです。

[ffi]: ffi.html

```rust
unsafe {
#    // scary stuff
    // 恐ろしいもの
}
```

<!-- The third is for unsafe traits: -->
3つめは、アンセーフトレイトです。

```rust
unsafe trait Scary { }
```

<!-- And the fourth is for `impl`ementing one of those traits: -->
そして、4つめは、そのアンセーフトレイトを実装する場合です。

```rust
# unsafe trait Scary { }
unsafe impl Scary for i32 {}
```

<!-- It’s important to be able to explicitly delineate code that may have bugs that -->
<!-- cause big problems. If a Rust program segfaults, you can be sure it’s somewhere -->
<!-- in the sections marked `unsafe`. -->
大きな問題を引き起こすバグがあるかもしれないコードを明示できるのは重要なことです。
もしRustのプログラムがセグメンテーション違反を起こしても、バグは `unsafe` で印付けられた区間のどこかにあると確信できます。

<!-- # What does ‘safe’ mean? -->
# 「安全」とはどういう意味か?

<!-- Safe, in the context of Rust, means ‘doesn’t do anything unsafe’. It’s also -->
<!-- important to know that there are certain behaviors that are probably not -->
<!-- desirable in your code, but are expressly _not_ unsafe: -->
Rustの文脈で、安全とは「どのようなアンセーフなこともしない」ことを意味します。

> 訳注:
正確には、安全とは「決して未定義動作を起こさない」ということです。
そして、安全性が保証されていないことを「アンセーフ」と呼びます。
つまり、未定義動作が起きるおそれがあるなら、それはアンセーフです。

知っておくべき重要なことに、たいていのコードにおいて望ましくないが、アンセーフ _ではない_ とされている動作がいくらか存在するということがあります。

<!-- * Deadlocks -->
<!-- * Leaks of memory or other resources -->
<!-- * Exiting without calling destructors -->
<!-- * Integer overflow -->
* デッドロック
* メモリやその他のリソースのリーク
* デストラクタを呼び出さないプログラム終了
* 整数オーバーフロー

<!-- Rust cannot prevent all kinds of software problems. Buggy code can and will be -->
<!-- written in Rust. These things aren’t great, but they don’t qualify as `unsafe` -->
<!-- specifically. -->
Rustはソフトウェアが抱えるすべての種類の問題を防げるわけではありません。
Rustでバグのあるコードを書くことはできますし、実際に書かれるでしょう。
これらの動作は良いことではありませんが、特にアンセーフだとは見なされません。

<!-- In addition, the following are all undefined behaviors in Rust, and must be -->
<!-- avoided, even when writing `unsafe` code: -->
さらに、Rustにおいては、次のものは未定義動作で、 `unsafe` コード中であっても、避ける必要があります。

> 訳注:
> 関数に付いている`unsafe`は「その関数の処理はアンセーフである」ということを表します。
> その一方で、ブロックに付いている`unsafe`は「ブロック中の個々の操作はアンセーフだが、全体としては安全な処理である」ということを表します。
> 避ける必要があるのは、未定義動作が起こりうる処理をアンセーフブロックの中に書くことです。
> それは、アンセーフブロックの処理が安全であるために、その内部で未定義動作が決して起こらないことが必要だからです。
> アンセーフ関数には安全性の保証が要らないので、未定義動作が起こりうるアンセーフ関数を定義することに問題はありません。

<!-- * Data races -->
<!-- * Dereferencing a null/dangling raw pointer -->
<!-- * Reads of [undef][undef] (uninitialized) memory -->
<!-- * Breaking the [pointer aliasing rules][aliasing] with raw pointers. -->
<!-- * `&mut T` and `&T` follow LLVM’s scoped [noalias][noalias] model, except if -->
<!--   the `&T` contains an `UnsafeCell<U>`. Unsafe code must not violate these -->
<!--   aliasing guarantees. -->
<!-- * Mutating an immutable value/reference without `UnsafeCell<U>` -->
<!-- * Invoking undefined behavior via compiler intrinsics: -->
<!--   * Indexing outside of the bounds of an object with `std::ptr::offset` -->
<!--     (`offset` intrinsic), with -->
<!--     the exception of one byte past the end which is permitted. -->
<!--   * Using `std::ptr::copy_nonoverlapping_memory` (`memcpy32`/`memcpy64` -->
<!--     intrinsics) on overlapping buffers -->
<!-- * Invalid values in primitive types, even in private fields/locals: -->
<!--   * Null/dangling references or boxes -->
<!--   * A value other than `false` (0) or `true` (1) in a `bool` -->
<!--   * A discriminant in an `enum` not included in its type definition -->
<!--   * A value in a `char` which is a surrogate or above `char::MAX` -->
<!--   * Non-UTF-8 byte sequences in a `str` -->
<!-- * Unwinding into Rust from foreign code or unwinding from Rust into foreign -->
<!--   code. -->
* データ競合
* ヌル・ダングリング生ポインタの参照外し
* [undef][undef] （未初期化）メモリの読み出し
* 生ポインタによる [pointer aliasing rules][aliasing] の違反
* `&mut T` と `&T` は、 `UnsafeCell<U>` を含む `&T` を除き、LLVMのスコープ化された [noalias][noalias] モデルに従っています。
  アンセーフコードは、それら参照のエイリアシング保証を破ってはいけません。
* `UnsafeCell<U>` を持たないイミュータブルな値・参照の変更
* コンパイラIntrinsic経由の未定義挙動の呼び出し
  * `std::ptr::offset` (`offset` intrinsic) を使って、オブジェクトの範囲外を指すこと。
    ただし、オブジェクトの最後より1バイト後を指すことは許されている。
  * 範囲の重なったバッファに対して `std::ptr::copy_nonoverlapping_memory` (`memcpy32`/`memcpy64`
    intrinsics) を使う
* プリミティブ型の不正な値（プライベートなフィールドやローカル変数を含む）
  * ヌルかダングリングである参照やボックス
  * `bool` における、 `false` (0) か `true` (1) でない値
  * `enum` の定義に含まれていない判別子
  * `char` における、サロゲートか `char::MAX` を超えた値
  * `str` における、UTF-8でないバイト列
* 他言語からRustへの巻き戻しや、Rustから他言語への巻き戻し

[noalias]: http://llvm.org/docs/LangRef.html#noalias
[undef]: http://llvm.org/docs/LangRef.html#undefined-values
[aliasing]: http://llvm.org/docs/LangRef.html#pointer-aliasing-rules

<!-- # Unsafe Superpowers -->
# アンセーフの能力

<!-- In both unsafe functions and unsafe blocks, Rust will let you do three things -->
<!-- that you normally can not do. Just three. Here they are: -->
アンセーフ関数・アンセーフブロックでは、Rustは普段できない3つのことをさせてくれます。
たった3つです。それは、

<!-- 1. Access or update a [static mutable variable][static]. -->
<!-- 2. Dereference a raw pointer. -->
<!-- 3. Call unsafe functions. This is the most powerful ability. -->
1. [静的ミュータブル変数][static]のアクセスとアップデート。
2. 生ポインタの参照外し。
3. アンセーフ関数の呼び出し。これが最も強力な能力です。

<!-- That’s it. It’s important that `unsafe` does not, for example, ‘turn off the -->
<!-- borrow checker’. Adding `unsafe` to some random Rust code doesn’t change its -->
<!-- semantics, it won’t just start accepting anything. But it will let you write -->
<!-- things that _do_ break some of the rules. -->
以上です。
重要なのは、 `unsafe` が、たとえば「借用チェッカをオフにする」といったことを行わないことです。
Rustのコードの適当な位置に `unsafe` を加えてもセマンティクスは変わらず、何でもただ受理するようになるということにはなりません。
それでも、`unsafe` はルールのいくつかを破るコードを書けるようにはするのです。

<!-- You will also encounter the `unsafe` keyword when writing bindings to foreign -->
<!-- (non-Rust) interfaces. You're encouraged to write a safe, native Rust interface -->
<!-- around the methods provided by the library. -->
また、`unsafe` キーワードは、Rust以外の言語とのインターフェースを書くときに遭遇するでしょう。
ライブラリの提供するメソッドの周りに、安全な、Rustネイティブのインターフェースを書くことが推奨されています。

<!-- Let’s go over the basic three abilities listed, in order. -->
これから、その基本的な3つの能力を順番に見ていきましょう。

<!-- ## Access or update a `static mut` -->
## `static mut` のアクセスとアップデート。

<!-- Rust has a feature called ‘`static mut`’ which allows for mutable global state. -->
<!-- Doing so can cause a data race, and as such is inherently not safe. For more -->
<!-- details, see the [static][static] section of the book. -->
Rustには「`static mut`」という、ミュータブルでグローバルな状態を実現する機能があります。
これを使うことはデータレースが起こるおそれがあるので、本質的に安全ではありません。
詳細は、この本の[static][static]セクションを参照してください。

[static]: const-and-static.html#static

<!-- ## Dereference a raw pointer -->
## 生ポインタの参照外し

<!-- Raw pointers let you do arbitrary pointer arithmetic, and can cause a number of -->
<!-- different memory safety and security issues. In some senses, the ability to -->
<!-- dereference an arbitrary pointer is one of the most dangerous things you can -->
<!-- do. For more on raw pointers, see [their section of the book][rawpointers]. -->
生ポインタによって任意のポインタ演算が可能になりますが、いくつもの異なるメモリ安全とセキュリティの問題が起こるおそれがあります。
ある意味で、任意のポインタを参照外しする能力は行いうる操作のうち最も危険なもののひとつです。
詳細は、[この本の生ポインタに関するセクション][rawpointers]を参照してください。

[rawpointers]: raw-pointers.html

<!-- ## Call unsafe functions -->
## アンセーフ関数の呼び出し

<!-- This last ability works with both aspects of `unsafe`: you can only call -->
<!-- functions marked `unsafe` from inside an unsafe block. -->
この最後の能力は、`unsafe`の両面とともに働きます。
すなわち、`unsafe`で印付けられた関数は、アンセーフブロックの内部からのみ呼び出すことができます。

<!-- This ability is powerful and varied. Rust exposes some [compiler -->
<!-- intrinsics][intrinsics] as unsafe functions, and some unsafe functions bypass -->
<!-- safety checks, trading safety for speed. -->
この能力は強力で多彩です。
Rustはいくらかの[compiler intrinsics][intrinsics]をアンセーフ関数として公開しており、また、いくつかのアンセーフ関数は安全性検査を回避することで、安全性とスピードを引き換えています。

<!-- I’ll repeat again: even though you _can_ do arbitrary things in unsafe blocks -->
<!-- and functions doesn’t mean you should. The compiler will act as though you’re -->
<!-- upholding its invariants, so be careful! -->
繰り返しになりますが、アンセーフブロックと関数の内部で任意のことが _できる_ としても、それをすべきだということを意味しません。
コンパイラは、あなたが不変量を守っているかのように動作しますから、注意してください！

[intrinsics]: intrinsics.html
