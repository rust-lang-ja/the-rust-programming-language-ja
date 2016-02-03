% ベクタ
<!-- % Vectors -->

<!-- A ‘vector’ is a dynamic or ‘growable’ array, implemented as the standard -->
<!-- library type [`Vec<T>`][vec]. The `T` means that we can have vectors -->
<!-- of any type (see the chapter on [generics][generic] for more). -->
<!-- Vectors always allocate their data on the heap. -->
<!-- You can create them with the `vec!` macro: -->
「ベクタ」は動的な、または「拡張可能な」配列です、標準ライブラリ上で [`Vec<T>`][vec] として提供されています。
`T` はどんなタイプのベクタをも作成することが可能なことを意味しています。(詳細は[ジェネリクス][generics]を御覧ください)
ベクタはデータを常にヒープ上にアロケーションします。
ベクタは以下のように `vec!` マクロを用いて作成できます:

```rust
let v = vec![1, 2, 3, 4, 5]; // v: Vec<i32>
```

<!-- (Notice that unlike the `println!` macro we’ve used in the past, we use square -->
<!-- brackets `[]` with `vec!` macro. Rust allows you to use either in either situation, -->
<!-- this is just convention.) -->
(依然使った`println!` マクロと異なり、`vec!` マクロで 角括弧 `[]` を利用しました。
Rustではどちらの括弧もどちらのシチュエーションでも利用可能であり、解りやすさのためです。

<!-- There’s an alternate form of `vec!` for repeating an initial value: -->
`vec!` には初期値の繰り返しを表現するための形式があります:

```rust
# // let v = vec![0; 10]; // ten zeroes
let v = vec![0; 10]; // 0が10個
```

## Accessing elements

To get the value at a particular index in the vector, we use `[]`s:

```rust
let v = vec![1, 2, 3, 4, 5];

println!("The third element of v is {}", v[2]);
```

The indices count from `0`, so the third element is `v[2]`.

It’s also important to note that you must index with the `usize` type:

```ignore
let v = vec![1, 2, 3, 4, 5];

let i: usize = 0;
let j: i32 = 0;

// works
v[i];

// doesn’t
v[j];
```

Indexing with a non-`usize` type gives an error that looks like this:

```text
error: the trait `core::ops::Index<i32>` is not implemented for the type
`collections::vec::Vec<_>` [E0277]
v[j];
^~~~
note: the type `collections::vec::Vec<_>` cannot be indexed by `i32`
error: aborting due to previous error
```

There’s a lot of punctuation in that message, but the core of it makes sense:
you cannot index with an `i32`.

## Iterating

Once you have a vector, you can iterate through its elements with `for`. There
are three versions:

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

Vectors have many more useful methods, which you can read about in [their
API documentation][vec].

[vec]: ../std/vec/index.html
[generic]: generics.html
