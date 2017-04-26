% 構造体
<!-- % Structs -->

<!-- `struct`s are a way of creating more complex data types. For example, if we were
doing calculations involving coordinates in 2D space, we would need both an `x`
and a `y` value: -->
`struct` はより複雑なデータ型を作る方法の1つです。例えば、もし私たちが2次元空間の座標に関する計算を行っているとして、 `x` と `y` 、両方の値が必要になるでしょう。

```rust
let origin_x = 0;
let origin_y = 0;
```

<!-- A `struct` lets us combine these two into a single, unified datatype: -->
`struct` でこれら2つを1つのデータ型にまとめることができます。

```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let origin = Point { x: 0, y: 0 }; // origin: Point

    println!("The origin is at ({}, {})", origin.x, origin.y);
}
```

<!-- There’s a lot going on here, so let’s break it down. We declare a `struct` with
the `struct` keyword, and then with a name. By convention, `struct`s begin with
a capital letter and are camel cased: `PointInSpace`, not `Point_In_Space`. -->
ここで多くの情報が出てきましたから、順番に見ていきましょう。まず、 `struct` キーワードを使って構造体とその名前を宣言しています。慣習により、構造体は初めが大文字のキャメルケースで記述しています。 `PointInSpace` であり、 `Point_In_Space` ではありません。

<!-- We can create an instance of our `struct` via `let`, as usual, but we use a `key:
value` style syntax to set each field. The order doesn’t need to be the same as
in the original declaration. -->
いつものように、 `let` で `struct` のインスタンスを作ることができますが、ここでは `key: value` スタイルの構文でそれぞれのフィールドに値をセットしています。順序は元の宣言と同じである必要はありません。

<!-- Finally, because fields have names, we can access the field through dot
notation: `origin.x`. -->
最後に、作成された構造体のフィールドは名前を持つため、 `origin.x` というようにドット表記でアクセスできます。

<!-- The values in `struct`s are immutable by default, like other bindings in Rust.
Use `mut` to make them mutable -->
Rustの他の束縛のように、 `struct` が持つ値はイミュータブルがデフォルトです。 `mut` を使うと値をミュータブルにできます。

```rust
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let mut point = Point { x: 0, y: 0 };

    point.x = 5;

    println!("The point is at ({}, {})", point.x, point.y);
}
```

<!-- This will print `The point is at (5, 0)`. -->
これは `The point is at (5, 0)` と出力されます。

<!-- Rust does not support field mutability at the language level, so you cannot
write something like this: -->
Rustは言語レベルでフィールドのミュータビリティに対応していないため、以下の様に書くことはできません。


```rust,ignore
struct Point {
    mut x: i32,
    y: i32,
}
```

<!-- Mutability is a property of the binding, not of the structure itself. If you’re
used to field-level mutability, this may seem strange at first, but it
significantly simplifies things. It even lets you make things mutable for a short
time only: -->
ミュータビリティは束縛に付与できる属性であり、構造体自体に付与できる属性ではありません。もしあなたがフィールドレベルのミュータビリティを使うのであれば、初めこそ奇妙に見えるものの、非常に簡単に実現できる方法があります。以下の方法で少しの間だけミュータブルな構造体を作ることができます。

```rust,ignore
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let mut point = Point { x: 0, y: 0 };

    point.x = 5;

# //    let point = point; // this new binding can’t change now
    let point = point; // この新しい束縛でここから変更できなくなります

# //    point.y = 6; // this causes an error
    point.y = 6; // これはエラーになります
}
```

<!-- # Update syntax -->
# アップデート構文

<!-- A `struct` can include `..` to indicate that you want to use a copy of some
other `struct` for some of the values. For example: -->
`struct` の初期化時には、値の一部を他の構造体からコピーしたいことを示す `..` を含めることができます。例えば、

```rust
struct Point3d {
    x: i32,
    y: i32,
    z: i32,
}

let mut point = Point3d { x: 0, y: 0, z: 0 };
point = Point3d { y: 1, .. point };
```

<!-- This gives `point` a new `y`, but keeps the old `x` and `z` values. It doesn’t
have to be the same `struct` either, you can use this syntax when making new
ones, and it will copy the values you don’t specify:-->
ここでは`point`に新しい`y`を与えていますが、`x`と`z`は元の値のままです。コピー先は元の構造体と同じである必要はなく、この構文で新しい構造体を作ることもできます。その場合、指定しなかったフィールドは元の構造体からコピーされます。

