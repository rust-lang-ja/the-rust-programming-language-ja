% 参照と借用
<!-- % References and Borrowing -->

<!-- This guide is two of three presenting Rust’s ownership system. This is one of -->
<!-- Rust’s most unique and compelling features, with which Rust developers should -->
<!-- become quite acquainted. Ownership is how Rust achieves its largest goal, -->
<!-- memory safety. There are a few distinct concepts, each with its own -->
<!-- chapter: -->
このガイドはRustの所有権システムの3つの解説の2つ目です。
これはRustの最も独特で注目されている機能です。そして、Rust開発者はそれについて高度に精通しておくべきです。
所有権こそはRustがその最大の目標、メモリ安全性を得るための方法です。
そこにはいくつかの別個の概念があり、各概念が独自の章を持ちます。

<!-- * [ownership][ownership], the key concept -->
<!-- * borrowing, which you’re reading now -->
<!-- * [lifetimes][lifetimes], an advanced concept of borrowing -->
* キーとなる概念、 [所有権][ownership]
* 今読んでいる、借用
* 借用のもう一歩進んだ概念、 [ライフタイム][lifetimes]

<!-- These three chapters are related, and in order. You’ll need all three to fully -->
<!-- understand the ownership system. -->
それらの3つの章は関連していて、それらは順番に並んでいます。
所有権システムを完全に理解するためには、3つ全てを必要とするでしょう。

[ownership]: ownership.html
[lifetimes]: lifetimes.html

<!-- # Meta -->
# 概論

<!-- Before we get to the details, two important notes about the ownership system. -->
詳細に入る前に、所有権システムについての2つの重要な注意があります。

<!-- Rust has a focus on safety and speed. It accomplishes these goals through many -->
<!-- ‘zero-cost abstractions’, which means that in Rust, abstractions cost as little -->
<!-- as possible in order to make them work. The ownership system is a prime example -->
<!-- of a zero cost abstraction. All of the analysis we’ll talk about in this guide -->
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

<!-- With that in mind, let’s learn about borrowing. -->
それを念頭に置いて、借用について学びましょう。

<!-- # Borrowing -->
# 借用

<!-- At the end of the [ownership][ownership] section, we had a nasty function that looked -->
<!-- like this: -->
[所有権][ownership] セクションの最後に、このような感じの厄介な関数に出会いました。

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

<!-- This is not idiomatic Rust, however, as it doesn’t take advantage of borrowing. Here’s -->
<!-- the first step: -->
しかし、これはRust的なコードではありません。なぜなら、それは借用の利点を生かしていないからです。
これが最初のステップです。

```rust
fn foo(v1: &Vec<i32>, v2: &Vec<i32>) -> i32 {
#   // do stuff with v1 and v2
    // v1とv2についての作業を行う

#   // return the answer
    // 答えを返す
    42
}

let v1 = vec![1, 2, 3];
let v2 = vec![1, 2, 3];

let answer = foo(&v1, &v2);

# // we can use v1 and v2 here!
// ここではv1とv2が使える!
```

<!-- Instead of taking `Vec<i32>`s as our arguments, we take a reference: -->
<!-- `&Vec<i32>`. And instead of passing `v1` and `v2` directly, we pass `&v1` and -->
<!-- `&v2`. We call the `&T` type a ‘reference’, and rather than owning the resource, -->
<!-- it borrows ownership. A binding that borrows something does not deallocate the -->
<!-- resource when it goes out of scope. This means that after the call to `foo()`, -->
<!-- we can use our original bindings again. -->
引数として `Vec<i32>` を使う代わりに、参照、つまり `&Vec<i32>` を使います。
そして、 `v1` と `v2` を直接渡す代わりに、 `&v1` と `&v2` を渡します。
`&T` 型は「参照」と呼ばれ、それは、リソースを所有するのではなく、所有権を借用します。
何かを借用した束縛はそれがスコープから外れるときにリソースを割当解除しません。
これは `foo()` の呼出しの後に元の束縛を再び使うことができることを意味します。

<!-- References are immutable, just like bindings. This means that inside of `foo()`, -->
<!-- the vectors can’t be changed at all: -->
参照は束縛とちょうど同じようにイミュータブルです。
これは `foo()` の中ではベクタは全く変更できないことを意味します。

```rust,ignore
fn foo(v: &Vec<i32>) {
     v.push(5);
}

let v = vec![];

foo(&v);
```

