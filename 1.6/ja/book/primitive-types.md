% プリミティブ型
<!-- % Primitive Types --> 

<!-- The Rust language has a number of types that are considered ‘primitive’. This --> 
<!-- means that they’re built-in to the language. Rust is structured in such a way --> 
<!-- that the standard library also provides a number of useful types built on top --> 
<!-- of these ones, as well, but these are the most primitive. --> 
Rust言語は「プリミティブ」であると考えられるかなりの数の型を持ちます。
これはそれらが言語に組み込まれていることを意味します。
標準ライブラリも同様にそれらの型の上に構築されたかなりの数の便利な型を提供していて、そのような方法でRustは構造化されています。しかし、プリミティブ型が最もプリミティブです。

<!-- # Booleans --> 
# ブーリアン型

<!-- Rust has a built in boolean type, named `bool`. It has two values, `true` and `false`: --> 
Rustには `bool` と名付けられた組込みのブーリアン型があります。
それは `true` と `false` という2つの値を持ちます。

```rust
let x = true;

let y: bool = false;
```

<!-- A common use of booleans is in [`if` conditionals][if]. --> 
ブーリアンの一般的な使い方は、 [`if`条件][if] の中で用いるものです。

[if]: if.html

<!-- You can find more documentation for `bool`s [in the standard library --> 
<!-- documentation][bool]. --> 
`bool` のさらなるドキュメントは [標準ライブラリのドキュメントの中][bool] で見付けることができます。

[bool]: ../std/primitive.bool.html

<!-- # `char` --> 
# `char`

<!-- The `char` type represents a single Unicode scalar value. You can create `char`s --> 
<!-- with a single tick: (`'`) --> 
`char` 型は1つのユニコードのスカラ値を表現します。
`char` はシングルクオート（ `'` ）で作ることができます。

```rust
let x = 'x';
let two_hearts = '💕';
```

<!-- Unlike some other languages, this means that Rust’s `char` is not a single byte, --> 
<!-- but four. --> 
`char` が1バイトである他の言語と異なり、これはRustの `char` が1バイトではなく4バイトであるということを意味します。

<!-- You can find more documentation for `char`s [in the standard library --> 
<!-- documentation][char]. --> 
`char` のさらなるドキュメントは [標準ライブラリのドキュメントの中][char] で見付けることができます。

[char]: ../std/primitive.char.html

<!-- # Numeric types --> 
# 数値型

<!-- Rust has a variety of numeric types in a few categories: signed and unsigned, --> 
<!-- fixed and variable, floating-point and integer. --> 
Rustにはいくつかのカテゴリの中にたくさんの種類の数値型があります。そのカテゴリは符号ありと符号なし、固定長と可変長、浮動小数点数と整数です。

<!-- These types consist of two parts: the category, and the size. For example, --> 
<!-- `u16` is an unsigned type with sixteen bits of size. More bits lets you have --> 
<!-- bigger numbers. --> 
それらの型はカテゴリとサイズという2つの部分から成ります。
例えば、 `u16` はサイズ16ビットで符号なしの型です。
ビット数を大きくすれば、より大きな数値を扱うことができます。

<!-- If a number literal has nothing to cause its type to be inferred, it defaults: --> 
もし数値リテラルがその型を推論させるものを何も持たないのであれば、以下のとおりデフォルトになります。

```rust
# // let x = 42; // x has type i32
let x = 42; // xはi32型を持つ
# // let y = 1.0; // y has type f64
let y = 1.0; // yはf64型を持つ
```

<!-- Here’s a list of the different numeric types, with links to their documentation --> 
<!-- in the standard library: --> 
これはいろいろな数値型のリストにそれらの標準ライブラリのドキュメントへのリンクを付けたものです。

* [i8](../std/primitive.i8.html)
* [i16](../std/primitive.i16.html)
* [i32](../std/primitive.i32.html)
* [i64](../std/primitive.i64.html)
* [u8](../std/primitive.u8.html)
* [u16](../std/primitive.u16.html)
* [u32](../std/primitive.u32.html)
* [u64](../std/primitive.u64.html)
* [isize](../std/primitive.isize.html)
* [usize](../std/primitive.usize.html)
* [f32](../std/primitive.f32.html)
* [f64](../std/primitive.f64.html)

<!-- Let’s go over them by category: --> 
それらをカテゴリ別に調べましょう。

<!-- ## Signed and Unsigned --> 
## 符号ありと符号なし

