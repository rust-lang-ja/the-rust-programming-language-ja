% クロージャ
<!-- % Closures -->

<!-- Sometimes it is useful to wrap up a function and _free variables_ for better -->
<!-- clarity and reuse. The free variables that can be used come from the -->
<!-- enclosing scope and are ‘closed over’ when used in the function. From this, we -->
<!-- get the name ‘closures’ and Rust provides a really great implementation of -->
<!-- them, as we’ll see. -->
しばしば、関数と _自由変数_ と一つにまとめておくことがコードの明確さや再利用の役に立つことが有ります。
自由変数は外部のスコープから来て、関数中で使われるときに「閉じ込め」られます。
このことから、これを「クロージャ」と呼びRustはこれから見ていくようにクロージャの非常に良い実装を提供しています。

<!-- # Syntax -->
# 構文

<!-- Closures look like this: -->
クロージャは以下のような見た目です:

```rust
let plus_one = |x: i32| x + 1;

assert_eq!(2, plus_one(1));
```

<!-- We create a binding, `plus_one`, and assign it to a closure. The closure’s -->
<!-- arguments go between the pipes (`|`), and the body is an expression, in this -->
<!-- case, `x + 1`. Remember that `{ }` is an expression, so we can have multi-line -->
<!-- closures too: -->
束縛 `plus_one` を作成し、クロージャをアサインしています。
クロージャの引数はパイプ( `|` )の間に書きます、そしてクロージャの本体は式です、
この場合は `x + 1` がそれに当たります。
`{ }` が式であることを思い出して下さい、 `{ }` が式であるため、複数行のクロージャを作成することも可能です:

```rust
let plus_two = |x| {
    let mut result: i32 = x;

    result += 1;
    result += 1;

    result
};

assert_eq!(4, plus_two(2));
```

<!-- You’ll notice a few things about closures that are a bit different from regular -->
<!-- named functions defined with `fn`. The first is that we did not need to -->
<!-- annotate the types of arguments the closure takes or the values it returns. We -->
<!-- can: -->
いくつかクロージャと通常の `fn` で定義される関数との違いに気がつくでしょう。
一つ目はクロージャの引数や返り値の型を示す必要が無い事です。
型を以下のように示すこともできます:

```rust
let plus_one = |x: i32| -> i32 { x + 1 };

assert_eq!(2, plus_one(1));
```

<!-- But we don’t have to. Why is this? Basically, it was chosen for ergonomic -->
<!-- reasons. While specifying the full type for named functions is helpful with -->
<!-- things like documentation and type inference, the full type signatures of -->
<!-- closures are rarely documented since they’re anonymous, and they don’t cause -->
<!-- the kinds of error-at-a-distance problems that inferring named function types -->
<!-- can. -->
しかし、このように型を示す必要はありません。
なぜでしょう？一言で言えば、これは使いやすさのためです。
名前の有る関数の型を全て指定するのはドキュメンテーションや型推論の役に立つとしても、
クロージャの型は示されません、これはクロージャたちが匿名であり、
さらに名前付きの関数が引き起こすと思われるような遠くで発生するエラーの要因ともならないためです。

<!-- The second is that the syntax is similar, but a bit different. I’ve added -->
<!-- spaces here for easier comparison: -->
通常の関数との違いの二つ目は、構文は似ていますが、ほんの少し違うという点です。
比較がしやすいようにスペースを適宜つけて以下に示しています:

```rust
fn  plus_one_v1   (x: i32) -> i32 { x + 1 }
let plus_one_v2 = |x: i32| -> i32 { x + 1 };
let plus_one_v3 = |x: i32|          x + 1  ;
```

<!-- Small differences, but they’re similar. -->
小さな違いは有りますが似ています。

<!-- # Closures and their environment -->
# クロージャとクロージャの環境

<!-- The environment for a closure can include bindings from its enclosing scope in -->
<!-- addition to parameters and local bindings. It looks like this: -->
クロージャの環境はクロージャを囲んでいるスコープ中の束縛を引数やローカルな束縛に追加で含むことが可能です。
例えば以下のようになります:

```rust
let num = 5;
let plus_num = |x: i32| x + num;

assert_eq!(10, plus_num(5));
```

