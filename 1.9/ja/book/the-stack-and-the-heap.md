% スタックとヒープ
<!-- % The Stack and the Heap -->

<!--
As a systems language, Rust operates at a low level. If you’re coming from a
high-level language, there are some aspects of systems programming that you may
not be familiar with. The most important one is how memory works, with a stack
and a heap. If you’re familiar with how C-like languages use stack allocation,
this chapter will be a refresher. If you’re not, you’ll learn about this more
general concept, but with a Rust-y focus.
-->
Rustはシステム言語なので、低水準の操作を行います。
もしあなたが高水準言語を使ってきたのであれば、システムプログラミングのいくつかの側面をよく知らないかもしれません。
一番重要なのは、スタックとヒープと関連してメモリがどのように機能するかということです。
もしC言語のような言語でスタックアロケーションをどのように使っているかをよく知っているのであれば、この章は復習になるでしょう。
そうでなければ、このより一般的な概念について、Rust流の焦点の絞り方ではありますが、学んでゆくことになるでしょう。

<!--
As with most things, when learning about them, we’ll use a simplified model to
start. This lets you get a handle on the basics, without getting bogged down
with details which are, for now, irrelevant. The examples we’ll use aren’t 100%
accurate, but are representative for the level we’re trying to learn at right
now. Once you have the basics down, learning more about how allocators are
implemented, virtual memory, and other advanced topics will reveal the leaks in
this particular abstraction.
-->
ほとんどの物事と同様に、それらについて学ぶにあたって、まず簡略化したモデルを使って始めましょう。
そうすることで、今は無関係な枝葉末節に足を取られることなく、基本を把握できます。
これから使う例示は100%正確ではありませんが、現時点で学ぼうとするレベルのための見本になっています。
ひとたび基本を飲み込めば、アロケータがどう実装されているかや仮想メモリなどの発展的なトピックを学ぶことによって、この特殊な抽象モデルが取り漏らしているものが明らかになるでしょう。

# メモリ管理
<!--# Memory management-->

<!--
These two terms are about memory management. The stack and the heap are
abstractions that help you determine when to allocate and deallocate memory.
-->
これら2つの用語はメモリ管理についてのものです。スタックとヒープは、いつメモリをアロケート・デアロケートするのかを決定するのを助ける抽象化です。

<!--
Here’s a high-level comparison:
-->
大まかに比較してみましょう:

<!--
The stack is very fast, and is where memory is allocated in Rust by default.
But the allocation is local to a function call, and is limited in size. The
heap, on the other hand, is slower, and is explicitly allocated by your
program. But it’s effectively unlimited in size, and is globally accessible.
-->
スタックはとても高速で、Rustにおいてデフォルトでメモリが確保される場所です。
しかし、このアロケーションはひとつの関数呼び出しに限られた局所的なもので、サイズに制限があります。
一方、ヒープはより遅く、プログラムによって明示的にアロケートされます。
しかし、事実上サイズに制限がなく、広域的にアクセス可能です。

# スタック
<!--# The Stack-->

<!--
Let’s talk about this Rust program:
-->
次のRustプログラムについて話しましょう:

```rust
fn main() {
    let x = 42;
}
```

<!--
This program has one variable binding, `x`. This memory needs to be allocated
from somewhere. Rust ‘stack allocates’ by default, which means that basic
values ‘go on the stack’. What does that mean?
-->
このプログラムは変数 `x` の束縛をひとつ含んでいます。
このメモリはどこかからアロケートされる必要があります。
Rustはデフォルトで「スタックアロケート」、すなわち基本的な値を「スタックに置く」ということをします。
それはどういう意味でしょうか。

<!--
Well, when a function gets called, some memory gets allocated for all of its
local variables and some other information. This is called a ‘stack frame’, and
for the purpose of this tutorial, we’re going to ignore the extra information
and only consider the local variables we’re allocating. So in this case, when
`main()` is run, we’ll allocate a single 32-bit integer for our stack frame.
This is automatically handled for you, as you can see; we didn’t have to write
any special Rust code or anything.
-->
関数が呼び出されたとき、関数中のローカル変数とそのほかの多少の情報のためにメモリがいくらかアロケートされます。
これを「スタックフレーム」と呼びますが、このチュートリアルにおいては、余分な情報は無視して、アロケートするローカル変数だけを考えることにします。
なので今回の場合は、 `main()` が実行されるとき、スタックフレームとして32ビット整数をただ1つアロケートすることになります。
これは、見ての通り自動的に取り扱われるので、特別なRustコードか何かを書く必要はありません。

