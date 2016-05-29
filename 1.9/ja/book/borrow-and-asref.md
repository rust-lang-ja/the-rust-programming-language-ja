% BorrowとAsRef
<!-- % Borrow and AsRef -->

<!-- The [`Borrow`][borrow] and [`AsRef`][asref] traits are very similar, but -->
<!-- different. Here’s a quick refresher on what these two traits mean. -->
[`Borrow`][borrow] トレイトと [`AsRef`][asref] トレイトはとてもよく似ていますが違うものです。ここでは2つのトレイトの意味を簡単に説明します。

[borrow]: ../std/borrow/trait.Borrow.html
[asref]: ../std/convert/trait.AsRef.html

<!-- # Borrow -->
# Borrow

<!-- The `Borrow` trait is used when you’re writing a datastructure, and you want to -->
<!-- use either an owned or borrowed type as synonymous for some purpose. -->
`Borrow` トレイトはデータ構造を書いていて、所有型と借用型を同等に扱いたいときに使います。

<!-- For example, [`HashMap`][hashmap] has a [`get` method][get] which uses `Borrow`: -->
例えば、 [`HashMap`][hashmap] には `Borrow` を使った [`get` メソッド][get] があります。

```rust,ignore
fn get<Q: ?Sized>(&self, k: &Q) -> Option<&V>
    where K: Borrow<Q>,
          Q: Hash + Eq
```

[hashmap]: ../std/collections/struct.HashMap.html
[get]: ../std/collections/struct.HashMap.html#method.get

<!-- This signature is pretty complicated. The `K` parameter is what we’re interested -->
<!-- in here. It refers to a parameter of the `HashMap` itself: -->
このシグネチャは少し複雑です。`K` パラメータに注目してください。これは以下のように `HashMap` 自身のパラメータになっています。

```rust,ignore
struct HashMap<K, V, S = RandomState> {
```

<!-- The `K` parameter is the type of _key_ the `HashMap` uses. So, looking at -->
<!-- the signature of `get()` again, we can use `get()` when the key implements -->
<!-- `Borrow<Q>`. That way, we can make a `HashMap` which uses `String` keys, -->
<!-- but use `&str`s when we’re searching: -->
`K` パラメータは `HashMap` の「キー」を表す型です。ここで再び `get()` のシグネチャを見ると、キーが `Borrow<Q>` を実装しているときに `get()` を使えることが分かります。そのため、以下のように `String` をキーとした `HashMap` を検索するときに `&str` を使うことができます。

```rust
use std::collections::HashMap;

let mut map = HashMap::new();
map.insert("Foo".to_string(), 42);

assert_eq!(map.get("Foo"), Some(&42));
```

<!-- This is because the standard library has `impl Borrow<str> for String`. -->
これは標準ライブラリが `impl Borrow<str> for String` を提供しているためです。

<!-- For most types, when you want to take an owned or borrowed type, a `&T` is -->
<!-- enough. But one area where `Borrow` is effective is when there’s more than one -->
<!-- kind of borrowed value. This is especially true of references and slices: you -->
<!-- can have both an `&T` or a `&mut T`. If we wanted to accept both of these types, -->
<!-- `Borrow` is up for it: -->
所有型か借用型のどちらかを取りたい場合、たいていは `&T` で十分ですが、借用された値が複数種類ある場合 `Borrow` が役に立ちます。特に参照とスライスは `&T` と `&mut T` のいずれも取りうるため、そのどちらも受け入れたい場合は `Borrow` がよいでしょう。

```rust
use std::borrow::Borrow;
use std::fmt::Display;

fn foo<T: Borrow<i32> + Display>(a: T) {
    println!("a is borrowed: {}", a);
}

let mut i = 5;

foo(&i);
foo(&mut i);
```

<!-- This will print out `a is borrowed: 5` twice. -->
上のコードは `a is borrowed: 5` を二度出力します。

<!-- # AsRef -->
# AsRef

<!-- The `AsRef` trait is a conversion trait. It’s used for converting some value to -->
<!-- a reference in generic code. Like this: -->
`AsRef` トレイトは変換用のトレイトです。ジェネリックなコードにおいて、値を参照に変換したい場合に使います。

```rust
let s = "Hello".to_string();

fn foo<T: AsRef<str>>(s: T) {
    let slice = s.as_ref();
}
```

<!-- # Which should I use? -->
# どちらを使うべきか

<!-- We can see how they’re kind of the same: they both deal with owned and borrowed -->
<!-- versions of some type. However, they’re a bit different. -->
ここまでで見てきた通り、2つのトレイトは、どちらもある型の所有型バージョンと借用型バージョンの両方を扱う、という意味で同じような種類のものですが、少し違います。

<!-- Choose `Borrow` when you want to abstract over different kinds of borrowing, or -->
<!-- when you’re building a datastructure that treats owned and borrowed values in -->
<!-- equivalent ways, such as hashing and comparison. -->
いくつかの異なる種類の借用を抽象化したい場合や、ハッシュ化や比較のために所有型と借用型を同等に扱いたいデータ構造を作る場合は `Borrow` を使ってください。

<!-- Choose `AsRef` when you want to convert something to a reference directly, and -->
<!-- you’re writing generic code. -->
ジェネリックなコードで値を参照に直接変換したい場合は `AsRef` を使ってください。
