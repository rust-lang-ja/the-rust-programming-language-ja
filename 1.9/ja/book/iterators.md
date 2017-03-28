% イテレータ
<!-- % Iterators -->

<!-- Let's talk about loops. -->
ループの話をしましょう。

<!-- Remember Rust's `for` loop? Here's an example: -->
Rustの `for` ループを覚えていますか？以下が例です。

```rust
for x in 0..10 {
    println!("{}", x);
}
```

<!-- Now that you know more Rust, we can talk in detail about how this works.
Ranges (the `0..10`) are 'iterators'. An iterator is something that we can
call the `.next()` method on repeatedly, and it gives us a sequence of things. -->
あなたはもうRustに詳しいので、私たちはどのようにこれが動作しているのか詳しく話すことができます。
レンジ(ranges、ここでは `0..10` )は「イテレータ」(iterators)です。イテレータは `.next()` メソッドを繰り返し呼び出すことができ、その都度順番に値を返すものです。

<!-- (By the way, a range with two dots like `0..10` is inclusive on the left (so it
starts at 0) and exclusive on the right (so it ends at 9). A mathematician
would write "[0, 10)". To get a range that goes all the way up to 10 you can
write `0...10`.) -->
（ところで、 `0..10` のようにドット2つのレンジは左端を含み（つまり0から始まる）右端を含みません（つまり9で終わる）。数学的な書き方をすれば 「[0, 10)」です。10まで含むレンジが欲しければ `0...10` と書きます。）

<!-- Like this: -->
こんな風に:

```rust
let mut range = 0..10;

loop {
    match range.next() {
        Some(x) => {
            println!("{}", x);
        },
        None => { break }
    }
}
```

<!-- We make a mutable binding to the range, which is our iterator. We then `loop`,
with an inner `match`. This `match` is used on the result of `range.next()`,
which gives us a reference to the next value of the iterator. `next` returns an
`Option<i32>`, in this case, which will be `Some(i32)` when we have a value and
`None` once we run out. If we get `Some(i32)`, we print it out, and if we get
`None`, we `break` out of the loop. -->
始めに変数rangeへミュータブルな束縛を行っていますが、これがイテレータです。その次には中に `match` が入った `loop` があります。この `match` は `range.next()` を呼び出し、イテレータから得た次の値への参照を使用しています。 `next` は `Option<i32>` を返します。このケースでは、次の値があればその値は `Some(i32)` であり、返ってくる値が無くなれば `None` が返ってきます。もし `Some(i32)` であればそれを表示し、 `None` であれば `break` によりループから脱出しています。

<!-- This code sample is basically the same as our `for` loop version. The `for`
loop is a handy way to write this `loop`/`match`/`break` construct. -->
このコードは、基本的に `for` ループバージョンと同じ動作です。 `for` ループはこの `loop`/ `match` / `break` で構成された処理を手軽に書ける方法というわけです。

<!-- `for` loops aren't the only thing that uses iterators, however. Writing your
own iterator involves implementing the `Iterator` trait. While doing that is
outside of the scope of this guide, Rust provides a number of useful iterators
to accomplish various tasks. But first, a few notes about limitations of ranges. -->
しかしながら `for` ループだけがイテレータを使う訳ではありません。自作のイテレータを書く時は `Iterator` トレイトを実装する必要があります。それは本書の範囲外ですが、Rustは多様な反復処理を実現するために便利なイテレータを幾つか提供しています。ただその前に、少しばかりレンジの限界について言及しておきましょう。

<!-- Ranges are very primitive, and we often can use better alternatives. Consider the
following Rust anti-pattern: using ranges to emulate a C-style `for` loop. Let’s
suppose you needed to iterate over the contents of a vector. You may be tempted
to write this: -->
レンジはとても素朴な機能ですから、度々別のより良い手段を用いることもあります。ここであるRustのアンチパターンについて考えてみましょう。それはレンジをC言語ライクな `for` ループの再現に用いることです。例えばベクタの中身をイテレートする必要があったとしましょう。あなたはこう書きたくなるかもしれません。

```rust
let nums = vec![1, 2, 3];

for i in 0..nums.len() {
    println!("{}", nums[i]);
}
```

<!-- This is strictly worse than using an actual iterator. You can iterate over vectors
directly, so write this: -->
これは実際のイテレータの使い方からすれば全く正しくありません。あなたはベクタを直接反復処理できるのですから、こう書くべきです。

```rust
let nums = vec![1, 2, 3];

for num in &nums {
    println!("{}", num);
}
```

