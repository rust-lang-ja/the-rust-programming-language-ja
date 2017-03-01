% メソッド構文
<!-- % Method Syntax -->

<!-- Functions are great, but if you want to call a bunch of them on some data, it -->
<!-- can be awkward. Consider this code: -->
関数は素晴らしいのですが、幾つかのデータに対し複数の関数をまとめて呼び出したい時、困ったことになります。
以下のコードについて考えてみます。

```rust,ignore
baz(bar(foo));
```

<!-- We would read this left-to-right, and so we see ‘baz bar foo’. But this isn’t the -->
<!-- order that the functions would get called in, that’s inside-out: ‘foo bar baz’. -->
<!-- Wouldn’t it be nice if we could do this instead? -->
私たちはこれを左から右へ、「baz bar foo」と読むことになりますが、関数が呼び出される順番は異なり、内側から外へ「foo bar baz」となります。
もし代わりにこうできたらいいとは思いませんか?

```rust,ignore
foo.bar().baz();
```

<!-- Luckily, as you may have guessed with the leading question, you can! Rust provides -->
<!-- the ability to use this ‘method call syntax’ via the `impl` keyword. -->
最初の質問でもう分かっているかもしれませんが、幸いにもこれは可能です！
Rustは `impl` キーワードによってこの「メソッド呼び出し構文」の機能を提供しています。

<!-- # Method calls -->
# メソッド呼び出し

<!-- Here’s how it works: -->
どんな風に動作するかが以下になります。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }
}

fn main() {
    let c = Circle { x: 0.0, y: 0.0, radius: 2.0 };
    println!("{}", c.area());
}
```

<!-- This will print `12.566371`. -->
これは `12.566371` と出力します。

<!-- We’ve made a `struct` that represents a circle. We then write an `impl` block, -->
<!-- and inside it, define a method, `area`. -->
私たちは円を表す `struct` を作りました。
その際 `impl` ブロックを書き、その中に `area` というメソッドを定義しています。

<!-- Methods take a special first parameter, of which there are three variants: -->
<!-- `self`, `&self`, and `&mut self`. You can think of this first parameter as -->
<!-- being the `foo` in `foo.bar()`. The three variants correspond to the three -->
<!-- kinds of things `foo` could be: `self` if it’s just a value on the stack, -->
<!-- `&self` if it’s a reference, and `&mut self` if it’s a mutable reference. -->
<!-- Because we took the `&self` parameter to `area`, we can use it just like any -->
<!-- other parameter. Because we know it’s a `Circle`, we can access the `radius` -->
<!-- just like we would with any other `struct`. -->
メソッドに渡す特別な第1引数として、 `self` 、 `&self` 、 `&mut self` という3つの変形があります。
第一引数は `foo.bar()` に於ける `foo` だと考えて下さい。
3つの変形は `foo` が成り得る3種類の状態に対応しており、それぞれ `self` がスタック上の値である場合、 `&self` が参照である場合、 `&mut self` がミュータブルな参照である場合となっています。
`area` では `&self` を受け取っているため、他の引数と同じように扱えます。
引数が `Circle` であるのは分かっていますから、他の `struct` でするように `radius` へアクセスできます。

<!-- We should default to using `&self`, as you should prefer borrowing over taking -->
<!-- ownership, as well as taking immutable references over mutable ones. Here’s an -->
<!-- example of all three variants: -->
所有権を渡すよりも借用を好んで使うべきなのは勿論のこと、ミュータブルな参照よりもイミュータブルな参照を渡すべきですから、 `&self` を常用すべきです。以下が3種類全ての例です。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn reference(&self) {
       println!("taking self by reference!");
    }

    fn mutable_reference(&mut self) {
       println!("taking self by mutable reference!");
    }

    fn takes_ownership(self) {
       println!("taking ownership of self!");
    }
}
```

<!--You can use as many `impl` blocks as you’d like. The previous example could -->
<!-- have also been written like this: -->
好きな数だけ `impl` ブロックを使用することができます。
前述の例は以下のように書くこともできるでしょう。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn reference(&self) {
       println!("taking self by reference!");
    }
}

impl Circle {
    fn mutable_reference(&mut self) {
       println!("taking self by mutable reference!");
    }
}

impl Circle {
    fn takes_ownership(self) {
       println!("taking ownership of self!");
    }
}
```

<!-- # Chaining method calls -->
# メソッドチェーン

<!-- So, now we know how to call a method, such as `foo.bar()`. But what about our -->
<!-- original example, `foo.bar().baz()`? This is called ‘method chaining’. Let’s -->
<!-- look at an example: -->
ここまでで、`foo.bar()` というようなメソッドの呼び出し方が分かりましたね。
ですが元の例の `foo.bar().baz()` はどうなっているのでしょう？
これは「メソッドチェーン」と呼ばれています。
以下の例を見て下さい。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }

    fn grow(&self, increment: f64) -> Circle {
        Circle { x: self.x, y: self.y, radius: self.radius + increment }
    }
}

fn main() {
    let c = Circle { x: 0.0, y: 0.0, radius: 2.0 };
    println!("{}", c.area());

    let d = c.grow(2.0).area();
    println!("{}", d);
}
```

