% 保証を選ぶ
<!--% Choosing your Guarantees-->

<!--One important feature of Rust is that it lets us control the costs and guarantees-->
<!--of a program.-->
Rustの重要な特長の1つは、プログラムのコストと保証を制御することができるということです。

<!--There are various &ldquo;wrapper type&rdquo; abstractions in the Rust standard library which embody-->
<!--a multitude of tradeoffs between cost, ergonomics, and guarantees. Many let one choose between-->
<!--run time and compile time enforcement. This section will explain a few selected abstractions in-->
<!--detail.-->
Rustの標準ライブラリには、様々な「ラッパ型」の抽象があり、それらはコスト、エルゴノミクス、保証の間の多数のトレードオフをまとめています。
それらのトレードオフの多くでは実行時とコンパイル時のどちらかを選ばせてくれます。
このセクションでは、いくつかの抽象を選び、詳細に説明します。

<!--Before proceeding, it is highly recommended that one reads about [ownership][ownership] and-->
<!--[borrowing][borrowing] in Rust.-->
先に進む前に、Rustにおける [所有権][ownership] と [借用][borrowing] について読んでおくことを強く推奨します。

[ownership]: ownership.html
[borrowing]: references-and-borrowing.html

<!--# Basic pointer types-->
# 基本的なポインタ型

## `Box<T>`

<!--[`Box<T>`][box] is an &ldquo;owned&rdquo; pointer, or a &ldquo;box&rdquo;. While it can hand-->
<!--out references to the contained data, it is the only owner of the data. In particular, consider-->
<!--the following:-->
[`Box<T>`][box] は「所有される」ポインタ、すなわち「ボックス」です。
ボックスは中身のデータへの参照を渡すことができますが、ボックスだけがそのデータの唯一の所有者です。
特に、次のことを考えましょう。

```rust
let x = Box::new(1);
let y = x;
# // x no longer accessible here
// ここではもうxにアクセスできない
```

<!--Here, the box was _moved_ into `y`. As `x` no longer owns it, the compiler will no longer allow the-->
<!--programmer to use `x` after this. A box can similarly be moved _out_ of a function by returning it.-->
ここで、そのボックスは `y` に _ムーブ_ されました。
`x` はもはやそれを所有していないので、これ以降、コンパイラはプログラマが `x` を使うことを許しません。
同様に、ボックスはそれを返すことで関数の _外_ にムーブさせることもできます。

