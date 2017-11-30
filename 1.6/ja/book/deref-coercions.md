% `Deref` による型強制
<!-- % `Deref` coercions -->

<!-- The standard library provides a special trait, [`Deref`][deref]. It’s normally -->
<!-- used to overload `*`, the dereference operator: -->
標準ライブラリは特別なトレイト [`Deref`][deref] を提供します。
`Deref` は通常、参照外し演算子 `*` をオーバーロードするために利用されます。

```rust
use std::ops::Deref;

struct DerefExample<T> {
    value: T,
}

impl<T> Deref for DerefExample<T> {
    type Target = T;

    fn deref(&self) -> &T {
        &self.value
    }
}

fn main() {
    let x = DerefExample { value: 'a' };
    assert_eq!('a', *x);
}
```

[deref]: ../std/ops/trait.Deref.html

<!-- This is useful for writing custom pointer types. However, there’s a language -->
<!-- feature related to `Deref`: ‘deref coercions’. Here’s the rule: If you have a -->
<!-- type `U`, and it implements `Deref<Target=T>`, values of `&U` will -->
<!-- automatically coerce to a `&T`. Here’s an example: -->
このように、 `Deref` はカスタマイズしたポインタ型を定義するのに便利です。
一方で、`Deref` に関連する機能がもう一つ有ります: 「derefによる型強制」です。
これは、 `Deref<Target=T>` を実装している型 `U` があるときに、
`&U` が自動的に `&T` に型強制されるというルールです。
例えば:

```rust
fn foo(s: &str) {
# //    // borrow a string for a second
    // 一瞬だけ文字列を借用します
}

# // // String implements Deref<Target=str>
// String は Deref<Target=str> を実装しています
let owned = "Hello".to_string();

# // // therefore, this works:
// なので、以下のコードはきちんと動作します:
foo(&owned);
```

<!-- Using an ampersand in front of a value takes a reference to it. So `owned` is a -->
<!-- `String`, `&owned` is an `&String`, and since `impl Deref<Target=str> for -->
<!-- String`, `&String` will deref to `&str`, which `foo()` takes. -->
値の前にアンパサンド(&)をつけることによってその値への参照を取得することができます。
なので、 `owned` は `String` であり、 `&owned` は `&String` であり、
そして、 `String` が `Deref<Target=str>` を実装しているために、
`&String` は `foo()` が要求している `&str` に型強制されます。

<!-- That’s it. This rule is one of the only places in which Rust does an automatic -->
<!-- conversion for you, but it adds a lot of flexibility. For example, the `Rc<T>` -->
<!-- type implements `Deref<Target=T>`, so this works: -->
以上です! このルールはRustが自動的に変換を行う数少ない箇所の一つです。
これによって、多くの柔軟性が手にはいります。
例えば `Rc<T>` は `Deref<Target=T>` を実装しているため、以下のコードは正しく動作します:

```rust
use std::rc::Rc;

fn foo(s: &str) {
# //    // borrow a string for a second
      // 文字列を一瞬だけ借用します
}

# // // String implements Deref<Target=str>
// String は Deref<Target=str>を実装しています
let owned = "Hello".to_string();
let counted = Rc::new(owned);

# // // therefore, this works:
// ゆえに、以下のコードは正しく動作します:
foo(&counted);
```

<!-- All we’ve done is wrap our `String` in an `Rc<T>`. But we can now pass the -->
<!-- `Rc<String>` around anywhere we’d have a `String`. The signature of `foo` -->
<!-- didn’t change, but works just as well with either type. This example has two -->
<!-- conversions: `Rc<String>` to `String` and then `String` to `&str`. Rust will do -->
<!-- this as many times as possible until the types match. -->
先ほどのコードとの変化は `String` を `Rc<T>` でラッピングした点ですが、
依然 `Rc<String>` を `String` が必要なところに渡すことができます。
`foo` のシグネチャは変化していませんが、どちらの型についても正しく動作します。
この例は２つの変換を含んでいます: `Rc<String>` が `String` に変換され、次に `String` が `&str` に変換されます。
Rustはこのような変換を型がマッチするまで必要なだけ繰り返します。

<!-- Another very common implementation provided by the standard library is: -->
標準ライブラリに頻繁に見られるその他の実装は例えば以下の様なものが有ります:

```rust
fn foo(s: &[i32]) {
# //    // borrow a slice for a second
     // スライスを一瞬だけ借用します
}

# // // Vec<T> implements Deref<Target=[T]>
// Vec<T> は Deref<Target=[T]> を実装しています
let owned = vec![1, 2, 3];

foo(&owned);
```

<!-- Vectors can `Deref` to a slice. -->
ベクタはスライスに `Deref` することができます。

<!-- ## Deref and method calls -->
## Derefとメソッド呼び出し

<!-- `Deref` will also kick in when calling a method. Consider the following -->
<!-- example. -->
`Deref` はメソッド呼び出し時にも自動的に呼びだされます。
例えば以下の様なコードを見てみましょう:

```rust
struct Foo;

impl Foo {
    fn foo(&self) { println!("Foo"); }
}

let f = &&Foo;

f.foo();
```

<!-- Even though `f` is a `&&Foo` and `foo` takes `&self`, this works. That’s -->
<!-- because these things are the same: -->
`f` は `&&Foo` であり、 `foo` は `&self` を引数に取るにも関わらずこのコードは動作します。
これは、以下が全て等価なことによります:

```rust,ignore
f.foo();
(&f).foo();
(&&f).foo();
(&&&&&&&&f).foo();
```

<!-- A value of type `&&&&&&&&&&&&&&&&Foo` can still have methods defined on `Foo` -->
<!-- called, because the compiler will insert as many * operations as necessary to -->
<!-- get it right. And since it’s inserting `*`s, that uses `Deref`. -->
`&&&&&&&&&&&&&&&&Foo` 型の値は `Foo` で定義されているメソッドを呼び出すことができます。
これは、コンパイラが自動的に必要なだけ * 演算子を補うことによります。
そして `*` が補われることによって `Deref` が利用される事になります。