<!-- Check the return type: -->
以下の返す型を確認して下さい。

```rust
# struct Circle;
# impl Circle {
fn grow(&self, increment: f64) -> Circle {
# Circle } }
```

<!-- We just say we’re returning a `Circle`. With this method, we can grow a new -->
<!-- `Circle` to any arbitrary size. -->
単に `Circle` を返しているだけです。
このメソッドにより、私たちは新しい `Circle` を任意の大きさに拡大することができます。

<!-- # Associated functions -->
# 関連関数

<!-- You can also define associated functions that do not take a `self` parameter. -->
<!-- Here’s a pattern that’s very common in Rust code: -->
あなたは `self` を引数に取らない関連関数を定義することもできます。
以下のパターンはRustのコードにおいて非常にありふれた物です。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn new(x: f64, y: f64, radius: f64) -> Circle {
        Circle {
            x: x,
            y: y,
            radius: radius,
        }
    }
}

fn main() {
    let c = Circle::new(0.0, 0.0, 2.0);
}
```

<!-- This ‘associated function’ builds a new `Circle` for us. Note that associated -->
<!-- functions are called with the `Struct::function()` syntax, rather than the -->
<!-- `ref.method()` syntax. Some other languages call associated functions ‘static -->
<!-- methods’. -->
この「関連関数」(associated function)は新たに `Circle` を構築します。
この関数は `ref.method()` ではなく、 `Struct::function()` という構文で呼び出されることに注意して下さい。
幾つかの言語では、関連関数を「静的メソッド」(static methods)と呼んでいます。

<!-- # Builder Pattern -->
# Builderパターン

<!-- Let’s say that we want our users to be able to create `Circle`s, but we will -->
<!-- allow them to only set the properties they care about. Otherwise, the `x` -->
<!-- and `y` attributes will be `0.0`, and the `radius` will be `1.0`. Rust doesn’t -->
<!-- have method overloading, named arguments, or variable arguments. We employ -->
<!-- the builder pattern instead. It looks like this: -->
ユーザが `Circle` を作成できるようにしつつも、書き換えたいプロパティだけを設定すれば良いようにしたいとしましょう。
もし指定が無ければ `x` と `y` が `0.0` 、 `radius` が `1.0` であるものとします。
Rustはメソッドのオーバーロードや名前付き引数、可変個引数といった機能がない代わりにBuilderパターンを採用しており、それは以下のようになります。

```rust
struct Circle {
    x: f64,
    y: f64,
    radius: f64,
}

impl Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * (self.radius * self.radius)
    }
}

struct CircleBuilder {
    x: f64,
    y: f64,
    radius: f64,
}

impl CircleBuilder {
    fn new() -> CircleBuilder {
        CircleBuilder { x: 0.0, y: 0.0, radius: 1.0, }
    }

    fn x(&mut self, coordinate: f64) -> &mut CircleBuilder {
        self.x = coordinate;
        self
    }

    fn y(&mut self, coordinate: f64) -> &mut CircleBuilder {
        self.y = coordinate;
        self
    }

    fn radius(&mut self, radius: f64) -> &mut CircleBuilder {
        self.radius = radius;
        self
    }

    fn finalize(&self) -> Circle {
        Circle { x: self.x, y: self.y, radius: self.radius }
    }
}

fn main() {
    let c = CircleBuilder::new()
                .x(1.0)
                .y(2.0)
                .radius(2.0)
                .finalize();

    println!("area: {}", c.area());
    println!("x: {}", c.x);
    println!("y: {}", c.y);
}
```

<!-- What we’ve done here is make another `struct`, `CircleBuilder`. We’ve defined our -->
<!-- builder methods on it. We’ve also defined our `area()` method on `Circle`. We -->
<!-- also made one more method on `CircleBuilder`: `finalize()`. This method creates -->
<!-- our final `Circle` from the builder. Now, we’ve used the type system to enforce -->
<!-- our concerns: we can use the methods on `CircleBuilder` to constrain making -->
<!-- `Circle`s in any way we choose. -->
ここではもう1つの `struct` である `CircleBuilder` を作成しています。
その中にBuilderメソッドを定義しました。
また `Circle` に `area()` メソッドを定義しました。
そして `CircleBuilder` にもう1つ `finalize()` というメソッドを作りました。
このメソッドはBuilderから最終的な `Circle` を作成します。
さて、先程の要求を実施するために型システムを使いました。
`CircleBuilder` のメソッドを好きなように組み合わせ、作る `Circle` への制約を与えることができます。
