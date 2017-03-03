% 標準ライブラリ無しでRustを使う
<!-- % Using Rust Without the Standard Library -->

<!-- Rust’s standard library provides a lot of useful functionality, but assumes -->
<!-- support for various features of its host system: threads, networking, heap -->
<!-- allocation, and others. There are systems that do not have these features, -->
<!-- however, and Rust can work with those too! To do so, we tell Rust that we -->
<!-- don’t want to use the standard library via an attribute: `#![no_std]`. -->
Rustの標準ライブラリは多くの便利な機能を提供している一方で、スレッド、ネットワーク、ヒープアロケーション、その他の多くの機能をホストシステムが提供していることを前提としています。
一方で、それらの機能を提供していないシステムも存在します。
しかし、Rustはそれらの上でも利用できます！
それは、Rustに標準ライブラリを利用しないということを `#![no_std]` アトリビュートを利用して伝えることで可能となります。

<!-- > Note: This feature is technically stable, but there are some caveats. For -->
<!-- > one, you can build a `#![no_std]` _library_ on stable, but not a _binary_. -->
<!-- > For details on binaries without the standard library, see [the nightly -->
<!-- > chapter on `#![no_std]`](no-stdlib.html) -->
> メモ: このフィーチャーは技術的には安定していますが、いくつか注意点があります。
> 例えば、 `#![no_std]` を含んだ _ライブラリ_ は 安定版でビルド可能ですが、 _バイナリ_ はビルド不可能です。
> 標準ライブラリを利用しないバイナリについては [`#![no_std]` についての不安定版のドキュメント](no-stdlib.html) を確認してください。

<!-- To use `#![no_std]`, add it to your crate root: -->
`#![no_std]` アトリビュートを利用するには、クレートのトップに以下のように追加します:

```rust
#![no_std]

fn plus_one(x: i32) -> i32 {
    x + 1
}
```

<!-- Much of the functionality that’s exposed in the standard library is also -->
<!-- available via the [`core` crate](../core/). When we’re using the standard -->
<!-- library, Rust automatically brings `std` into scope, allowing you to use -->
<!-- its features without an explicit import. By the same token, when using -->
<!-- `#![no_std]`, Rust will bring `core` into scope for you, as well as [its -->
<!-- prelude](../core/prelude/v1/). This means that a lot of code will Just Work: -->
標準ライブラリで提供されている多くの機能は [`core` クレート](../core/) を用いることでも利用できます。
標準ライブラリを利用しているとき、Rustは自動的に `std` をスコープに導入し、標準ライブラリの機能を明示的にインポートすること無しに利用可能にします。
それと同じように、もし `#![no_std]` を利用しているときは、Rustは自動的に `core` と [そのプレリュード](../core/prelude/v1/) をスコープに導入します。
これは、例えば多くの以下のようなコードが動作することを意味しています:

```rust
#![no_std]

fn may_fail(failure: bool) -> Result<(), &'static str> {
    if failure {
        Err("this didn’t work!")
    } else {
        Ok(())
    }
}
```