<!-- errors with: -->
次のようなエラーが出ます。

```text
error: cannot borrow immutable borrowed content `*v` as mutable
v.push(5);
^
```

<!-- Pushing a value mutates the vector, and so we aren’t allowed to do it. -->
値の挿入はベクタを変更するものであり、そうすることは許されていません。

<!-- # &mut references -->
# &mut参照

<!-- There’s a second kind of reference: `&mut T`. A ‘mutable reference’ allows you -->
<!-- to mutate the resource you’re borrowing. For example: -->
参照には2つ目の種類、 `&mut T` があります。
「ミュータブルな参照」によって借用しているリソースを変更することができるようになります。
例は次のとおりです。

```rust
let mut x = 5;
{
    let y = &mut x;
    *y += 1;
}
println!("{}", x);
```

<!-- This will print `6`. We make `y` a mutable reference to `x`, then add one to -->
<!-- the thing `y` points at. You’ll notice that `x` had to be marked `mut` as well. -->
<!-- If it wasn’t, we couldn’t take a mutable borrow to an immutable value. -->
これは `6` をプリントするでしょう。
`y` を `x` へのミュータブルな参照にして、それから `y` の指示先に1を足します。
`x` も `mut` とマークしなければならないことに気付くでしょう。
そうしないと、イミュータブルな値へのミュータブルな借用ということになってしまい、使うことができなくなってしまいます。

<!-- You'll also notice we added an asterisk (`*`) in front of `y`, making it `*y`, -->
<!-- this is because `y` is an `&mut` reference. You'll also need to use them for -->
<!-- accessing the contents of a reference as well. -->
アスタリスク（ `*` ）を `y` の前に追加して、それを `*y` にしたことにも気付くでしょう。これは、 `y` が `&mut` 参照だからです。
参照の内容にアクセスするためにもそれらを使う必要があるでしょう。

<!-- Otherwise, `&mut` references are just like references. There _is_ a large -->
<!-- difference between the two, and how they interact, though. You can tell -->
<!-- something is fishy in the above example, because we need that extra scope, with -->
<!-- the `{` and `}`. If we remove them, we get an error: -->
それ以外は、 `&mut` 参照は普通の参照と全く同じです。
しかし、2つの間には、そしてそれらがどのように相互作用するかには大きな違いが _あります_ 。
前の例で何かが怪しいと思ったかもしれません。なぜなら、 `{` と `}` を使って追加のスコープを必要とするからです。
もしそれらを削除すれば、次のようなエラーが出ます。

```text
error: cannot borrow `x` as immutable because it is also borrowed as mutable
    println!("{}", x);
                   ^
note: previous borrow of `x` occurs here; the mutable borrow prevents
subsequent moves, borrows, or modification of `x` until the borrow ends
        let y = &mut x;
                     ^
note: previous borrow ends here
fn main() {

}
^
```

<!-- As it turns out, there are rules. -->
結論から言うと、ルールがあります。

<!-- # The Rules -->
# ルール

<!-- Here’s the rules about borrowing in Rust: -->
これがRustでの借用についてのルールです。

<!-- First, any borrow must last for a scope no greater than that of the owner. -->
<!-- Second, you may have one or the other of these two kinds of borrows, but not -->
<!-- both at the same time: -->
最初に、借用は全て所有者のスコープより長く存続してはなりません。
次に、次の2種類の借用のどちらか1つを持つことはありますが、両方を同時に持つことはありません。

<!-- * one or more references (`&T`) to a resource, -->
<!-- * exactly one mutable reference (`&mut T`). -->
* リソースに対する1つ以上の参照（ `&T` ）
* ただ1つのミュータブルな参照（ `&mut T` ）

<!-- You may notice that this is very similar, though not exactly the same as, -->
<!-- to the definition of a data race: -->
これがデータ競合の定義と非常に似ていることに気付くかもしれません。全く同じではありませんが。

<!-- &lt; There is a ‘data race’ when two or more pointers access the same memory -->
<!-- &lt; location at the same time, where at least one of them is writing, and the -->
<!-- &lt; operations are not synchronized. -->
> 「データ競合」は2つ以上のポインタがメモリの同じ場所に同時にアクセスするとき、少なくともそれらの1つが書込みを行っていて、作業が同期されていないところで「データ競合」は起きます。