<!-- Integer types come in two varieties: signed and unsigned. To understand the --> 
<!-- difference, let’s consider a number with four bits of size. A signed, four-bit --> 
<!-- number would let you store numbers from `-8` to `+7`. Signed numbers use --> 
<!-- “two’s complement representation”. An unsigned four bit number, since it does --> 
<!-- not need to store negatives, can store values from `0` to `+15`. --> 
整数型には符号ありと符号なしという2つの種類があります。
違いを理解するために、サイズ4ビットの数値を考えましょう。
符号あり4ビット整数は `-8` から `+7` までの数値を保存することができます。
符号ありの数値は「2の補数表現」を使います。
符号なし4ビット整数は、マイナスを保存する必要がないため、 `0` から `+15` までの値を保存することができます。

<!-- Unsigned types use a `u` for their category, and signed types use `i`. The `i` --> 
<!-- is for ‘integer’. So `u8` is an eight-bit unsigned number, and `i8` is an --> 
<!-- eight-bit signed number. --> 
符号なし（訳注：unsigned）型はそれらのカテゴリに `u` を使い、符号あり型は `i` を使います。
`i` は「整数（訳注：integer）」の頭文字です。
そのため、 `u8` は8ビット符号なし数値、 `i8` は8ビット符号あり数値です。

<!-- ## Fixed size types --> 
## 固定長型

<!-- Fixed size types have a specific number of bits in their representation. Valid --> 
<!-- bit sizes are `8`, `16`, `32`, and `64`. So, `u32` is an unsigned, 32-bit integer, --> 
<!-- and `i64` is a signed, 64-bit integer. --> 
固定長型はそれらの表現の中に特定のビット数を持ちます。
指定することのできるビット長は `8` 、 `16` 、 `32` 、 `64` です。
そのため、 `u32` は符号なし32ビット整数、 `i64` は符号あり64ビット整数です。

<!-- ## Variable sized types --> 
## 可変長型

<!-- Rust also provides types whose size depends on the size of a pointer of the --> 
<!-- underlying machine. These types have ‘size’ as the category, and come in signed --> 
<!-- and unsigned varieties. This makes for two types: `isize` and `usize`. --> 
Rustはそのサイズが実行しているマシンのポインタのサイズに依存する型も提供します。
それらの型はカテゴリとして「size」を使い、符号ありと符号なしの種類があります。
これが `isize` と `usize` という2つの型を作ります。

<!-- ## Floating-point types --> 
## 浮動小数点型

<!-- Rust also has two floating point types: `f32` and `f64`. These correspond to --> 
<!-- IEEE-754 single and double precision numbers. --> 
Rustは `f32` と `f64` という2つの浮動小数点型を持ちます。
それらはIEEE-754単精度及び倍精度小数点数に対応します。

<!-- # Arrays --> 
# 配列

<!-- Like many programming languages, Rust has list types to represent a sequence of --> 
<!-- things. The most basic is the *array*, a fixed-size list of elements of the --> 
<!-- same type. By default, arrays are immutable. --> 
多くのプログラミング言語のように、Rustには何かのシーケンスを表現するためのリスト型があります。
最も基本的なものは *配列* 、固定長の同じ型の要素のリストです。
デフォルトでは、配列はイミュータブルです。

```rust
let a = [1, 2, 3]; // a: [i32; 3]
let mut m = [1, 2, 3]; // m: [i32; 3]
```

<!-- Arrays have type `[T; N]`. We’ll talk about this `T` notation [in the generics --> 
<!-- section][generics]. The `N` is a compile-time constant, for the length of the --> 
<!-- array. --> 
配列は `[T; N]` という型を持ちます。
この `T` 記法については [ジェネリクスのセクションの中][generics] で話します。
`N` は配列の長さのためのコンパイル時の定数です。

<!-- There’s a shorthand for initializing each element of an array to the same --> 
<!-- value. In this example, each element of `a` will be initialized to `0`: --> 
配列の各要素を同じ値で初期化するための省略表現があります。
この例では、 `a` の各要素は `0` で初期化されます。

```rust
let a = [0; 20]; // a: [i32; 20]
```

<!-- You can get the number of elements in an array `a` with `a.len()`: --> 
配列 `a` の要素の個数は `a.len()` で得ることができます。

```rust
let a = [1, 2, 3];

println!("a has {} elements", a.len());
```

<!-- You can access a particular element of an array with *subscript notation*: --> 
配列の特定の要素には *添字記法* でアクセスすることができます。

```rust
let names = ["Graydon", "Brian", "Niko"]; // names: [&str; 3]

println!("The second name is: {}", names[1]);
```