<!-- This closure, `plus_num`, refers to a `let` binding in its scope: `num`. More -->
<!-- specifically, it borrows the binding. If we do something that would conflict -->
<!-- with that binding, we get an error. Like this one: -->
クロージャ `plus_num` はスコープ内の `let` 束縛 `num` を参照しています。
より厳密に言うと、クロージャ `plus_num` は束縛 `num` を借用しています。
もし、この束縛と衝突する処理を行うとエラーが発生します。
例えば、以下のようなコードは:

```rust,ignore
let mut num = 5;
let plus_num = |x: i32| x + num;

let y = &mut num;
```

<!-- Which errors with: -->
以下のエラーを発生させます:

```text
error: cannot borrow `num` as mutable because it is also borrowed as immutable
    let y = &mut num;
                 ^~~
note: previous borrow of `num` occurs here due to use in closure; the immutable
  borrow prevents subsequent moves or mutable borrows of `num` until the borrow
  ends
    let plus_num = |x| x + num;
                   ^~~~~~~~~~~
note: previous borrow ends here
fn main() {
    let mut num = 5;
    let plus_num = |x| x + num;

    let y = &mut num;
}
^
```

<!-- A verbose yet helpful error message! As it says, we can’t take a mutable borrow -->
<!-- on `num` because the closure is already borrowing it. If we let the closure go -->
<!-- out of scope, we can: -->
冗長ですが役に立つエラーメッセージです!
エラーが示しているように、クロージャが既に `num` を借用しているために、 `num` の変更可能な借用を取得することはできません。
もしクロージャがスコープ外になるようにした場合以下のようにできます:

```rust
let mut num = 5;
{
    let plus_num = |x: i32| x + num;

# // } // plus_num goes out of scope, borrow of num ends
} // plus_numがスコープ外に出て、numの借用が終わります

let y = &mut num;
```

<!-- If your closure requires it, however, Rust will take ownership and move -->
<!-- the environment instead. This doesn’t work: -->
もしクロージャが必要としたならば、Rustは所有権を取り、かわりに環境をムーブします。
以下のコードは動作しません:

```rust,ignore
let nums = vec![1, 2, 3];

let takes_nums = || nums;

println!("{:?}", nums);
```

<!-- We get this error: -->
このコードは以下の様なエラーを発生させます:

```text
note: `nums` moved into closure environment here because it has type
  `[closure(()) -> collections::vec::Vec<i32>]`, which is non-copyable
let takes_nums = || nums;
                 ^~~~~~~
```

<!-- `Vec<T>` has ownership over its contents, and therefore, when we refer to it -->
<!-- in our closure, we have to take ownership of `nums`. It’s the same as if we’d -->
<!-- passed `nums` to a function that took ownership of it. -->
`Vec<T>` は `Vec<T>` の要素に対する所有権を持っています、
それゆえそれらの要素をクロージャ内で参照した場合、 `num` の所有権を取ることになります。
これは `num` の所有権を取るを関数に渡した場合と同じです。

<!-- ## `move` closures -->
## `move` クロージャ

<!-- We can force our closure to take ownership of its environment with the `move` -->
<!-- keyword: -->
`move` キーワードを用いることで、クロージャに環境の所有権を取得することを強制することができます。

```rust
let num = 5;

let owns_num = move |x: i32| x + num;
```

<!-- Now, even though the keyword is `move`, the variables follow normal move semantics. -->
<!-- In this case, `5` implements `Copy`, and so `owns_num` takes ownership of a copy -->
<!-- of `num`. So what’s the difference? -->
今や、 `move` というキーワードにもかかわらず、変数は通常のmoveのセマンティクスに従います。
この場合、 `5` は `Copy` を実装しています、
そのため `owns_num` は `num` のコピーの所有権を取得します。
では、なにが異なるのでしょうか？

```rust
let mut num = 5;

{
    let mut add_num = |x: i32| num += x;

    add_num(5);
}

assert_eq!(10, num);
```

<!-- So in this case, our closure took a mutable reference to `num`, and then when -->
<!-- we called `add_num`, it mutated the underlying value, as we’d expect. We also -->
<!-- needed to declare `add_num` as `mut` too, because we’re mutating its -->
<!-- environment. -->
このケースでは、クロージャは `num` の変更可能な参照を取得し、 `add_num` を呼び出した時予想したように `num` の値を変更します。
`add_num` を同様に `mut` として宣言する必要があります、なぜならクロージャ `add_num` はその環境を変更するためです。

<!-- If we change to a `move` closure, it’s different: -->
もしクロージャを `move` に変更した場合、結果は変化します:

```rust
let mut num = 5;

{
    let mut add_num = move |x: i32| num += x;

    add_num(5);
}

assert_eq!(5, num);
```

<!-- We only get `5`. Rather than taking a mutable borrow out on our `num`, we took -->
<!-- ownership of a copy. -->
結果は `5` になります。`num` の変更可能な借用を取得するよりもむしろ、コピーの所有権を取得します。

<!-- Another way to think about `move` closures: they give a closure its own stack -->
<!-- frame.  Without `move`, a closure may be tied to the stack frame that created -->
<!-- it, while a `move` closure is self-contained. This means that you cannot -->
<!-- generally return a non-`move` closure from a function, for example. -->
`move` クロージャについて考えるその他の方法は: スタックフレームをクロージャに与えるます。
`move` がなかった場合、クロージャはクロージャを作成したスタックフレームと結合されます、
`move` クロージャは自己従属しているとしても。
これは一般的に、`move` でないクロージャを関数から返すことはできないという事を意味しています。

<!-- But before we talk about taking and returning closures, we should talk some -->
<!-- more about the way that closures are implemented. As a systems language, Rust -->
<!-- gives you tons of control over what your code does, and closures are no -->
<!-- different. -->
クロージャを引数に取ったり、帰り値として返したりということについて説明する間に、
クロージャの実装についてもう少し説明する必要があります。
システム言語としてRustはコードの動作についてコントロールする方法を大量に提供しています、
そしてそれはクロージャも例外ではありません。

<!-- # Closure implementation -->
# クロージャの実装

<!-- Rust’s implementation of closures is a bit different than other languages. They -->
<!-- are effectively syntax sugar for traits. You’ll want to make sure to have read -->
<!-- the [traits chapter][traits] before this one, as well as the chapter on [trait -->
<!-- objects][trait-objects]. -->
Rustにおけるクロージャの実装は他の言事は少し異なります。
クロージャは効率的なトレイトへの糖衣構文となっています。
[トレイト][traits] や [トレイトオブジェクト][trait-objects] についてのチャプターを学ぶ前に読みたくなるでしょう。

[traits]: traits.html
[trait-objects]: trait-objects.html

<!-- Got all that? Good. -->
よろしいですか？ では、続きを説明いたします。

<!-- The key to understanding how closures work under the hood is something a bit -->
<!-- strange: Using `()` to call a function, like `foo()`, is an overloadable -->
<!-- operator. From this, everything else clicks into place. In Rust, we use the -->
<!-- trait system to overload operators. Calling functions is no different. We have -->
<!-- three separate traits to overload with: -->
クロージャの内部的な動作を理解するための鍵は少し奇妙です: 関数を呼び出すのに `()` を 例えば `foo()` の様に使いますが、これはオーバーロード可能な演算子です。
これから、残りの全てを正しく理解することができます。Rustでは、トレイトを演算子のオーバーロードに利用します。
関数の予備だしも例外ではありません。３つのオーバーロードするトレイトが存在します:

```rust
# mod foo {
pub trait Fn<Args> : FnMut<Args> {
    extern "rust-call" fn call(&self, args: Args) -> Self::Output;
}

pub trait FnMut<Args> : FnOnce<Args> {
    extern "rust-call" fn call_mut(&mut self, args: Args) -> Self::Output;
}

pub trait FnOnce<Args> {
    type Output;

    extern "rust-call" fn call_once(self, args: Args) -> Self::Output;
}
# }
```

<!-- You’ll notice a few differences between these traits, but a big one is `self`: -->
<!-- `Fn` takes `&self`, `FnMut` takes `&mut self`, and `FnOnce` takes `self`. This -->
<!-- covers all three kinds of `self` via the usual method call syntax. But we’ve -->
<!-- split them up into three traits, rather than having a single one. This gives us -->
<!-- a large amount of control over what kind of closures we can take. -->
これらのトレイトの間の僅かな違いに気がつくことでしょう、しかし大きな違いは `self` についてです:
`Fn` は `&self` を引数に取ります、 `FnMut` は `&mut self` を引数に取ります、そして `FnOnce` は `self` を引数に取ります。
これは通常のメソッド呼び出しにおける `self` のすべての種類をカバーしています。
しかし、これら `self` の各種類を一つの大きなトレイトにまとめるのではなく異なるトレイトに分けています。
このようにすることで、どのような種類のクロージャを取るのかについて多くをコントロールすることができます。