<!-- With references, you may have as many as you’d like, since none of them are -->
<!-- writing. However, as we can only have one `&mut` at a time, it is impossible to -->
<!-- have a data race. This is how Rust prevents data races at compile time: we’ll -->
<!-- get errors if we break the rules. -->
書込みを行わないのであれば、参照は好きな数だけ使うことができます。
`&mut` は同時に1つしか持つことができないので、データ競合は起き得ません。
これがRustがデータ競合をコンパイル時に回避する方法です。もしルールを破れば、そのときはエラーが出るでしょう。

<!-- With this in mind, let’s consider our example again. -->
これを念頭に置いて、もう一度例を考えましょう。

<!-- ## Thinking in scopes -->
## スコープの考え方

<!-- Here’s the code: -->
このコードについて考えていきます。

```rust,ignore
let mut x = 5;
let y = &mut x;

*y += 1;

println!("{}", x);
```

<!-- This code gives us this error: -->
このコードは次のようなエラーを出します。

```text
error: cannot borrow `x` as immutable because it is also borrowed as mutable
    println!("{}", x);
                   ^
```

<!-- This is because we’ve violated the rules: we have a `&mut T` pointing to `x`, -->
<!-- and so we aren’t allowed to create any `&T`s. One or the other. The note -->
<!-- hints at how to think about this problem: -->
なぜなら、これはルールに違反しているからです。つまり、 `x` を指示する `&mut T` を持つので、 `&T` を作ることは許されないのです。
どちらか1つです。
note の部分はこの問題についての考え方のヒントを示します。

```text
note: previous borrow ends here
fn main() {

}
^
```

<!-- In other words, the mutable borrow is held through the rest of our example. What -->
<!-- we want is for the mutable borrow to end _before_ we try to call `println!` and -->
<!-- make an immutable borrow. In Rust, borrowing is tied to the scope that the -->
<!-- borrow is valid for. And our scopes look like this: -->
言い換えると、ミュータブルな借用は先程の例の残りの間ずっと保持されるということです。
必要なものは、 `println!` を呼び出し、イミュータブルな借用を作ろうとする _前に_ 終わるミュータブルな借用です。
Rustでは借用はその有効なスコープと結び付けられます。
そしてスコープはこのように見えます。

```rust,ignore
let mut x = 5;

# let y = &mut x;    // -+ &mut borrow of x starts here
#                    //  |
# *y += 1;           //  |
#                    //  |
# println!("{}", x); // -+ - try to borrow x here
#                    // -+ &mut borrow of x ends here
let y = &mut x;    // -+ xの&mut借用がここから始まる
                   //  |
*y += 1;           //  |
                   //  |
println!("{}", x); // -+ - ここでxを借用しようとする
                   // -+ xの&mut借用がここで終わる
```

<!-- The scopes conflict: we can’t make an `&x` while `y` is in scope. -->
スコープは衝突します。 `y` がスコープにある間は、 `&x` を作ることができません。

<!-- So when we add the curly braces: -->
そして、波括弧を追加するときはこうなります。

```rust
let mut x = 5;

{
#     let y = &mut x; // -+ &mut borrow starts here
#     *y += 1;        //  |
# }                   // -+ ... and ends here
    let y = &mut x; // -+ &mut借用がここから始まる
    *y += 1;        //  |
}                   // -+ ... そしてここで終わる

# println!("{}", x);  // <- try to borrow x here
println!("{}", x);  // <- ここでxを借用しようとする
```

<!-- There’s no problem. Our mutable borrow goes out of scope before we create an -->
<!-- immutable one. But scope is the key to seeing how long a borrow lasts for. -->
問題ありません。
ミュータブルな借用はイミュータブルな借用を作る前にスコープから外れます。
しかしスコープは借用がどれくらい存続するのか理解するための鍵となります。

<!-- ## Issues borrowing prevents -->
## 借用が回避する問題

<!-- Why have these restrictive rules? Well, as we noted, these rules prevent data -->
<!-- races. What kinds of issues do data races cause? Here’s a few. -->
なぜこのような厳格なルールがあるのでしょうか。
そう、前述したように、それらのルールはデータ競合を回避します。
データ競合はどのような種類の問題を起こすのでしょうか。
ここに一部を示します。

<!-- ### Iterator invalidation -->
### イテレータの無効

