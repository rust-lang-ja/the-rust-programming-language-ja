% ベクタ
<!-- % Vectors -->

<!-- A ‘vector’ is a dynamic or ‘growable’ array, implemented as the standard -->
<!-- library type [`Vec<T>`][vec]. The `T` means that we can have vectors -->
<!-- of any type (see the chapter on [generics][generic] for more). -->
<!-- Vectors always allocate their data on the heap. -->
<!-- You can create them with the `vec!` macro: -->
「ベクタ」は動的な、または「拡張可能な」配列です、標準ライブラリ上で [`Vec<T>`][vec] として提供されています。
`T` はどんなタイプのベクタをも作成することが可能なことを意味しています。(詳細は[ジェネリクス][generic]を御覧ください)
ベクタはデータを常にヒープ上にアロケーションします。
ベクタは以下のように `vec!` マクロを用いて作成できます:

```rust
let v = vec![1, 2, 3, 4, 5]; // v: Vec<i32>
```

<!-- (Notice that unlike the `println!` macro we’ve used in the past, we use square -->
<!-- brackets `[]` with `vec!` macro. Rust allows you to use either in either situation, -->
<!-- this is just convention.) -->
(以前使った`println!` マクロと異なり、`vec!` マクロで 角括弧 `[]` を利用しました。)
Rustではどちらの括弧もどちらのシチュエーションでも利用可能であり、解りやすさのためです。

<!-- There’s an alternate form of `vec!` for repeating an initial value: -->
`vec!` には初期値の繰り返しを表現するための形式があります:

```rust
# // let v = vec![0; 10]; // ten zeroes
let v = vec![0; 10]; // 0が10個
```

## 要素へのアクセス

<!-- To get the value at a particular index in the vector, we use `[]`s: -->
ベクタ中の特定のインデックスの値にアクセスするには `[]` を利用します:

```rust
let v = vec![1, 2, 3, 4, 5];

println!("The third element of v is {}", v[2]);
```

<!-- The indices count from `0`, so the third element is `v[2]`.-->
インデックスは `0` から始まります、なので三番目の要素は `v[2]` となります。

<!-- It’s also important to note that you must index with the `usize` type: -->
また、インデックスは `usize` 型でなければならない点に注意しましょう:

```ignore
let v = vec![1, 2, 3, 4, 5];

let i: usize = 0;
let j: i32 = 0;

# // // works
// これは動作します
v[i];

# // // doesn’t
// 一方、こちらは動作しません
v[j];
```

<!-- Indexing with a non-`usize` type gives an error that looks like this: -->
`usize` 型でないインデックスを用いた場合、以下の様なエラーが発生します:

```text
error: the trait `core::ops::Index<i32>` is not implemented for the type
`collections::vec::Vec<_>` [E0277]
v[j];
^~~~
note: the type `collections::vec::Vec<_>` cannot be indexed by `i32`
error: aborting due to previous error
```

<!-- There’s a lot of punctuation in that message, but the core of it makes sense: -->
<!-- you cannot index with an `i32`. -->
エラーメッセージ中には多くの点が含まれていますが、一番大切な部分は `i32` をインデックスとして用いることはできないという点です。

## イテレーティング

<!-- Once you have a vector, you can iterate through its elements with `for`. There -->
<!-- are three versions: -->
ベクタである値に対して `for` を用いて以下の様な3つの方法でイテレートすることができます:

```rust
let mut v = vec![1, 2, 3, 4, 5];

for i in &v {
    println!("A reference to {}", i);
}

for i in &mut v {
    println!("A mutable reference to {}", i);
}

for i in v {
    println!("Take ownership of the vector and its element {}", i);
}
```

<!-- Vectors have many more useful methods, which you can read about in [their -->
<!-- API documentation][vec]. -->
ベクタにはもっと多くの便利なメソッドが定義されています。それらのメソッドについては [APIドキュメント][vec] で確認することができます。

[vec]: ../std/vec/index.html
[generic]: generics.html
