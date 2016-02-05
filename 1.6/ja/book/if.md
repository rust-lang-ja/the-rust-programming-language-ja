% if
<!-- % if -->

<!-- Rust’s take on `if` is not particularly complex, but it’s much more like the -->
<!-- `if` you’ll find in a dynamically typed language than in a more traditional -->
<!-- systems language. So let’s talk about it, to make sure you grasp the nuances. -->
Rustにおける `if` の扱いはさほど複雑ではありませんが、伝統的なシステムプログラミング言語のそれに比べて、
動的型付け言語でみられる `if` にずっと近いものになっています。そのニュアンスをしっかり理解できるよう、
さっそく説明していきましょう。

<!-- `if` is a specific form of a more general concept, the ‘branch’. The name comes -->
<!-- from a branch in a tree: a decision point, where depending on a choice, -->
<!-- multiple paths can be taken. -->
`if` は一般化されたコンセプト、「分岐(branch)」の特別な形式です。この名前は木の枝(branch)を由来とし:
取りうる複数のパスから、選択の決定を行うポイントを表します。

<!-- In the case of `if`, there is one choice that leads down two paths: -->
`if` の場合は、続く2つのパスから1つを選択します。

```rust
let x = 5;

if x == 5 {
# // println!("x is five!");
    println!("x は 5 です!");
}
```

<!-- If we changed the value of `x` to something else, this line would not print. -->
<!-- More specifically, if the expression after the `if` evaluates to `true`, then -->
<!-- the block is executed. If it’s `false`, then it is not. -->
仮に `x` を別の値へと変更すると、この行は表示されません。より正確に言うなら、
`if` のあとにくる式が `true` に評価された場合に、ブロックが実行されます。
`false` の場合、ブロックは実行されません。

<!-- If you want something to happen in the `false` case, use an `else`: -->
`false` の場合にも何かをしたいなら、 `else` を使います:

```rust
let x = 5;

if x == 5 {
# // println!("x is five!");
    println!("x は 5 です!");
} else {
# // println!("x is not five :(");
    println!("x は 5 ではありません :(");
}
```

<!-- If there is more than one case, use an `else if`: -->
場合分けが複数あるときは、 `else if` を使います:

```rust
let x = 5;

if x == 5 {
# // println!("x is five!");
    println!("x は 5 です!");
} else if x == 6 {
# // println!("x is six!");
    println!("x は 6 です!");
} else {
# // println!("x is not five or six :(");
    println!("x は 5 でも 6 でもありません :(");
}
```

<!-- This is all pretty standard. However, you can also do this: -->
全くもって普通ですね。しかし、次のような使い方もできるのです:

```rust
let x = 5;

let y = if x == 5 {
    10
} else {
    15
}; // y: i32
```

<!-- Which we can (and probably should) write like this: -->
次のように書くこともできます（そして、大抵はこう書くべきです）:

```rust
let x = 5;

let y = if x == 5 { 10 } else { 15 }; // y: i32
```

<!-- This works because `if` is an expression. The value of the expression is the -->
<!-- value of the last expression in whichever branch was chosen. An `if` without an -->
<!-- `else` always results in `()` as the value. -->
これが出来るのは `if` が式であるためです。その式の値は、選択された分岐中の最後の式の値となります。
`else` のない `if` では、その値は常に `()` となります。

