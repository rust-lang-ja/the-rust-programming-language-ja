% 列挙型
<!-- % Enums -->

<!-- An `enum` in Rust is a type that represents data that could be one of
several possible variants: -->
Rustの `enum` は、いくつかのヴァリアントのうちからどれか一つをとるデータを表す型です。

```rust
enum Message {
    Quit,
    ChangeColor(i32, i32, i32),
    Move { x: i32, y: i32 },
    Write(String),
}
```

<!-- Each variant can optionally have data associated with it. The syntax for
defining variants resembles the syntaxes used to define structs: you can
have variants with no data (like unit-like structs), variants with named
data, and variants with unnamed data (like tuple structs). Unlike
separate struct definitions, however, an `enum` is a single type. A
value of the enum can match any of the variants. For this reason, an
enum is sometimes called a ‘sum type’: the set of possible values of the
enum is the sum of the sets of possible values for each variant. -->
各ヴァリアントは、自身に関連するデータを持つこともできます。
ヴァリアントの定義のための構文は、構造体を定義するのに使われる構文と似ており、
（unit-like構造体のような）データを持たないヴァリアント、名前付きデータを持つヴァリアント、（タプル構造体のような）名前なしデータを持つヴァリアントがありえます。
しかし、別々に構造体を定義する場合とは異なり、 `enum` は一つの型です。
列挙型の値はどのヴァリアントにもマッチしうるのです。
このことから、列挙型は「直和型」(sum type) と呼ばれることもあります。
列挙型としてとりうる値の集合は、各ヴァリアントとしてとりうる値の集合の和であるためです。

<!-- We use the `::` syntax to use the name of each variant: they’re scoped by the name
of the `enum` itself. This allows both of these to work: -->
各ヴァリアントの名前を使うためには、 `::` 構文を使います。
すなわち、ヴァリアントの名前は `enum` 自体の名前によってスコープ化されています。
これにより、以下のどちらもうまく動きます。

```rust
# enum Message {
#     Move { x: i32, y: i32 },
# }
let x: Message = Message::Move { x: 3, y: 4 };

enum BoardGameTurn {
    Move { squares: i32 },
    Pass,
}

let y: BoardGameTurn = BoardGameTurn::Move { squares: 1 };
```

<!-- Both variants are named `Move`, but since they’re scoped to the name of
the enum, they can both be used without conflict. -->
どちらのヴァリアントも `Move` という名前ですが、列挙型の名前でスコープ化されているため、衝突することなく使うことができます。

<!-- A value of an enum type contains information about which variant it is,
in addition to any data associated with that variant. This is sometimes
referred to as a ‘tagged union’, since the data includes a ‘tag’
indicating what type it is. The compiler uses this information to
enforce that you’re accessing the data in the enum safely. For instance,
you can’t simply try to destructure a value as if it were one of the
possible variants: -->
列挙型の値は、ヴァリアントに関連するデータに加え、その値自身がどのヴァリアントであるかという情報を持っています。
これを「タグ付き共用体」(tagged union) ということもあります。
データが、それ自身がどの型なのかを示す「タグ」をもっているためです。
コンパイラはこの情報を用いて、列挙型内のデータへ安全にアクセスすることを強制します。
例えば、値をどれか一つのヴァリアントであるかのようにみなして、その中身を取り出すということはできません。

```rust,ignore
fn process_color_change(msg: Message) {
# //    let Message::ChangeColor(r, g, b) = msg; // compile-time error
    let Message::ChangeColor(r, g, b) = msg; // コンパイル時エラー
}
```

<!-- Not supporting these operations may seem rather limiting, but it’s a limitation
which we can overcome. There are two ways: by implementing equality ourselves,
or by pattern matching variants with [`match`][match] expressions, which you’ll
learn in the next section. We don’t know enough about Rust to implement
equality yet, but we’ll find out in the [`traits`][traits] section. -->
こういった操作が許されないことで制限されているように感じられるかもしれませんが、この制限は克服できます。
それには二つの方法があります。
一つは等値性を自分で実装する方法、もう一つは次のセクションで学ぶ [`match`][match] 式でヴァリアントのパターンマッチを行う方法です。
等値性を実装する方法についてはまだ説明していませんが、 [`トレイト`][traits] のセクションに書いてあります。

[match]: match.html
[if-let]: if-let.html
[traits]: traits.html

<!-- # Constructors as functions -->
# 関数としてのコンストラクタ

<!-- An enum’s constructors can also be used like functions. For example: -->
列挙型のコンストラクタも、関数のように使うことができます。
例えばこうです。

```rust
# enum Message {
# Write(String),
# }
let m = Message::Write("Hello, world".to_string());
```

<!-- Is the same as -->
これは、以下と同じです。

```rust
# enum Message {
# Write(String),
# }
fn foo(x: String) -> Message {
    Message::Write(x)
}

let x = foo("Hello, world".to_string());
```

<!-- This is not immediately useful to us, but when we get to
[`closures`][closures], we’ll talk about passing functions as arguments to
other functions. For example, with [`iterators`][iterators], we can do this
to convert a vector of `String`s into a vector of `Message::Write`s: -->
このことは今すぐ役立つことではないのですが、[`クロージャ`][closures] のセクションでは関数を他の関数へ引数として渡す話をします。
例えば、これを [`イテレータ`][iterators] とあわせることで、 `String` のベクタから `Message::Write` のベクタへ変換することができます。

```rust
# enum Message {
# Write(String),
# }

let v = vec!["Hello".to_string(), "World".to_string()];

let v1: Vec<Message> = v.into_iter().map(Message::Write).collect();
```

[closures]: closures.html
[iterators]: iterators.html
