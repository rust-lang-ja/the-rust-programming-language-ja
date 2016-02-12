% ミュータビリティ
<!-- % Mutability -->

<!-- Mutability, the ability to change something, works a bit differently in Rust -->
<!-- than in other languages. The first aspect of mutability is its non-default -->
<!-- status: -->
Rustにおけるミュータビリティ、何かを変更する能力は、他のプログラミング言語とはすこし異なっています。
ミュータビリティの一つ目の特徴は、デフォルトでは無いという点です:

```rust,ignore
let x = 5;
x = 6; // error!
```

<!-- We can introduce mutability with the `mut` keyword: -->
`mut` キーワードによりミュータビリティを導入できます:

```rust
let mut x = 5;

x = 6; // no problem!
```

<!-- This is a mutable [variable binding][vb]. When a binding is mutable, it means -->
<!-- you’re allowed to change what the binding points to. So in the above example, -->
<!-- it’s not so much that the value at `x` is changing, but that the binding -->
<!-- changed from one `i32` to another. -->
これはミュータブルな [変数束縛][vb] です。束縛がミュータブルのとき、束縛が何を指すかを変更して良いことを意味します。
つまり上記の例では、 `x` の値を変更したのではなく、束縛がある `i32` から別のものへ変わったのです。

[vb]: variable-bindings.html

<!-- If you want to change what the binding points to, you’ll need a [mutable reference][mr]: -->
束縛先を変更したいのであれば、 [ミュータブル参照][mr] を使うことができます:

```rust
let mut x = 5;
let y = &mut x;
```

[mr]: references-and-borrowing.html

<!-- `y` is an immutable binding to a mutable reference, which means that you can’t -->
<!-- bind `y` to something else (`y = &mut z`), but you can mutate the thing that’s -->
<!-- bound to `y` (`*y = 5`). A subtle distinction. -->
`y` はミュータブル参照へのイミュータブル束縛であり、 `y` の束縛先を他のものに変える(`y = &mut z`)ことはできません。
しかし、`y` に束縛されているものを変化させること(`*y = 5`)は可能です。

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
`mut` は [パターン][pattern] の一部であることに十分注意してください。
つまり、次のようなことを行えます:

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
「外側のミュータビリティ(exterior mutability)」を表します。例として、 [`Arc<T>`][arc] を考えます:

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
ここでは `mut` を一切使っていません。つまり `x` はイミュータブル束縛であり、
`&mut 5` のような引数もとりません。一体どうなっているの？

<!-- To understand this, we have to go back to the core of Rust’s guiding -->
<!-- philosophy, memory safety, and the mechanism by which Rust guarantees it, the -->
<!-- [ownership][ownership] system, and more specifically, [borrowing][borrowing]: -->
これを理解するには、Rust言語の設計哲学の中心をなすメモリ安全性、Rustがそれを保証するメカニズムである [所有権][ownership] システム、
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
つまり、「イミュータビリティ」の真の定義はこうです: これは2つから指されても安全か?
`Arc<T>` の例では、イエス: 変更は完全それ自身の構造の内側で行われます。ユーザ向いではありません。
このような理由により、 `clone()` を用いて `T&` を配るのです。仮に `&mut T` を配ってしまうと、
問題になるでしょう。(訳注: `Arc<T>`を用いて複数スレッドへイミュータブルな値を配布する。)

<!-- Other types, like the ones in the [`std::cell`][stdcell] module, have the -->
<!-- opposite: interior mutability. For example: -->
[`std::cell`][stdcell] モジュール中の他の型は、反対の性質: 内側のミュータビリティを持ちます。
例えば:

```rust
use std::cell::RefCell;

let x = RefCell::new(42);

let y = x.borrow_mut();
```

[stdcell]: ../std/cell/index.html

RefCell hands out `&mut` references to what’s inside of it with the
`borrow_mut()` method. Isn’t that dangerous? What if we do:

```rust,ignore
use std::cell::RefCell;

let x = RefCell::new(42);

let y = x.borrow_mut();
let z = x.borrow_mut();
# (y, z);
```

This will in fact panic, at runtime. This is what `RefCell` does: it enforces
Rust’s borrowing rules at runtime, and `panic!`s if they’re violated. This
allows us to get around another aspect of Rust’s mutability rules. Let’s talk
about it first.

## Field-level mutability

Mutability is a property of either a borrow (`&mut`) or a binding (`let mut`).
This means that, for example, you cannot have a [`struct`][struct] with
some fields mutable and some immutable:

```rust,ignore
struct Point {
    x: i32,
    mut y: i32, // nope
}
```

The mutability of a struct is in its binding:

```rust,ignore
struct Point {
    x: i32,
    y: i32,
}

let mut a = Point { x: 5, y: 6 };

a.x = 10;

let b = Point { x: 5, y: 6};

b.x = 10; // error: cannot assign to immutable field `b.x`
```

[struct]: structs.html

However, by using [`Cell<T>`][cell], you can emulate field-level mutability:

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

This will print `y: Cell { value: 7 }`. We’ve successfully updated `y`.
