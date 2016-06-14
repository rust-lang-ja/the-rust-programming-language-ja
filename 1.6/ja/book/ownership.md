% 所有権
<!-- % Ownership -->

<!-- This guide is one of three presenting Rust’s ownership system. This is one of -->
<!-- Rust’s most unique and compelling features, with which Rust developers should -->
<!-- become quite acquainted. Ownership is how Rust achieves its largest goal, -->
<!-- memory safety. There are a few distinct concepts, each with its own -->
<!-- chapter: -->
このガイドはRustの所有権システムの3つの解説の1つ目です。
これはRustの最も独特で注目されている機能です。そして、Rust開発者はそれについて高度に精通しておくべきです。
所有権こそはRustがその最大の目標、メモリ安全性を得るための方法です。
そこにはいくつかの別個の概念があり、各概念が独自の章を持ちます。

<!-- * ownership, which you’re reading now -->
<!-- * [borrowing][borrowing], and their associated feature ‘references’ -->
<!-- * [lifetimes][lifetimes], an advanced concept of borrowing -->
* 今読んでいる、所有権
* [借用][borrowing] 、そしてそれらに関連する機能、「参照」
* 借用のもう一歩進んだ概念、 [ライフタイム][lifetimes]

<!-- These three chapters are related, and in order. You’ll need all three to fully -->
<!-- understand the ownership system. -->
それらの3つの章は関連していて、それらは順番に並んでいます。
所有権システムを完全に理解するためには、3つ全てを必要とするでしょう。

[borrowing]: references-and-borrowing.html
[lifetimes]: lifetimes.html

<!-- # Meta -->
# 概論

<!-- Before we get to the details, two important notes about the ownership system. -->
詳細に入る前に、所有権システムについての2つの重要な注意があります。

<!-- Rust has a focus on safety and speed. It accomplishes these goals through many -->
<!-- ‘zero-cost abstractions’, which means that in Rust, abstractions cost as little -->
<!-- as possible in order to make them work. The ownership system is a prime example -->
<!-- of a zero-cost abstraction. All of the analysis we’ll talk about in this guide -->
<!-- is _done at compile time_. You do not pay any run-time cost for any of these -->
<!-- features. -->
Rustは安全性とスピートに焦点を合わせます。
Rustはそれらの目標をたくさんの「ゼロコスト抽象化」を通じて成し遂げます。それは、Rustでは抽象化を機能させるためのコストをできる限り小さくすることを意味します。
所有権システムはゼロコスト抽象化の主な例です。
このガイドの中で話すであろう解析の全ては _コンパイル時に行われます_ 。
それらのどの機能に対しても実行時のコストは全く掛かりません。

<!-- However, this system does have a certain cost: learning curve. Many new users -->
<!-- to Rust experience something we like to call ‘fighting with the borrow -->
<!-- checker’, where the Rust compiler refuses to compile a program that the author -->
<!-- thinks is valid. This often happens because the programmer’s mental model of -->
<!-- how ownership should work doesn’t match the actual rules that Rust implements. -->
<!-- You probably will experience similar things at first. There is good news, -->
<!-- however: more experienced Rust developers report that once they work with the -->
<!-- rules of the ownership system for a period of time, they fight the borrow -->
<!-- checker less and less. -->
しかし、このシステムはあるコストを持ちます。それは学習曲線です。
多くの新しいRustのユーザは「借用チェッカとの戦い」と好んで呼ばれるものを経験します。そこではRustコンパイラが開発者が正しいと考えるプログラムをコンパイルすることを拒絶します。
所有権がどのように機能するのかについてのプログラマのメンタルモデルがRustの実装する実際のルールにマッチしないため、これはしばしば起きます。
しかし、よいニュースがあります。より経験豊富なRustの開発者は次のことを報告します。一度彼らが所有権システムのルールとともにしばらく仕事をすれば、彼らが借用チェッカと戦うことは少なくなっていくということです。

<!-- With that in mind, let’s learn about ownership. -->
それを念頭に置いて、所有権について学びましょう。

<!-- # Ownership -->
# 所有権

<!-- [Variable bindings][bindings] have a property in Rust: they ‘have ownership’ -->
<!-- of what they’re bound to. This means that when a binding goes out of scope, -->
<!-- Rust will free the bound resources. For example: -->
Rustでは [変数束縛][bindings] はある特性を持ちます。それは、束縛されているものの「所有権を持つ」ということです。
これは束縛がスコープから外れるとき、Rustは束縛されているリソースを解放するだろうということを意味します。
例えばこうです。

```rust
fn foo() {
    let v = vec![1, 2, 3];
}
```

