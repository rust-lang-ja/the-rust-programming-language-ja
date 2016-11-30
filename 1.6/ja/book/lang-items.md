% 言語アイテム
<!-- % Lang items -->

<!-- &gt; **Note**: lang items are often provided by crates in the Rust distribution, -->
<!-- &gt; and lang items themselves have an unstable interface. It is recommended to use -->
<!-- &gt; officially distributed crates instead of defining your own lang items. -->
> **注意** : 言語アイテムは大抵Rustの配布物内のクレートから提供されていますし言語アイテムのインターフェース自体安定していません。
> 自身で言語アイテムを定義するのではなく公式の配布物のクレートを使うことが推奨されています。

<!-- The `rustc` compiler has certain pluggable operations, that is, -->
<!-- functionality that isn't hard-coded into the language, but is -->
<!-- implemented in libraries, with a special marker to tell the compiler -->
<!-- it exists. The marker is the attribute `#[lang = "..."]` and there are -->
<!-- various different values of `...`, i.e. various different 'lang -->
<!-- items'. -->
`rustc` コンパイラはあるプラガブルな操作、つまり機能が言語にハードコードされているのではなくライブラリで実装されているものを持っており、特別なマーカによってそれが存在することをコンパイラに伝えます。
マーカとは `#[lang = "..."]` アトリビュートで、 `...` には様々な値が、つまり様々な「言語アイテム」あります。

<!-- For example, `Box` pointers require two lang items, one for allocation -->
<!-- and one for deallocation. A freestanding program that uses the `Box` -->
<!-- sugar for dynamic allocations via `malloc` and `free`: -->
例えば、 `Box` ポインタは2つの言語アイテムを必要とします。1つはアロケーションのため、もう1つはデアロケーションのため。
フリースタンディング環境で動くプログラムは `Box` を `malloc` と `free` による動的アロケーションの糖衣として使います。

```rust
#![feature(lang_items, box_syntax, start, libc)]
#![no_std]

extern crate libc;

extern {
    fn abort() -> !;
}

#[lang = "owned_box"]
pub struct Box<T>(*mut T);

#[lang = "exchange_malloc"]
unsafe fn allocate(size: usize, _align: usize) -> *mut u8 {
    let p = libc::malloc(size as libc::size_t) as *mut u8;

    // malloc failed
    if p as usize == 0 {
        abort();
    }

    p
}
#[lang = "exchange_free"]
unsafe fn deallocate(ptr: *mut u8, _size: usize, _align: usize) {
    libc::free(ptr as *mut libc::c_void)
}

#[start]
fn main(argc: isize, argv: *const *const u8) -> isize {
    let x = box 1;

    0
}

#[lang = "eh_personality"] extern fn eh_personality() {}
#[lang = "panic_fmt"] fn panic_fmt() -> ! { loop {} }
# #[lang = "eh_unwind_resume"] extern fn rust_eh_unwind_resume() {}
# #[no_mangle] pub extern fn rust_eh_register_frames () {}
# #[no_mangle] pub extern fn rust_eh_unregister_frames () {}
```

<!-- Note the use of `abort`: the `exchange_malloc` lang item is assumed to -->
<!-- return a valid pointer, and so needs to do the check internally. -->
`abort` を使ってることに注意して下さい: `exchange_malloc` 言語アイテムは有効なポインタを返すものとされており、内部でその検査をする必要があるのです。

<!-- Other features provided by lang items include: -->
言語アイテムによって提供される機能には以下のようなものがあります。:

<!-- - overloadable operators via traits: the traits corresponding to the -->
<!--   `==`, `<`, dereferencing (`*`) and `+` (etc.) operators are all -->
<!--   marked with lang items; those specific four are `eq`, `ord`, -->
<!--   `deref`, and `add` respectively. -->
<!-- - stack unwinding and general failure; the `eh_personality`, `fail` -->
<!--   and `fail_bounds_checks` lang items. -->
<!-- - the traits in `std::marker` used to indicate types of -->
<!--   various kinds; lang items `send`, `sync` and `copy`. -->
<!-- - the marker types and variance indicators found in -->
<!--   `std::marker`; lang items `covariant_type`, -->
<!--   `contravariant_lifetime`, etc. -->

- トレイトによるオーバーロード可能な演算子: `==` 、 `<` 、 参照外し（ `*` ） そして `+` （など）の演算子は全て言語アイテムでマークされています。
  これら4つはそれぞれ `eq` 、 `ord` 、 `deref` 、 `add` です
- スタックの巻き戻しと一般の失敗は `eh_personality` 、 `fail` そして `fail_bounds_check` 言語アイテムです。
- `std::marker` 内のトレイトで様々な型を示すのに使われています。 `send` 、 `sync` そして `copy` 言語アイテム。
- マーカ型と `std::marker` にある変性指示子。 `covariant_type` 、 `contravariant_lifetime` 言語アイテムなどなど。

<!-- Lang items are loaded lazily by the compiler; e.g. if one never uses -->
<!-- `Box` then there is no need to define functions for `exchange_malloc` -->
<!-- and `exchange_free`. `rustc` will emit an error when an item is needed -->
<!-- but not found in the current crate or any that it depends on. -->
言語アイテムはコンパイラによって必要に応じてロードされます、例えば、 `Box` を一度も使わないなら `exchange_malloc` と `exchange_free` の関数を定義する必要はありません。
`rustc` はアイテムが必要なのに現在のクレートあるいはその依存するクレート内で見付からないときにエラーを出します。
