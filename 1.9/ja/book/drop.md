% Drop
<!-- % Drop -->

<!-- Now that we’ve discussed traits, let’s talk about a particular trait provided -->
<!-- by the Rust standard library, [`Drop`][drop]. The `Drop` trait provides a way -->
<!-- to run some code when a value goes out of scope. For example: -->
トレイトについて学びましたので、Rustの標準ライブラリによって提供されている具体的なトレイト [`Drop`][drop] について説明しましょう。
`Drop` トレイトは値がスコープ外になった時にコードを実行する方法を提供します。

[drop]: ../std/ops/trait.Drop.html

```rust
struct HasDrop;

impl Drop for HasDrop {
    fn drop(&mut self) {
        println!("Dropping!");
    }
}

fn main() {
    let x = HasDrop;

#   // do stuff
    // いくつかの処理

# // } // x goes out of scope here
} // x はここでスコープ外になります
```

<!-- When `x` goes out of scope at the end of `main()`, the code for `Drop` will -->
<!-- run. `Drop` has one method, which is also called `drop()`. It takes a mutable -->
<!-- reference to `self`. -->
`x` が `main()` の終わりでスコープ外になった時、 `Drop` のコードが実行されます。
`Drop` にはメソッドは1つだけあり、それもまた `drop()` と呼ばれます。
ミュータブルな `self` への参照を引数に取ります。

<!-- That’s it! The mechanics of `Drop` are very simple, but there are some -->
<!-- subtleties. For example, values are dropped in the opposite order they are -->
<!-- declared. Here’s another example: -->
これだけです！
`Drop` のメカニズムは非常にシンプルですが、少しばかり注意があります。
たとえば、値がドロップされる順序は、それらが定義された順序と反対の順序になります。

```rust
struct Firework {
    strength: i32,
}

impl Drop for Firework {
    fn drop(&mut self) {
        println!("BOOM times {}!!!", self.strength);
    }
}

fn main() {
    let firecracker = Firework { strength: 1 };
    let tnt = Firework { strength: 100 };
}
```

<!-- This will output: -->
このコードは以下のように出力します。

```text
BOOM times 100!!!
BOOM times 1!!!
```

<!-- The `tnt` goes off before the `firecracker` does, because it was declared -->
<!-- afterwards. Last in, first out. -->
`tnt` が `firecracker` （爆竹）が鳴る前に爆発してしまいました。
これはTNTが定義されたのは爆竹よりも後だったためです。
ラストイン・ファーストアウトです。

<!-- So what is `Drop` good for? Generally, `Drop` is used to clean up any resources -->
<!-- associated with a `struct`. For example, the [`Arc<T>` type][arc] is a -->
<!-- reference-counted type. When `Drop` is called, it will decrement the reference -->
<!-- count, and if the total number of references is zero, will clean up the -->
<!-- underlying value. -->
`Drop` は何をするのに向いているのでしょうか？
一般的に `Drop` は `struct` に関連付けられているリソースのクリーンアップに使われます。
たとえば [`Arc<T>` 型][arc] は参照カウントを行う型です。
`Drop` が呼ばれると、参照カウントがデクリメントされ、もし参照の合計数が0になっていたら、内包している値がクリーンアップされます。

[arc]: ../std/sync/struct.Arc.html
