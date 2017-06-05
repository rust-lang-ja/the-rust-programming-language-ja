% サイズ不定型
<!-- % Unsized Types -->

<!-- Most types have a particular size, in bytes, that is knowable at compile time. -->
<!-- For example, an `i32` is thirty-two bits big, or four bytes. However, there are -->
<!-- some types which are useful to express, but do not have a defined size. These are -->
<!-- called ‘unsized’ or ‘dynamically sized’ types. One example is `[T]`. This type -->
<!-- represents a certain number of `T` in sequence. But we don’t know how many -->
<!-- there are, so the size is not known. -->
ほとんどの型はコンパイル時に知れる、バイト数で測った、サイズがあります。
例えば、 `i32` 型は、32ビット(4バイト)というサイズです。
しかしながら、表現のためには便利であってもサイズが定まっていない型が存在します。
そのような型を 「サイズ不定」又は「動的サイズ」型と呼びます。
一例を上げると `[T]` 型は 一定のサイズの`T` のシーケンスを意味していますが、その要素数については規定されていないため、サイズは不定となります。

<!-- Rust understands a few of these types, but they have some restrictions. There -->
<!-- are three: -->
Rustはいくつかのそのような型を扱うことができますが、それらには以下の様な3つの制約が存在します:

<!-- 1. We can only manipulate an instance of an unsized type via a pointer. An ->
<!--    `&[T]` works just fine, but a `[T]` does not. -->
<!-- 2. Variables and arguments cannot have dynamically sized types. -->
<!-- 3. Only the last field in a `struct` may have a dynamically sized type; the -->
<!--    other fields must not. Enum variants must not have dynamically sized types as -->
<!--    data. -->
1. サイズ不定型はポインタを通してのみ操作することができます、たとえば、 `&[T]` は大丈夫ですが、 `[T]` はそうではありません。
2. 変数や引数は動的なサイズを持つことはできません。
3. `struct` の最後のフィールドのみ、動的なサイズを持つことが許されます、その他のフィールドはサイズが不定であってはなりません。
   また、Enumのバリアントはデータとして動的なサイズの型を持つ事はできません。

<!-- So why bother? Well, because `[T]` can only be used behind a pointer, if we -->
<!-- didn’t have language support for unsized types, it would be impossible to write -->
<!-- this: -->
なぜこんなにややこしいのでしょうか？ これは、`[T]` はポインタを通してのみ操作可能であるため、
もし言語がサイズ不定型をサポートしていなかった場合、以下のようなコードを書くことは不可能となります:

```rust,ignore
impl Foo for str {
```

<!-- or -->
また、以下の様なコードも:

```rust,ignore
impl<T> Foo for [T] {
```

<!-- Instead, you would have to write: -->
このように書く代わりに、以下のように書く必要があることになるでしょう:

```rust,ignore
impl Foo for &str {
```

<!-- Meaning, this implementation would only work for [references][ref], and not -->
<!-- other types of pointers. With the `impl for str`, all pointers, including (at -->
<!-- some point, there are some bugs to fix first) user-defined custom smart -->
<!-- pointers, can use this `impl`. -->
このように書いたとすると、このコードは [参照][ref] に対してのみ動作するようになり、他のポインタ型に対しては動作しないことになります。
`impl for str` のように書くことで、すべてのポインタ、ユーザーの定義した独自のスマートポインタ(いくつかの点についてバグがあるので、それを先ずは直さなくてはなりませんが)もこの `impl` を利用可能になります。

[ref]: references-and-borrowing.html

# ?Sized

<!-- If you want to write a function that accepts a dynamically sized type, you -->
<!-- can use the special bound, `?Sized`: -->
もし動的サイズ型を引数に取れるような関数を定義したい場合、特別な境界 `?Sized` を利用できます:

```rust
struct Foo<T: ?Sized> {
    f: T,
}
```

<!-- This `?`, read as “T may be `Sized`”,  means that this bound is special: it -->
<!-- lets us match more kinds, not less. It’s almost like every `T` implicitly has -->
<!-- `T: Sized`, and the `?` undoes this default. -->
`?` は 「Tは `Sized` かもしれない」と読みます、これは `?` が特別な境界: より小さいカインドとマッチするのではなく、より大きいカインドとマッチする ということを意味しています。
これは、すべての `T` は暗黙的に `T : Sized` という制限がかけられていて、 `?` はその制限を解除するというようなものです。
