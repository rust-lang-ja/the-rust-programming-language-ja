% パターン
<!-- % Patterns -->

<!-- Patterns are quite common in Rust. -->
パターンはRustにおいて極めて一般的です。

<!-- We use them in [variable
bindings][bindings], [match statements][match], and other places, too.-->
パターンは [変数束縛][bindings]、 [マッチ文][match] などで使われています。

<!--Let’s go on a whirlwind tour of all of the things patterns can do!-->
さあ、めくるめくパターンの旅を始めましょう！

[bindings]: variable-bindings.html
[match]: match.html

<!-- A quick refresher: you can match against literals directly, and `_` acts as an
‘any’ case: -->
簡単な復習：リテラルに対しては直接マッチさせられます。また、 `_` は「任意の」ケースとして振る舞います。

```rust
let x = 1;

match x {
    1 => println!("one"),
    2 => println!("two"),
    3 => println!("three"),
    _ => println!("anything"),
}
```

<!-- This prints `one`. -->
これは `one` を表示します。

<!-- There’s one pitfall with patterns: like anything that introduces a new binding,they introduce shadowing. For example: -->
パターンには一つ落とし穴があります。新しい束縛を導入する他の構文と同様、パターンはシャドーイングをします。例えば：

```rust
let x = 'x';
let c = 'c';

match c {
    x => println!("x: {} c: {}", x, c),
}

println!("x: {}", x)
```

<!-- This prints:-->
これは以下のように出力します。

```text
x: c c: c
x: x
```

<!-- In other words, `x =>` matches the pattern and introduces a new binding named
`x` that’s in scope for the match arm. Because we already have a binding named
`x`, this new `x` shadows it. -->
別の言い方をすると、 `x =>` は値をパターンにマッチさせ、マッチの腕内で有効な `x` という名前の束縛を導入します。既に `x` という束縛が存在していたので、新たに導入した `x` は、その古い `x` をシャドーイングします。

<!-- # Multiple patterns -->
# 複式パターン

<!-- You can match multiple patterns with `|`: -->
`|` を使うと、複数のパターンにマッチさせることができます：


```rust
let x = 1;

match x {
    1 | 2 => println!("one or two"),
    3 => println!("three"),
    _ => println!("anything"),
}
```

<!--This prints `one or two`.-->
これは、 `one or two` を出力します。

<!-- # Destructuring -->
# 分配束縛

<!-- If you have a compound data type, like a [`struct`][struct], you can destructure it
inside of a pattern: -->
[`struct`][struct] のような複合データ型が存在するとき、パターン内でその値を分解することができます。

```rust
struct Point {
    x: i32,
    y: i32,
}

let origin = Point { x: 0, y: 0 };

match origin {
    Point { x, y } => println!("({},{})", x, y),
}
```

[struct]: structs.html

<!-- We can use `:` to give a value a different name.-->
値に別の名前を付けたいときは、 `:` を使うことができます。

```rust
struct Point {
    x: i32,
    y: i32,
}

let origin = Point { x: 0, y: 0 };

match origin {
    Point { x: x1, y: y1 } => println!("({},{})", x1, y1),
}
```

<!-- If we only care about some of the values, we don’t have to give them all names: -->
値の一部にだけ興味がある場合は、値のすべてに名前を付ける必要はありません。

```rust
struct Point {
    x: i32,
    y: i32,
}

let origin = Point { x: 0, y: 0 };

match origin {
    Point { x, .. } => println!("x is {}", x),
}
```

<!-- This prints `x is 0`. -->
これは `x is 0` を出力します。

<!-- You can do this kind of match on any member, not just the first:-->
最初のメンバだけでなく、どのメンバに対してもこの種のマッチを行うことができます。

```rust
struct Point {
    x: i32,
    y: i32,
}

let origin = Point { x: 0, y: 0 };

match origin {
    Point { y, .. } => println!("y is {}", y),
}
```

<!-- This prints `y is 0`. -->
これは `y is 0` を出力します。

<!-- This ‘destructuring’ behavior works on any compound data type, like
[tuples][tuples] or [enums][enums]. -->
この「分配束縛」 (destructuring) と呼ばれる振る舞いは、 [タプル][tuples] や [列挙型][enums] のような、任意の複合データ型で使用できます。

[tuples]: primitive-types.html#tuples
[enums]: enums.html

<!-- # Ignoring bindings -->
# 束縛の無視

<!-- You can use `_` in a pattern to disregard the type and value.-->
パターン内の型や値を無視するために `_` を使うことができます。

<!-- For example, here’s a `match` against a `Result<T, E>`: -->
例として、 `Result<T, E>` に対して `match` をしてみましょう：

```rust
# let some_value: Result<i32, &'static str> = Err("There was an error");
match some_value {
    Ok(value) => println!("got a value: {}", value),
    Err(_) => println!("an error occurred"),
}
```

<!-- In the first arm, we bind the value inside the `Ok` variant to `value`. But
in the `Err` arm, we use `_` to disregard the specific error, and just print
a general error message. -->
最初の部分では `Ok` ヴァリアント内の値に `value` を束縛しています。しかし `Err` 部分では、ヴァリアント内のエラー情報を無視して一般的なエラーメッセージを表示するために `_` を使っています。

<!-- `_` is valid in any pattern that creates a binding. This can be useful to
ignore parts of a larger structure: -->
`_` は束縛を導入するどのようなパターンにおいても有効です。これは大きな構造の一部を無視する際に有用です。

```rust
fn coordinate() -> (i32, i32, i32) {
#     // generate and return some sort of triple tuple
    // 3要素のタプルを生成して返す
# (1, 2, 3)
}

let (x, _, z) = coordinate();
```

