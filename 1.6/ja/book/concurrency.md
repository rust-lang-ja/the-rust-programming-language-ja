% 並行性
<!-- % Concurrency -->

<!-- Concurrency and parallelism are incredibly important topics in computer -->
<!-- science, and are also a hot topic in industry today. Computers are gaining more -->
<!-- and more cores, yet many programmers aren't prepared to fully utilize them. -->
並行性と並列性はコンピュータサイエンスにおいて極めて重要なトピックであり、現在では産業界でもホットトピックです。
コンピュータはどんどん多くのコアを持つようになってきていますが、多くのプログラマはまだそれを十分に使いこなす準備ができていません。

<!-- Rust's memory safety features also apply to its concurrency story too. Even -->
<!-- concurrent Rust programs must be memory safe, having no data races. Rust's type -->
<!-- system is up to the task, and gives you powerful ways to reason about -->
<!-- concurrent code at compile time. -->
Rustのメモリ安全性の機能は、Rustの並行性の話においても適用されます。
Rustプログラムは並行であっても、メモリ安全でなければならず、データ競合を起こさないのです。
Rustの型システムはこの問題を扱うことができ、並行なコードをコンパイル時に確かめるための強力な方法を与えます。

<!-- Before we talk about the concurrency features that come with Rust, it's important -->
<!-- to understand something: Rust is low-level enough that the vast majority of -->
<!-- this is provided by the standard library, not by the language. This means that -->
<!-- if you don't like some aspect of the way Rust handles concurrency, you can -->
<!-- implement an alternative way of doing things. -->
<!-- [mio](https://github.com/carllerche/mio) is a real-world example of this -->
<!-- principle in action. -->
Rustが備えている並行性の機能について語る前に、理解しておくべき重要なことがあります。
それは、Rustは十分にローレベルであるため、その大部分は、言語によってではなく、標準ライブラリによって提供されるということです。
これは、もしRustの並行性の扱い方に気に入らないところがあれば、代わりの方法を実装できるということを意味します。
[mio](https://github.com/carllerche/mio) はこの原則を行動で示している実例です。

<!-- ## Background: `Send` and `Sync` -->
## 背景: `Send` と `Sync`

<!-- Concurrency is difficult to reason about. In Rust, we have a strong, static -->
<!-- type system to help us reason about our code. As such, Rust gives us two traits -->
<!-- to help us make sense of code that can possibly be concurrent. -->
並行性を確かめるのは難しいことです。
Rustには、コードを確かめるのを支援する強力で静的な型システムがあります。
そしてRustは、並行になりうるコードの理解を助ける２つのトレイトを提供します。

### `Send`

<!-- The first trait we're going to talk about is -->
<!-- [`Send`](../std/marker/trait.Send.html). When a type `T` implements `Send`, it -->
<!-- indicates that something of this type is able to have ownership transferred -->
<!-- safely between threads. -->
最初に取り上げるトレイトは [`Send`](../std/marker/trait.Send.html) です。
型 `T` が `Send` を実装していた場合、 この型のものはスレッド間で安全に受け渡しされる所有権を持てることを意味します。

<!-- This is important to enforce certain restrictions. For example, if we have a -->
<!-- channel connecting two threads, we would want to be able to send some data -->
<!-- down the channel and to the other thread. Therefore, we'd ensure that `Send` was -->
<!-- implemented for that type. -->
これはある種の制約を強制させる際に重要です。
例えば、もし２つのスレッドをつなぐチャネルがあり、そのチャネルを通じてデータを別のスレッドに送れるようにしたいとします。
このときには、その型について `Send` が実装されているかを確かめます。

<!-- In the opposite way, if we were wrapping a library with [FFI][ffi] that isn't -->
<!-- threadsafe, we wouldn't want to implement `Send`, and so the compiler will help -->
<!-- us enforce that it can't leave the current thread. -->
逆に、スレッドセーフでない [FFI][ffi]  でライブラリを包んでいて、 `Send` を実装したくなかったとします。
このときコンパイラは、そのライブラリが現在のスレッドの外にいかないよう強制することを支援してくれるでしょう。

[ffi]: ffi.html

### `Sync`

<!-- The second of these traits is called [`Sync`](../std/marker/trait.Sync.html). -->
<!-- When a type `T` implements `Sync`, it indicates that something -->
<!-- of this type has no possibility of introducing memory unsafety when used from -->
<!-- multiple threads concurrently through shared references. This implies that -->
<!-- types which don't have [interior mutability](mutability.html) are inherently -->
<!-- `Sync`, which includes simple primitive types (like `u8`) and aggregate types -->
<!-- containing them. -->
２つ目のトレイトは [`Sync`](../std/marker/trait.Sync.html) といいます。
型 `T` が `Sync` を実装していた場合、この型のものは共有された参照を通じて複数スレッドから並行に使われたとしても、必ずメモリ安全であることを意味します。
そのため、 [interior mutability](mutability.html) を持たない型はもともと `Sync` であるといえます。
そのような型としては、 `u8` などの単純なプリミティブ型やそれらを含む合成型などがあります。

<!-- For sharing references across threads, Rust provides a wrapper type called -->
<!-- `Arc<T>`. `Arc<T>` implements `Send` and `Sync` if and only if `T` implements -->
<!-- both `Send` and `Sync`. For example, an object of type `Arc<RefCell<U>>` cannot -->
<!-- be transferred across threads because -->
<!-- [`RefCell`](choosing-your-guarantees.html#refcellt) does not implement -->
<!-- `Sync`, consequently `Arc<RefCell<U>>` would not implement `Send`. -->
スレッドをまたいで参照を共有するために、Rustは `Arc<T>` というラッパ型を提供しています。
`T` が `Send` と `Sync` の両方を実装している時かつその時に限り、 `Arc<T>` は `Send` と `Sync` を実装します。
例えば、型 `Arc<RefCell<U>>` のオブジェクトをスレッドをまたいで受け渡すことはできません。
なぜなら、 [`RefCell`](choosing-your-guarantees.html#refcellt) は `Sync` を実装していないため、 `Arc<RefCell<U>>` は `Send` を実装しないためです。

<!-- These two traits allow you to use the type system to make strong guarantees -->
<!-- about the properties of your code under concurrency. Before we demonstrate -->
<!-- why, we need to learn how to create a concurrent Rust program in the first -->
<!-- place! -->
これらの２つのトレイトのおかげで、コードの並行性に関する性質を強く保証するのに型システムを使うことができます。
ただ、それがどうしてかということを示す前に、まずどうやって並行なRustプログラムをつくるかということを学ぶ必要があります!

<!-- ## Threads -->
## スレッド

<!-- Rust's standard library provides a library for threads, which allow you to -->
<!-- run Rust code in parallel. Here's a basic example of using `std::thread`: -->
Rustの標準ライブラリはスレッドのためのライブラリを提供しており、それによりRustのコードを並列に走らせることができます。
これが `std::thread` を使う基本的な例です。

```rust
use std::thread;

fn main() {
    thread::spawn(|| {
        println!("Hello from a thread!");
    });
}
```

<!-- The `thread::spawn()` method accepts a [closure](closures.html), which is executed in a -->
<!-- new thread. It returns a handle to the thread, that can be used to -->
<!-- wait for the child thread to finish and extract its result: -->
`thread::spawn()` というメソッドは [クロージャ](closures.html) を受け取り、それを新たなスレッドで実行します。
そして、元のスレッドにハンドルを返します。
このハンドルは、子スレッドが終了するのを待機しその結果を取り出すのに使うことが出来ます。

```rust
use std::thread;

fn main() {
    let handle = thread::spawn(|| {
        "Hello from a thread!"
    });

    println!("{}", handle.join().unwrap());
}
```

<!-- Many languages have the ability to execute threads, but it's wildly unsafe. -->
<!-- There are entire books about how to prevent errors that occur from shared -->
<!-- mutable state. Rust helps out with its type system here as well, by preventing -->
<!-- data races at compile time. Let's talk about how you actually share things -->
<!-- between threads. -->
多くの言語はスレッドを実行できますが、それはひどく危険です。
shared mutable stateによって引き起こされるエラーをいかに防ぐかを丸々あつかった本もあります。
Rustはこれについて型システムによって、コンパイル時にデータ競合を防ぐことで支援します。
それでは、実際にどうやってスレッド間での共有を行うかについて話しましょう。

> 訳注: "shared mutable state" は 「共有されたミュータブルな状態」という意味ですが、定型句として、訳さずそのまま使用しています。

<!-- ## Safe Shared Mutable State -->
## 安全な Shared Mutable State

<!-- Due to Rust's type system, we have a concept that sounds like a lie: "safe
shared mutable state." Many programmers agree that shared mutable state is
very, very bad. -->
Rustの型システムのおかげで、「安全な shared mutable state」という嘘のようにきこえる概念があらわれます。
shared mutable state がとてもとても悪いものであるということについて、多くのプログラマの意見は一致しています。

<!-- Someone once said this: -->
このようなことを言った人がいます。

> Shared mutable state is the root of all evil. Most languages attempt to deal
> with this problem through the 'mutable' part, but Rust deals with it by
> solving the 'shared' part.

> 訳: shared mutable state は諸悪の根源だ。
> 多くの言語は `mutable` の部分を通じてこの問題に対処しようとしている。
> しかし、Rustは `shared` の部分を解決することで対処する。

<!-- The same [ownership system](ownership.html) that helps prevent using pointers -->
<!-- incorrectly also helps rule out data races, one of the worst kinds of -->
<!-- concurrency bugs. -->
ポインタの誤った使用の防止には [所有権のシステム](ownership.html) が役立ちますが、このシステムはデータ競合を排除する際にも同様に一役買います。
データ競合は、並行性のバグの中で最悪なものの一つです。

<!-- As an example, here is a Rust program that would have a data race in many -->
<!-- languages. It will not compile: -->
例として、多くの言語で起こるようなデータ競合を含んだRustプログラムをあげます。
これは、コンパイルが通りません。

```ignore
use std::thread;
use std::time::Duration;

fn main() {
    let mut data = vec![1, 2, 3];

    for i in 0..3 {
        thread::spawn(move || {
            data[i] += 1;
        });
    }

    thread::sleep(Duration::from_millis(50));
}
```

<!-- This gives us an error: -->
以下のようなエラーがでます。

```text
8:17 error: capture of moved value: `data`
        data[i] += 1;
        ^~~~
```

<!-- Rust knows this wouldn't be safe! If we had a reference to `data` in each -->
<!-- thread, and the thread takes ownership of the reference, we'd have three -->
<!-- owners! -->
Rustはこれが安全でないだろうと知っているのです!
もし、各スレッドに `data` への参照があり、スレッドごとにその参照の所有権があるとしたら、３人の所有者がいることになってしまうのです!

<!-- So, we need some type that lets us have more than one reference to a value and -->
<!-- that we can share between threads, that is it must implement `Sync`. -->
そのため、１つの値に対して２つ以上の参照を持てるようにして、スレッド間で共有できるような型が必要です。
そして、その型は `Sync` を実装していなければなりません。

<!-- We'll use `Arc<T>`, Rust's standard atomic reference count type, which -->
<!-- wraps a value up with some extra runtime bookkeeping which allows us to -->
<!-- share the ownership of the value between multiple references at the same time. -->
Rustの標準アトミック参照カウント型である `Arc<T>` を使いましょう。
これは複数の参照間で値の所有権を同時に共有できるように、値を特別な実行時の管理用データでくるむものです。

<!-- The bookkeeping consists of a count of how many of these references exist to -->
<!-- the value, hence the reference count part of the name. -->
その管理用データには、値への参照がいくつ存在しているかというカウントが記録されています。
すなわち名前の「参照カウント」の部分にあたります。

<!-- The Atomic part means `Arc<T>` can safely be accessed from multiple threads. -->
<!-- To do this the compiler guarantees that mutations of the internal count use -->
<!-- indivisible operations which can't have data races. -->
「アトミック」という部分は `Arc<T>` が複数スレッドから安全にアクセスできることを意味しています。
このためにコンパイラは、内部のカウントの更新には、データ競合が起こりえない分割不能な操作が用いられることを保証します。

```ignore
use std::thread;
use std::sync::Arc;
use std::time::Duration;

fn main() {
    let mut data = Arc::new(vec![1, 2, 3]);

    for i in 0..3 {
        let data = data.clone();
        thread::spawn(move || {
            data[i] += 1;
        });
    }

    thread::sleep(Duration::from_millis(50));
}
```

<!-- We now call `clone()` on our `Arc<T>`, which increases the internal count. -->
<!-- This handle is then moved into the new thread. -->
ここで `Arc<T>` について `clone()` を呼んで、内部のカウントを増やしています。
そして、このハンドルは新たなスレッドに移動されます。

<!-- And... still gives us an error. -->
そうすると...
まだ、エラーがでます。

```text
<anon>:11:24 error: cannot borrow immutable borrowed content as mutable
<anon>:11                    data[i] += 1;
                             ^~~~
```

<!-- `Arc<T>` assumes one more property about its contents to ensure that it is safe -->
<!-- to share across threads: it assumes its contents are `Sync`. This is true for -->
<!-- our value if it's immutable, but we want to be able to mutate it, so we need -->
<!-- something else to persuade the borrow checker we know what we're doing. -->
`Arc<T>` はスレッドをまたいだ共有を安全にするために、その中身に対してもう一つの仮定をおいています。
それは、中身が `Sync` であるという仮定です。
この仮定は値がイミュータブルであるときは真になりますが、今回は値を変化できるようにしたいです。
そのため、借用チェッカに対し、我々は自分たちが何をやっているかを知っています、と説得するための何かが必要になります。

<!-- It looks like we need some type that allows us to safely mutate a shared value, -->
<!-- for example a type that can ensure only one thread at a time is able to -->
<!-- mutate the value inside it at any one time. -->
共有された値を安全に変更できるようにするための型が必要そうです。
例えば、どの時点においても、同時に一つのスレッドのなかでしか値は変更できないということを保証できる型です。

<!-- For that, we can use the `Mutex<T>` type! -->
そのためには、 `Mutex<T>` 型を使うことができます!

<!-- Here's the working version: -->
これが動くバージョンです。

```rust
use std::sync::{Arc, Mutex};
use std::thread;
use std::time::Duration;

fn main() {
    let data = Arc::new(Mutex::new(vec![1, 2, 3]));

    for i in 0..3 {
        let data = data.clone();
        thread::spawn(move || {
            let mut data = data.lock().unwrap();
            data[i] += 1;
        });
    }

    thread::sleep(Duration::from_millis(50));
}
```

<!-- Note that the value of `i` is bound (copied) to the closure and not shared
among the threads. -->
`i` の値はクロージャへ束縛(コピー)されるだけで、スレッド間で共有されるわけではないことに注意してください。

<!-- Also note that [`lock`](../std/sync/struct.Mutex.html#method.lock) method of -->
<!-- [`Mutex`](../std/sync/struct.Mutex.html) has this signature: -->
また、[`Mutex`](../std/sync/struct.Mutex.html) の [`lock`](../std/sync/struct.Mutex.html#method.lock) メソッドは以下のシグネチャを持つことにも注意してください。

```ignore
fn lock(&self) -> LockResult<MutexGuard<T>>
```

<!-- and because `Send` is not implemented for `MutexGuard<T>`, the guard cannot -->
<!-- cross thread boundaries, ensuring thread-locality of lock acquire and release. -->
そして、 `Send` は `MutexGuard<T>` に対して実装されていないため、ガードはスレッドの境界をまたげず、ロックの獲得と解放のスレッドローカル性が保証されています。

<!-- Let's examine the body of the thread more closely: -->
それでは、スレッドの中身をさらに詳しく見ていきましょう。

```rust
# use std::sync::{Arc, Mutex};
# use std::thread;
# use std::time::Duration;
# fn main() {
#     let data = Arc::new(Mutex::new(vec![1, 2, 3]));
#     for i in 0..3 {
#         let data = data.clone();
thread::spawn(move || {
    let mut data = data.lock().unwrap();
    data[i] += 1;
});
#     }
#     thread::sleep(Duration::from_millis(50));
# }
```

<!-- First, we call `lock()`, which acquires the mutex's lock. Because this may fail, -->
<!-- it returns an `Result<T, E>`, and because this is just an example, we `unwrap()` -->
<!-- it to get a reference to the data. Real code would have more robust error handling -->
<!-- here. We're then free to mutate it, since we have the lock. -->
まず、 `lock()` を呼び、mutex のロックを獲得します。
これは失敗するかもしれないため、`Result<T, E>` が返されます。
そして、今回は単なる例なので、データへの参照を得るためにそれを `unwrap()` します。
実際のコードでは、ここでもっとちゃんとしたエラーハンドリングをするでしょう。
そうしたら、ロックを持っているので、自由に値を変更できます。

<!-- Lastly, while the threads are running, we wait on a short timer. But -->
<!-- this is not ideal: we may have picked a reasonable amount of time to -->
<!-- wait but it's more likely we'll either be waiting longer than -->
<!-- necessary or not long enough, depending on just how much time the -->
<!-- threads actually take to finish computing when the program runs. -->
最後の部分で、スレッドが実行されている間、短いタイマーで待機しています。
しかし、これはよろしくないです。
というのも、ちょうどよい待機時間を選んでいた可能性より、必要以上に長い時間待ってしまっていたり、十分に待っていなかったりする可能性の方が高いからです。
適切な待ち時間というのは、プログラムを実行した際に、実際に計算が終わるまでどれだけの時間がかかったかに依存します。

<!-- A more precise alternative to the timer would be to use one of the -->
<!-- mechanisms provided by the Rust standard library for synchronizing -->
<!-- threads with each other. Let's talk about one of them: channels. -->
タイマーに代わるより良い選択肢は、Rust標準ライブラリによって提供されている、スレッドがお互いに同期するためのメカニズムを用いることです。
それでは、そのようなものの一つについて話しましょう。
チャネルです。

<!-- ## Channels -->
## チャネル

<!-- Here's a version of our code that uses channels for synchronization, rather -->
<!-- than waiting for a specific time: -->
このコードが、適当な時間を待つ代わりに、同期のためにチャネルを使ったバージョンです。

```rust
use std::sync::{Arc, Mutex};
use std::thread;
use std::sync::mpsc;

fn main() {
    let data = Arc::new(Mutex::new(0));

    let (tx, rx) = mpsc::channel();

    for _ in 0..10 {
        let (data, tx) = (data.clone(), tx.clone());

        thread::spawn(move || {
            let mut data = data.lock().unwrap();
            *data += 1;

            tx.send(()).unwrap();
        });
    }

    for _ in 0..10 {
        rx.recv().unwrap();
    }
}
```

<!-- We use the `mpsc::channel()` method to construct a new channel. We just `send` -->
<!-- a simple `()` down the channel, and then wait for ten of them to come back. -->
`mpsc::channel()` メソッドを使って、新たなチャネルを生成しています。
そして、ただの `()` をチャネルを通じて単に `send` し、それが１０個戻ってくるのを待機します。

<!-- While this channel is just sending a generic signal, we can send any data that -->
<!-- is `Send` over the channel! -->
このチャネルはただシグナルを送っているだけですが、 `Send` であるデータならばなんでもこのチャネルを通じて送れます!

```rust
use std::thread;
use std::sync::mpsc;

fn main() {
    let (tx, rx) = mpsc::channel();

    for i in 0..10 {
        let tx = tx.clone();

        thread::spawn(move || {
            let answer = i * i;

            tx.send(answer).unwrap();
        });
    }

    for _ in 0..10 {
        println!("{}", rx.recv().unwrap());
    }
}
```

<!-- Here we create 10 threads, asking each to calculate the square of a number (`i` -->
<!-- at the time of `spawn()`), and then `send()` back the answer over the channel. -->
ここでは、１０個のスレッドを生成し、それぞれに数値 ( `spawn()` したときの `i` ) の２乗を計算させ、その答えをチャネルを通じて `send()` で送り返させています。

<!-- ## Panics -->
## パニック

<!-- A `panic!` will crash the currently executing thread. You can use Rust's -->
<!-- threads as a simple isolation mechanism: -->
`panic!` は現在実行中のスレッドをクラッシュさせます。
Rustのスレッドは独立させるための単純なメカニズムとして使うことができます。

```rust
use std::thread;

let handle = thread::spawn(move || {
    panic!("oops!");
});

let result = handle.join();

assert!(result.is_err());
```

<!-- `Thread.join()` gives us a `Result` back, which allows us to check if the thread -->
<!-- has panicked or not. -->
`Thread.join()` は `Result` を返し、これによってスレッドがパニックしたかどうかをチェックできます。