<!-- The `|| {}` syntax for closures is sugar for these three traits. Rust will -->
<!-- generate a struct for the environment, `impl` the appropriate trait, and then -->
<!-- use it. -->
クロージャに対する構文 `|| {}` は上述の3つのトレイトへの糖衣構文です。
Rustは環境の構造体を作成し、 適切なトレイトを `impl` し、それを利用します。


<!-- # Taking closures as arguments -->
# クロージャを引数に取る

<!-- Now that we know that closures are traits, we already know how to accept and -->
<!-- return closures: just like any other trait! -->
クロージャが実際にはトレイトであることを知ったので、
クロージャをどのように引数として取ったり返り値として返せばいいかわかりました: 通常のトレイトと同様に行うのです!

<!-- This also means that we can choose static vs dynamic dispatch as well. First, -->
<!-- let’s write a function which takes something callable, calls it, and returns -->
<!-- the result: -->
これは、静的なディスパッチと動的なディスパッチを洗濯することができるという事も意味しています。
手始めに呼び出し可能な何かを引数にとりそれを呼び出し、その結果を返す関数を書いてみましょう:

```rust
fn call_with_one<F>(some_closure: F) -> i32
    where F : Fn(i32) -> i32 {

    some_closure(1)
}

let answer = call_with_one(|x| x + 2);

assert_eq!(3, answer);
```

<!-- We pass our closure, `|x| x + 2`, to `call_with_one`. It just does what it -->
<!-- suggests: it calls the closure, giving it `1` as an argument. -->
クロージャ `|x| x + 2` を `call_with_one` に渡しました。
これは `call_with_one` という関数名から推測される処理を行います: クロージャに `1` を与えて呼び出します。

<!-- Let’s examine the signature of `call_with_one` in more depth: -->
`call_with_one` のシグネチャを詳細に見ていきましょう:

```rust
fn call_with_one<F>(some_closure: F) -> i32
#    where F : Fn(i32) -> i32 {
#    some_closure(1) }
```

<!-- We take one parameter, and it has the type `F`. We also return a `i32`. This part -->
<!-- isn’t interesting. The next part is: -->
型 `F` を持つ引数を１つ取り、返り値として `i32` を返します。
この部分は特に注目には値しません。次の部分は:

```rust
# fn call_with_one<F>(some_closure: F) -> i32
    where F : Fn(i32) -> i32 {
#   some_closure(1) }
```

<!-- Because `Fn` is a trait, we can bound our generic with it. In this case, our -->
<!-- closure takes a `i32` as an argument and returns an `i32`, and so the generic -->
<!-- bound we use is `Fn(i32) -> i32`. -->
`Fn` がトレイトであるために、ジェネリックの境界として `Fn` を指定する事ができます。
この場合はクロージャは `i32` を引数として取り、 `i32` を返します、そのため
ジェネリックの境界として `Fn(i32) -> i32` を指定子ます。

<!-- There’s one other key point here: because we’re bounding a generic with a -->
<!-- trait, this will get monomorphized, and therefore, we’ll be doing static -->
<!-- dispatch into the closure. That’s pretty neat. In many languages, closures are -->
<!-- inherently heap allocated, and will always involve dynamic dispatch. In Rust, -->
<!-- we can stack allocate our closure environment, and statically dispatch the -->
<!-- call. This happens quite often with iterators and their adapters, which often -->
<!-- take closures as arguments. -->
キーポイントがここにもあります: ジェネリックをトレイトで境界を指定したために、この関数は単相化されます、
それゆえ、静的なディスパッチをクロージャに対して行います。これはとても素敵です。
多くの言語では、クロージャは常にヒープにアロケートされ、常に動的ディスパッチが行われます。
Rustではスタックにクロージャの環境をアロケーションし、呼び出しを静的にディスパッチすることができます。
これは比較的頻繁にクロージャを引数として取るイテレータやそれらのアダプタにおいて発生します。

<!-- Of course, if we want dynamic dispatch, we can get that too. A trait object -->
<!-- handles this case, as usual: -->
もちろん、動的ディスパッチ行いたいときは、そのようにすることもできます。
そのような場合もトレイトオブジェクトが通常どうりに対応します:

```rust
fn call_with_one(some_closure: &Fn(i32) -> i32) -> i32 {
    some_closure(1)
}

let answer = call_with_one(&|x| x + 2);

assert_eq!(3, answer);
```

