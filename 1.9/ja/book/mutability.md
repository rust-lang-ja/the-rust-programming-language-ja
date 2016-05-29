% ミュータビリティ
<!-- % Mutability -->

<!-- Mutability, the ability to change something, works a bit differently in Rust -->
<!-- than in other languages. The first aspect of mutability is its non-default -->
<!-- status: -->
Rustにおけるミュータビリティ、何かを変更する能力は、他のプログラミング言語とはすこし異なっています。
ミュータビリティの一つ目の特徴は、それがデフォルトでは無いという点です:

```rust,ignore
let x = 5;
# // x = 6; // error!
x = 6; // エラー!
```

<!-- We can introduce mutability with the `mut` keyword: -->
`mut` キーワードによりミュータビリティを導入できます:

```rust
let mut x = 5;

# // x = 6; // no problem!
x = 6; // 問題なし!
```

<!-- This is a mutable [variable binding][vb]. When a binding is mutable, it means -->
<!-- you’re allowed to change what the binding points to. So in the above example, -->
<!-- it’s not so much that the value at `x` is changing, but that the binding -->
<!-- changed from one `i32` to another. -->
これはミュータブルな [変数束縛][vb] です。束縛がミュータブルであるとき、その束縛が何を指すかを変更して良いことを意味します。
つまり上記の例では、`x` の値を変更したのではなく、ある `i32` から別の値へと束縛が変わったのです。

[vb]: variable-bindings.html

<!-- If you want to change what the binding points to, you’ll need a [mutable reference][mr]: -->
束縛が指す先を変更する場合は、[ミュータブル参照][mr] を使う必要があるでしょう:

```rust
let mut x = 5;
let y = &mut x;
```

[mr]: references-and-borrowing.html

<!-- `y` is an immutable binding to a mutable reference, which means that you can’t -->
<!-- bind `y` to something else (`y = &mut z`), but you can mutate the thing that’s -->
<!-- bound to `y` (`*y = 5`). A subtle distinction. -->
`y` はミュータブル参照へのイミュータブルな束縛であり、 `y` を他の束縛に変える(`y = &mut z`)ことはできません。
しかし、`y` に束縛されているものを変化させること(`*y = 5`)は可能です。微妙な区別です。

<!-- Of course, if you need both: -->
もちろん、両方が必要ならば:

```rust
let mut x = 5;
let mut y = &mut x;
```

<!-- Now `y` can be bound to another value, and the value it’s referencing can be -->
<!-- changed. -->
今度は `y` が他の値を束縛することもできますし、参照している値を変更することもできます。

<!-- It’s important to note that `mut` is part of a [pattern][pattern], so you -->
<!-- can do things like this: -->
`mut` は [パターン][pattern] の一部を成すことに十分注意してください。
つまり、次のようなことが可能です:

```rust
let (mut x, y) = (5, 6);

fn foo(mut x: i32) {
# }
```

[pattern]: patterns.html

<!-- # Interior vs. Exterior Mutability -->
# 内側 vs. 外側のミュータビリティ

<!-- However, when we say something is ‘immutable’ in Rust, that doesn’t mean that -->
<!-- it’s not able to be changed: we mean something has ‘exterior mutability’. Consider, -->
<!-- for example, [`Arc<T>`][arc]: -->
一方で、Rustで「イミュータブル(immutable)」について言及するとき、変更不可能であることを意味しない:
「外側のミュータビリティ(exterior mutability)」を表します。例として、[`Arc<T>`][arc] を考えます:

```rust
use std::sync::Arc;

let x = Arc::new(5);
let y = x.clone();
```

[arc]: ../std/sync/struct.Arc.html

<!-- When we call `clone()`, the `Arc<T>` needs to update the reference count. Yet -->
<!-- we’ve not used any `mut`s here, `x` is an immutable binding, and we didn’t take -->
<!-- `&mut 5` or anything. So what gives? -->
`clone()` を呼び出すとき、`Arc<T>` は参照カウントを更新する必要があります。しかし、
ここでは `mut` を一切使っていません。つまり `x` はイミュータブルな束縛であり、
`&mut 5` のような引数もとりません。一体どうなっているの?

<!-- To understand this, we have to go back to the core of Rust’s guiding -->
<!-- philosophy, memory safety, and the mechanism by which Rust guarantees it, the -->
<!-- [ownership][ownership] system, and more specifically, [borrowing][borrowing]: -->
これを理解するには、Rust言語の設計哲学の中心をなすメモリ安全性と、Rustがそれを保証するメカニズムである [所有権][ownership] システム、
特に [借用][borrowing] に立ち返る必要があります。

