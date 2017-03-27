% 条件付きコンパイル
<!-- % Conditional Compilation -->

<!-- Rust has a special attribute, `#[cfg]`, which allows you to compile code -->
<!-- based on a flag passed to the compiler. It has two forms: -->
Rustには `#[cfg]` という特別なアトリビュートがあり、
コンパイラに渡されたフラグに合わせてコードをコンパイルすることを可能にします。
`#[cfg]` アトリビュートは以下の2つの形式で利用することができます:

```rust
#[cfg(foo)]
# fn foo() {}

#[cfg(bar = "baz")]
# fn bar() {}
```

<!-- They also have some helpers: -->
また、以下の様なヘルパが存在します:

```rust
#[cfg(any(unix, windows))]
# fn foo() {}

#[cfg(all(unix, target_pointer_width = "32"))]
# fn bar() {}

#[cfg(not(foo))]
# fn not_foo() {}
```

<!-- These can nest arbitrarily: -->
ヘルパは以下のように自由にネストすることが可能です:

```rust
#[cfg(any(not(unix), all(target_os="macos", target_arch = "powerpc")))]
# fn foo() {}
```

<!-- As for how to enable or disable these switches, if you’re using Cargo, -->
<!-- they get set in the [`[features]` section][features] of your `Cargo.toml`: -->
このようなスイッチの有効・無効の切り替えはCargoを利用している場合 `Cargo.toml` 中の [`[features]` セクション][features] で設定できます。

[features]: http://doc.crates.io/manifest.html#the-features-section

```toml
[features]
# no features by default
default = []

# フィーチャ「secure-password」は bcrypt パッケージに依存しています
secure-password = ["bcrypt"]
```

<!-- When you do this, Cargo passes along a flag to `rustc`: -->
もしこのように設定した場合、Cargoは `rustc` に以下のようにフラグを渡します:

```text
--cfg feature="${feature_name}"
```

<!-- The sum of these `cfg` flags will determine which ones get activated, and -->
<!-- therefore, which code gets compiled. Let’s take this code: -->
渡されたすべての `cfg` フラグによってどのフラグが有効に成るか決定され、
それによってどのコードがコンパイルされるかも決定されます。以下のコードを見てみましょう:

```rust
#[cfg(feature = "foo")]
mod foo {
}
```

<!-- If we compile it with `cargo build --features "foo"`, it will send the `--cfg -->
<!-- feature="foo"` flag to `rustc`, and the output will have the `mod foo` in it. -->
<!-- If we compile it with a regular `cargo build`, no extra flags get passed on, -->
<!-- and so, no `foo` module will exist. -->
もしこのコードを `cargo build --features "foo"` としてコンパイルを行うと、
`--cfg features="foo"` が `rustc` に渡され、出力には `mod foo` が含まれます。
もし標準的な `cargo build` でコンパイルを行った場合、`rustc` に追加のフラグは渡されず `foo` モジュールは存在しない事になります。

# cfg_attr

<!-- You can also set another attribute based on a `cfg` variable with `cfg_attr`: -->
また、`cfg_attr` を用いることで、`cfg` に設定された値によってアトリビュートを有効にすることができます:

```rust
#[cfg_attr(a, b)]
# fn foo() {}
```

<!-- Will be the same as `#[b]` if `a` is set by `cfg` attribute, and nothing otherwise. -->
このようにすると、`cfg` アトリビュートによって `a` が有効になっている場合に限り `#[b]` と設定されている
場合と同じ効果が得られます。

# cfg!

<!-- The `cfg!` [syntax extension][compilerplugins] lets you use these kinds of flags -->
<!-- elsewhere in your code, too: -->
`cfg!` [拡張構文][compilerplugins] は以下のようにコード中でフラグを利用することを可能にします:

```rust
if cfg!(target_os = "macos") || cfg!(target_os = "ios") {
    println!("Think Different!");
}
```

[compilerplugins]: compiler-plugins.html

<!-- These will be replaced by a `true` or `false` at compile-time, depending on the -->
<!-- configuration settings. -->

このようなコードは設定に応じてコンパイル時に `true` または `false` に置き換えられます。