<!-- There are two reasons for this. First, this more directly expresses what we
mean. We iterate through the entire vector, rather than iterating through
indexes, and then indexing the vector. Second, this version is more efficient:
the first version will have extra bounds checking because it used indexing,
`nums[i]`. But since we yield a reference to each element of the vector in turn
with the iterator, there's no bounds checking in the second example. This is
very common with iterators: we can ignore unnecessary bounds checks, but still
know that we're safe. -->
これには2つの理由があります。第一に、この方が書き手の意図をはっきり表せています。私たちはベクタのインデックスを作成してからその要素を繰り返し参照したいのではなく、ベクタ自体を反復処理したいのです。第二に、このバージョンのほうがより効率的です。1つ目の例では `num[i]` というようにインデックスを介し参照しているため、余計な境界チェックが発生します。しかし、イテレータが順番にベクタの各要素への参照を生成していくため、2つ目の例では境界チェックが発生しません。これはイテレータにとってごく一般的な性質です。不要な境界チェックを省くことができ、それでもなお安全なままなのです。

<!-- There's another detail here that's not 100% clear because of how `println!`
works. `num` is actually of type `&i32`. That is, it's a reference to an `i32`,
not an `i32` itself. `println!` handles the dereferencing for us, so we don't
see it. This code works fine too: -->
ここにはもう1つ、`println!` の動作という詳細が100%はっきりしていない処理があります。 `num` は実際には `&i32` 型です。これは `i32` の参照であり、 `i32` それ自体ではありません。 `println!` は上手い具合に参照外し(dereferencing)をしてくれますから、これ以上深追いはしないことにします。以下のコードも正しく動作します。

```rust
let nums = vec![1, 2, 3];

for num in &nums {
    println!("{}", *num);
}
```

<!-- Now we're explicitly dereferencing `num`. Why does `&nums` give us
references?  Firstly, because we explicitly asked it to with
`&`. Secondly, if it gave us the data itself, we would have to be its
owner, which would involve making a copy of the data and giving us the
copy. With references, we're only borrowing a reference to the data,
and so it's only passing a reference, without needing to do the move. -->
今、私たちは明示的に `num` の参照外しを行いました。なぜ `&nums` は私たちに参照を渡すのでしょうか？第一に、`&`を用いて私たちが明示的に要求したからです。第二に、もしデータそれ自体を渡す場合、私たちはデータの所有者でなければならないため、データの複製と、それを私たちに渡す操作が伴います。参照を使えば、データへの参照を借用して渡すだけで済み、ムーブを行う必要がなくなります。

<!-- So, now that we've established that ranges are often not what you want, let's
talk about what you do want instead. -->
ここまでで、多くの場合レンジはあなたの欲する物ではないとわかりましたから、あなたが実際に欲しているものについて話しましょう。

<!-- There are three broad classes of things that are relevant here: iterators,
*iterator adaptors*, and *consumers*. Here's some definitions: -->
それは大きく分けてイテレータ、 *イテレータアダプタ* (iterator adaptors)、そして *コンシューマ* (consumers)の3つです。以下が定義となります。

<!-- * *iterators* give you a sequence of values.
* *iterator adaptors* operate on an iterator, producing a new iterator with a
  different output sequence.
* *consumers* operate on an iterator, producing some final set of values. -->
* *イテレータ* は値のシーケンスを渡します。
* *イテレータアダプタ* はイテレータに作用し、出力の異なるイテレータを生成します。
* *コンシューマ* はイテレータに作用し、幾つかの最終的な値の組を生成します。

<!-- Let's talk about consumers first, since you've already seen an iterator, ranges. -->
既にイテレータとレンジについて見てきましたから、初めにコンシューマについて話しましょう。

<!-- ## Consumers -->
## コンシューマ

<!-- A *consumer* operates on an iterator, returning some kind of value or values.
The most common consumer is `collect()`. This code doesn't quite compile,
but it shows the intention: -->
*コンシューマ* とはイテレータに作用し、何らかの値を返すものです。最も一般的なコンシューマは `collect()` です。このコードは全くコンパイルできませんが、意図するところは伝わるでしょう。

```rust,ignore
let one_to_one_hundred = (1..101).collect();
```

<!-- As you can see, we call `collect()` on our iterator. `collect()` takes
as many values as the iterator will give it, and returns a collection
of the results. So why won't this compile? Rust can't determine what
type of things you want to collect, and so you need to let it know.
Here's the version that does compile: -->
ご覧のとおり、ここではイテレータの `collect()` を呼び出しています。 `collect()` はイテレータが渡す沢山の値を全て受け取り、その結果をコレクションとして返します。それならなぜこのコードはコンパイルできないのでしょうか？Rustはあなたが集めたい値の型を判断することができないため、あなたが欲しい型を指定する必要があります。以下のバージョンはコンパイルできます。

