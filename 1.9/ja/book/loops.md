% ループ
<!-- % Loops -->

<!-- Rust currently provides three approaches to performing some kind of iterative activity. They are: `loop`, `while` and `for`. Each approach has its own set of uses. -->
現在、Rustは、なんらかの繰り返しを伴う処理に対して、3種類の手法: `loop`, `while`, `for` を提供しています。
各アプローチにはそれぞれの使い方があります。

## loop

<!-- The infinite `loop` is the simplest form of loop available in Rust. Using the keyword `loop`, Rust provides a way to loop indefinitely until some terminating statement is reached. Rust's infinite `loop`s look like this: -->
Rustで使えるループのなかで最もシンプルな形式が、無限 `loop` です。Rustのキーワード `loop` によって、
何らかの終了状態に到達するまで 延々とループし続ける手段を提供します。Rustの無限 `loop` は次の通りです:

```rust,ignore
loop {
    println!("Loop forever!");
}
```

## while

<!-- Rust also has a `while` loop. It looks like this: -->
Rustには `while` ループもあります。次の通りです:

```rust
let mut x = 5; // mut x: i32
let mut done = false; // mut done: bool

while !done {
    x += x - 3;

    println!("{}", x);

    if x % 5 == 0 {
        done = true;
    }
}
```

<!-- `while` loops are the correct choice when you’re not sure how many times -->
<!-- you need to loop. -->
何回ループする必要があるか明らかではない状況では、`while` ループは正しい選択です。

<!-- If you need an infinite loop, you may be tempted to write this: -->
無限ループの必要があるとき、次のように書きたくなるかもしれません:

```rust,ignore
while true {
```

<!-- However, `loop` is far better suited to handle this case: -->
しかし、 `loop`は、 こういった場合に はるかに適しています。

```rust,ignore
loop {
```

<!-- Rust’s control-flow analysis treats this construct differently than a `while -->
<!-- true`, since we know that it will always loop. In general, the more information -->
<!-- we can give to the compiler, the better it can do with safety and code -->
<!-- generation, so you should always prefer `loop` when you plan to loop -->
<!-- infinitely. -->
Rustの制御フロー解析では、必ずループすると知っていることから、これを `while true` とは異なる構造として扱います。
一般に、コンパイラへ与える情報量が多いほど、安全性が高くより良いコード生成につながるため、
無限にループするつもりであれば、常に `loop` を使うべきです。


## for

<!-- The `for` loop is used to loop a particular number of times. Rust’s `for` loops -->
<!-- work a bit differently than in other systems languages, however. Rust’s `for` -->
<!-- loop doesn’t look like this “C-style” `for` loop: -->

特定の回数だけループするときには `for` ループを使います。しかし、Rustの `for` ループは他のシステムプログラミング言語のそれとは少し異なる働きをします。 Rustの `for` ループは、次のような「Cスタイル」 `for` ループとは似ていません:

```c
for (x = 0; x < 10; x++) {
    printf( "%d\n", x );
}
```

<!-- Instead, it looks like this: -->
代わりに、このように書きます:

```rust
for x in 0..10 {
    println!("{}", x); // x: i32
}
```

<!-- In slightly more abstract terms, -->
もう少し抽象的な用語を使うと、

```ignore
for var in expression {
    code
}
```

<!-- The expression is an item that can be converted into an [iterator] using -->
<!-- [`IntoIterator`]. The iterator gives back a series of elements. Each element is -->
<!-- one iteration of the loop. That value is then bound to the name `var`, which is -->
<!-- valid for the loop body. Once the body is over, the next value is fetched from -->
<!-- the iterator, and we loop another time. When there are no more values, the `for` -->
<!-- loop is over. -->
式(expression)は[`IntoIterator`]を用いて[イテレータ][iterator]へと変換することができるアイテムです。
イテレータは一連の要素を返します。それぞれの要素がループの1回の反復になります。 その値は、ループ本体に有効な名前, `var` に束縛されています。いったんループ本体を抜けると、次の値がイテレータから取り出され、次のループ処理を行います。それ以上の値が存在しない時は、`for` ループは終了します。

[iterator]: iterators.html
[`IntoIterator`]: ../std/iter/trait.IntoIterator.html

<!-- In our example, `0..10` is an expression that takes a start and an end position, -->
<!-- and gives an iterator over those values. The upper bound is exclusive, though, -->
<!-- so our loop will print `0` through `9`, not `10`. -->
この例では、`0..10` が開始と終了位置をとる式であり、同範囲の値を返すイテレータを与えます。
上限はその値自身を含まないため、このループは `0` から `9` までを表示します。 `10` ではありません。