<!-- When `v` comes into scope, a new [`Vec<T>`][vect] is created. In this case, the -->
<!-- vector also allocates space on [the heap][heap], for the three elements. When -->
<!-- `v` goes out of scope at the end of `foo()`, Rust will clean up everything -->
<!-- related to the vector, even the heap-allocated memory. This happens -->
<!-- deterministically, at the end of the scope. -->
`v` がスコープに入るとき、新しい [`Vec<T>`][vect] が作られます。
この場合、ベクタも3つの要素のために [ヒープ][heap] に空間を割り当てます。
`foo()` の最後で `v` がスコープから外れるとき、Rustはベクタに関連するもの全てを取り除くでしょう。それがヒープ割当てのメモリであってもです。
これはスコープの最後で決定的に起こります。

[vect]: ../std/vec/struct.Vec.html
[heap]: the-stack-and-the-heap.html
[bindings]: variable-bindings.html

<!-- # Move semantics -->
# ムーブセマンティクス

<!-- There’s some more subtlety here, though: Rust ensures that there is _exactly -->
<!-- one_ binding to any given resource. For example, if we have a vector, we can -->
<!-- assign it to another binding: -->
しかし、ここではもっと微妙なことがあります。それは、Rustは与えられたリソースに対する束縛が _1つだけ_ あるということを保証するということです。
例えば、もしベクタがあれば、それを別の束縛に割り当てることはできます。

```rust
let v = vec![1, 2, 3];

let v2 = v;
```

<!-- But, if we try to use `v` afterwards, we get an error: -->
しかし、もし後で `v` を使おうとすると、エラーが出ます。

```rust,ignore
let v = vec![1, 2, 3];

let v2 = v;

println!("v[0] is: {}", v[0]);
```

<!-- It looks like this: -->
それはこのように見えます。

```text
error: use of moved value: `v`
println!("v[0] is: {}", v[0]);
                        ^
```

<!-- A similar thing happens if we define a function which takes ownership, and -->
<!-- try to use something after we’ve passed it as an argument: -->
もし所有権を受け取る関数を定義して、引数として何かを渡した後でそれを使おうとするならば、同じようなことが起きます。

```rust,ignore
fn take(v: Vec<i32>) {
#   // what happens here isn’t important.
    // ここで何が起きるかは重要ではない
}

let v = vec![1, 2, 3];

take(v);

println!("v[0] is: {}", v[0]);
```

<!-- Same error: ‘use of moved value’. When we transfer ownership to something else, -->
<!-- we say that we’ve ‘moved’ the thing we refer to. You don’t need some sort of -->
<!-- special annotation here, it’s the default thing that Rust does. -->
「use of moved value」という同じエラーです。
所有権を何か別のものに転送するとき、参照するものを「ムーブした」と言います。
ここでは特別な種類の注釈を必要としません。
それはRustの行うデフォルトの動作です。

<!-- ## The details -->
## 詳細

<!-- The reason that we cannot use a binding after we’ve moved it is subtle, but -->
<!-- important. When we write code like this: -->
束縛をムーブした後ではそれを使うことができないということの理由は微妙ですが重要です。
このようなコードを書いたとします。

```rust
let v = vec![1, 2, 3];

let v2 = v;
```

<!-- The first line allocates memory for the vector object, `v`, and for the data it -->
<!-- contains. The vector object is stored on the [stack][sh] and contains a pointer -->
<!-- to the content (`[1, 2, 3]`) stored on the [heap][sh]. When we move `v` to `v2`, -->
<!-- it creates a copy of that pointer, for `v2`. Which means that there would be two -->
<!-- pointers to the content of the vector on the heap. It would violate Rust’s -->
<!-- safety guarantees by introducing a data race. Therefore, Rust forbids using `v` -->
<!-- after we’ve done the move. -->
最初の行はベクタオブジェクト `v` とそれの含むデータのためのメモリを割り当てます。
ベクタオブジェクトは [スタック][sh] に保存され、 [ヒープ][sh] に保存された内容（ `[1, 2, 3]` ）へのポインタを含みます。
`v` を `v2` にムーブするとき、それは `v2` のためにそのポインタのコピーを作ります。
それは、ヒープ上のベクタの内容へのポインタが2つあることを意味します。
それはデータ競合を持ち込むことでRustの安全性保証に違反するでしょう。
そのため、Rustはムーブを終えた後の `v` の使用を禁止するのです。

[sh]: the-stack-and-the-heap.html

<!-- It’s also important to note that optimizations may remove the actual copy of -->
<!-- the bytes on the stack, depending on circumstances. So it may not be as -->
<!-- inefficient as it initially seems. -->
最適化が状況によってはスタック上のバイトの実際のコピーを削除するかもしれないことに気付くことも重要です。
そのため、それは最初に思ったほど非効率ではないかもしれません。

