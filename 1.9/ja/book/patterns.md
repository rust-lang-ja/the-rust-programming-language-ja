% パターン
<!-- % Patterns -->

<!-- Patterns are quite common in Rust. We use them in [variable -->
<!-- bindings][bindings], [match expressions][match], and other places, too. Let’s go -->
<!-- on a whirlwind tour of all of the things patterns can do!-->
パターンはRustにおいて極めて一般的です。
パターンは [変数束縛][bindings], [マッチ文][match] などで使われています。
さあ、めくるめくパターンの旅を始めましょう！

[bindings]: variable-bindings.html
[match]: match.html

<!-- A quick refresher: you can match against literals directly, and `_` acts as an
‘any’ case: -->
簡単な復習：リテラルに対しては直接マッチ出来ます。
また、 `_` は「任意の」ケースとして振る舞います。

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

<!-- There’s one pitfall with patterns: like anything that introduces a new binding, -->
<!-- they introduce shadowing. For example: -->
パターンには一つ落とし穴があります。
新しい束縛を導入すると、他の束縛を導入するものと同じように、シャドーイングします。
例えば：

```rust
let x = 1;
let c = 'c';

match c {
    x => println!("x: {} c: {}", x, c),
}

println!("x: {}", x)
```

<!-- This prints:-->
これの結果は以下のようになります：

```text
x: c c: c
x: 1
```

<!-- In other words, `x =>` matches the pattern and introduces a new binding named -->
<!-- `x`. This new binding is in scope for the match arm and takes on the value of -->
<!-- `c`. Notice that the value of `x` outside the scope of the match has no bearing -->
<!-- on the value of `x` within it. Because we already have a binding named `x`, this -->
<!-- new `x` shadows it. -->
別の言い方をすると、 `x =>` はパターンへにマッチし `x` という名前の束縛を導入します。
この束縛はマッチの腕で有効で、 `c` の値を引き受けます。
マッチのスコープ外にある `x` は内部での `x` の値に関係していないことに注意して下さい。
既に `x` は束縛されていたので、この新しい `x` はそれを覆い隠します。

<!-- # Multiple patterns -->
# 複式パターン

<!-- You can match multiple patterns with `|`: -->
`|` を使うと、複式パターンが導入できます：


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
# デストラクチャリング

<!-- If you have a compound data type, like a [`struct`][struct], you can destructure it -->
<!-- inside of a pattern: -->
例えば [`struct`][struct] のような複合データ型があるとき、パターン内でデータを分解することができます。

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
値の一部だけを扱いたい場合は、値の全てに名前を付ける必要はありません。

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

<!-- You can do this kind of match on any member, not only the first: -->
最初のものだけでなく、どのメンバに対してもこの種のマッチを行うことができます。

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

<!-- This ‘destructuring’ behavior works on any compound data type, like -->
<!-- [tuples][tuples] or [enums][enums]. -->
この「デストラクチャリング(destructuring)」と呼ばれる振る舞いは、 [タプル][tuples] や [列挙型][enums] のような、複合データ型で使用できます。

[tuples]: primitive-types.html#tuples
[enums]: enums.html

<!-- # Ignoring bindings -->
# 束縛の無視

<!-- You can use `_` in a pattern to disregard the type and value.-->
<!-- For example, here’s a `match` against a `Result<T, E>`: -->
パターン内の型や値を無視するために `_` を使うことができます。
例として、 `Result<T, E>` に対して `match` を適用してみましょう：

```rust
# let some_value: Result<i32, &'static str> = Err("There was an error");
match some_value {
    Ok(value) => println!("got a value: {}", value),
    Err(_) => println!("an error occurred"),
}
```

<!-- In the first arm, we bind the value inside the `Ok` variant to `value`. But -->
<!-- in the `Err` arm, we use `_` to disregard the specific error, and print -->
<!-- a general error message. -->
最初の部分では `Ok` ヴァリアント内の値を `value` に束縛しています。
しかし `Err` 部分では、`_` を使って特定のエラーを無視し、一般的なエラーメッセージを表示しています。

<!-- `_` is valid in any pattern that creates a binding. This can be useful to -->
<!-- ignore parts of a larger structure: -->
`_` は束縛を伴うどんなパターンにおいても有効です。
これは大きな構造の一部分を無視する際に有用です。

```rust
fn coordinate() -> (i32, i32, i32) {
#     // generate and return some sort of triple tuple
    // 3要素のタプルを生成して返す
# (1, 2, 3)
}

let (x, _, z) = coordinate();
```

<!-- Here, we bind the first and last element of the tuple to `x` and `z`, but -->
<!-- ignore the middle element. -->
ここでは、タプルの最初と最後の要素を `x` と `z` に結びつけています。

<!-- It’s worth noting that using `_` never binds the value in the first place, -->
<!-- which means a value may not move: -->
`_` はそもそも値を束縛しない、つまり値がムーブしないということは特筆に値します。

