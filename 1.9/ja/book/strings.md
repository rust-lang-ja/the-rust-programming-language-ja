% 文字列
<!-- % Strings -->

<!-- Strings are an important concept for any programmer to master. Rust’s string -->
<!-- handling system is a bit different from other languages, due to its systems -->
<!-- focus. Any time you have a data structure of variable size, things can get -->
<!-- tricky, and strings are a re-sizable data structure. That being said, Rust’s -->
<!-- strings also work differently than in some other systems languages, such as C. -->
文字列は、プログラマがマスタすべき重要な概念です。
Rustの文字列の扱いは、Rust言語がシステムプログラミングにフォーカスしているため、少し他の言語と異なります。
動的なサイズを持つデータ構造があるといつも、物事は複雑性を孕みます。
そして文字列もまたサイズを変更することができるデータ構造です。
これはつまり、Rustの文字列もまた、Cのような他のシステム言語とは少し異なる振る舞いをするということです。


<!-- Let’s dig into the details. A ‘string’ is a sequence of Unicode scalar values -->
<!-- encoded as a stream of UTF-8 bytes. All strings are guaranteed to be a valid -->
<!-- encoding of UTF-8 sequences. Additionally, unlike some systems languages, -->
<!-- strings are not null-terminated and can contain null bytes. -->
詳しく見ていきましょう。「文字列」は、UTF-8のバイトストリームとしてエンコードされたユニコードのスカラ値のシーケンスです。
すべての文字列は、妥当なUTF-8のシーケンスであることが保証されています。
また、他のシステム言語とは異なり、文字列はnull終端でなく、nullバイトを保持することもできます。

<!-- Rust has two main types of strings: `&str` and `String`. Let’s talk about -->
<!-- `&str` first. These are called ‘string slices’. A string slice has a fixed -->
<!-- size, and cannot be mutated. It is a reference to a sequence of UTF-8 bytes. -->
Rustには主要な文字列型が二種類あります。`&str` と `String`です。
まず `&str` について説明しましょう。 `&str` は「文字列スライス」と呼ばれます。
文字列スライスは固定サイズで変更不可能です。文字列スライスはUTF-8のバイトシーケンスへの参照です。


```rust
let greeting = "Hello there."; // greeting: &'static str
```

<!-- `"Hello there."` is a string literal and its type is `&'static str`. A string -->
<!-- literal is a string slice that is statically allocated, meaning that it’s saved -->
<!-- inside our compiled program, and exists for the entire duration it runs. The -->
<!-- `greeting` binding is a reference to this statically allocated string. Any -->
<!-- function expecting a string slice will also accept a string literal. -->
`"Hello there."` は文字列リテラルで、 `&'static str` 型を持ちます。
文字列リテラルは、静的にアロケートされた文字列スライスです。これはつまりコンパイルされたプログラム内に保存されていて、
プログラムの実行中全てにわたって存在しているということです。
`greeting`の束縛はこのように静的にアロケートされた文字列を参照しています。
文字列スライスを引数として期待している関数はすべて文字列リテラルを引数に取ることができます。

<!-- String literals can span multiple lines. There are two forms. The first will -->
<!-- include the newline and the leading spaces: -->
文字列リテラルは複数行にわたることができます。
複数行文字列リテラルには2つの形式があります。
一つ目の形式は、改行と行頭の空白を含む形式です:

```rust
let s = "foo
    bar";

assert_eq!("foo\n        bar", s);
```

<!-- The second, with a `\`, trims the spaces and the newline: -->
もう一つは `\` を使って空白と改行を削る形式です:

```rust
let s = "foo\
    bar";

assert_eq!("foobar", s);
```

<!-- Note that you normally cannot access a `str` directly, but only through a `&str` -->
<!-- reference. This is because `str` is an unsized type which requires additional -->
<!-- runtime information to be usable. For more information see the chapter on -->
<!-- [unsized types][ut]. -->
通常、`str` には直接アクセスできず、 `&str` 経由でのみアクセス出来ることに注意して下さい。
これは `str` がサイズ不定型であり追加の実行時情報がないと使用できないからです。
詳しくは[サイズ不定型][ut]の章を読んで下さい。

<!-- Rust has more than only `&str`s though. A `String` is a heap-allocated string. -->
<!-- This string is growable, and is also guaranteed to be UTF-8. `String`s are -->
<!-- commonly created by converting from a string slice using the `to_string` -->
<!-- method. -->
Rustには `&str` だけでなく、 `String` というヒープアロケートされる文字列もあります。
この文字列は伸張可能であり、またUTF-8であることも保証されています。
`String` は一般的に文字列スライスを `to_string` メソッドで変換することで作成されます。

```rust
let mut s = "Hello".to_string(); // mut s: String
println!("{}", s);

s.push_str(", world.");
println!("{}", s);
```

<!-- `String`s will coerce into `&str` with an `&`: -->
`String` は `&` によって `&str` に型強制されます。

```rust
fn takes_slice(slice: &str) {
    println!("Got: {}", slice);
}