<!-- ## `Copy` types -->
## `Copy` 型

<!-- We’ve established that when ownership is transferred to another binding, you -->
<!-- cannot use the original binding. However, there’s a [trait][traits] that changes this -->
<!-- behavior, and it’s called `Copy`. We haven’t discussed traits yet, but for now, -->
<!-- you can think of them as an annotation to a particular type that adds extra -->
<!-- behavior. For example: -->
所有権が他の束縛に転送されるとき、元の束縛を使うことができないということを証明しました。
しかし、この挙動を変更する [トレイト][traits] があります。それは `Copy` と呼ばれます。
トレイトについてはまだ議論していませんが、とりあえずそれらを挙動を追加するある型への注釈として考えることができます。
例えばこうです。

```rust
let v = 1;

let v2 = v;

println!("v is: {}", v);
```

<!-- In this case, `v` is an `i32`, which implements the `Copy` trait. This means -->
<!-- that, just like a move, when we assign `v` to `v2`, a copy of the data is made. -->
<!-- But, unlike a move, we can still use `v` afterward. This is because an `i32` -->
<!-- has no pointers to data somewhere else, copying it is a full copy. -->
この場合、 `v` は `i32` で、それは `Copy` トレイトを実装します。
これはちょうどムーブと同じように、 `v` を `v2` に割り当てるとき、データのコピーが作られるということを意味します。
しかし、ムーブと違って後でまだ `v` を使うことができます。
これは `i32` がどこか別の場所へのポインタを持たず、コピーが完全コピーだからです。

<!-- All primitive types implement the `Copy` trait and their ownership is -->
<!-- therefore not moved like one would assume, following the ´ownership rules´. -->
<!-- To give an example, the two following snippets of code only compile because the -->
<!-- `i32` and `bool` types implement the `Copy` trait. -->
全てのプリミティブ型は `Copy` トレイトを実装しているので、推測どおりそれらの所有権は「所有権ルール」に従ってはムーブしません。
例として、次の2つのコードスニペットはコンパイルが通ります。なぜなら、 `i32` 型と `bool` 型は `Copy` トレイトを実装するからです。

```rust
fn main() {
    let a = 5;

    let _y = double(a);
    println!("{}", a);
}

fn double(x: i32) -> i32 {
    x * 2
}
```

```rust
fn main() {
    let a = true;

    let _y = change_truth(a);
    println!("{}", a);
}

fn change_truth(x: bool) -> bool {
    !x
}
```

<!-- If we had used types that do not implement the `Copy` trait, -->
<!-- we would have gotten a compile error because we tried to use a moved value. -->
もし `Copy` トレイトを実装していない型を使っていたならば、ムーブした値を使おうとしたため、コンパイルエラーが出ていたでしょう。

```text
error: use of moved value: `a`
println!("{}", a);
               ^
```

<!-- We will discuss how to make your own types `Copy` in the [traits][traits] -->
<!-- section. -->
独自の `Copy` 型を作る方法は [トレイト][traits] セクションで議論するでしょう。

[traits]: traits.html

<!-- # More than ownership -->
# 所有権を越えて

<!-- Of course, if we had to hand ownership back with every function we wrote: -->
もちろん、もし書いた全ての関数で所有権を返さなければならないのであれば、こうなります。

```rust
fn foo(v: Vec<i32>) -> Vec<i32> {
#   // do stuff with v
    // vについての作業を行う

#   // hand back ownership
    // 所有権を返す
    v
}
```

<!-- This would get very tedious. It gets worse the more things we want to take ownership of: -->
これは非常に退屈になるでしょう。
もっとたくさんのものの所有権を受け取れば、それはもっとひどくなります。

```rust
fn foo(v1: Vec<i32>, v2: Vec<i32>) -> (Vec<i32>, Vec<i32>, i32) {
#   // do stuff with v1 and v2
    // v1とv2についての作業を行う

#   // hand back ownership, and the result of our function
    // 所有権と関数の結果を返す
    (v1, v2, 42)
}

let v1 = vec![1, 2, 3];
let v2 = vec![1, 2, 3];

let (v1, v2, answer) = foo(v1, v2);
```

<!-- Ugh! The return type, return line, and calling the function gets way more -->
<!-- complicated. -->
うわあ!
戻り値の型、リターン行、関数呼出しがもっと複雑になります。

<!-- Luckily, Rust offers a feature, borrowing, which helps us solve this problem. -->
<!-- It’s the topic of the next section! -->
幸運なことに、Rustは借用という機能を提供します。それはこの問題を解決するために手助けしてくれます。
それが次のセクションの話題です!