<!--
When the function exits, its stack frame gets deallocated. This happens
automatically as well.
-->
関数が終了するとき、スタックフレームはデアロケートされます。これもアロケーションと同様自動的に行われます。

<!--
That’s all there is for this simple program. The key thing to understand here
is that stack allocation is very, very fast. Since we know all the local
variables we have ahead of time, we can grab the memory all at once. And since
we’ll throw them all away at the same time as well, we can get rid of it very
fast too.
-->
これが、この単純なプログラムにあるものすべてです。
ここで理解する鍵となるのは、スタックアロケーションはとても、とても高速だということです。
ローカル変数はすべて事前にわかっているので、メモリを一度に確保できます。
また、破棄するときも同様に、変数をすべて同時に破棄できるので、こちらもとても高速に済みます。

<!--
The downside is that we can’t keep values around if we need them for longer
than a single function. We also haven’t talked about what the word, ‘stack’,
means. To do that, we need a slightly more complicated example:
-->
この話でよくないことは、単一の関数を超えて値が必要でも、その値を保持しつづけられないことです。
また、「スタック」が何を意味するのかについてまだ話していませんでした。
その点について見るために、もう少し複雑な例が必要です。

```rust
fn foo() {
    let y = 5;
    let z = 100;
}

fn main() {
    let x = 42;

    foo();
}
```

<!--
This program has three variables total: two in `foo()`, one in `main()`. Just
as before, when `main()` is called, a single integer is allocated for its stack
frame. But before we can show what happens when `foo()` is called, we need to
visualize what’s going on with memory. Your operating system presents a view of
memory to your program that’s pretty simple: a huge list of addresses, from 0
to a large number, representing how much RAM your computer has. For example, if
you have a gigabyte of RAM, your addresses go from `0` to `1,073,741,823`. That
number comes from 2<sup>30</sup>, the number of bytes in a gigabyte. [^gigabyte]
-->
このプログラムには変数が `foo()` に2つ、 `main()` に1つで、全部で3つあります。
前の例と同様に `main()` が呼び出されたときは1つの整数がスタックフレームとしてアロケートされます。
しかし、 `foo()` が呼び出されたときに何が起こるかを話す前に、まずメモリ上に何が置いてあるかを図示する必要があります。
オペレーティングシステムは、メモリをプログラムに対してとてもシンプルなものとして見せています。それは、0からコンピュータが搭載しているRAMの容量を表現する大きな数までのアドレスの巨大なリストです。
たとえば、もしあなたのコンピュータに1ギガバイトのRAMがのっていれば、アドレスは`0`から`1,073,741,823`になります。
この数値は、1ギガバイトのバイト数である2<sup>30</sup>から来ています。[^gigabyte]

<!-- [^gigabyte]: ‘Gigabyte’ can mean two things: 10^9, or 2^30. The SI standard resolved this by stating that ‘gigabyte’ is 10^9, and ‘gibibyte’ is 2^30. However, very few people use this terminology, and rely on context to differentiate. We follow in that tradition here. -->
[^gigabyte]: 「ギガバイト」が指すものには、 10<sup>9</sup> と 2<sup>30</sup> の2つがありえます。国際単位系 SI では「ギガバイト」は 10<sup>9</sup> を、「ギビバイト」は 2<sup>30</sup> を指すと決めることで、この問題を解決しています。しかしながら、このような用語法を使う人はとても少なく、文脈で両者を区別しています。ここでは、その慣習に則っています。

<!--
This memory is kind of like a giant array: addresses start at zero and go
up to the final number. So here’s a diagram of our first stack frame:
-->
このメモリは巨大な配列のようなものです。すなわち、アドレスは0から始まり、最後の番号まで続いています。そして、これが最初のスタックフレームの図です:

| Address | Name | Value |
|---------|------|-------|
| 0       | x    | 42    |

<!--
We’ve got `x` located at address `0`, with the value `42`.
-->
この図から、 `x` はアドレス `0` に置かれ、その値は `42` だとわかります。

<!--
When `foo()` is called, a new stack frame is allocated:
-->
`foo()` が呼び出されると、新しいスタックフレームがアロケートされます:

| Address | Name | Value |
|---------|------|-------|
| 2       | z    | 100   |
| 1       | y    | 5     |
| 0       | x    | 42    |

<!--
Because `0` was taken by the first frame, `1` and `2` are used for `foo()`’s
stack frame. It grows upward, the more functions we call.
-->
`0` は最初のフレームに取られているので、 `1` と `2` が `foo()` のスタックフレームのために使われます。
これは、関数呼び出しが行われるたびに上に伸びていきます。

