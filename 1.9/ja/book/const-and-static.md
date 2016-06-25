% `const` と `static`
<!-- % `const` and `static` -->

<!-- Rust has a way of defining constants with the `const` keyword: -->
Rustでは `const` を用いることで定数を定義できます:

```rust
const N: i32 = 5;
```

<!-- Unlike [`let`][let] bindings, you must annotate the type of a `const`. -->
[`let`][let] による束縛とは異なり、`const` を用いるときは型を明示する必要があります。

[let]: variable-bindings.html

<!-- Constants live for the entire lifetime of a program. More specifically, -->
<!-- constants in Rust have no fixed address in memory. This is because they’re -->
<!-- effectively inlined to each place that they’re used. References to the same -->
<!-- constant are not necessarily guaranteed to refer to the same memory address for -->
<!-- this reason. -->
定数はプログラム全体のライフタイムの間生きています。
さらに言えば、Rustプログラム中で定数はメモリ中に固定のアドレスを持ちません。
これは定数が利用されている時にそれらが効率的にインライン化されるためです。
このため、同じ定数への参照が必ずしも同じアドレスを指しているとは保証されません。

# `static`

<!-- Rust provides a ‘global variable’ sort of facility in static items. They’re -->
<!-- similar to constants, but static items aren’t inlined upon use. This means that -->
<!-- there is only one instance for each value, and it’s at a fixed location in -->
<!-- memory. -->
Rustは「グローバル変数」と呼ばれる静的アイテムを提供します。
「グローバル変数」は定数と似ていますが、静的アイテムは使用にあたってインライン化は行われません。
これは、「グローバル変数」にはそれぞれに対しただひとつのインスタンスのみが存在することを意味し、
メモリ上に固定の位置を持つことになります。

<!-- Here’s an example: -->
以下に例を示します:

```rust
static N: i32 = 5;
```

<!-- Unlike [`let`][let] bindings, you must annotate the type of a `static`. -->
[`let`][let] による束縛とは異なり、`static` を用いるときは型を明示する必要があります。

<!-- Statics live for the entire lifetime of a program, and therefore any -->
<!-- reference stored in a constant has a [`'static` lifetime][lifetimes]: -->
静的アイテムはプログラム全体のライフタイムの間生きています。
そのため定数に保存されている参照は [`static` ライフタイム][lifetimes] を持ちます:

```rust
static NAME: &'static str = "Steve";
```

[lifetimes]: lifetimes.html

<!-- ## Mutability -->
## ミュータビリティ

<!-- You can introduce mutability with the `mut` keyword: -->
`mut` を利用することでミュータビリティを導入できます:

```rust
static mut N: i32 = 5;
```

<!-- Because this is mutable, one thread could be updating `N` while another is -->
<!-- reading it, causing memory unsafety. As such both accessing and mutating a -->
<!-- `static mut` is [`unsafe`][unsafe], and so must be done in an `unsafe` block: -->
この静的な変数 `N` はミュータブルであるため、別のスレッドから読まれている間に変更される可能性があり、メモリの不安全性の原因となります。
そのため `static mut` な変数にアクセスを行うことは [`unsafe`][unsafe] であり、 `unsafe` ブロック中で行う必要があります。

```rust
# static mut N: i32 = 5;

unsafe {
    N += 1;

    println!("N: {}", N);
}
```

[unsafe]: unsafe.html

<!-- Furthermore, any type stored in a `static` must be `Sync`, and must not have -->
<!-- a [`Drop`][drop] implementation. -->
さらに言えば、 `static` な変数に格納される値の型は `Sync` を実装しており、かつ [`Drop`][drop] は実装していない必要があります。

[drop]: drop.html

<!-- # Initializing -->
# 初期化

<!-- Both `const` and `static` have requirements for giving them a value. They must -->
<!-- be given a value that’s a constant expression. In other words, you cannot use -->
<!-- the result of a function call or anything similarly complex or at runtime. -->
`const` 、 `static` どちらも値に対してそれらが定数式でなければならないという要件があります。
言い換えると、関数の呼び出しのような複雑なものや実行時の値を指定することはできないということです。

<!-- # Which construct should I use? -->
# どちらを使うべきか

<!-- Almost always, if you can choose between the two, choose `const`. It’s pretty -->
<!-- rare that you actually want a memory location associated with your constant, -->
<!-- and using a const allows for optimizations like constant propagation not only -->
<!-- in your crate but downstream crates. -->
大抵の場合、`static` か `const` で選ぶときは `const` を選ぶと良いでしょう。
定数を定義したい時に、そのメモリロケーションが固定であることを必要とする場面は珍しく、また `const` を用いることで定数伝播によってあなたのクレートだけでなく、それを利用するクレートでも最適化が行われます。
