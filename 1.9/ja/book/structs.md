% 構造体
<!-- % Structs -->

<!-- `struct`s are a way of creating more complex data types. For example, if we were -->
<!-- doing calculations involving coordinates in 2D space, we would need both an `x` -->
<!-- and a `y` value: -->
`struct` はより複雑なデータ型を作る方法の1つです。
例えば、もし私たちが2次元空間の座標に関する計算を行っているとして、 `x` と `y` 、両方の値が必要になるでしょう。

```rust
let origin_x = 0;
let origin_y = 0;
```

<!-- A `struct` lets us combine these two into a single, unified datatype with `x` -->
<!-- and `y` as field labels: -->
`struct` でこれら2つを、`x` と `y` というフィールドラベルを持つ、1つのデータ型にまとめることができます。

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

> 訳注：
>
> The origin is at ({}, {}): 原点は ({}, {}) にあります。

<!-- There’s a lot going on here, so let’s break it down. We declare a `struct` with -->
<!-- the `struct` keyword, and then with a name. By convention, `struct`s begin with -->
<!-- a capital letter and are camel cased: `PointInSpace`, not `Point_In_Space`. -->
ここで多くの情報が出てきましたから、順番に見ていきましょう。
まず `struct` キーワードを使って構造体とその名前を宣言しています。
慣習により、構造体は頭文字が大文字のキャメルケースで記述しています。
`PointInSpace` であり、 `Point_In_Space` ではありません。

<!-- We can create an instance of our `struct` via `let`, as usual, but we use a `key: -->
<!-- value` style syntax to set each field. The order doesn’t need to be the same as -->
<!-- in the original declaration. -->
いつものように `let` で `struct` のインスタンスを作れますが、ここでは `key: value` スタイルの構文でそれぞれのフィールドに値をセットしています。
順序は元の宣言と同じである必要はありません。

<!-- Finally, because fields have names, we can access them through dot -->
<!-- notation: `origin.x`. -->
最後に、作成された構造体のフィールドは名前を持つため、 `origin.x` というようにドット表記でアクセスできます。

<!-- The values in `struct`s are immutable by default, like other bindings in Rust. -->
<!-- Use `mut` to make them mutable -->
Rustの他の束縛のように、 `struct` が持つ値はデフォルトでイミュータブルです。
`mut` を使うと値をミュータブルにできます。

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
これは `The point is at (5, 0)` と表示します。

<!-- Rust does not support field mutability at the language level, so you cannot -->
<!-- write something like this: -->
Rustは言語レベルではフィールドのミュータビリティに対応していないため、以下のようには書けません。

```rust,ignore
struct Point {
    mut x: i32,
    y: i32,
}
```

<!-- Mutability is a property of the binding, not of the structure itself. If you’re -->
<!-- used to field-level mutability, this may seem strange at first, but it -->
<!-- significantly simplifies things. It even lets you make things mutable on a temporary -->
<!-- basis: -->
ミュータビリティは束縛が持つ属性であり、構造体自体の属性ではないのです。
もしあなたがフィールドレベルのミュータビリティに慣れているなら、初めは奇妙に映るかもしれません。
しかし、このことが物事をとてもシンプルにしてくれます。
またこれは、構造体を一時的にミュータブルにすることも可能にします。

```rust,ignore
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let mut point = Point { x: 0, y: 0 };

    point.x = 5;

# //    let point = point; // now immutable
    let point = point; // ここからは不変

# //    point.y = 6; // this causes an error
    point.y = 6; // これはエラーになります
}
```

<!-- Your structure can still contain `&mut` pointers, which will let -->
<!-- you do some kinds of mutation: -->
構造体に `&mut` ポインタを含めることはできますので、ある種の変更を行えます。

```rust
struct Point {
    x: i32,
    y: i32,
}

struct PointRef<'a> {
    x: &'a mut i32,
    y: &'a mut i32,
}

fn main() {
    let mut point = Point { x: 0, y: 0 };

    {
        let r = PointRef { x: &mut point.x, y: &mut point.y };

        *r.x = 5;
        *r.y = 6;
    }

    assert_eq!(5, point.x);
    assert_eq!(6, point.y);
}
```

<!-- # Update syntax -->
# アップデート構文

<!-- A `struct` can include `..` to indicate that you want to use a copy of some -->
<!-- other `struct` for some of the values. For example: -->
`struct` の値を作る時に `..` を含めると、他の `struct` から一部の値をコピーしたいことを示せます。
たとえば、

```rust
struct Point3d {
    x: i32,
    y: i32,
    z: i32,
}

let mut point = Point3d { x: 0, y: 0, z: 0 };
point = Point3d { y: 1, .. point };
```

<!-- This gives `point` a new `y`, but keeps the old `x` and `z` values. It doesn’t -->
<!-- have to be the same `struct` either, you can use this syntax when making new -->
<!-- ones, and it will copy the values you don’t specify:-->
ここでは `point` に新しい `y` を与えていますが、`x` と `z` は古い値を維持します。
これは同一の `struct` でなくても構いません。
この構文を新しい `struct` の作成に使用でき、値を指定しなかったフィールドについてはコピーされます。

```rust
# struct Point3d {
#     x: i32,
#     y: i32,
#     z: i32,
# }
let origin = Point3d { x: 0, y: 0, z: 0 };
let point = Point3d { z: 1, x: 2, .. origin };
```