<!--
There are some important things we have to take note of here. The numbers 0, 1,
and 2 are all solely for illustrative purposes, and bear no relationship to the
address values the computer will use in reality. In particular, the series of
addresses are in reality going to be separated by some number of bytes that
separate each address, and that separation may even exceed the size of the
value being stored.
-->
ここで注意しなければならない重要なことがいくつかあります。
`0`, `1`, `2` といった番号は単に解説するためのもので、コンピュータが実際に使うアドレス値とは関係がありません。
特に、連続したアドレスは、実際にはそれぞれ数バイトずつ隔てられていて、その間隔は格納されている値のサイズより大きいこともあります。

<!--
After `foo()` is over, its frame is deallocated:
-->
`foo()` が終了した後、そのフレームはデアロケートされます:

| Address | Name | Value |
|---------|------|-------|
| 0       | x    | 42    |

<!--
And then, after `main()`, even this last value goes away. Easy!
-->
そして `main()` の後には、残っている値も消えてなくなります。簡単ですね!

<!--
It’s called a ‘stack’ because it works like a stack of dinner plates: the first
plate you put down is the last plate to pick back up. Stacks are sometimes
called ‘last in, first out queues’ for this reason, as the last value you put
on the stack is the first one you retrieve from it.
-->
「スタック」という名は、積み重ねたディナープレート（a stack of dinner plates）のように働くことに由来します。
最初に置かれたプレートは、最後に取り去られるプレートです。
そのため、スタックはしばしば「last in, first out queues」（訳注: 最後に入ったものが最初に出るキュー、LIFOと略記される）と呼ばれ、最後にスタックに積んだ値は最初にスタックから取り出す値になります。

<!--
Let’s try a three-deep example:
-->
3段階の深さの例を見てみましょう:

```rust
fn italic() {
    let i = 6;
}

fn bold() {
    let a = 5;
    let b = 100;
    let c = 1;

    italic();
}

fn main() {
    let x = 42;

    bold();
}
```

<!--
We have some kooky function names to make the diagrams clearer.
-->
分かりやすいようにちょと変な名前をつけています。

<!--
Okay, first, we call `main()`:
-->
それでは、まず、 `main()` を呼び出します:

| Address | Name | Value |
|---------|------|-------|
| 0       | x    | 42    |

<!--
Next up, `main()` calls `bold()`:
-->
次に、 `main()` は `bold()` を呼び出します:

| Address | Name | Value |
|---------|------|-------|
| **3**   | **c**|**1**  |
| **2**   | **b**|**100**|
| **1**   | **a**| **5** |
| 0       | x    | 42    |

<!--
And then `bold()` calls `italic()`:
-->
そして `bold()` は `italic()` を呼び出します:

| Address | Name | Value |
|---------|------|-------|
| *4*     | *i*  | *6*   |
| **3**   | **c**|**1**  |
| **2**   | **b**|**100**|
| **1**   | **a**| **5** |
| 0       | x    | 42    |

<!--
Whew! Our stack is growing tall.
-->
ふう、スタックが高く伸びましたね。

<!--
After `italic()` is over, its frame is deallocated, leaving just `bold()` and
`main()`:
-->
`italic()` が終了した後、そのフレームはデアロケートされて `bold()` と `main()` だけが残ります:

| Address | Name | Value |
|---------|------|-------|
| **3**   | **c**|**1**  |
| **2**   | **b**|**100**|
| **1**   | **a**| **5** |
| 0       | x    | 42    |

<!--
And then `bold()` ends, leaving just `main()`:
-->
そして `bold()` が終了すると `main()` だけが残ります:

| Address | Name | Value |
|---------|------|-------|
| 0       | x    | 42    |

<!--
And then we’re done. Getting the hang of it? It’s like piling up dishes: you
add to the top, you take away from the top.
-->
ついに、やりとげました。コツをつかみましたか? 皿を積み重ねるようなものです。
つまり、一番上に追加し、一番上から取るんです。

# ヒープ
<!--# The Heap-->

<!--
Now, this works pretty well, but not everything can work like this. Sometimes,
you need to pass some memory between different functions, or keep it alive for
longer than a single function’s execution. For this, we can use the heap.
-->
さて、このやり方は結構うまくいくのですが、すべてがこのようにいくわけではありません。
ときには、メモリを異なる関数間でやりとりしたり、1回の関数実行より長く保持する必要があります。
そのためには、ヒープを使います。