```rust
# struct Point3d {
#     x: i32,
#     y: i32,
#     z: i32,
# }
let origin = Point3d { x: 0, y: 0, z: 0 };
let point = Point3d { z: 1, x: 2, .. origin };
```

<!-- # Tuple structs -->
# タプル構造体

<!-- Rust has another data type that’s like a hybrid between a [tuple][tuple] and a
`struct`, called a ‘tuple struct’. Tuple structs have a name, but
their fields don’t:-->
Rustには「タプル構造体」と呼ばれる、[タプル][tuple]と `struct` のハイブリットのようなデータ型があります。タプル構造体自体には名前がありますが、そのフィールドには名前がありません。

```rust
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);
```

[tuple]: primitive-types.html#tuples

<!-- These two will not be equal, even if they have the same values: -->
これら2つは同じ値を持つ同士であったとしても等しくありません。

```rust
# struct Color(i32, i32, i32);
# struct Point(i32, i32, i32);
let black = Color(0, 0, 0);
let origin = Point(0, 0, 0);
```

<!-- It is almost always better to use a `struct` than a tuple struct. We would write
`Color` and `Point` like this instead: -->
ほとんどの場合タプル構造体よりも `struct` を使ったほうが良いです。 `Color` や `Point` はこのようにも書けます。

```rust
struct Color {
    red: i32,
    blue: i32,
    green: i32,
}

struct Point {
    x: i32,
    y: i32,
    z: i32,
}
```

<!-- Now, we have actual names, rather than positions. Good names are important,
and with a `struct`, we have actual names. -->
今、私たちはフィールドの位置ではなく実際のフィールドの名前を持っています。良い名前は重要で、 `struct` を使うということは、実際に名前を持っているということです。

> 訳注: 原文を元に噛み砕くと、「タプルはフィールドの並びによって区別され、構造体はフィールドの名前によって区別されます。これはタプルと構造体の最たる違いであり、構造体を持つことは名前を付けられたデータの集まりを持つことに等しいため、構造体における名前付けは重要です。」といった所でしょうか。

<!-- There _is_ one case when a tuple struct is very useful, though, and that’s a
tuple struct with only one element. We call this the ‘newtype’ pattern, because
it allows you to create a new type, distinct from that of its contained value
and expressing its own semantic meaning: -->
ただし、タプル構造体が非常に便利な場合も _あります_。要素が1つだけの場合です。要素の値と区別でき、独自の意味を表現できるような新しい型を作成できることから、私たちはこれを「newtype」パターンと呼んでいます。

```rust
struct Inches(i32);

let length = Inches(10);

let Inches(integer_length) = length;
println!("length is {} inches", integer_length);
```

<!-- As you can see here, you can extract the inner integer type through a
destructuring `let`, just as with regular tuples. In this case, the
`let Inches(integer_length)` assigns `10` to `integer_length`. -->
上記の通り、標準のタプルと同じように `let` を使って分解することで内部の整数型を取り出すことができます。
このケースでは `let Inches(integer_length)` が `integer_length` に `10` を代入します。

# Unit-like 構造体

<!-- You can define a `struct` with no members at all: -->
全くメンバを持たない `struct` を定義することもできます。

```rust
struct Electron;

let x = Electron;
```

<!-- Such a `struct` is called ‘unit-like’ because it resembles the empty
tuple, `()`, sometimes called ‘unit’. Like a tuple struct, it defines a
new type. -->
このような構造体は「unit-like」であると言われます。空のタプルであり「unit」とも呼ばれる `()` とよく似ているからです。タプル構造体と同様に、 unit-like 構造体も新しい型を定義します。

<!-- This is rarely useful on its own (although sometimes it can serve as a
marker type), but in combination with other features, it can become
useful. For instance, a library may ask you to create a structure that
implements a certain [trait][trait] to handle events. If you don’t have
any data you need to store in the structure, you can just create a
unit-like `struct`. -->
これは単体では滅多に役に立ちません（マーカ型として使える場合もあります）が、他の機能と組み合わせると便利な場合があります。例えば、ライブラリがイベントを処理する特定の[トレイト][trait]を実装する構造体の作成を要求するかもしれません。もしその構造体の中に保存すべき値が何もなければ、単にunit-likeな `struct` を作るだけで良いのです。

[trait]: traits.html
