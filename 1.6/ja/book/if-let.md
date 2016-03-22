% if let
<!-- % if let -->

<!-- `if let` allows you to combine `if` and `let` together to reduce the overhead -->
<!-- of certain kinds of pattern matches. -->
`if let` によって`if` と `let` を一体化して用いることが可能となり、
ある種のパターンマッチに伴うオーバーヘッドを削減することができます。

<!-- For example, let’s say we have some sort of `Option<T>`. We want to call a function -->
<!-- on it if it’s `Some<T>`, but do nothing if it’s `None`. That looks like this: -->
例えば今、 `Option<T>` 型の値が有るとして、
この値が `Some<T>` であるならば何らかの関数を呼び出し、`None` ならば何もしたくないとしましょう
そのような処理は例えば以下のように書けるでしょう:

```rust
# let option = Some(5);
# fn foo(x: i32) { }
match option {
    Some(x) => { foo(x) },
    None => {},
}
```

<!-- We don’t have to use `match` here, for example, we could use `if`: -->
このような場合 `match` を用いなくても良く、 `if` を使って以下のように書けます:

```rust
# let option = Some(5);
# fn foo(x: i32) { }
if option.is_some() {
    let x = option.unwrap();
    foo(x);
}
```

<!-- Neither of these options is particularly appealing. We can use `if let` to -->
<!-- do the same thing in a nicer way: -->
上述のコードのどちらもまだ理想的ではありません。 `if let` を用いてより良い方法で記述できます:

```rust
# let option = Some(5);
# fn foo(x: i32) { }
if let Some(x) = option {
    foo(x);
}
```

<!-- If a [pattern][patterns] matches successfully, it binds any appropriate parts of -->
<!-- the value to the identifiers in the pattern, then evaluates the expression. If -->
<!-- the pattern doesn’t match, nothing happens. -->
もし [パターン][patterns] マッチが成功した場合、パターンに含まれる変数に適切に値が割り当てられ、
式が評価されます。もしパターンマッチが失敗した場合には何も起こりません。

<!-- If you want to do something else when the pattern does not match, you can -->
<!-- use `else`: -->
もしパターンマッチに失敗した場合に実行したいコードが有る場合は `else` を使うことができます:

```rust
# let option = Some(5);
# fn foo(x: i32) { }
# fn bar() { }
if let Some(x) = option {
    foo(x);
} else {
    bar();
}
```

## `while let`

<!-- In a similar fashion, `while let` can be used when you want to conditionally -->
<!-- loop  as long as a value matches a certain pattern. It turns code like this: -->
同じように、 `while let` を使うことで、値がパターンにマッチし続ける限り繰り返し実行することができます。
例えば以下の様なコードが有るときに:

```rust
let mut v = vec![1, 3, 5, 7, 11];
loop {
    match v.pop() {
        Some(x) =>  println!("{}", x),
        None => break,
    }
}
```

<!-- Into code like this: -->
`while let` を用いることで、以下のように書くことができます:

```rust
let mut v = vec![1, 3, 5, 7, 11];
while let Some(x) = v.pop() {
    println!("{}", x);
}
```

[patterns]: patterns.html