<!-- Here, we bind the first and last element of the tuple to `x` and `z`, but
ignore the middle element. -->
ここでは、タプルの最初と最後の要素に `x` と `z` を束縛します。

<!-- Similarly, you can use `..` in a pattern to disregard multiple values. -->
同様に `..` でパターン内の複数の値を無視することができます。

```rust
enum OptionalTuple {
    Value(i32, i32, i32),
    Missing,
}

let x = OptionalTuple::Value(5, -2, 3);

match x {
    OptionalTuple::Value(..) => println!("Got a tuple!"),
    OptionalTuple::Missing => println!("No such luck."),
}
```

<!--This prints `Got a tuple!`. -->
これは `Got a tuple!` を出力します。

<!-- # ref and ref mut -->
# ref と ref mut

<!-- If you want to get a [reference][ref], use the `ref` keyword:-->
[参照][ref] を取得したいときは `ref` キーワードを使いましょう。

```rust
let x = 5;

match x {
    ref r => println!("Got a reference to {}", r),
}
```

<!--This prints `Got a reference to 5`. -->
これは `Got a reference to 5` を出力します。

[ref]: references-and-borrowing.html

<!-- Here, the `r` inside the `match` has the type `&i32`. In other words, the `ref`
keyword _creates_ a reference, for use in the pattern. If you need a mutable
reference, `ref mut` will work in the same way: -->
ここで `match` 内の `r` は `&i32` 型を持っています。言い換えると、 `ref` キーワードはパターン内で使う参照を _作り出します_ 。ミュータブルな参照が必要な場合は、同様に `ref mut` を使います。

```rust
let mut x = 5;

match x {
    ref mut mr => println!("Got a mutable reference to {}", mr),
}
```

<!-- # Ranges -->
# 範囲

<!-- You can match a range of values with `...`: -->
`...` で値の範囲をマッチさせることができます：

```rust
let x = 1;

match x {
    1 ... 5 => println!("one through five"),
    _ => println!("anything"),
}
```

<!-- This prints `one through five`. -->
これは `one through five` を出力します。

<!-- Ranges are mostly used with integers and `char`s: -->
範囲は多くの場合、整数か `char` 型で使われます：

```rust
let x = '💅';

match x {
    'a' ... 'j' => println!("early letter"),
    'k' ... 'z' => println!("late letter"),
    _ => println!("something else"),
}
```

<!-- This prints `something else`. -->
これは `something else` を出力します。

<!-- # Bindings -->
# 束縛

<!-- You can bind values to names with `@`: -->
`@` で値に名前を束縛することができます。

```rust
let x = 1;

match x {
    e @ 1 ... 5 => println!("got a range element {}", e),
    _ => println!("anything"),
}
```

<!-- This prints `got a range element 1`. This is useful when you want to
do a complicated match of part of a data structure: -->
これは `got a range element 1` を出力します。
データ構造の一部に対して複雑なマッチングをしたいときに有用です：

```rust
#[derive(Debug)]
struct Person {
    name: Option<String>,
}

let name = "Steve".to_string();
let mut x: Option<Person> = Some(Person { name: Some(name) });
match x {
    Some(Person { name: ref a @ Some(_), .. }) => println!("{:?}", a),
    _ => {}
}
```

<!--This prints `Some("Steve")`: we’ve bound the inner `name` to `a`.-->
これは `Some("Steve")` を出力します。内側の `name` の値への参照に `a` を束縛します。

<!-- If you use `@` with `|`, you need to make sure the name is bound in each part
of the pattern: -->
`@` を `|` と組み合わせて使う場合は、それぞれのパターンで同じ名前が束縛されるようにする必要があります：

```rust
let x = 5;

match x {
    e @ 1 ... 5 | e @ 8 ... 10 => println!("got a range element {}", e),
    _ => println!("anything"),
}
```

<!-- # Guards -->
# ガード

<!--You can introduce ‘match guards’ with `if`: -->
`if` を使うことでマッチガードを導入することができます：

```rust
enum OptionalInt {
    Value(i32),
    Missing,
}

let x = OptionalInt::Value(5);

match x {
    OptionalInt::Value(i) if i > 5 => println!("Got an int bigger than five!"),
    OptionalInt::Value(..) => println!("Got an int!"),
    OptionalInt::Missing => println!("No such luck."),
}
```

<!--This prints `Got an int!`. -->
これは `Got an int!` を出力します。

<!--If you’re using `if` with multiple patterns, the `if` applies to both sides:-->
複式パターンで `if` を使うと、 `if` は `|` の両側に適用されます：

```rust
let x = 4;
let y = false;

match x {
    4 | 5 if y => println!("yes"),
    _ => println!("no"),
}
```

<!--This prints `no`, because the `if` applies to the whole of `4 | 5`, and not to
just the `5`. In other words, the precedence of `if` behaves like this: -->
これは `no` を出力します。なぜなら `if` は `4 | 5` 全体に適用されるのであって、 `5` 単独に対して適用されるのではないからです。つまり `if` 節は以下のように振舞います：

```text
(4 | 5) if y => ...
```

<!--not this: -->
次のようには解釈されません：

```text
4 | (5 if y) => ...
```

<!-- # Mix and Match -->
# 混ぜてマッチ

<!--Whew! That’s a lot of different ways to match things, and they can all be
mixed and matched, depending on what you’re doing: -->
ふう、マッチには様々な方法があるのですね。やりたいことに応じて、それらを混ぜてマッチさせることもできます：

```rust,ignore
match x {
    Foo { x: Some(ref name), y: None } => ...
}
```

<!-- Patterns are very powerful. Make good use of them. -->
パターンはとても強力です。上手に使いましょう。