<!--
In Rust, you can allocate memory on the heap with the [`Box<T>` type][box].
Here’s an example:
-->
Rustでは、[`Box<T>` 型][box]を使うことで、メモリをヒープ上にアロケートできます。

```rust
fn main() {
    let x = Box::new(5);
    let y = 42;
}
```

[box]: ../std/boxed/index.html

<!--
Here’s what happens in memory when `main()` is called:
-->
`main()` が呼び出されたとき、メモリは次のようになります:

| Address | Name | Value  |
|---------|------|--------|
| 1       | y    | 42     |
| 0       | x    | ?????? |

<!--
We allocate space for two variables on the stack. `y` is `42`, as it always has
been, but what about `x`? Well, `x` is a `Box<i32>`, and boxes allocate memory
on the heap. The actual value of the box is a structure which has a pointer to
‘the heap’. When we start executing the function, and `Box::new()` is called,
it allocates some memory for the heap, and puts `5` there. The memory now looks
like this:
-->
2つの変数のために、スタック上に領域がアロケートされます。
通常通り、 `y` は `42` になりますが、 `x` はどうなるのでしょうか?
`x` は `Box<i32>` 型で、ボックスはヒープ上のメモリをアロケートします。
このボックスの実際の値は、「ヒープ」へのポインタを持ったストラクチャです。
関数の実行が開始され、 `Box::new()` が呼び出されると、ヒープ上のメモリがいくらかアロケートされ、そこに `5` が置かれます。
すると、メモリはこんな感じになります:


| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 5                      |
| ...                  | ...  | ...                    |
| 1                    | y    | 42                     |
| 0                    | x    | → (2<sup>30</sup>) - 1 |

<!--
We have (2<sup>30</sup>) - 1 addresses in our hypothetical computer with 1GB of RAM. And since
our stack grows from zero, the easiest place to allocate memory is from the
other end. So our first value is at the highest place in memory. And the value
of the struct at `x` has a [raw pointer][rawpointer] to the place we’ve
allocated on the heap, so the value of `x` is (2<sup>30</sup>) - 1, the memory
location we’ve asked for.
-->
今考えている1GBのRAMを備えた仮想のコンピュータには (2<sup>30</sup>) - 1 のアドレスがあります。
また、スタックはゼロから伸びていますから、メモリをアロケートするのに一番楽なのは、反対側の端の場所です。
ですから、最初の値はメモリのうち番号が一番大きい場所に置かれます。
そして、 `x` にある構造体はヒープ上にアロケートした場所への[生ポインタ][rawpointer]を持っているので、 `x` の値は、今求めた位置 (2<sup>30</sup>) - 1 です。

[rawpointer]: raw-pointers.html

<!--
We haven’t really talked too much about what it actually means to allocate and
deallocate memory in these contexts. Getting into very deep detail is out of
the scope of this tutorial, but what’s important to point out here is that
the heap isn’t a stack that grows from the opposite end. We’ll have an
example of this later in the book, but because the heap can be allocated and
freed in any order, it can end up with ‘holes’. Here’s a diagram of the memory
layout of a program which has been running for a while now:
-->
ここまでの話では、メモリをアロケート・デアロケートするということのこの文脈における意味を過剰に語ることはありませんでした。
詳細を深く掘り下げるのはこのチュートリアルの目的範囲外なのですが、ここで重要なこととして指摘したいのは、ヒープは単にメモリの反対側から伸びるスタックなのではないということです。
後ほど例を見ていきますが、ヒープはアロケート・デアロケートをどの順番にしてもよく、その結果「穴」のある状態になります。
次の図は、とあるプログラムをしばらく実行していたときのメモリレイアウトです。


| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 5                      |
| (2<sup>30</sup>) - 2 |      |                        |
| (2<sup>30</sup>) - 3 |      |                        |
| (2<sup>30</sup>) - 4 |      | 42                     |
| ...                  | ...  | ...                    |
| 3                    | y    | → (2<sup>30</sup>) - 4 |
| 2                    | y    | 42                     |
| 1                    | y    | 42                     |
| 0                    | x    | → (2<sup>30</sup>) - 1 |