```rust
let tuple: (u32, String) = (5, String::from("five"));

# // Here, tuple is moved, because the String moved:
// これだとタプルはムーブします。何故ならStringがムーブしているからです:
let (x, _s) = tuple;

# // The next line would give "error: use of partially moved value: `tuple`"
// この行は「error: use of partially moved value: `tuple`」を出します。
// println!("Tuple is: {:?}", tuple);

# // However,
// しかしながら、

let tuple = (5, String::from("five"));

# // Here, tuple is _not_ moved, as the String was never moved, and u32 is Copy:
// これだとタプルはムーブ _されません_ 。何故ならStringはムーブされず、u32はCopyだからです:
let (x, _) = tuple;

# // That means this works:
// つまりこれは動きます:
println!("Tuple is: {:?}", tuple);
```

<!-- This also means that any temporary variables will be dropped at the end of the -->
<!-- statement: -->
また、束縛されていない値は文の終わりでドロップされるということでもあります。

```rust
# // Here, the String created will be dropped immediately, as it’s not bound:
// 生成されたStringは束縛されていないので即座にドロップされる
let _ = String::from("  hello  ").trim();
```

<!-- You can also use `..` in a pattern to disregard multiple values: -->
複数の値を捨てるのには `..` パターンが使えます。

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
もし [リファレンス][ref] を取得したいときは `ref` キーワードを使いましょう。

```rust
let x = 5;

match x {
    ref r => println!("Got a reference to {}", r),
}
```

<!-- This prints `Got a reference to 5`. -->
これは `Got a reference to 5` を出力します。

[ref]: references-and-borrowing.html

<!-- Here, the `r` inside the `match` has the type `&i32`. In other words, the `ref` -->
<!-- keyword _creates_ a reference, for use in the pattern. If you need a mutable -->
<!-- reference, `ref mut` will work in the same way: -->
ここで `match` 内の `r` は `&i32` 型を持っています。
言い換えると `ref` キーワードがパターン内で使うリファレンスを _作ります_ 。
ミュータブルなリファレンスが必要なら、 `ref mut` が同じように動作します。

```rust
let mut x = 5;

match x {
    ref mut mr => println!("Got a mutable reference to {}", mr),
}
```

<!-- # Ranges -->
# レンジ

<!-- You can match a range of values with `...`: -->
`...` で値のレンジのマッチを行うことができます：

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
レンジは大体、整数か `char` 型で使われます：

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
`@` で値を名前に束縛することができます。

```rust
let x = 1;

match x {
    e @ 1 ... 5 => println!("got a range element {}", e),
    _ => println!("anything"),
}
```

<!-- This prints `got a range element 1`. This is useful when you want to -->
<!-- do a complicated match of part of a data structure: -->
これは `got a range element 1` を出力します。
データ構造の一部に対する複雑なマッチが欲しいときに有用です：

```rust
#[derive(Debug)]
struct Person {
    name: Option<String>,
}

let name = "Steve".to_string();
let x: Option<Person> = Some(Person { name: Some(name) });
match x {
    Some(Person { name: ref a @ Some(_), .. }) => println!("{:?}", a),
    _ => {}
}
```

<!-- This prints `Some("Steve")`: we’ve bound the inner `name` to `a`.-->
これは `Some("Steve")` を出力します。内側の `name` を `a` に結びつけます。

<!-- If you use `@` with `|`, you need to make sure the name is bound in each part -->
<!-- of the pattern: -->
もし `|` で `@` を使うときは、必ずそれぞれのパターンが名前と結びついている必要があります。

```rust
let x = 5;

match x {
    e @ 1 ... 5 | e @ 8 ... 10 => println!("got a range element {}", e),
    _ => println!("anything"),
}
```

<!-- # Guards -->
# ガード

<!-- You can introduce ‘match guards’ with `if`: -->
`if` を使うことで「マッチガード」を導入することができます：

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

<!-- This prints `Got an int!`. -->
これは `Got an int!` を出力します。

<!-- If you’re using `if` with multiple patterns, the `if` applies to both sides: -->
複式パターンで `if` を使うと、 `if` は両方に適用されます：

```rust
let x = 4;
let y = false;

match x {
    4 | 5 if y => println!("yes"),
    _ => println!("no"),
}
```

<!-- This prints `no`, because the `if` applies to the whole of `4 | 5`, and not to -->
<!-- only the `5`. In other words, the precedence of `if` behaves like this: -->
これは `no` を出力します。なぜなら `if` は `4 | 5` 全体に適用されるのであって、 `5` 単独に対してではないからです。つまり `if` 節は以下のように振舞います：

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

<!-- Whew! That’s a lot of different ways to match things, and they can all be -->
<!-- mixed and matched, depending on what you’re doing: -->
ふう、マッチには様々な方法があるのですね。やりたいこと次第で、それらを混ぜてマッチさせることもできます：

```rust,ignore
match x {
    Foo { x: Some(ref name), y: None } => ...
}
```

<!-- Patterns are very powerful. Make good use of them. -->
パターンはとても強力です。上手に使いましょう。