> 訳注: 原文の「同一の `struct` でなくても構いません」というのは、誤解を招くかもしれません。
> まず、2種類の「別の型の」構造体の間では、この構文は使えません。
> また、ある1種類の構造体のインスタンスについて考える場合でも、この構文によって、既存のインスタンスの値が「その場で更新」されるわけではないことに注意してください。
> 実際には、既存のインスタンスのフィールド値を元に、新しいインスタンスが作られます。
>
> つまり、「同一の `struct` でなくても構わない」というよりも、「ある `struct` 型の既存のインスタンスを元に、同じ型の新しいインスタンスを作る」ことしかできないのです。

<!-- # Tuple structs -->
# タプル構造体

<!-- Rust has another data type that’s like a hybrid between a [tuple][tuple] and a -->
<!-- `struct`, called a ‘tuple struct’. Tuple structs have a name, but their fields -->
<!-- don't. They are declared with the `struct` keyword, and then with a name -->
<!-- followed by a tuple: -->

Rustには「タプル構造体」と呼ばれる、[タプル][tuple]と `struct` のハイブリットのようなデータ型があります。
タプル構造体自体には名前がありますが、そのフィールドには名前がありません。
これらは `struct` キーワードによって宣言され、名前と単一のタプルが続きます。

[tuple]: primitive-types.html#tuples

```rust
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);
let black = Color(0, 0, 0);
let origin = Point(0, 0, 0);
```

<!-- Here, `black` and `origin` are not equal, even though they contain the same -->
<!-- values. -->
ここで `black` と `origin` は同じ値を格納していますが、2者は等しくありません。
（訳注: 2者は別の型として扱われます）

<!-- It is almost always better to use a `struct` than a tuple struct. We -->
<!-- would write `Color` and `Point` like this instead: -->
ほとんどの場合タプル構造体よりも `struct` を使ったほうがいいでしょう。
`Color` や `Point` はこのようにも書けます。

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

<!-- Good names are important, and while values in a tuple struct can be -->
<!-- referenced with dot notation as well, a `struct` gives us actual names, -->
<!-- rather than positions. -->
良い名前は重要です。
タプル構造体に格納された値はドット表記で参照できますが、 `struct` なら、フィールドの位置ではなく、実際のフィールドの名前で参照できます。

> 訳注: 原文を元に噛み砕くと、「タプルはフィールドの並びによって区別され、構造体はフィールドの名前によって区別されます。これはタプルと構造体の最たる違いであり、構造体を持つことは名前を付けられたデータの集まりを持つことに等しいため、構造体における名前付けは重要です。」といった所でしょうか。

<!-- There _is_ one case when a tuple struct is very useful, though, and that is when -->
<!-- it has only one element. We call this the ‘newtype’ pattern, because -->
<!-- it allows you to create a new type that is distinct from its contained value -->
<!-- and also expresses its own semantic meaning: -->
タプル構造体が非常に便利な場合も _あります_ 。
それは要素を1つだけ持つ時です。
私たちはこれを「newtype」パターンと呼んでいます。
なぜなら、それ自体のセマンティックな意味を表現でき、格納している値とは別の型として扱われる、新しい型が作れるからです。

```rust
struct Inches(i32);

let length = Inches(10);

let Inches(integer_length) = length;
println!("length is {} inches", integer_length);
```

<!-- As you can see here, you can extract the inner integer type through a -->
<!-- destructuring `let`, as with regular tuples. In this case, the -->
<!-- `let Inches(integer_length)` assigns `10` to `integer_length`. -->
上記の通り `let` を使って分解することで、標準のタプルと同じように内部の整数型を取り出せます。
このケースでは `let Inches(integer_length)` により `integer_length` へ `10` が束縛されます。

> 訳注： Rustには `type` 文もありますが、単に「型の別名」を定義するだけで、newtypeパターンのような「新しい型」は定義しません。
>
> たとえば、`type` 文を使って、`i32` 型から `Inches` と `Meters` という2つの別名を定義した場合、コンパイラはこの2つの別名を同じ型として扱います。
> つまり、本来 `Inches` の値を使う場所でうっかり `Meters` の値を使ってしまっても、コンパイルエラーになりません。
>
> 一方で、これらを `Inches(i32)` と `Meters(i32)` というタプル構造体として定義した場合は、コンパイラは別の型として扱います。従って、もし使い間違えたときにはコンパイルエラーになってくれます。

# Unit-like 構造体

<!-- You can define a `struct` with no members at all: -->
全くメンバを持たない `struct` も定義できます。

```rust
struct Electron;

let x = Electron;
```

<!-- Such a `struct` is called ‘unit-like’ because it resembles the empty -->
<!-- tuple, `()`, sometimes called ‘unit’. Like a tuple struct, it defines a -->
<!-- new type. -->
空のタプルである `()` は時々 `unit` と呼ばれ、それに似ていることからこのような構造体を `unit-like` と呼んでいます。
タプル構造体のように、これは新しい型を定義します。

<!-- This is rarely useful on its own (although sometimes it can serve as a -->
<!-- marker type), but in combination with other features, it can become -->
<!-- useful. For instance, a library may ask you to create a structure that -->
<!-- implements a certain [trait][trait] to handle events. If you don’t have -->
<!-- any data you need to store in the structure, you can create a -->
<!-- unit-like `struct`. -->
これは単体でもごくまれに役立ちます（もっとも、時々型をマーク代わりとして役立てる程度です）が、他の機能と組み合わせることにより便利になります。
例えば、ライブラリはあなたにイベントを処理できる特定の [トレイト][trait] を実装した構造体の作成を要求するかもしれません。
もしその構造体に保存すべき値が何もなければ、あなたはダミーのデータを作成する必要はなく、unit-likeな `struct` を作れば良いのです。

[trait]: traits.html