<!--
In this case, we’ve allocated four things on the heap, but deallocated two of
them. There’s a gap between (2<sup>30</sup>) - 1 and (2<sup>30</sup>) - 4 which isn’t
currently being used. The specific details of how and why this happens depends
on what kind of strategy you use to manage the heap. Different programs can use
different ‘memory allocators’, which are libraries that manage this for you.
Rust programs use [jemalloc][jemalloc] for this purpose.
-->
この場合では、4つのものをヒープにアロケートしていますが、2つはすでにデアロケートされています。
アドレス (2<sup>30</sup>) - 1 と (2<sup>30</sup>) - 4 の間には、現在使われていない隙間があります。このような隙間がなぜ、どのように起きるかの詳細は、どのようなヒープ管理戦略を使っているかによります。
異なるブログラムには異なる「メモリアロケータ」というメモリを管理するライブラリを使うことができます。
Rustのプログラムはこの用途に[jemalloc][jemalloc]を使います。

[jemalloc]: http://www.canonware.com/jemalloc/

<!--
Anyway, back to our example. Since this memory is on the heap, it can stay
alive longer than the function which allocates the box. In this case, however,
it doesn’t.[^moving] When the function is over, we need to free the stack frame
for `main()`. `Box<T>`, though, has a trick up its sleeve: [Drop][drop]. The
implementation of `Drop` for `Box` deallocates the memory that was allocated
when it was created. Great! So when `x` goes away, it first frees the memory
allocated on the heap:
-->
ともかく、私たちのプログラムの例に戻ります。
この（訳注: `x` のポインタが指す）メモリはヒープ上にあるので、ボックスをアロケートした関数よりも長い間生存しつづけることができます。
しかし、この例ではそうではありません。[^moving]
関数が終了したとき、 `main()` のためのスタックフレームを解放する必要があります。
しかし、`Box<T>`には隠れた仕掛け、[Drop][drop]があります。
`Drop`トレイトの`Box`への実装は、ボックスが作られたときにアロケートされたメモリをデアロケートします。すばらしい!
なので `x` が解放されるときには先にヒープ上にアロケートされたメモリを解放します。

| Address | Name | Value  |
|---------|------|--------|
| 1       | y    | 42     |
| 0       | x    | ?????? |

[drop]: drop.html

<!-- [^moving]: We can make the memory live longer by transferring ownership, -->
<!--            sometimes called ‘moving out of the box’. More complex examples will -->
<!--            be covered later. -->
<!-- 訳注: 元の表現は「ボックスからのムーブアウト」だが、誤りなので修正した。 -->
[^moving]: （「変数からのムーブアウト」とも呼ばれることもある）所有権の移動によって、メモリをより長い間生存させられます。
           より複雑な例は後ほど解説します。

<!--
And then the stack frame goes away, freeing all of our memory.
-->
その後スタックフレームが無くなることで、全てのメモリが解放されます。

# 引数と借用
<!--# Arguments and borrowing-->

<!--
We’ve got some basic examples with the stack and the heap going, but what about
function arguments and borrowing? Here’s a small Rust program:
-->
ここまででスタックとヒープの基本的な例をいくつか学び進めましたが、関数の引数と借用についてはどうでしょうか?
ここに小さなRustプログラムがあります:

```rust
fn foo(i: &i32) {
    let z = 42;
}

fn main() {
    let x = 5;
    let y = &x;

    foo(y);
}
```

<!--
When we enter `main()`, memory looks like this:
-->
処理が `main()` に入ると、メモリはこんな感じになります:

| Address | Name | Value  |
|---------|------|--------|
| 1       | y    | → 0    |
| 0       | x    | 5      |

<!--
`x` is a plain old `5`, and `y` is a reference to `x`. So its value is the
memory location that `x` lives at, which in this case is `0`.
-->
`x` は普通の `5` で、 `y` は `x` への参照です。そのため、 `y` の値は `x` のメモリ上の位置で、今回は `0` です。

<!--
What about when we call `foo()`, passing `y` as an argument?
-->
引数として `y` を渡している関数 `foo()` の呼び出しはどうなるのでしょうか?

| Address | Name | Value  |
|---------|------|--------|
| 3       | z    | 42     |
| 2       | i    | → 0    |
| 1       | y    | → 0    |
| 0       | x    | 5      |

<!--
Stack frames aren’t only for local bindings, they’re for arguments too. So in
this case, we need to have both `i`, our argument, and `z`, our local variable
binding. `i` is a copy of the argument, `y`. Since `y`’s value is `0`, so is
`i`’s.
-->
スタックフレームは単にローカルな束縛のために使われるだけでなく、引数のためにも使われます。
なので、この例では、引数の `i` とローカル変数の束縛 `z` の両方が必要です。
`i` は引数 `y` のコピーです。
`y` の値は `0` ですから、 `i` の値も `0` になります。