```rust
let one_to_one_hundred = (1..101).collect::<Vec<i32>>();
```

<!-- If you remember, the `::<>` syntax allows us to give a type hint,
and so we tell it that we want a vector of integers. You don't always
need to use the whole type, though. Using a `_` will let you provide
a partial hint: -->
もしあなたが覚えているなら、 `::<>` 構文で型ヒント(type hint)を与え、整数型のベクタが欲しいと伝えることができます。かといって常に型をまるごとを書く必要はありません。 `_` を用いることで部分的に推論してくれます。

```rust
let one_to_one_hundred = (1..101).collect::<Vec<_>>();
```

<!-- This says "Collect into a `Vec<T>`, please, but infer what the `T` is for me."
`_` is sometimes called a "type placeholder" for this reason. -->
これは「値を `Vec<T>` の中に集めて下さい、しかし `T` は私のために推論して下さい」という意味です。このため `_` は「型プレースホルダ」(type placeholder)と呼ばれることもあります。

<!-- `collect()` is the most common consumer, but there are others too. `find()`
is one: -->
`collect()` は最も一般的なコンシューマですが、他にもあります。 `find()` はそのひとつです。

```rust
let greater_than_forty_two = (0..100)
                             .find(|x| *x > 42);

match greater_than_forty_two {
    Some(_) => println!("Found a match!"),
    None => println!("No match found :("),
}
```

<!-- `find` takes a closure, and works on a reference to each element of an
iterator. This closure returns `true` if the element is the element we're
looking for, and `false` otherwise. `find` returns the first element satisfying
the specified predicate. Because we might not find a matching element, `find`
returns an `Option` rather than the element itself. -->
`find` はクロージャを引数にとり、イテレータの各要素の参照に対して処理を行います。ある要素が私たちの期待するものであれば、このクロージャは `true` を返し、そうでなければ `false` を返します。マッチングする要素が無いかもしれないので、 `find` は要素それ自体ではなく `Option` を返します。

<!-- Another important consumer is `fold`. Here's what it looks like: -->
もう一つの重要なコンシューマは `fold` です。こんな風になります。

```rust
let sum = (1..4).fold(0, |sum, x| sum + x);
```

<!-- `fold()` is a consumer that looks like this:
`fold(base, |accumulator, element| ...)`. It takes two arguments: the first
is an element called the *base*. The second is a closure that itself takes two
arguments: the first is called the *accumulator*, and the second is an
*element*. Upon each iteration, the closure is called, and the result is the
value of the accumulator on the next iteration. On the first iteration, the
base is the value of the accumulator. -->
`fold()` は `fold(base, |accumulator, element| ...)` というシグネチャのコンシューマで、2つの引数を取ります。第1引数は *base* (基底)と呼ばれます。第2引数は2つ引数を受け取るクロージャです。クロージャの第1引数は *accumulator* (累積値)と呼ばれており、第2引数は *element* (要素)です。各反復毎にクロージャが呼び出され、その結果が次の反復のaccumulatorの値となります。反復処理の開始時は、baseがaccumulatorの値となります。

<!-- Okay, that's a bit confusing. Let's examine the values of all of these things
in this iterator: -->
ええ、ちょっとややこしいですね。ではこのイテレータを以下の値で試してみましょう。

| base | accumulator | element | クロージャの結果 |
|------|-------------|---------|------------------|
| 0    | 0           | 1       | 1                |
| 0    | 1           | 2       | 3                |
| 0    | 3           | 3       | 6                |

<!-- We called `fold()` with these arguments: -->
これらの引数で `fold()` を呼び出してみました。

```rust
# (1..4)
.fold(0, |sum, x| sum + x);
```

<!-- So, `0` is our base, `sum` is our accumulator, and `x` is our element.  On the
first iteration, we set `sum` to `0`, and `x` is the first element of `nums`,
`1`. We then add `sum` and `x`, which gives us `0 + 1 = 1`. On the second
iteration, that value becomes our accumulator, `sum`, and the element is
the second element of the array, `2`. `1 + 2 = 3`, and so that becomes
the value of the accumulator for the last iteration. On that iteration,
`x` is the last element, `3`, and `3 + 3 = 6`, which is our final
result for our sum. `1 + 2 + 3 = 6`, and that's the result we got. -->
というわけで、 `0` がbaseで、 `sum` がaccumulatorで、xがelementです。1度目の反復では、私たちはsumに0をセットし、 `nums` の1つ目の要素 `1` が `x` になります。その後 `sum` と `x` を足し、 `0 + 1 = 1` を計算します。2度目の反復では前回の `sum` がaccumulatorになり、elementは値の列の2番目の要素 `2` になります。 `1 + 2 = 3` の結果は最後の反復処理におけるaccumulatorの値になります。最後の反復処理において、 `x` は最後の要素 `3` であり、 `3 + 3 = 6` が最終的な結果となります。 `1 + 2 + 3 = 6` 、これが得られる結果となります。

