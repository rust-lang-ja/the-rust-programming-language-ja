% アトリビュート
<!-- % Attributes -->

<!-- Declarations can be annotated with ‘attributes’ in Rust. They look like this: -->
Rustでは以下のように「アトリビュート」によって宣言を修飾することができます。

```rust
#[test]
# fn foo() {}
```

<!-- or like this: -->
または以下のように:

```rust
# mod foo {
#![test]
# }
```

<!-- The difference between the two is the `!`, which changes what the attribute  -->
<!-- applies to: -->
２つの違いは `!` に有ります、 `!` はアトリビュートが適用されるものを変更します:

```rust,ignore
#[foo]
struct Foo;

mod bar {
    #![bar]
}
```

<!-- The `#[foo]` attribute applies to the next item, which is the `struct` -->
<!-- declaration. The `#![bar]` attribute applies to the item enclosing it, which is -->
<!-- the `mod` declaration. Otherwise, they’re the same. Both change the meaning of -->
<!-- the item they’re attached to somehow. -->
`#[foo]` アトリビュートは次のアイテムに適用され、この場合は `struct` 宣言に適用されます。
`#![bar]` アトリビュートは `#![bar]` アトリビュートを囲んでいるアイテムに適用され、この場合は `mod` 宣言に適用されます。
その他の点については同じであり、どちらも適用されたアイテムの意味を変化させます。



<!-- For example, consider a function like this: -->
例を挙げると、たとえば以下の様な関数では:

```rust
#[test]
fn check() {
    assert_eq!(2, 1 + 1);
}
```

<!-- It is marked with `#[test]`. This means it’s special: when you run -->
<!-- [tests][tests], this function will execute. When you compile as usual, it won’t -->
<!-- even be included. This function is now a test function. -->
この関数は `#[test]` によってマークされており、これは [テスト][tests] を走らせた時に実行されるという特別な意味になります。
通常通りにコンパイルをした場合は、コンパイル結果に含まれません。この関数は今やテスト関数なのです。

[tests]: testing.html

<!-- Attributes may also have additional data: -->
アトリビュートは以下のように、追加のデータを持つことができます:

```rust
#[inline(always)]
fn super_fast_fn() {
# }
```

<!-- Or even keys and values: -->
また、キーと値についても持つことができます:

```rust
#[cfg(target_os = "macos")]
mod macos_only {
# }
```

<!-- Rust attributes are used for a number of different things. There is a full list -->
<!-- of attributes [in the reference][reference]. Currently, you are not allowed to -->
<!-- create your own attributes, the Rust compiler defines them. -->
Rustのアトリビュートは様々なことに利用されます。
すべてのアトリビュートのリストは [リファレンス][reference] に載っています。
現在は、Rustコンパイラによって定義されている以外の独自のアトリビュートを作成することは許可されていません。

[reference]: ../reference.html#attributes