<!--
This is one reason why borrowing a variable doesn’t deallocate any memory: the
value of a reference is a pointer to a memory location. If we got rid of
the underlying memory, things wouldn’t work very well.
-->
これは、変数を借用してもどのメモリもデアロケートされることがないことのひとつの理由になっています。
つまり、参照の値はメモリ上の位置を示すポインタです。
もしポインタが指しているメモリを取り去ってしまうと、ことが立ちゆかなくなってしまうでしょう。

# 複雑な例
<!--# A complex example-->

<!--
Okay, let’s go through this complex program step-by-step:
-->
それでは、次の複雑な例をステップ・バイ・ステップでやっていきましょう:

```rust
fn foo(x: &i32) {
    let y = 10;
    let z = &y;

    baz(z);
    bar(x, z);
}

fn bar(a: &i32, b: &i32) {
    let c = 5;
    let d = Box::new(5);
    let e = &d;

    baz(e);
}

fn baz(f: &i32) {
    let g = 100;
}

fn main() {
    let h = 3;
    let i = Box::new(20);
    let j = &h;

    foo(j);
}
```

<!--
First, we call `main()`:
-->
まず、`main()`を呼び出します:

| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 20                     |
| ...                  | ...  | ...                    |
| 2                    | j    | → 0                    |
| 1                    | i    | → (2<sup>30</sup>) - 1 |
| 0                    | h    | 3                      |

<!--
We allocate memory for `j`, `i`, and `h`. `i` is on the heap, and so has a
value pointing there.
-->
<!-- 訳注: 原文の「`i` はヒープ上にあるので」は誤りなので、「..が束縛されるボックスが確保する領域..」を追記した。 -->
`j`, `i`, `h` のためのメモリをアロケートします。
`i` が束縛されるボックスが確保する領域はヒープ上にあるので、 `i` はそこを指す値を持っています。

<!--
Next, at the end of `main()`, `foo()` gets called:
-->
つぎに、 `main()` の最後で、 `foo()` が呼び出されます:

| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 20                     |
| ...                  | ...  | ...                    |
| 5                    | z    | → 4                    |
| 4                    | y    | 10                     |
| 3                    | x    | → 0                    |
| 2                    | j    | → 0                    |
| 1                    | i    | → (2<sup>30</sup>) - 1 |
| 0                    | h    | 3                      |

<!--
Space gets allocated for `x`, `y`, and `z`. The argument `x` has the same value
as `j`, since that’s what we passed it in. It’s a pointer to the `0` address,
since `j` points at `h`.
-->
`x`, `y`, `z`のための空間が確保されます。
引数 `x` は、渡された `j` と同じ値を持ちます。
`j` は `h` を指しているので、値は `0` アドレスを指すポインタです。

<!--
Next, `foo()` calls `baz()`, passing `z`:
-->
つぎに、 `foo()` は `baz()` を呼び出し、 `z` を渡します:

| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 20                     |
| ...                  | ...  | ...                    |
| 7                    | g    | 100                    |
| 6                    | f    | → 4                    |
| 5                    | z    | → 4                    |
| 4                    | y    | 10                     |
| 3                    | x    | → 0                    |
| 2                    | j    | → 0                    |
| 1                    | i    | → (2<sup>30</sup>) - 1 |
| 0                    | h    | 3                      |

<!--
We’ve allocated memory for `f` and `g`. `baz()` is very short, so when it’s
over, we get rid of its stack frame:
-->
`f` と `g` のためにメモリを確保しました。
`baz()` はとても短いので、 `baz()` の実行が終わったときに、そのスタックフレームを取り除きます。

| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 20                     |
| ...                  | ...  | ...                    |
| 5                    | z    | → 4                    |
| 4                    | y    | 10                     |
| 3                    | x    | → 0                    |
| 2                    | j    | → 0                    |
| 1                    | i    | → (2<sup>30</sup>) - 1 |
| 0                    | h    | 3                      |

<!--
Next, `foo()` calls `bar()` with `x` and `z`:
-->
次に、 `foo()` は `bar()` を `x` と `z` を引数にして呼び出します:

| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 20                     |
| (2<sup>30</sup>) - 2 |      | 5                      |
| ...                  | ...  | ...                    |
| 10                   | e    | → 9                    |
| 9                    | d    | → (2<sup>30</sup>) - 2 |
| 8                    | c    | 5                      |
| 7                    | b    | → 4                    |
| 6                    | a    | → 0                    |
| 5                    | z    | → 4                    |
| 4                    | y    | 10                     |
| 3                    | x    | → 0                    |
| 2                    | j    | → 0                    |
| 1                    | i    | → (2<sup>30</sup>) - 1 |
| 0                    | h    | 3                      |