<!-- Whew. `fold` can be a bit strange the first few times you see it, but once it
clicks, you can use it all over the place. Any time you have a list of things,
and you want a single result, `fold` is appropriate. -->
ふぅ、ようやく説明し終わりました。 `fold` は初めのうちこそ少し奇妙に見えるかもしれませんが、一度理解すればあらゆる場面で使えるでしょう。何らかのリストを持っていて、そこから1つの結果を求めたい時ならいつでも、 `fold` は適切な処理です。

<!-- Consumers are important due to one additional property of iterators we haven't
talked about yet: laziness. Let's talk some more about iterators, and you'll
see why consumers matter. -->
イテレータにはまだ話していないもう1つの性質、遅延性があり、コンシューマはそれに関連して重要な役割を担っています。それではもっと詳しくイテレータについて話していきましょう、そうすればなぜコンシューマが重要なのか理解できるはずです。

<!-- ## Iterators -->
## イテレータ

<!-- As we've said before, an iterator is something that we can call the
`.next()` method on repeatedly, and it gives us a sequence of things.
Because you need to call the method, this means that iterators
can be *lazy* and not generate all of the values upfront. This code,
for example, does not actually generate the numbers `1-99`, instead
creating a value that merely represents the sequence: -->
前に言ったように、イテレータは `.next()` メソッドを繰り返し呼び出すことができ、その都度順番に値を返すものです。メソッドを繰り返し呼ぶ必要があることから、イテレータは *lazy* であり、前もって全ての値を生成できないことがわかります。このコードでは、例えば `1-99` の値は実際には生成されておらず、代わりにただシーケンスを表すだけの値を生成しています。

```rust
let nums = 1..100;
```

<!-- Since we didn't do anything with the range, it didn't generate the sequence.
Let's add the consumer: -->
私たちはレンジを何にも使っていないため、値を生成しません。コンシューマを追加してみましょう。

```rust
let nums = (1..100).collect::<Vec<i32>>();
```

<!-- Now, `collect()` will require that the range gives it some numbers, and so
it will do the work of generating the sequence. -->
`collect()` は幾つかの数値を渡してくれるレンジを要求し、シーケンスを生成する作業を行います。

<!-- Ranges are one of two basic iterators that you'll see. The other is `iter()`.
`iter()` can turn a vector into a simple iterator that gives you each element
in turn: -->
レンジは基本的な2つのイテレータのうちの1つです。もう片方は `iter()` です。 `iter()` はベクタを順に各要素を渡すシンプルなイテレータへ変換できます。

```rust
let nums = vec![1, 2, 3];

for num in nums.iter() {
   println!("{}", num);
}
```

<!-- These two basic iterators should serve you well. There are some more
advanced iterators, including ones that are infinite. -->
これら2つの基本的なイテレータはあなたの役に立つはずです。無限を扱えるものも含め、より応用的なイテレータも幾つか用意されています。

<!-- That's enough about iterators. Iterator adaptors are the last concept
we need to talk about with regards to iterators. Let's get to it! -->
これでイテレータについては十分でしょう。私たちがイテレータに関して最後に話しておくべき概念がイテレータアダプタです。それでは説明しましょう！

<!-- ## Iterator adaptors  -->
## イテレータアダプタ

<!-- *Iterator adaptors* take an iterator and modify it somehow, producing
a new iterator. The simplest one is called `map`: -->
*イテレータアダプタ* はイテレータを受け取って何らかの方法で加工し、新たなイテレータを生成します。 `map` はその中でも最も単純なものです。


```rust,ignore
(1..100).map(|x| x + 1);
```

<!-- `map` is called upon another iterator, and produces a new iterator where each
element reference has the closure it's been given as an argument called on it.
So this would give us the numbers from `2-100`. Well, almost! If you
compile the example, you'll get a warning: -->
`map` は別のイテレータについて呼び出され、各要素の参照をクロージャに引数として与えた結果を新しいイテレータとして生成します。つまりこのコードは私たちに `2-100` の値を返してくれるでしょう。えーっと、厳密には少し違います！もしこの例をコンパイルすると、こんな警告が出るはずです。