<!-- > You may have one or the other of these two kinds of borrows, but not both at -->
<!-- > the same time: -->
<!-- > -->
<!-- > * one or more references (`&T`) to a resource, -->
<!-- > * exactly one mutable reference (`&mut T`). -->
> 次の2種類の借用のどちらか1つを持つことはありますが、両方を同時に持つことはありません。
>
> * リソースに対する1つ以上の参照（`&T`）
> * ただ1つのミュータブルな参照（`&mut T`）

[ownership]: ownership.html
[borrowing]: references-and-borrowing.html#borrowing

<!-- So, that’s the real definition of ‘immutability’: is this safe to have two -->
<!-- pointers to? In `Arc<T>`’s case, yes: the mutation is entirely contained inside -->
<!-- the structure itself. It’s not user facing. For this reason, it hands out `&T` -->
<!-- with `clone()`. If it handed out `&mut T`s, though, that would be a problem. -->
つまり、「イミュータビリティ」の真の定義はこうです: これは2箇所から指されても安全ですか?
`Arc<T>` の例では、イエス: 変更は完全にそれ自身の構造の内側で行われます。ユーザからは見えません。
このような理由により、 `clone()` を用いて `&T` を配るのです。仮に `&mut T` を配ってしまうと、
問題になるでしょう。
（訳注: `Arc<T>`を用いて複数スレッドにイミュータブル参照を配布し、スレッド間でオブジェクトを共有できます。）

<!-- Other types, like the ones in the [`std::cell`][stdcell] module, have the -->
<!-- opposite: interior mutability. For example: -->
[`std::cell`][stdcell] モジュールにあるような別の型では、反対の性質: 内側のミュータビリティ(interior mutability)を持ちます。
例えば:

```rust
use std::cell::RefCell;

let x = RefCell::new(42);

let y = x.borrow_mut();
```

[stdcell]: ../std/cell/index.html

<!-- RefCell hands out `&mut` references to what’s inside of it with the -->
<!-- `borrow_mut()` method. Isn’t that dangerous? What if we do: -->
RefCellでは `borrow_mut()` メソッドによって、その内側にある値への `&mut` 参照を配ります。
それって危ないのでは? もし次のようにすると:

```rust,ignore
use std::cell::RefCell;

let x = RefCell::new(42);

let y = x.borrow_mut();
let z = x.borrow_mut();
# (y, z);
```

<!-- This will in fact panic, at runtime. This is what `RefCell` does: it enforces -->
<!-- Rust’s borrowing rules at runtime, and `panic!`s if they’re violated. This -->
<!-- allows us to get around another aspect of Rust’s mutability rules. Let’s talk -->
<!-- about it first. -->
実際に、このコードは実行時にパニックするでしょう。これが `RefCell` が行うことです:
Rustの借用ルールを実行時に強制し、違反したときには `panic!` を呼び出します。
これによりRustのミュータビリティ・ルールのもう一つの特徴を回避できるようになります。
最初に見ていきましょう。

<!-- ## Field-level mutability -->
## フィールド・レベルのミュータビリティ

<!-- Mutability is a property of either a borrow (`&mut`) or a binding (`let mut`). -->
<!-- This means that, for example, you cannot have a [`struct`][struct] with -->
<!-- some fields mutable and some immutable: -->
ミュータビリティとは、借用(`&mut`)や束縛(`let mut`)に関する属性です。これが意味するのは、
例えば、一部がミュータブルで一部がイミュータブルなフィールドを持つ [`struct`][struct] は作れないということです。


```rust,ignore
struct Point {
    x: i32,
# // mut y: i32, // nope
    mut y: i32, // ダメ
}
```

<!-- The mutability of a struct is in its binding: -->
構造体のミュータビリティは、それへの束縛の一部です。

```rust,ignore
struct Point {
    x: i32,
    y: i32,
}

let mut a = Point { x: 5, y: 6 };

a.x = 10;

let b = Point { x: 5, y: 6};

# // b.x = 10; // error: cannot assign to immutable field `b.x`
b.x = 10; // エラー: イミュータブルなフィールド `b.x` へ代入できない
```

[struct]: structs.html

<!-- However, by using [`Cell<T>`][cell], you can emulate field-level mutability: -->
しかし、[`Cell<T>`][cell] を使えば、フィールド・レベルのミュータビリティをエミュレートできます。

```rust
use std::cell::Cell;

struct Point {
    x: i32,
    y: Cell<i32>,
}

let point = Point { x: 5, y: Cell::new(6) };

point.y.set(7);

println!("y: {:?}", point.y);
```

[cell]: ../std/cell/struct.Cell.html

<!-- This will print `y: Cell { value: 7 }`. We’ve successfully updated `y`. -->
このコードは `y: Cell { value: 7 }` と表示するでしょう。ちゃんと `y` を更新できました。