<!--
We end up allocating another value on the heap, and so we have to subtract one
from (2<sup>30</sup>) - 1. It’s easier to write that than `1,073,741,822`. In any
case, we set up the variables as usual.
-->
その結果、ヒープに値をもうひとつアロケートすることになるので、(2<sup>30</sup>) - 1から1を引かなくてはなりません。
そうすることは、 `1,073,741,822` と書くよりは簡単です。
いずれにせよ、いつものように変数を準備します。

<!--
At the end of `bar()`, it calls `baz()`:
-->
`bar()` の最後で、 `baz()` を呼び出します:

| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 20                     |
| (2<sup>30</sup>) - 2 |      | 5                      |
| ...                  | ...  | ...                    |
| 12                   | g    | 100                    |
| 11                   | f    | → (2<sup>30</sup>) - 2 |
| 10                   | e    | → 9                    |
| 9                    | d    | → (2<sup>30</sup>) - 2 |
| 8                    | c    | 5                      |
| 7                    | b    | → 4                    |
| 6                    | a    | → 0                    |
| 5                    | z    | → 4                    |
| 4                    | y    | 10                     |
| 3                    | x    | → 0                    |
| 2                    | j    | → 0                    |
| 1                    | i    | → (2<sup>30</sup>) - 1 |
| 0                    | h    | 3                      |

<!--
With this, we’re at our deepest point! Whew! Congrats for following along this
far.
-->
こうして、一番深い所までやってきました! ふう! ここまで長い過程をたどってきて、お疲れ様でした。

<!--
After `baz()` is over, we get rid of `f` and `g`:
-->
`baz()` が終わったあとは、 `f` と `g` を取り除きます:

| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 20                     |
| (2<sup>30</sup>) - 2 |      | 5                      |
| ...                  | ...  | ...                    |
| 10                   | e    | → 9                    |
| 9                    | d    | → (2<sup>30</sup>) - 2 |
| 8                    | c    | 5                      |
| 7                    | b    | → 4                    |
| 6                    | a    | → 0                    |
| 5                    | z    | → 4                    |
| 4                    | y    | 10                     |
| 3                    | x    | → 0                    |
| 2                    | j    | → 0                    |
| 1                    | i    | → (2<sup>30</sup>) - 1 |
| 0                    | h    | 3                      |

<!--
Next, we return from `bar()`. `d` in this case is a `Box<T>`, so it also frees
what it points to: (2<sup>30</sup>) - 2.
-->
次に、 `bar()` から戻ります。
ここで `d` は `Box<T>` 型なので、 `d` が指している (2<sup>30</sup>) - 2 も一緒に解放されます。

| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 20                     |
| ...                  | ...  | ...                    |
| 5                    | z    | → 4                    |
| 4                    | y    | 10                     |
| 3                    | x    | → 0                    |
| 2                    | j    | → 0                    |
| 1                    | i    | → (2<sup>30</sup>) - 1 |
| 0                    | h    | 3                      |

<!--
And after that, `foo()` returns:
-->
その後、 `foo()` から戻ります:

| Address              | Name | Value                  |
|----------------------|------|------------------------|
| (2<sup>30</sup>) - 1 |      | 20                     |
| ...                  | ...  | ...                    |
| 2                    | j    | → 0                    |
| 1                    | i    | → (2<sup>30</sup>) - 1 |
| 0                    | h    | 3                      |

<!--
And then, finally, `main()`, which cleans the rest up. When `i` is `Drop`ped,
it will clean up the last of the heap too.
-->
そして最後に `main()` から戻るところで、残っているものを除去します。
`i` が `Drop` されるとき、ヒープの最後の残りも除去されます。

# 他の言語では何をしているのか?
<!--# What do other languages do?-->

<!--
Most languages with a garbage collector heap-allocate by default. This means
that every value is boxed. There are a number of reasons why this is done, but
they’re out of scope for this tutorial. There are some possible optimizations
that don’t make it true 100% of the time, too. Rather than relying on the stack
and `Drop` to clean up memory, the garbage collector deals with the heap
instead.
-->
ガベージコレクタを備えた多くの言語はデフォルトでヒープアロケートします。
つまり、すべての値がボックス化されています。
そうなっている理由がいくつかあるのですが、それはこのチュートリアルの範囲外です。
また、そのことが100%真であると言えなくなるような最適化もいくつか行われることがあります。
メモリの解放のためにスタックと `Drop` を頼りにするかわりに、ガベージコレクタがヒープを取り扱います。