<!--When a box (that hasn't been moved) goes out of scope, destructors are run. These destructors take-->
<!--care of deallocating the inner data.-->
（ムーブされていない）ボックスがスコープから外れると、デストラクタが実行されます。
それらのデストラクタは中身のデータを解放して片付けます。

<!--This is a zero-cost abstraction for dynamic allocation. If you want to allocate some memory on the-->
<!--heap and safely pass around a pointer to that memory, this is ideal. Note that you will only be-->
<!--allowed to share references to this by the regular borrowing rules, checked at compile time.-->
これは動的割当てのゼロコスト抽象化です。
もしヒープにメモリを割り当てたくて、そのメモリへのポインタを安全に取り回したいのであれば、これは理想的です。
コンパイル時にチェックされる通常の借用のルールに基づいてこれへの参照を共有することが許されているだけだということに注意しましょう。

[box]: ../std/boxed/struct.Box.html

<!--## `&T` and `&mut T`-->
## `&T` と `&mut T`

<!--These are immutable and mutable references respectively. They follow the &ldquo;read-write lock&rdquo;-->
<!--pattern, such that one may either have only one mutable reference to some data, or any number of-->
<!--immutable ones, but not both. This guarantee is enforced at compile time, and has no visible cost at-->
<!--runtime. In most cases these two pointer types suffice for sharing cheap references between sections-->
<!--of code.-->
参照にはイミュータブルな参照とミュータブルな参照がそれぞれあります。
それらは「読み書きロック」パターンに従います。それは、あるデータへのミュータブルな参照を1つだけ持つこと、又は複数のイミュータブルな参照を持つことはあり得るが、その両方を持つことはあり得ないということです。
この保証はコンパイル時に強制され、目に見えるような実行時のコストは発生しません。
多くの場合、それら2つのポインタ型は低コストの参照をコードのセクション間で共有するには十分です。

<!--These pointers cannot be copied in such a way that they outlive the lifetime associated with them.-->
それらのポインタを関連付けられているライフタイムを超えて有効になるような方法でコピーすることはできません。

<!--## `*const T` and `*mut T`-->
## `*const T` と `*mut T`

<!-- These are C-like raw pointers with no lifetime or ownership attached to them. They point to -->
<!--some location in memory with no other restrictions. The only guarantee that these provide is that-->
<!--they cannot be dereferenced except in code marked `unsafe`.-->
関連付けられたライフタイムや所有権を持たない、C的な生ポインタがあります。
それらはメモリのある場所を何の制約もなく指示します。
それらの提供する唯一の保証は、 `unsafe` であるとマークされたコードの外ではそれらが参照を外せないということです。

<!--These are useful when building safe, low cost abstractions like `Vec<T>`, but should be avoided in-->
<!--safe code.-->
それらは `Vec<T>` のような安全で低コストな抽象を構築するときには便利ですが、安全なコードの中では避けるべきです。

## `Rc<T>`

<!--This is the first wrapper we will cover that has a runtime cost.-->
これは、本書でカバーする中では初めての、実行時にコストの発生するラッパです。

<!--[`Rc<T>`][rc] is a reference counted pointer. In other words, this lets us have multiple "owning"-->
<!--pointers to the same data, and the data will be dropped (destructors will be run) when all pointers-->
<!--are out of scope.-->
[`Rc<T>`][rc] は参照カウンタを持つポインタです。
言い換えると、これを使えば、あるデータを「所有する」複数のポインタを持つことができるようになるということです。そして、全てのポインタがスコープから外れたとき、そのデータは削除されます（デストラクタが実行されます）。

<!--Internally, it contains a shared &ldquo;reference count&rdquo; (also called &ldquo;refcount&rdquo;),-->
<!--which is incremented each time the `Rc` is cloned, and decremented each time one of the `Rc`s goes-->
<!--out of scope. The main responsibility of `Rc<T>` is to ensure that destructors are called for shared-->
<!--data.-->
内部的には、それは共有「参照カウント」（「refcount」とも呼ばれます）を持っています。それは、 `Rc` がクローンされる度に1増加し、 `Rc` がスコープから外れる度に1減少します。
`Rc<T>` の主な役割は、共有データのデストラクタが呼び出されることを保証することです。

<!--The internal data here is immutable, and if a cycle of references is created, the data will be-->
<!--leaked. If we want data that doesn't leak when there are cycles, we need a garbage collector.-->
ここでの中身のデータはイミュータブルで、もし循環参照が起きてしまったら、そのデータはメモリリークを起こすでしょう。
もし循環してもメモリリークを起こさないデータを求めるのであれば、ガーベジコレクタが必要です。

<!--#### Guarantees-->
#### 保証

<!--The main guarantee provided here is that the data will not be destroyed until all references to it-->
<!--are out of scope.-->
ここで提供される主な保証は、それに対する全ての参照がスコープから外れるまではデータが破壊されないということです。

<!--This should be used when we wish to dynamically allocate and share some data (read-only) between-->
<!--various portions of your program, where it is not certain which portion will finish using the pointer-->
<!--last. It's a viable alternative to `&T` when `&T` is either impossible to statically check for-->
<!--correctness, or creates extremely unergonomic code where the programmer does not wish to spend the-->
<!--development cost of working with.-->
これは（読込専用の）あるデータを動的に割り当て、プログラムの様々な部分で共有したいときで、どの部分が最後にポインタを使い終わるのかがはっきりしないときに使われるべきです。
それは `&T` が正しさを静的にチェックすることが不可能なとき、又はプログラマがそれを使うために開発コストを費やすことを望まないような極めて非エルゴノミックなコードを作っているときに、 `&T` の有望な代替品です。

<!--This pointer is _not_ thread safe, and Rust will not let it be sent or shared with other threads.-->
<!--This lets one avoid the cost of atomics in situations where they are unnecessary.-->
このポインタはスレッドセーフでは _ありません_ 。Rustはそれを他のスレッドに対して送ったり共有したりはさせません。
これによって、それらが不要な状況でのアトミック性のためのコストを省くことができます。

<!--There is a sister smart pointer to this one, `Weak<T>`. This is a non-owning, but also non-borrowed,-->
<!--smart pointer. It is also similar to `&T`, but it is not restricted in lifetime&mdash;a `Weak<T>`-->
<!--can be held on to forever. However, it is possible that an attempt to access the inner data may fail-->
<!--and return `None`, since this can outlive the owned `Rc`s. This is useful for cyclic-->
<!--data structures and other things.-->
これの姉妹に当たるスマートポインタとして、 `Weak<T>` があります。
これは所有せず、借用もしないスマートポインタです。
それは `&T` とも似ていますが、ライフタイムによる制約がありません。 `Weak<T>` は永遠に有効であり続けることができます。
しかし、これは所有する `Rc` のライフタイムを超えて有効である可能性があるため、中身のデータへのアクセスが失敗し、 `None` を返すという可能性があります。
これは循環するデータ構造やその他のものについて便利です。

<!--#### Cost-->
#### コスト

<!--As far as memory goes, `Rc<T>` is a single allocation, though it will allocate two extra words (i.e.-->
<!--two `usize` values) as compared to a regular `Box<T>` (for "strong" and "weak" refcounts).-->
メモリに関する限り、 `Rc<T>` の割当ては1回です。ただし、普通の `Box<T>` と比べると
（「強い」参照カウントと「弱い」参照カウントのために）、2ワード余分（つまり、2つの `usize` の値）に割り当てます。

<!--`Rc<T>` has the computational cost of incrementing/decrementing the refcount whenever it is cloned-->
<!--or goes out of scope respectively. Note that a clone will not do a deep copy, rather it will simply-->
<!--increment the inner reference count and return a copy of the `Rc<T>`.-->
`Rc<T>` では、それをクローンしたりそれがスコープから外れたりする度に参照カウントを増減するための計算コストが掛かります。
クローンはディープコピーではなく、それが単に内部の参照カウントを1増加させ、 `Rc<T>` のコピーを返すだけだということに注意しましょう。

[rc]: ../std/rc/struct.Rc.html

<!--# Cell types-->
# セル型

<!--`Cell`s provide interior mutability. In other words, they contain data which can be manipulated even-->
<!--if the type cannot be obtained in a mutable form (for example, when it is behind an `&`-ptr or-->
<!--`Rc<T>`).-->
`Cell` は内的ミュータビリティを提供します。
言い換えると、型がミュータブルな形式を持てないものであったとしても（例えば、それが `&` ポインタや `Rc<T>` の参照先であるとき）、操作できるデータを持つということです。

<!--[The documentation for the `cell` module has a pretty good explanation for these][cell-mod].-->
[`cell`モジュールのドキュメントには、それらについての非常によい説明があります][cell-mod] 。

<!--These types are _generally_ found in struct fields, but they may be found elsewhere too.-->
それらの型は _一般的には_ 構造体のフィールドで見られますが、他の場所でも見られるかもしれません。

## `Cell<T>`

<!--[`Cell<T>`][cell] is a type that provides zero-cost interior mutability, but only for `Copy` types.-->
<!--Since the compiler knows that all the data owned by the contained value is on the stack, there's-->
<!--no worry of leaking any data behind references (or worse!) by simply replacing the data.-->
[`Cell<T>`][cell] はゼロコストで内的ミュータビリティを提供するものですが、 `Copy` 型のためだけのものです。
コンパイラは含まれている値によって所有されている全てのデータがスタック上にあることを認識しています。そのため、単純にデータが置き換えられることによって参照先のデータがメモリリークを起こす（又はもっと悪いことも!）心配はありません。

<!--It is still possible to violate your own invariants using this wrapper, so be careful when using it.-->
<!--If a field is wrapped in `Cell`, it's a nice indicator that the chunk of data is mutable and may not-->
<!--stay the same between the time you first read it and when you intend to use it.-->
このラッパを使うことで、維持されている不変性に違反してしまう可能性もあるので、それを使うときには注意しましょう。
もしフィールドが `Cell` でラップされているならば、そのデータの塊はミュータブルで、最初にそれを読み込んだときとそれを使おうと思ったときで同じままだとは限らないということのよい目印になります。

```rust
use std::cell::Cell;

let x = Cell::new(1);
let y = &x;
let z = &x;
x.set(2);
y.set(3);
z.set(4);
println!("{}", x.get());
```

<!--Note that here we were able to mutate the same value from various immutable references.-->
ここでは同じ値を様々なイミュータブルな参照から変更できるということに注意しましょう。

<!--This has the same runtime cost as the following:-->
これには次のものと同じ実行時のコストが掛かります。

```rust,ignore
let mut x = 1;
let y = &mut x;
let z = &mut x;
x = 2;
*y = 3;
*z = 4;
println!("{}", x);
```

<!--but it has the added benefit of actually compiling successfully.-->
しかし、それには実際に正常にコンパイルできるという追加の利点があります。

<!--#### Guarantees-->
#### 保証

<!--This relaxes the &ldquo;no aliasing with mutability&rdquo; restriction in places where it's-->
<!--unnecessary. However, this also relaxes the guarantees that the restriction provides; so if your-->
<!--invariants depend on data stored within `Cell`, you should be careful.-->
これは「ミュータブルなエイリアスはない」という制約を、それが不要な場所において緩和します。
しかし、これはその制約が提供する保証をも緩和してしまいます。もし不変条件が `Cell` に保存されているデータに依存しているのであれば、注意すべきです。

<!--This is useful for mutating primitives and other `Copy` types when there is no easy way of-->
<!--doing it in line with the static rules of `&` and `&mut`.-->
これは `&` や `&mut` の静的なルールの下では簡単な方法がない場合に、プリミティブやその他の `Copy` 型を変更するのに便利です。

<!--`Cell` does not let you obtain interior references to the data, which makes it safe to freely-->
<!--mutate.-->
`Cell` によって安全な方法で自由に変更できるようなデータへの内部の参照を得られるわけではありません。

<!--#### Cost-->
#### コスト

<!--There is no runtime cost to using `Cell<T>`, however if you are using it to wrap larger (`Copy`)-->
<!--structs, it might be worthwhile to instead wrap individual fields in `Cell<T>` since each write is-->
<!--otherwise a full copy of the struct.-->
`Cell<T>` の使用に実行時のコストは掛かりません。ただし、もしそれを大きな（ `Copy` の）構造体をラップするために使っているのであれば、代わりに個々のフィールドを `Cell<T>` でラップする方がよいかもしれません。そうしなければ、各書込みが構造体の完全コピーを発生させることになるからです。

## `RefCell<T>`

<!--[`RefCell<T>`][refcell] also provides interior mutability, but isn't restricted to `Copy` types.-->
[`RefCell<T>`][refcell] もまた内的ミュータビリティを提供するものですが、 `Copy` 型に限定されません。

<!--Instead, it has a runtime cost. `RefCell<T>` enforces the read-write lock pattern at runtime (it's-->
<!--like a single-threaded mutex), unlike `&T`/`&mut T` which do so at compile time. This is done by the-->
<!--`borrow()` and `borrow_mut()` functions, which modify an internal reference count and return smart-->
<!--pointers which can be dereferenced immutably and mutably respectively. The refcount is restored when-->
<!--the smart pointers go out of scope. With this system, we can dynamically ensure that there are never-->
<!--any other borrows active when a mutable borrow is active. If the programmer attempts to make such a-->
<!--borrow, the thread will panic.-->
その代わり、それには実行時のコストが掛かります。
`RefCell<T>` は読み書きロックパターンを実行時に（シングルスレッドのミューテックスのように）強制します。この点が、それをコンパイル時に行う `&T` や `&mut T` とは異なります。
これは `borrow()` 関数と `borrow_mut()` 関数によって行われます。それらは内部の参照カウントを変更し、それぞれイミュータブル、ミュータブルに参照を外すことのできるスマートポインタを戻します。
参照カウントはスマートポインタがスコープから外れたときに元に戻されます。
このシステムによって、ミュータブルな借用が有効なときには決してその他の借用が有効にならないということを動的に保証することができます。
もしプログラマがそのような借用を作ろうとすれば、スレッドはパニックするでしょう。

```rust
use std::cell::RefCell;

let x = RefCell::new(vec![1,2,3,4]);
{
    println!("{:?}", *x.borrow())
}

{
    let mut my_ref = x.borrow_mut();
    my_ref.push(1);
}
```

<!--Similar to `Cell`, this is mainly useful for situations where it's hard or impossible to satisfy the-->
<!--borrow checker. Generally we know that such mutations won't happen in a nested form, but it's good-->
<!--to check.-->
`Cell` と同様に、これは主に、借用チェッカを満足させることが困難、又は不可能な状況で便利です。
一般的に、そのような変更はネストした形式では発生しないと考えられますが、それをチェックすることはよいことです。

<!--For large, complicated programs, it becomes useful to put some things in `RefCell`s to make things-->
<!-- simpler. For example, a lot of the maps in the `ctxt` struct in the Rust compiler internals -->
<!--are inside this wrapper. These are only modified once (during creation, which is not right after-->
<!--initialization) or a couple of times in well-separated places. However, since this struct is-->
<!--pervasively used everywhere, juggling mutable and immutable pointers would be hard (perhaps-->
<!--impossible) and probably form a soup of `&`-ptrs which would be hard to extend. On the other hand,-->
<!--the `RefCell` provides a cheap (not zero-cost) way of safely accessing these. In the future, if-->
<!--someone adds some code that attempts to modify the cell when it's already borrowed, it will cause a-->
<!--(usually deterministic) panic which can be traced back to the offending borrow.-->
大きく複雑なプログラムにとって、物事を単純にするために何かを `RefCell` の中に入れることは便利です。
例えば、Rustコンパイラの内部の`ctxt`構造体にあるたくさんのマップはこのラッパの中にあります。
それらは（初期化の直後ではなく生成の過程で）一度だけ変更されるか、又はきれいに分離された場所で数回変更されます。
しかし、この構造体はあらゆる場所で全般的に使われているので、ミュータブルなポインタとイミュータブルなポインタとをジャグリング的に扱うのは難しく（あるいは不可能で）、おそらく拡張の困難な `&` ポインタのスープになってしまいます。
一方、 `RefCell` はそれらにアクセスするための（ゼロコストではありませんが）低コストの方法です。
将来、もし誰かが既に借用されたセルを変更しようとするコードを追加すれば、それは（普通は確定的に）パニックを引き起こすでしょう。これは、その違反した借用まで遡り得ます。

<!--Similarly, in Servo's DOM there is a lot of mutation, most of which is local to a DOM type, but some-->
<!--of which crisscrosses the DOM and modifies various things. Using `RefCell` and `Cell` to guard all-->
<!--mutation lets us avoid worrying about mutability everywhere, and it simultaneously highlights the-->
<!--places where mutation is _actually_ happening.-->
同様に、ServoのDOMではたくさんの変更が行われるようになっていて、そのほとんどはDOM型にローカルです。しかし、複数のDOMに縦横無尽にまたがり、様々なものを変更するものもあります。
全ての変更をガードするために `RefCell` と `Cell` を使うことで、あらゆる場所でのミュータビリティについて心配する必要がなくなり、それは同時に、変更が _実際に_ 起こっている場所を強調してくれます。

<!--Note that `RefCell` should be avoided if a mostly simple solution is possible with `&` pointers.-->
もし `&` ポインタを使ってもっと単純に解決できるのであれば、 `RefCell` は避けるべきであるということに注意しましょう。

<!--#### Guarantees-->
#### 保証

<!--`RefCell` relaxes the _static_ restrictions preventing aliased mutation, and replaces them with-->
<!--_dynamic_ ones. As such the guarantees have not changed.-->
`RefCell` はミュータブルなエイリアスを作らせないという _静的な_ 制約を緩和し、それを _動的な_ 制約に置き換えます。
そのため、その保証は変わりません。

<!--#### Cost-->
#### コスト

<!--`RefCell` does not allocate, but it contains an additional "borrow state"-->
<!--indicator (one word in size) along with the data.-->
`RefCell` は割当てを行いませんが、データとともに（サイズ1ワードの）追加の「借用状態」の表示を持っています。

<!--At runtime each borrow causes a modification/check of the refcount.-->
実行時には、各借用が参照カウントの変更又はチェックを発生させます。

[cell-mod]: ../std/cell/
[cell]: ../std/cell/struct.Cell.html
[refcell]: ../std/cell/struct.RefCell.html

<!--# Synchronous types-->
# 同期型

<!--Many of the types above cannot be used in a threadsafe manner. Particularly, `Rc<T>` and-->
<!--`RefCell<T>`, which both use non-atomic reference counts (_atomic_ reference counts are those which-->
<!--can be incremented from multiple threads without causing a data race), cannot be used this way. This-->
<!--makes them cheaper to use, but we need thread safe versions of these too. They exist, in the form of-->
<!--`Arc<T>` and `Mutex<T>`/`RwLock<T>`-->
前に挙げた型の多くはスレッドセーフな方法で使うことができません。
特に `Rc<T>` と `RefCell<T>` は両方とも非アトミックな参照カウント（ _アトミックな_ 参照カウントとは、データ競合を発生させることなく複数のスレッドから増加させることができるもののことです）を使っていて、スレッドセーフな方法で使うことができません。
これによってそれらを低コストで使うことができるのですが、それらのスレッドセーフなバージョンも必要です。
それらは `Arc<T>` 、 `Mutex<T>` 、 `RwLock<T>` という形式で存在します。

<!--Note that the non-threadsafe types _cannot_ be sent between threads, and this is checked at compile-->
<!--time.-->
非スレッドセーフな型はスレッド間で送ることが _できません_ 。
これはコンパイル時にチェックされます。

<!--There are many useful wrappers for concurrent programming in the [sync][sync] module, but only the-->
<!--major ones will be covered below.-->
[sync][sync] モジュールには並行プログラミングのための便利なラッパがたくさんありますが、以下では有名なものだけをカバーします。

[sync]: ../std/sync/index.html

## `Arc<T>`

<!-- [`Arc<T>`][arc] is a version of `Rc<T>` that uses an atomic reference count (hence, "Arc"). -->
<!--This can be sent freely between threads.-->
[`Arc<T>`][arc] はアトミックな参照カウントを使う `Rc<T>` の別バージョンです（そのため、「Arc」なのです）。
これはスレッド間で自由に送ることができます。

<!--C++'s `shared_ptr` is similar to `Arc`, however in the case of C++ the inner data is always mutable.-->
<!--For semantics similar to that from C++, we should use `Arc<Mutex<T>>`, `Arc<RwLock<T>>`, or-->
<!--`Arc<UnsafeCell<T>>`[^4] (`UnsafeCell<T>` is a cell type that can be used to hold any data and has-->
<!--no runtime cost, but accessing it requires `unsafe` blocks). The last one should only be used if we-->
<!--are certain that the usage won't cause any memory unsafety. Remember that writing to a struct is not-->
<!--an atomic operation, and many functions like `vec.push()` can reallocate internally and cause unsafe-->
<!--behavior, so even monotonicity may not be enough to justify `UnsafeCell`.-->
C++の `shared_ptr` は `Arc` と似ていますが、C++の場合、中身のデータは常にミュータブルです。
C++と同じセマンティクスで使うためには、 `Arc<Mutex<T>>` 、 `Arc<RwLock<T>>` 、 `Arc<UnsafeCell<T>>` を使うべきです [^4] （ `UnsafeCell<T>` はどんなデータでも持つことができ、実行時のコストも掛かりませんが、それにアクセスするためには `unsafe` ブロックが必要というセル型です）。
最後のものは、その使用がメモリをアンセーフにしないことを確信している場合にだけ使うべきです。
次のことを覚えましょう。構造体に書き込むのはアトミックな作業ではなく、`vec.push()`のような多くの関数は内部でメモリの再割当てを行い、アンセーフな挙動を引き起こす可能性があります。そのため単純な操作であるということだけでは `UnsafeCell` を正当化するには十分ではありません。

<!--[^4]: `Arc<UnsafeCell<T>>` actually won't compile since `UnsafeCell<T>` isn't `Send` or `Sync`, but we can wrap it in a type and implement `Send`/`Sync` for it manually to get `Arc<Wrapper<T>>` where `Wrapper` is `struct Wrapper<T>(UnsafeCell<T>)`.-->
[^4]: `Arc<UnsafeCell<T>>` は `Send` や `Sync` ではないため、実際にはコンパイルできません。しかし、 `Arc<Wrapper<T>>` を得るために、手動でそれを `Send` と `Sync` を実装した型でラップすることができます。ここでの `Wrapper` は `struct Wrapper<T>(UnsafeCell<T>)` です。

<!--#### Guarantees-->
#### 保証

<!--Like `Rc`, this provides the (thread safe) guarantee that the destructor for the internal data will-->
<!--be run when the last `Arc` goes out of scope (barring any cycles).-->
`Rc` のように、これは最後の `Arc` がスコープから外れたときに（循環がなければ）中身のデータのためのデストラクタが実行されることを（スレッドセーフに）保証します。

<!--#### Cost-->
#### コスト

<!--This has the added cost of using atomics for changing the refcount (which will happen whenever it is-->
<!--cloned or goes out of scope). When sharing data from an `Arc` in a single thread, it is preferable-->
<!--to share `&` pointers whenever possible.-->
これには参照カウントの変更（これは、それがクローンされたりスコープから外れたりする度に発生します）にアトミック性を使うための追加のコストが掛かります。
シングルスレッドにおいて、データを `Arc` から共有するのであれば、可能な場合は `&` ポインタを共有する方が適切です。

[arc]: ../std/sync/struct.Arc.html

<!--## `Mutex<T>` and `RwLock<T>`-->
## `Mutex<T>` と `RwLock<T>`

<!--[`Mutex<T>`][mutex] and [`RwLock<T>`][rwlock] provide mutual-exclusion via RAII guards (guards are-->
<!--objects which maintain some state, like a lock, until their destructor is called). For both of-->
<!--these, the mutex is opaque until we call `lock()` on it, at which point the thread will block-->
<!--until a lock can be acquired, and then a guard will be returned. This guard can be used to access-->
<!--the inner data (mutably), and the lock will be released when the guard goes out of scope.-->
[`Mutex<T>`][mutex] と [`RwLock<T>`][rwlock] はRAIIガード（ガードとは、ロックのようにそれらのデストラクタが呼び出されるまである状態を保持するオブジェクトのことです）による相互排他を提供します。
それらの両方とも、その `lock()` を呼び出すまでミューテックスは不透明です。その時点で、スレッドはロックが得られ、ガードが戻されるまでブロックします。
このガードを使うことで、中身のデータに（ミュータブルに）アクセスできるようになり、ロックはガードがスコープから外れたときに解放されます。

```rust,ignore
{
    let guard = mutex.lock();
#   // guard dereferences mutably to the inner type
    // ガードがミュータブルに内部の型への参照を外す
    *guard += 1;
# // } // lock released when destructor runs
} // デストラクタが実行されるときにロックは解除される
```

<!--`RwLock` has the added benefit of being efficient for multiple reads. It is always safe to have-->
<!--multiple readers to shared data as long as there are no writers; and `RwLock` lets readers acquire a-->
<!--"read lock". Such locks can be acquired concurrently and are kept track of via a reference count.-->
<!--Writers must obtain a "write lock" which can only be obtained when all readers have gone out of-->
<!--scope.-->
`RwLock`には複数の読込みを効率化するという追加の利点があります。
それはライタのない限り常に、共有されたデータに対する複数のリーダを安全に持つことができます。そして、`RwLock`によってリーダは「読込みロック」を取得できます。
このようなロックは並行に取得することができ、参照カウントによって追跡することができます。
ライタは「書込みロック」を取得する必要があります。「書込みロック」はすべてのリーダがスコープから外れたときにだけ取得できます。

<!--#### Guarantees-->
#### 保証

<!--Both of these provide safe shared mutability across threads, however they are prone to deadlocks.-->
<!--Some level of additional protocol safety can be obtained via the type system.-->
それらのどちらもスレッド間での安全で共有されたミュータビリティを提供しますが、それらはデッドロックしがちです。
型システムによって、ある程度の追加のプロトコルの安全性を得ることができます。

<!--#### Costs-->
#### コスト

<!--These use internal atomic-like types to maintain the locks, which are pretty costly (they can block-->
<!--all memory reads across processors till they're done). Waiting on these locks can also be slow when-->
<!--there's a lot of concurrent access happening.-->
それらはロックを保持するために内部でアトミック的な型を使います。それにはかなりコストが掛かります（それらは仕事が終わるまで、プロセッサ中のメモリ読込み全てをブロックする可能性があります）。
たくさんの並行なアクセスが起こる場合には、それらのロックを待つことが遅くなる可能性があります。

[rwlock]: ../std/sync/struct.RwLock.html
[mutex]: ../std/sync/struct.Mutex.html
[sessions]: https://github.com/Munksgaard/rust-sessions

<!--# Composition-->
# 合成

<!--A common gripe when reading Rust code is with types like `Rc<RefCell<Vec<T>>>` (or even more-->
<!--complicated compositions of such types). It's not always clear what the composition does, or why the-->
<!--author chose one like this (and when one should be using such a composition in one's own code)-->
Rustのコードを読むときに一般的な悩みは、 `Rc<RefCell<Vec<T>>>` のような型（又はそのような型のもっと複雑な合成）です。
その合成が何をしているのか、なぜ作者はこんなものを選んだのか（そして、自分のコード内でいつこんな合成を使うべきなのか）ということは、常に明らかなわけではありません。

<!--Usually, it's a case of composing together the guarantees that you need, without paying for stuff-->
<!--that is unnecessary.-->
普通、それは不要なコストを支払うことなく、必要とする保証を互いに組み合わせた場合です。

<!--For example, `Rc<RefCell<T>>` is one such composition. `Rc<T>` itself can't be dereferenced mutably;-->
<!--because `Rc<T>` provides sharing and shared mutability can lead to unsafe behavior, so we put-->
<!--`RefCell<T>` inside to get dynamically verified shared mutability. Now we have shared mutable data,-->
<!--but it's shared in a way that there can only be one mutator (and no readers) or multiple readers.-->
例えば、 `Rc<RefCell<T>>` はそのような合成の1つです。
`Rc<T>` そのものはミュータブルに参照を外すことができません。 `Rc<T>` は共有を提供し、共有されたミュータビリティはアンセーフな挙動に繋がる可能性があります。そのため、動的に証明された共有されたミュータビリティを得るために、 `RefCell<T>` を中に入れます。
これで共有されたミュータブルなデータを持つことになりますが、それは（リーダはなしで）ライタが1つだけ、又はリーダが複数という方法で共有することになります。

<!--Now, we can take this a step further, and have `Rc<RefCell<Vec<T>>>` or `Rc<Vec<RefCell<T>>>`. These-->
<!--are both shareable, mutable vectors, but they're not the same.-->
今度は、これをさらに次の段階に進めると、 `Rc<RefCell<Vec<T>>>` や `Rc<Vec<RefCell<T>>>` を持つことができます。
それらは両方とも共有できるミュータブルなベクタですが、同じではありません。

<!--With the former, the `RefCell<T>` is wrapping the `Vec<T>`, so the `Vec<T>` in its entirety is-->
<!--mutable. At the same time, there can only be one mutable borrow of the whole `Vec` at a given time.-->
<!--This means that your code cannot simultaneously work on different elements of the vector from-->
<!--different `Rc` handles. However, we are able to push and pop from the `Vec<T>` at will. This is-->
<!-- similar to a `&mut Vec<T>` with the borrow checking done at runtime. -->
1つ目について、 `RefCell<T>` は `Vec<T>` をラップしているので、その `Vec<T>` 全体がミュータブルです。
同時に、それらは特定の時間において `Vec` 全体の唯一のミュータブルな借用になり得ます。
これは、コードがそのベクタの別の要素について、別の `Rc` ハンドルから同時には操作できないということを意味します。
しかし、 `Vec<T>` に対するプッシュやポップは好きなように行うことができます。
これは借用チェックが実行時に行われるという点で `&mut Vec<T>` と同様です。

<!--With the latter, the borrowing is of individual elements, but the overall vector is immutable. Thus,-->
<!--we can independently borrow separate elements, but we cannot push or pop from the vector. This is-->
<!-- similar to a `&mut [T]`[^3], but, again, the borrow checking is at runtime. -->
2つ目について、借用は個々の要素に対して行われますが、ベクタ全体がイミュータブルになります。
そのため、異なる要素を別々に借用することができますが、ベクタに対するプッシュやポップを行うことはできません。
これは `&mut [T]`[^3] と同じですが、やはり借用チェックは実行時に行われます。

<!--In concurrent programs, we have a similar situation with `Arc<Mutex<T>>`, which provides shared-->
<!--mutability and ownership.-->
並行プログラムでは、 `Arc<Mutex<T>>` と似た状況に置かれます。それは共有されたミュータビリティと所有権を提供します。

<!--When reading code that uses these, go in step by step and look at the guarantees/costs provided.-->
それらを使ったコードを読むときには、1行1行進み、提供される保証とコストを見ましょう。

<!--When choosing a composed type, we must do the reverse; figure out which guarantees we want, and at-->
<!--which point of the composition we need them. For example, if there is a choice between-->
<!--`Vec<RefCell<T>>` and `RefCell<Vec<T>>`, we should figure out the tradeoffs as done above and pick-->
<!--one.-->
合成された型を選択するときには、その逆に考えなければなりません。必要とする保証が何であるか、必要とする合成がどの点にあるのかを理解しましょう。
例えば、もし `Vec<RefCell<T>>` と `RefCell<Vec<T>>` のどちらかを選ぶのであれば、前の方で行ったようにトレードオフを理解し、選ばなければなりません。

<!--[^3]: `&[T]` and `&mut [T]` are _slices_; they consist of a pointer and a length and can refer to a portion of a vector or array. `&mut [T]` can have its elements mutated, however its length cannot be touched.-->
[^3]: `&[T]` と `&mut [T]` は _スライス_ です。それらはポインタと長さを持ち、ベクタや配列の一部を参照することができます。
`&mut [T]` ではその要素を変更できますが、その長さは変更することができません。
