% 型間のキャスト
<!-- % Casting Between Types -->

<!-- Rust, with its focus on safety, provides two different ways of casting
different types between each other. The first, `as`, is for safe casts.
In contrast, `transmute` allows for arbitrary casting, and is one of the
most dangerous features of Rust! -->
Rustは安全性に焦点を合わせており、異なる型の間を互いにキャストするために二つの異なる方法を提供しています。
一つは `as` であり、これは安全なキャストに使われます。
逆に `transmute` は任意のキャストに使え、Rustにおける最も危険なフィーチャの一つです!

<!-- # Coercion -->
# 型強制

<!-- Coercion between types is implicit and has no syntax of its own, but can
be spelled out with [`as`](#explicit-coercions). -->
型強制は暗黙に行われ、それ自体に構文はありませんが、[`as`](#明示的型強制) で書くこともできます。

<!-- Coercion occurs in `let`, `const`, and `static` statements; in
function call arguments; in field values in struct initialization; and in a
function result. -->
型強制が現れるのは、 `let` ・ `const` ・ `static` 文、関数呼び出しの引数、構造体初期化の際のフィールド値、そして関数の結果です。

<!-- The most common case of coercion is removing mutability from a reference: -->
一番よくある型強制は、参照からミュータビリティを取り除くものです。

<!-- * `&mut T` to `&T` -->
 * `&mut T` から `&T` へ

<!-- An analogous conversion is to remove mutability from a
[raw pointer](raw-pointers.md): -->
似たような変換としては、 [生ポインタ](raw-pointers.md) からミュータビリティを取り除くものがあります。

<!-- * `*mut T` to `*const T` -->
 * `*mut T` から `*const T` へ

<!-- References can also be coerced to raw pointers: -->
参照も同様に、生ポインタへ型強制できます。

<!-- * `&T` to `*const T` -->
 * `&T` から `*const T` へ

<!-- * `&mut T` to `*mut T` -->
 * `&mut T` から `*mut T` へ

<!-- Custom coercions may be defined using [`Deref`](deref-coercions.md). -->
[`Deref`](deref-coercions.md) によって、カスタマイズされた型強制が定義されることもあります。

<!-- Coercion is transitive. -->
型強制は推移的です。

<!-- # `as` -->
# `as`

<!-- The `as` keyword does safe casting: -->
`as` というキーワードは安全なキャストを行います。

```rust
let x: i32 = 5;

let y = x as i64;
```

<!-- There are three major categories of safe cast: explicit coercions, casts
between numeric types, and pointer casts. -->
安全なキャストは大きく三つに分類されます。
明示的型強制、数値型間のキャスト、そして、ポインタキャストです。

<!-- Casting is not transitive: even if `e as U1 as U2` is a valid
expression, `e as U2` is not necessarily so (in fact it will only be valid if
`U1` coerces to `U2`). -->
キャストは推移的ではありません。
`e as U1 as U2` が正しい式であったとしても、 `e as U2` が必ずしも正しいとは限らないのです。
(実際、この式が正しくなるのは、 `U1` が `U2` へ型強制されるときのみです。)


<!-- ## Explicit coercions -->
## 明示的型強制

<!-- A cast `e as U` is valid if `e` has type `T` and `T` *coerces* to `U`. -->
`e as U` というキャストは、 `e` が型 `T` を持ち、かつ `T` が `U` に *型強制* されるとき、有効です。

<!-- ## Numeric casts -->
## 数値キャスト

<!-- A cast `e as U` is also valid in any of the following cases: -->
`e as U` というキャストは、以下のどの場合でも有効です。

<!-- * `e` has type `T` and `T` and `U` are any numeric types; *numeric-cast* -->
<!-- * `e` is a C-like enum (with no data attached to the variants),
    and `U` is an integer type; *enum-cast* -->
<!-- * `e` has type `bool` or `char` and `U` is an integer type; *prim-int-cast* -->
<!-- * `e` has type `u8` and `U` is `char`; *u8-char-cast* -->
* `e` が型 `T` を持ち、 `T` と `U` が数値型であるとき; *numeric-cast*
* `e` が C-likeな列挙型であり(つまり、ヴァリアントがデータを持っておらず)、 `U` が整数型であるとき; *enum-cast*
* `e` の型が `bool` か `char` であり、 `U` が整数型であるとき; *prim-int-cast*
* `e` が型 `u8` を持ち、 `U` が `char` であるとき; *u8-char-cast*

<!-- For example -->
例えば、

```rust
let one = true as u8;
let at_sign = 64 as char;
let two_hundred = -56i8 as u8;
```

<!-- The semantics of numeric casts are: -->
数値キャストのセマンティクスは以下の通りです。

<!-- * Casting between two integers of the same size (e.g. i32 -> u32) is a no-op
* Casting from a larger integer to a smaller integer (e.g. u32 -> u8) will
  truncate
* Casting from a smaller integer to a larger integer (e.g. u8 -> u32) will
    * zero-extend if the source is unsigned
    * sign-extend if the source is signed
* Casting from a float to an integer will round the float towards zero
    * **[NOTE: currently this will cause Undefined Behavior if the rounded
      value cannot be represented by the target integer type][float-int]**.
      This includes Inf and NaN. This is a bug and will be fixed.
* Casting from an integer to float will produce the floating point
  representation of the integer, rounded if necessary (rounding strategy
  unspecified)
* Casting from an f32 to an f64 is perfect and lossless
* Casting from an f64 to an f32 will produce the closest possible value
  (rounding strategy unspecified)
    * **[NOTE: currently this will cause Undefined Behavior if the value
      is finite but larger or smaller than the largest or smallest finite
      value representable by f32][float-float]**. This is a bug and will
      be fixed. -->
* サイズの同じ二つの整数間のキャスト (例えば、i32 -> u32) は何も行いません
* サイズの大きい整数から小さい整数へのキャスト (例えば、u32 -> u8) では切り捨てを行います
* サイズの小さい整数から大きい整数へのキャスト (例えば、u8 -> u32) では、
    * 元の整数が符号無しならば、ゼロ拡張を行います
    * 元の整数が符号付きならば、符号拡張を行います
* 浮動小数点数から整数へのキャストでは、0方向への丸めを行います
    * **[注意: 現在、丸められた値がキャスト先の整数型で扱えない場合、このキャストは未定義動作を引き起こします。][float-int]**
      これには Inf や NaN も含まれます。
      これはバグであり、修正される予定です。
* 整数から浮動小数点数へのキャストでは、必要に応じて丸めが行われて、その整数を表す浮動小数点数がつくられます
  (丸め戦略は指定されていません)
* f32 から f64 へのキャストは完全で精度は落ちません
* f64 から f32 へのキャストでは、表現できる最も近い値がつくられます
  (丸め戦略は指定されていません)
    * **[注意: 現在、値が有限でありながらf32 で表現できる最大(最小)の有限値より大きい(小さい)場合、このキャストは未定義動作を引き起こします。][float-float]**
      これはバグであり、修正される予定です。

[float-int]: https://github.com/rust-lang/rust/issues/10184
[float-float]: https://github.com/rust-lang/rust/issues/15536

<!-- ## Pointer casts -->
## ポインタキャスト

<!-- Perhaps surprisingly, it is safe to cast [raw pointers](raw-pointers.md) to and
from integers, and to cast between pointers to different types subject to
some constraints. It is only unsafe to dereference the pointer: -->
驚くかもしれませんが、いくつかの制約のもとで、 [生ポインタ](raw-pointers.md) と整数の間のキャストや、ポインタと他の型の間のキャストは安全です。
安全でないのはポインタの参照外しだけなのです。

```rust
# // let a = 300 as *const char; // a pointer to location 300
let a = 300 as *const char; // 300番地へのポインタ
let b = a as u32;
```

<!-- `e as U` is a valid pointer cast in any of the following cases: -->
`e as U` が正しいポインタキャストであるのは、以下の場合です。

<!-- * `e` has type `*T`, `U` has type `*U_0`, and either `U_0: Sized` or
  `unsize_kind(T) == unsize_kind(U_0)`; a *ptr-ptr-cast*  -->
* `e` が型 `*T` を持ち、 `U` が `*U_0` であり、 `U_0: Sized` または `unsize_kind(T) == unsize_kind(U_0)` である場合; *ptr-ptr-cast*

<!-- * `e` has type `*T` and `U` is a numeric type, while `T: Sized`; *ptr-addr-cast* -->
* `e` が型 `*T` を持ち、 `U` が数値型で、 `T: Sized` である場合; *ptr-addr-cast*

<!-- * `e` is an integer and `U` is `*U_0`, while `U_0: Sized`; *addr-ptr-cast* -->
* `e` が整数、`U` が `*U_0` であり、 `U_0: Sized` である場合; *addr-ptr-cast*

<!-- * `e` has type `&[T; n]` and `U` is `*const T`; *array-ptr-cast* -->
* `e` が型 `&[T; n]` を持ち、 `U` が `*const T` である場合; *array-ptr-cast*

<!-- * `e` is a function pointer type and `U` has type `*T`,
  while `T: Sized`; *fptr-ptr-cast* -->
* `e` が関数ポインタ型であり、 `U` が `*T` であって、`T: Sized` の場合; *fptr-ptr-cast*

<!-- * `e` is a function pointer type and `U` is an integer; *fptr-addr-cast* -->
* `e` が関数ポインタ型であり、 `U` が整数型である場合; *fptr-addr-cast*

# `transmute`

<!-- `as` only allows safe casting, and will for example reject an attempt to
cast four bytes into a `u32`: -->
`as` は安全なキャストしか許さず、例えば4つのバイト値を `u32` へキャストすることはできません。

```rust,ignore
let a = [0u8, 0u8, 0u8, 0u8];

# // let b = a as u32; // four eights makes 32
let b = a as u32; // 4つの8で32になる
```

<!-- This errors with: -->
これは以下のようなメッセージがでて、エラーになります。

<!-- ```text
error: non-scalar cast: `[u8; 4]` as `u32`
let b = a as u32; // four eights makes 32
        ^~~~~~~~
``` -->
```text
error: non-scalar cast: `[u8; 4]` as `u32`
let b = a as u32; // 4つの8で32になる
        ^~~~~~~~
```

<!-- This is a ‘non-scalar cast’ because we have multiple values here: the four
elements of the array. These kinds of casts are very dangerous, because they
make assumptions about the way that multiple underlying structures are
implemented. For this, we need something more dangerous. -->
これは「non-scalar cast」であり、複数の値、つまり配列の4つの要素、があることが原因です。
この種類のキャストはとても危険です。
なぜなら、複数の裏に隠れた構造がどう実装されているかについて仮定をおいているからです。
そのためもっと危険なものが必要になります。

<!-- The `transmute` function is provided by a [compiler intrinsic][intrinsics], and
what it does is very simple, but very scary. It tells Rust to treat a value of
one type as though it were another type. It does this regardless of the
typechecking system, and just completely trusts you. -->
`transmute` 関数は [コンパイラ intrinsic][intrinsics] によって提供されており、やることはとてもシンプルながら、とても恐ろしいです。
この関数は、Rustに対し、ある型の値を他の型であるかのように扱うように伝えます。
これは型検査システムに関係なく行われ、完全に使用者頼みです。

[intrinsics]: intrinsics.html

<!-- In our previous example, we know that an array of four `u8`s represents a `u32`
properly, and so we want to do the cast. Using `transmute` instead of `as`,
Rust lets us: -->
先ほどの例では、4つの `u8` からなる配列が ちゃんと `u32` を表していることを知った上で、キャストを行おうとしました。
これは、`as` の代わりに `transmute` を使うことで、次のように書けます。

```rust
use std::mem;

unsafe {
    let a = [0u8, 0u8, 0u8, 0u8];

    let b = mem::transmute::<[u8; 4], u32>(a);
}
```

<!-- We have to wrap the operation in an `unsafe` block for this to compile
successfully. Technically, only the `mem::transmute` call itself needs to be in
the block, but it's nice in this case to enclose everything related, so you
know where to look. In this case, the details about `a` are also important, and
so they're in the block. You'll see code in either style, sometimes the context
is too far away, and wrapping all of the code in `unsafe` isn't a great idea. -->
コンパイルを成功させるために、この操作は `unsafe` ブロックでくるんであります。
技術的には、 `mem::transmute` の呼び出しのみをブロックに入れればいいのですが、今回はどこを見ればよいかわかるよう、関連するもの全部を囲んでいます。
この例では `a` に関する詳細も重要であるため、ブロックにいれてあります。
ただ、文脈が離れすぎているときは、こう書かないこともあるでしょう。
そういうときは、コード全体を `unsafe` でくるむことは良い考えではないのです。

<!-- While `transmute` does very little checking, it will at least make sure that
the types are the same size. This errors: -->
`transmute` はほとんどチェックを行わないのですが、最低限、型同士が同じサイズかの確認はします。
そのため、次の例はエラーになります。

```rust,ignore
use std::mem;

unsafe {
    let a = [0u8, 0u8, 0u8, 0u8];

    let b = mem::transmute::<[u8; 4], u64>(a);
}
```

<!-- with: -->
エラーメッセージはこうです。

```text
error: transmute called with differently sized types: [u8; 4] (32 bits) to u64
(64 bits)
```

<!-- Other than that, you're on your own! -->
ただそれ以外に関しては、自己責任です!