<!-- Rust does not have the “C-style” `for` loop on purpose. Manually controlling -->
<!-- each element of the loop is complicated and error prone, even for experienced C -->
<!-- developers. -->
Rustでは意図的に「Cスタイル」 `for` ループを持ちません。経験豊富なC言語の開発者でさえ、
ループの各要素を手動で制御することは複雑であり、また間違いを犯しやすいのです。

<!-- ### Enumerate -->
### 列挙

<!-- When you need to keep track of how many times you already looped, you can use the `.enumerate()` function. -->
ループの中で何回目の繰り返しかを把握する必要がある時、 `.enumerate()` 関数が使えます。

<!-- #### On ranges: -->
#### レンジを対象に:

```rust
for (i,j) in (5..10).enumerate() {
    println!("i = {} and j = {}", i, j);
}
```

<!-- Outputs: -->
出力:

```text
i = 0 and j = 5
i = 1 and j = 6
i = 2 and j = 7
i = 3 and j = 8
i = 4 and j = 9
```

<!-- Don't forget to add the parentheses around the range. -->
レンジを括弧で囲うのを忘れないで下さい。

<!-- #### On iterators: -->
#### イテレータを対象に:

```rust
let lines = "hello\nworld".lines();

for (linenumber, line) in lines.enumerate() {
    println!("{}: {}", linenumber, line);
}
```

<!-- Outputs: -->
出力:

```text
0: hello
1: world
```

<!-- ## Ending iteration early -->
## 反復の早期終了

<!-- Let’s take a look at that `while` loop we had earlier: -->
さきほどの `while` ループを見てみましょう:

```rust
let mut x = 5;
let mut done = false;

while !done {
    x += x - 3;

    println!("{}", x);

    if x % 5 == 0 {
        done = true;
    }
}
```

<!-- We had to keep a dedicated `mut` boolean variable binding, `done`, to know -->
<!-- when we should exit out of the loop. Rust has two keywords to help us with -->
<!-- modifying iteration: `break` and `continue`. -->

ループを終了する時を知るために、、専用の `mut`であるboolean変数束縛, `done` を使わなければなりませんでした。
Rustには反復の変更を手伝けする2つのキーワード: `break` と `continue` があります。

<!-- In this case, we can write the loop in a better way with `break`: -->
この例では、 `break` を使ってループを記述した方が良いでしょう:

```rust
let mut x = 5;

loop {
    x += x - 3;

    println!("{}", x);

    if x % 5 == 0 { break; }
}
```

<!-- We now loop forever with `loop` and use `break` to break out early. Issuing an explicit `return` statement will also serve to terminate the loop early. -->
ここでは `loop` による永久ループと 早期にループを抜けるため `break` を使っています。
明示的な `return` 文の発行でもループを早期に終了します。

<!-- `continue` is similar, but instead of ending the loop, goes to the next -->
<!-- iteration. This will only print the odd numbers: -->
`continue` も似ていますが、ループを終了させるのではなく、次の反復へと進めます。
これは奇数だけを表示するでしょう:

```rust
for x in 0..10 {
    if x % 2 == 0 { continue; }

    println!("{}", x);
}
```

<!-- ## Loop labels -->
## ループラベル

<!-- You may also encounter situations where you have nested loops and need to -->
<!-- specify which one your `break` or `continue` statement is for. Like most -->
<!-- other languages, by default a `break` or `continue` will apply to innermost -->
<!-- loop. In a situation where you would like to `break` or `continue` for one -->
<!-- of the outer loops, you can use labels to specify which loop the `break` or -->
<!--  `continue` statement applies to. This will only print when both `x` and `y` are -->
<!--  odd: -->
入れ子のループがあり、`break` や `continue` 文がどのループに対応するか指定する必要がある、
そのような状況に出会うかもしれません。大抵の他言語と同様に、 デフォルトで `break` や `continue` は最内ループに適用されます。
外側のループに `break` や `continue` を使いたいという状況では、 `break` や `continue` 文の適用先を指定するラベルを使えます。これは `x` と `y` 両方がともに奇数のときだけ表示を行います:

```rust
'outer: for x in 0..10 {
    'inner: for y in 0..10 {
# //    if x % 2 == 0 { continue 'outer; } // continues the loop over x
        if x % 2 == 0 { continue 'outer; } // x のループを継続
# //    if y % 2 == 0 { continue 'inner; } // continues the loop over y
        if y % 2 == 0 { continue 'inner; } // y のループを継続
        println!("x: {}, y: {}", x, y);
    }
}
```