# どちらを使えばいいのか?
<!--# Which to use?-->

<!--
So if the stack is faster and easier to manage, why do we need the heap? A big
reason is that Stack-allocation alone means you only have 'Last In First Out (LIFO)' semantics for
reclaiming storage. Heap-allocation is strictly more general, allowing storage
to be taken from and returned to the pool in arbitrary order, but at a
complexity cost.
-->
スタックのほうが速くて管理しやすいというのであれば、なぜヒープが要るのでしょうか?
大きな理由のひとつは、スタックアロケーションだけしかないということはストレージの再利用に「Last In First Out（LIFO）（訳注: 後入れ先出し）」セマンティクスをとるしかないということだからです。
ヒープアロケーションは厳密により普遍的で、ストレージを任意の順番でプールから取得したり、プールに返却することが許されているのですが、よりコストがかさみます。

<!--
Generally, you should prefer stack allocation, and so, Rust stack-allocates by
default. The LIFO model of the stack is simpler, at a fundamental level. This
has two big impacts: runtime efficiency and semantic impact.
-->
一般的にはスタックアロケーションを選ぶべきで、そのためRustはデフォルトでスタックアロケートします。
スタックのLIFOモデルはより単純で、基本的なレベルに置かれています。
このことは、実行時の効率性と意味論に大きな影響を与えています。

## 実行時の効率性
<!--## Runtime Efficiency-->

<!--
Managing the memory for the stack is trivial: The machine
increments or decrements a single value, the so-called “stack pointer”.
Managing memory for the heap is non-trivial: heap-allocated memory is freed at
arbitrary points, and each block of heap-allocated memory can be of arbitrary
size, so the memory manager must generally work much harder to
identify memory for reuse.
-->
スタックのメモリを管理するのは些細なことです: 機械は「スタックポインタ」と呼ばれる単一の値を増減します。
ヒープのメモリを管理するのは些細なことではありません: ヒープアロケートされたメモリは任意の時点で解放され、またヒープアロケートされたそれぞれのブロックは任意のサイズになりうるので、一般的にメモリマネージャは再利用するメモリを特定するためにより多くの仕事をします。

<!--
If you’d like to dive into this topic in greater detail, [this paper][wilson]
is a great introduction.
-->
この事柄についてより詳しいことを知りたいのであれば、[こちらの論文][wilson]がよいイントロダクションになっています。

[wilson]: http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.143.4688

## 意味論への影響
<!--## Semantic impact-->

<!--
Stack-allocation impacts the Rust language itself, and thus the developer’s
mental model. The LIFO semantics is what drives how the Rust language handles
automatic memory management. Even the deallocation of a uniquely-owned
heap-allocated box can be driven by the stack-based LIFO semantics, as
discussed throughout this chapter. The flexibility (i.e. expressiveness) of non
LIFO-semantics means that in general the compiler cannot automatically infer at
compile-time where memory should be freed; it has to rely on dynamic protocols,
potentially from outside the language itself, to drive deallocation (reference
counting, as used by `Rc<T>` and `Arc<T>`, is one example of this).
-->
スタックアロケーションはRustの言語自体へ影響を与えており、したがって開発者のメンタルモデルにも影響しています。
Rust言語がどのように自動メモリ管理を取り扱うかは、LIFOセマンティクスに従っています。
ヒープアロケートされユニークに所有されたボックスのデアロケーションさえも、スタックベースのLIFOセマンティクスに従っていることは、この章を通して論じてきたとおりです。
非LIFOセマンティクスの柔軟性（すなわち表現能力）は一般的に、いつメモリが解放されるべきなのかをコンパイラがコンパイル時に自動的に推論できなくなることを意味するので、デアロケーションを制御するために、ときに言語自体の外部に由来するかもしれない、動的なプロトコルに頼らなければなりません。（`Rc<T>` や `Arc<T>` が使っている参照カウントはその一例です。）

<!--
When taken to the extreme, the increased expressive power of heap allocation
comes at the cost of either significant runtime support (e.g. in the form of a
garbage collector) or significant programmer effort (in the form of explicit
memory management calls that require verification not provided by the Rust
compiler).
-->
突き詰めれば、ヒープアロケーションによって増大した表現能力は（例えばガベージコレクタという形の）著しい実行時サポートか、（Rustコンパイラが提供していないような検証を必要とする明示的なメモリ管理呼び出しという形の）著しいプログラマの努力のいずれかのコストを引き起こすのです。