<!-- Subscripts start at zero, like in most programming languages, so the first name --> 
<!-- is `names[0]` and the second name is `names[1]`. The above example prints --> 
<!-- `The second name is: Brian`. If you try to use a subscript that is not in the --> 
<!-- array, you will get an error: array access is bounds-checked at run-time. Such --> 
<!-- errant access is the source of many bugs in other systems programming --> 
<!-- languages. --> 
添字はほとんどのプログラミング言語と同じように0から始まります。そのため、最初の名前は `names[0]` で2つ目の名前は `names[1]` です。
前の例は `The second name is: Brian` とプリントします。
もし配列に含まれない添字を使おうとすると、エラーが出ます。配列アクセスは実行時に境界チェックを受けます。
他のシステムプログラミング言語では、そのような誤ったアクセスは多くのバグの源となります。

<!-- You can find more documentation for `array`s [in the standard library --> 
<!-- documentation][array]. --> 
`array` のさらなるドキュメントは [標準ライブラリのドキュメントの中][array] で見付けることができます。

[array]: ../std/primitive.array.html

<!-- # Slices --> 
# スライス

<!-- A ‘slice’ is a reference to (or “view” into) another data structure. They are --> 
<!-- useful for allowing safe, efficient access to a portion of an array without --> 
<!-- copying. For example, you might want to reference just one line of a file read --> 
<!-- into memory. By nature, a slice is not created directly, but from an existing --> 
<!-- variable binding. Slices have a defined length, can be mutable or immutable. --> 
「スライス」は他のデータ構造への参照（又は「ビュー」）です。
それらはコピーすることなく配列の要素への安全で効率的なアクセスを許すために便利です。
例えば、メモリに読み込んだファイルの1行だけを参照したいことがあるかもしれません。
本来、スライスは直接作られるのではなく、既存の変数束縛から作られます。
スライスは定義された長さを持ち、ミュータブルにもイミュータブルにもできます。

<!-- ## Slicing syntax --> 
## スライシング構文

<!-- You can use a combo of `&` and `[]` to create a slice from various things. The --> 
<!-- `&` indicates that slices are similar to references, and the `[]`s, with a --> 
<!-- range, let you define the length of the slice: --> 
様々なものからスライスを作るためには `&` と `[]` の組合せを使うことができます。
`&` はスライスが参照と同じであることを示し、 `[]` はレンジを持ち、スライスの長さを定義します。

```rust
let a = [0, 1, 2, 3, 4];
# // let complete = &a[..]; // A slice containing all of the elements in a
let complete = &a[..]; // aに含まれる全ての要素を持つスライス
# // let middle = &a[1..4]; // A slice of a: just the elements 1, 2, and 3
let middle = &a[1..4]; // 1、2、3のみを要素に持つaのスライス
```

<!-- Slices have type `&[T]`. We’ll talk about that `T` when we cover --> 
<!-- [generics][generics]. --> 
スライスは型 `&[T]` を持ちます。
[ジェネリクス][generics] をカバーするときにその `T` について話すでしょう。

[generics]: generics.html

<!-- You can find more documentation for slices [in the standard library --> 
<!-- documentation][slice]. --> 
`slice` のさらなるドキュメントは [標準ライブラリのドキュメントの中][slice] で見付けることができます。

[slice]: ../std/primitive.slice.html

<!-- # `str` --> 
# `str`

<!-- Rust’s `str` type is the most primitive string type. As an [unsized type][dst], --> 
<!-- it’s not very useful by itself, but becomes useful when placed behind a reference, --> 
<!-- like [`&str`][strings]. As such, we’ll just leave it at that. --> 
Rustの `str` 型は最もプリミティブな文字列型です。
[サイズ不定型][dst] のように、それはそれ自体で非常に便利なものではありませんが、 [`&str`][strings] のように参照の後ろに置かれたときに便利になります。
そのため、それはそのまま置いておきましょう。

[dst]: unsized-types.html
[strings]: strings.html

<!-- You can find more documentation for `str` [in the standard library --> 
<!-- documentation][str]. --> 
`str` のさらなるドキュメントは [標準ライブラリのドキュメントの中][str] で見付けることができます。

[str]: ../std/primitive.str.html

<!-- # Tuples --> 
# タプル

<!-- A tuple is an ordered list of fixed size. Like this: --> 
タプルは固定サイズの順序ありリストです。
このようなものです。

```rust
let x = (1, "hello");
```

<!-- The parentheses and commas form this two-length tuple. Here’s the same code, but --> 
<!-- with the type annotated: --> 
丸括弧とコンマがこの長さ2のタプルを形成します。
これは同じコードですが、型注釈が付いています。