```text
warning: unused result which must be used: iterator adaptors are lazy and
         do nothing unless consumed, #[warn(unused_must_use)] on by default
(1..100).map(|x| x + 1);
 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

<!-- Laziness strikes again! That closure will never execute. This example
doesn't print any numbers: -->
また遅延性にぶつかりました！このクロージャは実行されませんね。例えば以下の例は何の数字も出力されません。


```rust,ignore
(1..100).map(|x| println!("{}", x));
```

<!-- If you are trying to execute a closure on an iterator for its side effects,
use `for` instead. -->
もし副作用のためにイテレータに対してクロージャの実行を試みるのであれば、代わりに `for` を使いましょう。

<!-- There are tons of interesting iterator adaptors. `take(n)` will return an
iterator over the next `n` elements of the original iterator. Let's try it out
with an infinite iterator: -->
他にも面白いイテレータアダプタは山ほどあります。 `take(n)` は元のイテレータの `n` 要素目までを実行するイテレータを返します。先程言及していた無限を扱えるイテレータで試してみましょう。

```rust
for i in (1..).take(5) {
    println!("{}", i);
}
```

<!-- This will print -->
これの出力は、

```text
1
2
3
4
5
```

<!-- `filter()` is an adapter that takes a closure as an argument. This closure
returns `true` or `false`. The new iterator `filter()` produces
only the elements that the closure returns `true` for: -->
`filter()` は引数としてクロージャをとるアダプタです。このクロージャは `true` か `false` を返します。 `filter()` が生成する新たなイテレータはそのクロージャが `true` を返した要素のみとなります。

```rust
for i in (1..100).filter(|&x| x % 2 == 0) {
    println!("{}", i);
}
```

<!-- This will print all of the even numbers between one and a hundred.
(Note that, unlike `map`, the closure passed to `filter` is passed a reference
to the element instead of the element itself. The filter predicate here uses
the `&x` pattern to extract the integer. The filter closure is passed a
reference because it returns `true` or `false` instead of the element,
so the `filter` implementation must retain ownership to put the elements
into the newly constructed iterator.) -->
これは1から100の間の偶数を全て出力します。
（`map` と違って、`filter` に渡されたクロージャには要素そのものではなく要素への参照が渡されます。
フィルタする述語は `&x` パターンを使って整数を取り出しています。
フィルタするクロージャは要素ではなく `true` 又は `false` を返すので、 `filter` の実装は返り値のイテレータに所有権を渡すために要素への所有権を保持しておかないとならないのです。）

> 訳注: クロージャで用いられている `&x` パターンは [パターン][patterns] の章では紹介されていません。簡単に解説すると、何らかの参照 `&T` から **内容のみを取り出してコピー** するのが `&x` パターンです。参照をそのまま受け取る `ref x` パターンとは異なりますので注意して下さい。

[patterns]: patterns.html

<!-- You can chain all three things together: start with an iterator, adapt it
a few times, and then consume the result. Check it out: -->
あなたはここまでに説明された3つの概念を全て繋げることができます。イテレータから始まり、アダプタを幾つか繋ぎ、結果を消費するといった感じです。これを見て下さい。

```rust
(1..)
    .filter(|&x| x % 2 == 0)
    .filter(|&x| x % 3 == 0)
    .take(5)
    .collect::<Vec<i32>>();
```

<!-- This will give you a vector containing `6`, `12`, `18`, `24`, and `30`. -->
これは `6, 12, 18, 24,` 、そして `30` が入ったベクタがあなたに渡されます。

<!-- This is just a small taste of what iterators, iterator adaptors, and consumers
can help you with. There are a number of really useful iterators, and you can
write your own as well. Iterators provide a safe, efficient way to manipulate
all kinds of lists. They're a little unusual at first, but if you play with
them, you'll get hooked. For a full list of the different iterators and
consumers, check out the [iterator module documentation](../std/iter/index.html). -->

イテレータ、イテレータアダプタ、そしてコンシューマがあなたの助けになることをほんの少しだけ体験できました。本当に便利なイテレータが幾つも用意されていますし、あなたがイテレータを自作することもできます。イテレータは全ての種類のリストに対し効率的な処理方法と安全性を提供します。これらは初めこそ珍しいかもしれませんが、もし使えばあなたは夢中になることでしょう。全てのイテレータとコンシューマのリストは [イテレータモジュールのドキュメンテーション](../std/iter/index.html) を参照して下さい。