<!-- Now we take a trait object, a `&Fn`. And we have to make a reference -->
<!-- to our closure when we pass it to `call_with_one`, so we use `&||`. -->
トレイトオブジェクトを引数に取るようになり、
また `call_with_one` にクロージャを渡すときに参照を利用するようにしました、
そのため `&||` を利用しています。

<!-- # Function pointers and closures -->
# 関数ポインタとクロージャ

<!-- A function pointer is kind of like a closure that has no environment. As such, -->
<!-- you can pass a function pointer to any function expecting a closure argument, -->
<!-- and it will work: -->
関数ポインタは環境を持たないクロージャのようなものです。
そのため、クロージャを引数として期待している関数に関数ポインタを渡すことができます。

```rust
fn call_with_one(some_closure: &Fn(i32) -> i32) -> i32 {
    some_closure(1)
}

fn add_one(i: i32) -> i32 {
    i + 1
}

let f = add_one;

let answer = call_with_one(&f);

assert_eq!(2, answer);
```

<!-- In this example, we don’t strictly need the intermediate variable `f`, -->
<!-- the name of the function works just fine too: -->
この例では、中間の変数 `f` が必ず必要なわけではありません、関数名を指定することでもきちんと動作します:

```ignore
let answer = call_with_one(&add_one);
```

<!-- # Returning closures -->
# クロージャを返す

<!-- It’s very common for functional-style code to return closures in various -->
<!-- situations. If you try to return a closure, you may run into an error. At -->
<!-- first, it may seem strange, but we’ll figure it out. Here’s how you’d probably -->
<!-- try to return a closure from a function: -->
関数を用いたスタイルのコードでは、クロージャを返す事は非常によく見られます。
もし、クロージャを返す事を試みた場合、エラーが発生します。これは一見奇妙に思われますが、理解することができます。
以下は、関数からクロージャを返すことを試みた場合のコードです:

```rust,ignore
fn factory() -> (Fn(i32) -> i32) {
    let num = 5;

    |x| x + num
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

<!-- This gives us these long, related errors: -->
このコードは以下の長いエラーを発生させます:

```text
error: the trait `core::marker::Sized` is not implemented for the type
`core::ops::Fn(i32) -> i32` [E0277]
fn factory() -> (Fn(i32) -> i32) {
                ^~~~~~~~~~~~~~~~
note: `core::ops::Fn(i32) -> i32` does not have a constant size known at compile-time
fn factory() -> (Fn(i32) -> i32) {
                ^~~~~~~~~~~~~~~~
error: the trait `core::marker::Sized` is not implemented for the type `core::ops::Fn(i32) -> i32` [E0277]
let f = factory();
    ^
note: `core::ops::Fn(i32) -> i32` does not have a constant size known at compile-time
let f = factory();
    ^
```

<!-- In order to return something from a function, Rust needs to know what -->
<!-- size the return type is. But since `Fn` is a trait, it could be various -->
<!-- things of various sizes: many different types can implement `Fn`. An easy -->
<!-- way to give something a size is to take a reference to it, as references -->
<!-- have a known size. So we’d write this: -->
関数から何かを返すにあたって、Rustは返り値の型のサイズを知る必要があります。
しかし、 `Fn` はトレイトであるため、そのサイズや種類は多岐にわたることになります: 多くの異なる型が `Fn` を実装できます。
何かにサイズを与える簡単な方法は、それに対する参照を取得する方法です、参照は既知のサイズを持っています。
そのため、以下のように書くことができます:

```rust,ignore
fn factory() -> &(Fn(i32) -> i32) {
    let num = 5;

    |x| x + num
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

<!-- But we get another error: -->
しかし、他のエラーが発生してしまいます:

```text
error: missing lifetime specifier [E0106]
fn factory() -> &(Fn(i32) -> i32) {
                ^~~~~~~~~~~~~~~~~
```

<!-- Right. Because we have a reference, we need to give it a lifetime. But -->
<!-- our `factory()` function takes no arguments, so -->
<!-- [elision](lifetimes.html#lifetime-elision) doesn’t kick in here. Then what -->
<!-- choices do we have? Try `'static`: -->
ふむ。これはリファレンスを利用したため、ライフタイムを指定する必要が有ることによります。
しかし、 `factory()` 関数は引数を何も取りません、
そのため [elision](lifetimes.html#lifetime-elision) は実施されません。
では、どのような選択肢が有るのでしょうか？ `'static` を試してみましょう:

```rust,ignore
fn factory() -> &'static (Fn(i32) -> i32) {
    let num = 5;

    |x| x + num
}

let f = factory();

let answer = f(1);
assert_eq!(6, answer);
```

<!-- But we get another error: -->
しかし、以下の別のエラーが発生します:

```text
error: mismatched types:
 expected `&'static core::ops::Fn(i32) -> i32`,
    found `[closure@<anon>:7:9: 7:20]`
(expected &-ptr,
    found closure) [E0308]
         |x| x + num
         ^~~~~~~~~~~

```

<!-- This error is letting us know that we don’t have a `&'static Fn(i32) -> i32`, -->
<!-- we have a `[closure@<anon>:7:9: 7:20]`. Wait, what? -->
このエラーは `&'static Fn(i32) -> i32` ではなく、
 `[closure@<anon>:7:9: 7:20]` を使っているという事を伝えています。
しかし、これは一体何でしょう？


<!-- Because each closure generates its own environment `struct` and implementation -->
<!-- of `Fn` and friends, these types are anonymous. They exist just solely for -->
<!-- this closure. So Rust shows them as `closure@<anon>`, rather than some -->
<!-- autogenerated name. -->
それぞれのクロージャはそれぞれの環境の `struct` を生成し、 `Fn` やその仲間を実装するため、
それぞれの型は匿名となります。それぞれの型はそのクロージャのためだけに存在します。
そのためRustはそれらの型を自動生成された名前の代わりに `closure@<anon>` と示します。

<!-- The error also points out that the return type is expected to be a reference, -->
<!-- but what we are trying to return is not. Further, we cannot directly assign a -->
<!-- `'static` lifetime to an object. So we'll take a different approach and return -->
<!-- a ‘trait object’ by `Box`ing up the `Fn`. This _almost_ works: -->
このエラーはその他にも返り値の型が参照であることを期待しているが、
上のコードではそうではないという事についても指摘しています。
そのうえ、直接的に `'static` ライフタイムをオブジェクトに割り当てることはできません。
そのため、`Fn` をボックス化することで「トレイトオブジェクト」を返すという方法を取ります。
そうすると、動作するように成るまであと一歩のところまで来ます:


```rust,ignore
fn factory() -> Box<Fn(i32) -> i32> {
    let num = 5;

    Box::new(|x| x + num)
}
# fn main() {
let f = factory();

let answer = f(1);
assert_eq!(6, answer);
# }
```

<!-- There’s just one last problem: -->
最後に残されたエラーは以下のとおりです:

```text
error: closure may outlive the current function, but it borrows `num`,
which is owned by the current function [E0373]
Box::new(|x| x + num)
         ^~~~~~~~~~~
```

<!-- Well, as we discussed before, closures borrow their environment. And in this -->
<!-- case, our environment is based on a stack-allocated `5`, the `num` variable -->
<!-- binding. So the borrow has a lifetime of the stack frame. So if we returned -->
<!-- this closure, the function call would be over, the stack frame would go away, -->
<!-- and our closure is capturing an environment of garbage memory! With one last -->
<!-- fix, we can make this work: -->
以前説明したように、クロージャはその環境を借用します。
今回の場合は、環境はスタックにアロケートされた `5` に束縛された `num` からできていることから、
借用はスタックフレームと同じライフタイムを持っています。
そのため、もしこのクロージャを返り値とした場合、
 `factory()` 関数の処理が完了し、スタックフレームは取り除かれクロージャはゴミとなったメモリを参照することになります!
上のコードに最後の修正を施すことによって動作させることができるようになります:


```rust
fn factory() -> Box<Fn(i32) -> i32> {
    let num = 5;

    Box::new(move |x| x + num)
}
# fn main() {
let f = factory();

let answer = f(1);
assert_eq!(6, answer);
# }
```

<!-- By making the inner closure a `move Fn`, we create a new stack frame for our -->
<!-- closure. By `Box`ing it up, we’ve given it a known size, and allowing it to -->
<!-- escape our stack frame. -->
内部のクロージャを `move Fn` にすることで、新しいスタックフレームをクロージャのために生成します。
そしてボックス化することによって、既知のサイズとなり、現在のスタックフレームから抜けることが可能になります。