fn main() {
    let s = "Hello".to_string();
    takes_slice(&s);
}
```

<!-- This coercion does not happen for functions that accept one of `&str`’s traits -->
<!-- instead of `&str`. For example, [`TcpStream::connect`][connect] has a parameter -->
<!-- of type `ToSocketAddrs`. A `&str` is okay but a `String` must be explicitly -->
<!-- converted using `&*`. -->
このような変換は `&str` ではなく `&str` の実装するトレイトを引数として取る関数に対しては自動的には行われません。
たとえば、 [`TcpStream::connect`][connect] は引数として型 `ToSocketAddrs` を要求しています。
このような関数には `&str` は渡せますが、 `String` は `&*` を用いて明示的に変換しなければなりません。

```rust,no_run
use std::net::TcpStream;

# // TcpStream::connect("192.168.0.1:3000"); // &str parameter
TcpStream::connect("192.168.0.1:3000"); // 引数として &str を渡す

let addr_string = "192.168.0.1:3000".to_string();
# // TcpStream::connect(&*addr_string); // convert addr_string to &str
TcpStream::connect(&*addr_string); // addr_string を &str に変換して渡す
```

<!-- Viewing a `String` as a `&str` is cheap, but converting the `&str` to a -->
<!-- `String` involves allocating memory. No reason to do that unless you have to! -->
`String` を `&str` として見るコストは低いのですが、`&str` を `String` に変換するとメモリアロケーションが発生します。
必要がなければ、やるべきではないでしょう！

<!-- ## Indexing  -->
## インデクシング

<!-- Because strings are valid UTF-8, strings do not support indexing: -->
文字列は妥当なUTF-8であるため、文字列はインデクシングをサポートしていません:

```rust,ignore
let s = "hello";

# // println!("The first letter of s is {}", s[0]); // ERROR!!!
println!("The first letter of s is {}", s[0]); // エラー!!!
```

<!-- Usually, access to a vector with `[]` is very fast. But, because each character -->
<!-- in a UTF-8 encoded string can be multiple bytes, you have to walk over the -->
<!-- string to find the nᵗʰ letter of a string. This is a significantly more -->
<!-- expensive operation, and we don’t want to be misleading. Furthermore, ‘letter’ -->
<!-- isn’t something defined in Unicode, exactly. We can choose to look at a string as -->
<!-- individual bytes, or as codepoints:-->
普通、ベクタへの `[]` を用いたアクセスはとても高速です。
しかし、UTF-8でエンコードされた文字列内の文字は複数のバイト対応することがあるため、
文字列のn番目の文字を探すには文字列上を走査していく必要があります。
そのような処理はベクタのアクセスに比べると非常に高コストな演算であり、誤解を招きたくなかったのです。
さらに言えば、上の「文字 (letter)」というのはUnicodeでの定義と厳密には一致しません。
文字列をバイト列として見るかコードポイント列として見るか選ぶことができます。

```rust
let hachiko = "忠犬ハチ公";

for b in hachiko.as_bytes() {
    print!("{}, ", b);
}

println!("");

for c in hachiko.chars() {
    print!("{}, ", c);
}

println!("");
```

<!-- This prints: -->
これは、以下の様な出力をします:

```text
229, 191, 160, 231, 138, 172, 227, 131, 143, 227, 131, 129, 229, 133, 172,
忠, 犬, ハ, チ, 公,
```

<!-- As you can see, there are more bytes than `char`s.-->
ご覧のように、 `char` の数よりも多くのバイトが含まれています。

<!-- You can get something similar to an index like this: -->
インデクシングするのと近い結果を以下の様にして得ることができます:

```rust
# let hachiko = "忠犬ハチ公";
let dog = hachiko.chars().nth(1); // hachiko[1]のような感じで
```

<!-- This emphasizes that we have to walk from the beginning of the list of `chars`. -->
このコードは、`chars` のリストの上を先頭から走査しなければならないことを強調しています。

## スライシング

<!-- You can get a slice of a string with slicing syntax: -->
文字列スライスは以下のようにスライス構文を使って取得することができます:

```rust
let dog = "hachiko";
let hachi = &dog[0..5];
```

<!-- But note that these are _byte_ offsets, not _character_ offsets. So -->
<!-- this will fail at runtime: -->
しかし、注意しなくてはならない点はこれらのオフセットは _バイト_ であって _文字_ のオフセットではないという点です。
そのため、以下のコードは実行時に失敗します:

```rust,should_panic
let dog = "忠犬ハチ公";
let hachi = &dog[0..2];
```

<!-- with this error: -->
そして、次のようなエラーが発生します:


```text
thread '<main>' panicked at 'index 0 and/or 2 in `忠犬ハチ公` do not lie on
character boundary'
```

<!-- ## Concatenation -->
## 連結

<!-- If you have a `String`, you can concatenate a `&str` to the end of it: -->
`String` が存在するとき、 `&str` を末尾に連結することができます:

```rust
let hello = "Hello ".to_string();
let world = "world!";

let hello_world = hello + world;
```

<!-- But if you have two `String`s, you need an `&`: -->
しかし、2つの `String` を連結するには、 `&` が必要になります:

```rust
let hello = "Hello ".to_string();
let world = "world!".to_string();

let hello_world = hello + &world;
```

<!-- This is because `&String` can automatically coerce to a `&str`. This is a -->
<!-- feature called ‘[`Deref` coercions][dc]’. -->
これは、 `&String` が自動的に `&str` に型強制されるためです。
このフィーチャは 「 [`Deref` による型強制][dc] 」と呼ばれています。

[ut]: unsized-types.html
[dc]: deref-coercions.html
[connect]: ../std/net/struct.TcpStream.html#method.connect
