% マッチ
<!-- % Match -->

<!-- Often, a simple [`if`][if]/`else` isn’t enough, because you have more than two -->
<!-- possible options. Also, conditions can get quite complex. Rust -->
<!-- has a keyword, `match`, that allows you to replace complicated `if`/`else` -->
<!-- groupings with something more powerful. Check it out: -->
しばしば、２つ以上の可能な処理が存在するためや、分岐条件が非常に複雑になるために単純な [`if`][if]/`else` では充分でない場合があります。
Rustにはキーワード `match` が存在し、複雑な `if`/`else` のグループをさらに強力なもので置き換えられます。
以下の例を見てみましょう:

```rust
let x = 5;

match x {
    1 => println!("one"),
    2 => println!("two"),
    3 => println!("three"),
    4 => println!("four"),
    5 => println!("five"),
    _ => println!("something else"),
}
```

[if]: if.html

<!-- `match` takes an expression and then branches based on its value. Each ‘arm’ of -->
<!-- the branch is of the form `val => expression`. When the value matches, that arm’s -->
<!-- expression will be evaluated. It’s called `match` because of the term ‘pattern -->
<!-- matching’, which `match` is an implementation of. There’s an [entire section on -->
<!-- patterns][patterns] that covers all the patterns that are possible here. -->
`match` は一つの式とその式の値に基づく複数のブランチを取ります。
一つ一つの「腕」は `val => expression` という形式を取ります。
値がマッチした時に、対応する腕の式が評価されます。
このような式が `match` と呼ばれるのは「パターンマッチ」という用語に由来します。
[パターン][patterns] のセクションではこの部分に書けるすべてのパターンを説明しています。

[patterns]: patterns.html

<!-- So what’s the big advantage? Well, there are a few. First of all, `match` -->
<!-- enforces ‘exhaustiveness checking’. Do you see that last arm, the one with the -->
<!-- underscore (`_`)? If we remove that arm, Rust will give us an error: -->
`match` を使う利点は何でしょうか？ いくつか有りますが、
まず一つ目としては `match` をつかうことで、「網羅性検査」が実施されます。
上のコードで、最後のアンダースコア( `_` )を用いている腕があるのがわかりますか？
もし、その腕を削除した場合、Rustは以下の様なエラーを発生させます:

```text
error: non-exhaustive patterns: `_` not covered
```

<!-- In other words, Rust is trying to tell us we forgot a value. Because `x` is an -->
<!-- integer, Rust knows that it can have a number of different values – for -->
<!-- example, `6`. Without the `_`, however, there is no arm that could match, and -->
<!-- so Rust refuses to compile the code. `_` acts like a ‘catch-all arm’. If none -->
<!-- of the other arms match, the arm with `_` will, and since we have this -->
<!-- catch-all arm, we now have an arm for every possible value of `x`, and so our -->
<!-- program will compile successfully. -->
言い換えると、Rustは値を忘れていることを伝えようとしているのです。
なぜなら `x` は整数であるため、Rustは `x` は多くの異なる値を取ることができることを知っています。
例えば、 `6` などがそれに当たります。
もし `_` がなかった場合、 `6` にマッチする腕が存在しない事になります、そのためRustはコンパイルを通しません。
`_` は「全てキャッチする腕」のように振る舞います。
もし他の腕がどれもマッチしなかった場合、 `_` の腕が実行されることになります、
この「全てキャッチする腕」が存在するため、 `x` が取り得るすべての値について対応する腕が存在することになり、コンパイルが成功します。

<!-- `match` is also an expression, which means we can use it on the right-hand -->
<!-- side of a `let` binding or directly where an expression is used: -->
`match` は式でもあります、これはつまり `let` 束縛の右側や式が使われているところで利用することができるということを意味しています。

```rust
let x = 5;

let number = match x {
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    _ => "something else",
};
```

<!-- Sometimes it’s a nice way of converting something from one type to another. -->
このようにして、ある型から他の型への変換がうまく書ける場合があります。

<!-- # Matching on enums -->
# 列挙型に対するマッチ

<!-- Another important use of the `match` keyword is to process the possible -->
<!-- variants of an enum: -->
`match` の他の重要な利用方法としては列挙型のバリアントを処理することがあります:

```rust
enum Message {
    Quit,
    ChangeColor(i32, i32, i32),
    Move { x: i32, y: i32 },
    Write(String),
}

fn quit() { /* ... */ }
fn change_color(r: i32, g: i32, b: i32) { /* ... */ }
fn move_cursor(x: i32, y: i32) { /* ... */ }

fn process_message(msg: Message) {
    match msg {
        Message::Quit => quit(),
        Message::ChangeColor(r, g, b) => change_color(r, g, b),
        Message::Move { x: x, y: y } => move_cursor(x, y),
        Message::Write(s) => println!("{}", s),
    };
}
```

<!-- Again, the Rust compiler checks exhaustiveness, so it demands that you -->
<!-- have a match arm for every variant of the enum. If you leave one off, it -->
<!-- will give you a compile-time error unless you use `_`. -->
繰り返しになりますが、Rustコンパイラは網羅性のチェックを行い、列挙型のすべてのバリアントに対して、マッチする腕が存在することを要求します。
もし、一つでもマッチする腕のないバリアントを残している場合、 `_` を用いなければコンパイルエラーが発生します。

<!-- Unlike the previous uses of `match`, you can’t use the normal `if` -->
<!-- statement to do this. You can use the [`if let`][if-let] statement, -->
<!-- which can be seen as an abbreviated form of `match`. -->
先ほど説明した値に対する `match` の利用とは異なり、列挙型のバリアントに基いた分岐に `if` を用いることはできません。
列挙型のバリアントに基いた分岐には [`if let`][if-let] 文を用いることが可能です。 `if let` は `match` の短縮形と捉えることができます。

[if-let]: if-let.html