<!-- One example is ‘iterator invalidation’, which happens when you try to mutate a -->
<!-- collection that you’re iterating over. Rust’s borrow checker prevents this from -->
<!-- happening: -->
一例は「イテレータの無効」です。それは繰返しを行っているコレクションを変更しようとするときに起こります。
Rustの借用チェッカはこれの発生を回避します。

```rust
let mut v = vec![1, 2, 3];

for i in &v {
    println!("{}", i);
}
```

<!-- This prints out one through three. As we iterate through the vectors, we’re -->
<!-- only given references to the elements. And `v` is itself borrowed as immutable, -->
<!-- which means we can’t change it while we’re iterating: -->
これは1から3までをプリントアウトします。
ベクタに対して繰り返すとき、要素への参照だけを受け取ります。
そして、 `v` はそれ自体イミュータブルとして借用され、それは繰返しを行っている間はそれを変更できないことを意味します。

```rust,ignore
let mut v = vec![1, 2, 3];

for i in &v {
    println!("{}", i);
    v.push(34);
}
```

<!-- Here’s the error: -->
これがエラーです。

```text
error: cannot borrow `v` as mutable because it is also borrowed as immutable
    v.push(34);
    ^
note: previous borrow of `v` occurs here; the immutable borrow prevents
subsequent moves or mutable borrows of `v` until the borrow ends
for i in &v {
          ^
note: previous borrow ends here
for i in &v {
    println!(“{}”, i);
    v.push(34);
}
^
```

<!-- We can’t modify `v` because it’s borrowed by the loop. -->
`v` はループによって借用されるので、それを変更することはできません。

<!-- ### use after free -->
### 解放後の使用

<!-- References must not live longer than the resource they refer to. Rust will -->
<!-- check the scopes of your references to ensure that this is true. -->
参照はそれらの指示するリソースよりも長く生存することはできません。
Rustはこれが真であることを保証するために、参照のスコープをチェックするでしょう。

<!-- If Rust didn’t check this property, we could accidentally use a reference -->
<!-- which was invalid. For example: -->
もしRustがこの性質をチェックしなければ、無効な参照をうっかり使ってしまうかもしれません。
例えばこうです。

```rust,ignore
let y: &i32;
{
    let x = 5;
    y = &x;
}

println!("{}", y);
```

<!-- We get this error: -->
次のようなエラーが出ます。

```text
error: `x` does not live long enough
    y = &x;
         ^
note: reference must be valid for the block suffix following statement 0 at
2:16...
let y: &i32;
{
    let x = 5;
    y = &x;
}

note: ...but borrowed value is only valid for the block suffix following
statement 0 at 4:18
    let x = 5;
    y = &x;
}
```

<!-- In other words, `y` is only valid for the scope where `x` exists. As soon as -->
<!-- `x` goes away, it becomes invalid to refer to it. As such, the error says that -->
<!-- the borrow ‘doesn’t live long enough’ because it’s not valid for the right -->
<!-- amount of time. -->
言い換えると、 `y` は `x` が存在するスコープの中でだけ有効だということです。
`x` がなくなるとすぐに、それを指示することは不正になります。
そのように、エラーは借用が「十分長く生存していない」ことを示します。なぜなら、それが正しい期間有効ではないからです。

<!-- The same problem occurs when the reference is declared _before_ the variable it -->
<!-- refers to. This is because resources within the same scope are freed in the -->
<!-- opposite order they were declared: -->
参照がそれの参照する変数より _前に_ 宣言されたとき、同じ問題が起こります。
これは同じスコープにあるリソースはそれらの宣言された順番と逆に解放されるからです。

```rust,ignore
let y: &i32;
let x = 5;
y = &x;

println!("{}", y);
```

<!-- We get this error: -->
次のようなエラーが出ます。

```text
error: `x` does not live long enough
y = &x;
     ^
note: reference must be valid for the block suffix following statement 0 at
2:16...
    let y: &i32;
    let x = 5;
    y = &x;

    println!("{}", y);
}

note: ...but borrowed value is only valid for the block suffix following
statement 1 at 3:14
    let x = 5;
    y = &x;

    println!("{}", y);
}
```

<!-- In the above example, `y` is declared before `x`, meaning that `y` lives longer -->
<!-- than `x`, which is not allowed. -->
前の例では、 `y` は `x` より前に宣言されています。それは、 `y` が `x` より長く生存することを意味し、それは許されません。