```rust
let x: (i32, &str) = (1, "hello");
```

<!-- As you can see, the type of a tuple looks just like the tuple, but with each --> 
<!-- position having a type name rather than the value. Careful readers will also --> 
<!-- note that tuples are heterogeneous: we have an `i32` and a `&str` in this tuple. --> 
<!-- In systems programming languages, strings are a bit more complex than in other --> 
<!-- languages. For now, just read `&str` as a *string slice*, and we’ll learn more --> 
<!-- soon. --> 
見てのとおり、タプルの型はタプルとちょうど同じように見えます。しかし、各位置には値ではなく型名が付いています。
注意深い読者は、タプルが異なる型の値を含んでいることにも気が付くでしょう。このタプルには `i32` と `&str` が入っています。
システムプログラミング言語では、文字列は他の言語よりも少し複雑です。
今のところ、 `&str` を *文字列スライス* と読むだけにしましょう。それ以上のことは後で学ぶでしょう。

<!-- You can assign one tuple into another, if they have the same contained types --> 
<!-- and [arity]. Tuples have the same arity when they have the same length. --> 
もしそれらの持っている型と [アリティ][arity] が同じであれば、あるタプルを他のタプルに割り当てることができます。
タプルの長さが同じであれば、それらのタプルのアリティは同じです。

[arity]: glossary.html#arity

```rust
let mut x = (1, 2); // x: (i32, i32)
let y = (2, 3); // y: (i32, i32)

x = y;
```

<!-- You can access the fields in a tuple through a *destructuring let*. Here’s --> 
<!-- an example: --> 
タプルのフィールドには *分配束縛let* を通じてアクセスすることができます。
これが例です。

```rust
let (x, y, z) = (1, 2, 3);

println!("x is {}", x);
```

<!-- Remember [before][let] when I said the left-hand side of a `let` statement was more --> 
<!-- powerful than just assigning a binding? Here we are. We can put a pattern on --> 
<!-- the left-hand side of the `let`, and if it matches up to the right-hand side, --> 
<!-- we can assign multiple bindings at once. In this case, `let` “destructures” --> 
<!-- or “breaks up” the tuple, and assigns the bits to three bindings. --> 
[前に][let]`let` 文の左辺は単なる束縛の割当てよりももっと強力だと言ったときのことを覚えていますか。
ここで説明します。
`let` の左辺にはパターンを書くことができ、もしそれが右辺とマッチしたならば、複数の束縛を一度に割り当てることができます。
この場合、 `let` が「分配束縛」、つまりタプルを「分解して」、要素を3つの束縛に割り当てます。

[let]: variable-bindings.html

<!-- This pattern is very powerful, and we’ll see it repeated more later. --> 
このパターンは非常に強力で、後で繰り返し見るでしょう。

<!-- You can disambiguate a single-element tuple from a value in parentheses with a --> 
<!-- comma: --> 
コンマを付けることで要素1のタプルを丸括弧の中の値と混同しないように明示することができます。

```rust
# // (0,); // single-element tuple
 (0,); // 1要素のタプル
# // (0); // zero in parentheses
 (0); // 丸括弧に囲まれたゼロ
```

<!-- ## Tuple Indexing --> 
## タプルのインデックス

<!-- You can also access fields of a tuple with indexing syntax: --> 
タプルのフィールドにはインデックス構文でアクセスすることもできます。

```rust
let tuple = (1, 2, 3);

let x = tuple.0;
let y = tuple.1;
let z = tuple.2;

println!("x is {}", x);
```

<!-- Like array indexing, it starts at zero, but unlike array indexing, it uses a --> 
<!-- `.`, rather than `[]`s. --> 
配列のインデックスと同じように、それは0から始まります。しかし、配列のインデックスと異なり、それは `[]` ではなく `.` を使います。

<!-- You can find more documentation for tuples [in the standard library --> 
<!-- documentation][tuple]. --> 
タプルのさらなるドキュメントは [標準ライブラリのドキュメントの中][tuple] で見付けることができます。

[tuple]: ../std/primitive.tuple.html

<!-- # Functions --> 
# 関数

<!-- Functions also have a type! They look like this: --> 
関数も型を持ちます!
それらはこのようになります。

```rust
fn foo(x: i32) -> i32 { x }

let x: fn(i32) -> i32 = foo;
```

<!-- In this case, `x` is a ‘function pointer’ to a function that takes an `i32` and --> 
<!-- returns an `i32`. --> 
この場合、 `x` は `i32` を受け取り `i32` を戻す関数への「関数ポインタ」です。
