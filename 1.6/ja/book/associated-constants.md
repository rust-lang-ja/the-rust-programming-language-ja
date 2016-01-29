% 関連定数
<!-- % Associated Constants -->

<!-- With the `associated_consts` feature, you can define constants like this: -->
`associated_consts` フィーチャを使うと、以下のように定数を定義することができます。

```rust
#![feature(associated_consts)]

trait Foo {
    const ID: i32;
}

impl Foo for i32 {
    const ID: i32 = 1;
}

fn main() {
    assert_eq!(1, i32::ID);
}
```

<!-- Any implementor of `Foo` will have to define `ID`. Without the definition: -->
`Foo` を実装する場合、必ず `ID` を定義しなければなりません。もし以下のように定義がなかった場合

```rust,ignore
#![feature(associated_consts)]

trait Foo {
    const ID: i32;
}

impl Foo for i32 {
}
```

<!-- gives -->
このようになります。

```text
error: not all trait items implemented, missing: `ID` [E0046]
     impl Foo for i32 {
     }
```

> 訳注:
>
>
> ```text
> エラー: トレイトの全ての要素が実装されていません。 `ID` が未実装です。 [E0046]
>      impl Foo for i32 {
>      }
> ```

<!-- A default value can be implemented as well: -->
既定の値についても以下のように実装できます。

```rust
#![feature(associated_consts)]

trait Foo {
    const ID: i32 = 1;
}

impl Foo for i32 {
}

impl Foo for i64 {
    const ID: i32 = 5;
}

fn main() {
    assert_eq!(1, i32::ID);
    assert_eq!(5, i64::ID);
}
```

<!-- As you can see, when implementing `Foo`, you can leave it unimplemented, as -->
<!-- with `i32`. It will then use the default value. But, as in `i64`, we can also -->
<!-- add our own definition. -->
上記の通り、 `Foo` トレイトを実装する際、 `i32` のように未実装のままにすることができます。この場合、既定の値が使われます。一方 `i64` のように独自の定義を追加することもできます。

<!-- Associated constants don’t have to be associated with a trait. An `impl` block -->
<!-- for a `struct` or an `enum` works fine too: -->
関連定数はトレイトに限定されるものではありません。 `struct` や `enum` の `impl` ブロックにおいても使うことができます。

```rust
#![feature(associated_consts)]

struct Foo;

impl Foo {
    const FOO: u32 = 3;
}
```
