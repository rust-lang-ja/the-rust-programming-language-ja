% トレイトオブジェクト
<!-- % Trait Objects -->

<!-- When code involves polymorphism, there needs to be a mechanism to determine -->
<!-- which specific version is actually run. This is called ‘dispatch’. There are -->
<!-- two major forms of dispatch: static dispatch and dynamic dispatch. While Rust -->
<!-- favors static dispatch, it also supports dynamic dispatch through a mechanism -->
<!-- called ‘trait objects’. -->
コードがポリモーフィズムを伴う場合、実際に実行するバージョンを決定するメカニズムが必要です。
これは「ディスパッチ」(dispatch)と呼ばれます。
ディスパッチには主に静的ディスパッチと動的ディスパッチという2つの形態があります。
Rustは静的ディスパッチを支持している一方で、「トレイトオブジェクト」(trait objects)と呼ばれるメカニズムにより動的ディスパッチもサポートしています。

<!-- ## Background -->
## 背景

<!-- For the rest of this chapter, we’ll need a trait and some implementations. -->
<!-- Let’s make a simple one, `Foo`. It has one method that is expected to return a -->
<!-- `String`. -->
本章の後のために、トレイトとその実装が幾つか必要です。
単純に `Foo` としましょう。
これは `String` 型の値を返す関数を1つ持っています。

```rust
trait Foo {
    fn method(&self) -> String;
}
```

<!-- We’ll also implement this trait for `u8` and `String`: -->
また、このトレイトを `u8` と `String` に実装します。

```rust
# trait Foo { fn method(&self) -> String; }
impl Foo for u8 {
    fn method(&self) -> String { format!("u8: {}", *self) }
}

impl Foo for String {
    fn method(&self) -> String { format!("string: {}", *self) }
}
```

<!-- ## Static dispatch -->
## 静的ディスパッチ

<!-- We can use this trait to perform static dispatch with trait bounds: -->
トレイト境界を使ってこのトレイトで静的ディスパッチが出来ます。

```rust
# trait Foo { fn method(&self) -> String; }
# impl Foo for u8 { fn method(&self) -> String { format!("u8: {}", *self) } }
# impl Foo for String { fn method(&self) -> String { format!("string: {}", *self) } }
fn do_something<T: Foo>(x: T) {
    x.method();
}

fn main() {
    let x = 5u8;
    let y = "Hello".to_string();

    do_something(x);
    do_something(y);
}
```

<!-- Rust uses ‘monomorphization’ to perform static dispatch here. This means that -->
<!-- Rust will create a special version of `do_something()` for both `u8` and -->
<!-- `String`, and then replace the call sites with calls to these specialized -->
<!-- functions. In other words, Rust generates something like this: -->
これはRustが `u8` と `String` それぞれ専用の `do_something()` を作成し、それら特殊化された関数を宛てがうように呼び出しの部分を書き換えるという意味です。
（訳注: 作成された専用の `do_something()` は「特殊化された関数」(specialized function)と呼ばれます）

```rust
# trait Foo { fn method(&self) -> String; }
# impl Foo for u8 { fn method(&self) -> String { format!("u8: {}", *self) } }
# impl Foo for String { fn method(&self) -> String { format!("string: {}", *self) } }
fn do_something_u8(x: u8) {
    x.method();
}

fn do_something_string(x: String) {
    x.method();
}

fn main() {
    let x = 5u8;
    let y = "Hello".to_string();

    do_something_u8(x);
    do_something_string(y);
}
```

<!-- This has a great upside: static dispatch allows function calls to be -->
<!-- inlined because the callee is known at compile time, and inlining is -->
<!-- the key to good optimization. Static dispatch is fast, but it comes at -->
<!-- a tradeoff: ‘code bloat’, due to many copies of the same function -->
<!-- existing in the binary, one for each type. -->
これは素晴らしい利点です。
呼び出される関数はコンパイル時に分かっているため、静的ディスパッチは関数呼び出しをインライン化できます。
インライン化は優れた最適化の鍵です。
静的ディスパッチは高速ですが、バイナリ的には既にあるはずの同じ関数をそれぞれの型毎に幾つもコピーするため、トレードオフとして「コードの膨張」(code bloat)が発生してしまいます。

<!-- Furthermore, compilers aren’t perfect and may “optimize” code to become slower. -->
<!-- For example, functions inlined too eagerly will bloat the instruction cache -->
<!-- (cache rules everything around us). This is part of the reason that `#[inline]` -->
<!-- and `#[inline(always)]` should be used carefully, and one reason why using a -->
<!-- dynamic dispatch is sometimes more efficient. -->
その上、コンパイラは完璧ではなく、「最適化」したコードが遅くなってしまうこともあります。
例えば、あまりにも熱心にインライン化された関数は命令キャッシュを膨張させてしまいます（地獄の沙汰もキャッシュ次第）。
それが `#[inline]` や `#[inline(always)]` を慎重に使うべきである理由の1つであり、時として動的ディスパッチが静的ディスパッチよりも効率的である1つの理由なのです。

<!-- However, the common case is that it is more efficient to use static dispatch, -->
<!-- and one can always have a thin statically-dispatched wrapper function that does -->
<!-- a dynamic dispatch, but not vice versa, meaning static calls are more flexible. -->
<!-- The standard library tries to be statically dispatched where possible for this -->
<!-- reason. -->
しかしながら、一般的なケースでは静的ディスパッチを使用する方が効率的であり、また、動的ディスパッチを行う薄い静的ディスパッチラッパー関数を実装することは常に可能ですが、その逆はできません。
これは静的な呼び出しの方が柔軟性に富むことを示唆しています。
標準ライブラリはこの理由から可能な限り静的ディスパッチで実装するよう心がけています。

> 訳注: 「動的ディスパッチを行う薄い静的ディスパッチラッパー関数を実装することは常に可能だがその逆はできない」について

> 静的ディスパッチはコンパイル時に定まるのに対し、動的ディスパッチは実行時に結果が分かります。従って、動的ディスパッチが伴う処理を静的ディスパッチ関数でラッピングし、半静的なディスパッチとすることは常に可能（原文で「thin」と形容しているのはこのため）ですが、動的ディスパッチで遷移した値を元に静的ディスパッチを行うことはできないと言うわけです。

## 動的ディスパッチ
<!-- ## Dynamic dispatch -->

<!-- Rust provides dynamic dispatch through a feature called ‘trait objects’. Trait -->
<!-- objects, like `&Foo` or `Box<Foo>`, are normal values that store a value of -->
<!-- *any* type that implements the given trait, where the precise type can only be -->
<!-- known at runtime. -->
Rustは「トレイトオブジェクト」と呼ばれる機能によって動的ディスパッチを提供しています。
トレイトオブジェクトは `&Foo` か `Box<Foo>` の様に記述され、指定されたトレイトを実装する *あらゆる* 型の値を保持する通常の値です。
ただし、その正確な型は実行時になって初めて判明します。

<!-- A trait object can be obtained from a pointer to a concrete type that -->
<!-- implements the trait by *casting* it (e.g. `&x as &Foo`) or *coercing* it -->
<!-- (e.g. using `&x` as an argument to a function that takes `&Foo`). -->
トレイトオブジェクトはトレイトを実装した具体的な型を指すポインタから *キャスト* する(e.g. `&x as &Foo` )か、 *型強制* する（e.g. `&Foo` を取る関数の引数として `&x` を用いる）ことで得られます。

<!-- These trait object coercions and casts also work for pointers like `&mut T` to -->
<!-- `&mut Foo` and `Box<T>` to `Box<Foo>`, but that’s all at the moment. Coercions -->
<!-- and casts are identical. -->
これらトレイトオブジェクトの型強制とキャストは `&mut T` を `&mut Foo` へ、 `Box<T>` を `Box<Foo>` へ、というようにどちらもポインタに対する操作ですが、今の所はこれだけです。型強制とキャストは同一です。

<!-- This operation can be seen as ‘erasing’ the compiler’s knowledge about the -->
<!-- specific type of the pointer, and hence trait objects are sometimes referred to -->
<!-- as ‘type erasure’. -->
この操作がまるでポインタのある型に関するコンパイラの記憶を「消去している」(erasing)ように見えることから、トレイトオブジェクトは時に「型消去」(type erasure)とも呼ばれます。

<!-- Coming back to the example above, we can use the same trait to perform dynamic -->
<!-- dispatch with trait objects by casting: -->
上記の例に立ち帰ると、キャストによるトレイトオブジェクトを用いた動的ディスパッチの実現にも同じトレイトが使用できます。

```rust
# trait Foo { fn method(&self) -> String; }
# impl Foo for u8 { fn method(&self) -> String { format!("u8: {}", *self) } }
# impl Foo for String { fn method(&self) -> String { format!("string: {}", *self) } }

fn do_something(x: &Foo) {
    x.method();
}

fn main() {
    let x = 5u8;
    do_something(&x as &Foo);
}
```

<!-- or by coercing: -->
または型強制によって、

```rust
# trait Foo { fn method(&self) -> String; }
# impl Foo for u8 { fn method(&self) -> String { format!("u8: {}", *self) } }
# impl Foo for String { fn method(&self) -> String { format!("string: {}", *self) } }

fn do_something(x: &Foo) {
    x.method();
}

fn main() {
    let x = "Hello".to_string();
    do_something(&x);
}
```

<!-- A function that takes a trait object is not specialized to each of the types -->
<!-- that implements `Foo`: only one copy is generated, often (but not always) -->
<!-- resulting in less code bloat. However, this comes at the cost of requiring -->
<!-- slower virtual function calls, and effectively inhibiting any chance of -->
<!-- inlining and related optimizations from occurring. -->
トレイトオブジェクトを受け取った関数が `Foo` を実装した型ごとに特殊化されることはありません。
関数は1つだけ生成され、多くの場合（とはいえ常にではありませんが）コードの膨張は少なく済みます。
しかしながら、これは低速な仮想関数の呼び出しが必要となるため、実質的にインライン化とそれに関連する最適化の機会を阻害してしまいます。

<!-- ### Why pointers? -->
### 何故ポインタなのか？

<!-- Rust does not put things behind a pointer by default, unlike many managed -->
<!-- languages, so types can have different sizes. Knowing the size of the value at -->
<!-- compile time is important for things like passing it as an argument to a -->
<!-- function, moving it about on the stack and allocating (and deallocating) space -->
<!-- on the heap to store it. -->
Rustはガーベジコレクタによって管理される多くの言語とは異なり、デフォルトではポインタの参照先に値を配置するようなことはしませんから、型によってサイズが違います。
関数へ引数として渡されるような値を、スタック領域へムーブしたり保存のためヒープ領域上にメモリをアロケート（デアロケートも同様）するには、コンパイル時に値のサイズを知っていることが重要となります。

<!-- For `Foo`, we would need to have a value that could be at least either a -->
<!-- `String` (24 bytes) or a `u8` (1 byte), as well as any other type for which -->
<!-- dependent crates may implement `Foo` (any number of bytes at all). There’s no -->
<!-- way to guarantee that this last point can work if the values are stored without -->
<!-- a pointer, because those other types can be arbitrarily large. -->
`Foo` のためには、 `String` (24 bytes)か `u8` (1 byte)もしくは `Foo` （とにかくどんなサイズでも）を実装する依存クレート内の型のうちから少なくとも1つの値を格納する必要があります。
ポインタ無しで値を保存した場合、その直後の動作が正しいかどうかを保証する方法がありません。
型によって値のサイズが異なるからです。

<!-- Putting the value behind a pointer means the size of the value is not relevant -->
<!-- when we are tossing a trait object around, only the size of the pointer itself. -->
ポインタの参照先に値を配置することはトレイトオブジェクトを渡す場合に値自体のサイズが無関係になり、ポインタのサイズのみになることを意味しています。

<!-- ### Representation -->
### トレイトオブジェクトの内部表現

<!-- The methods of the trait can be called on a trait object via a special record -->
<!-- of function pointers traditionally called a ‘vtable’ (created and managed by -->
<!-- the compiler). -->
トレイトのメソッドはトレイトオブジェクト内にある伝統的に「vtable」（これはコンパイラによって作成、管理されます）と呼ばれる特別な関数ポインタのレコードを介して呼び出されます。

<!-- Trait objects are both simple and complicated: their core representation and -->
<!-- layout is quite straight-forward, but there are some curly error messages and -->
<!-- surprising behaviors to discover. -->
トレイトオブジェクトは単純ですが難解でもあります。
核となる表現と設計は非常に率直ですが、複雑なエラーメッセージを吐いたり、予期せぬ振る舞いが見つかったりします。

<!-- Let’s start simple, with the runtime representation of a trait object. The -->
<!-- `std::raw` module contains structs with layouts that are the same as the -->
<!-- complicated built-in types, [including trait objects][stdraw]: -->
単純な例として、トレイトオブジェクトの実行時の表現から見て行きましょう。
`std::raw` モジュールは複雑なビルドインの型と同じレイアウトの構造体を格納しており、 [トレイトオブジェクトも含まれています](https://doc.rust-lang.org/std/raw/) 。

```rust
# mod foo {
pub struct TraitObject {
    pub data: *mut (),
    pub vtable: *mut (),
}
# }
```

[stdraw]: ../std/raw/struct.TraitObject.html

<!-- That is, a trait object like `&Foo` consists of a ‘data’ pointer and a ‘vtable’ pointer. -->
つまり、 `&Foo` のようなトレイトオブジェクトは「data」ポインタと「vtable」ポインタから成るわけです。

<!-- The data pointer addresses the data (of some unknown type `T`) that the trait -->
<!-- object is storing, and the vtable pointer points to the vtable (‘virtual method -->
<!-- table’) corresponding to the implementation of `Foo` for `T`. -->
dataポインタはトレイトオブジェクトが保存している（何らかの不明な型 `T` の）データを指しており、vtableポインタは `T` への `Foo` の実装に対応するvtable（「virtual method table」）を指しています。

<!-- A vtable is essentially a struct of function pointers, pointing to the concrete -->
<!-- piece of machine code for each method in the implementation. A method call like -->
<!-- `trait_object.method()` will retrieve the correct pointer out of the vtable and -->
<!-- then do a dynamic call of it. For example: -->
vtableは本質的には関数ポインタの構造体で、実装内における各メソッドの具体的な機械語の命令列を指しています。
`trait_object.method()` のようなメソッド呼び出しを行うとvtableの中から適切なポインタを取り出し動的に呼び出しを行います。例えば、

```rust,ignore
struct FooVtable {
    destructor: fn(*mut ()),
    size: usize,
    align: usize,
    method: fn(*const ()) -> String,
}

// u8:

fn call_method_on_u8(x: *const ()) -> String {
# //     // the compiler guarantees that this function is only called
# //     // with `x` pointing to a u8
    // コンパイラは `x` がu8を指しているときにのみこの関数が呼ばれることを保障します
    let byte: &u8 = unsafe { &*(x as *const u8) };

    byte.method()
}

static Foo_for_u8_vtable: FooVtable = FooVtable {
# //     destructor: /* compiler magic */,
    destructor: /* コンパイラマジック */,
    size: 1,
    align: 1,

# //     // cast to a function pointer
    // 関数ポインタへキャスト
    method: call_method_on_u8 as fn(*const ()) -> String,
};


// String:

fn call_method_on_String(x: *const ()) -> String {
# //     // the compiler guarantees that this function is only called
# //     // with `x` pointing to a String
    // コンパイラは `x` がStringを指しているときにのみこの関数が呼ばれることを保障します
    let string: &String = unsafe { &*(x as *const String) };

    string.method()
}

static Foo_for_String_vtable: FooVtable = FooVtable {
# //     destructor: /* compiler magic */,
    destructor: /* コンパイラマジック */,
# //     // values for a 64-bit computer, halve them for 32-bit ones
    // この値は64bitコンピュータ向けのものです、32bitコンピュータではこの半分にします
    size: 24,
    align: 8,

    method: call_method_on_String as fn(*const ()) -> String,
};
```

<!-- The `destructor` field in each vtable points to a function that will clean up -->
<!-- any resources of the vtable’s type: for `u8` it is trivial, but for `String` it -->
<!-- will free the memory. This is necessary for owning trait objects like -->
<!-- `Box<Foo>`, which need to clean-up both the `Box` allocation as well as the -->
<!-- internal type when they go out of scope. The `size` and `align` fields store -->
<!-- the size of the erased type, and its alignment requirements; these are -->
<!-- essentially unused at the moment since the information is embedded in the -->
<!-- destructor, but will be used in the future, as trait objects are progressively -->
<!-- made more flexible. -->
各vtableの `destructor` フィールドはvtableが対応する型のリソースを片付ける関数を指しています。
`u8` のvtableは単純な型なので何もしませんが、 `String` のvtableはメモリを解放します。
このフィールドは `Box<Foo>` のような自作トレイトオブジェクトのために必要であり、 `Box` によるアロケートは勿論のことスコープ外に出た際に内部の型のリソースを片付けるのにも必要です。
`size` 及び `align` フィールドは消去された型のサイズとアライメント要件を保存しています。
これらの情報はデストラクタにも組み込まれているため現時点では基本的に使われていませんが、将来、トレイトオブジェクトがより柔軟になることで使われるようになるでしょう。

<!-- Suppose we’ve got some values that implement `Foo`. The explicit form of -->
<!-- construction and use of `Foo` trait objects might look a bit like (ignoring the -->
<!-- type mismatches: they’re all just pointers anyway): -->
例えば `Foo` を実装する値を幾つか得たとします。
`Foo` トレイトオブジェクトを作る、あるいは使う時のコードを明示的に書いたものは少しだけ似ているでしょう。
（型の違いを無視すればですが、どのみちただのポインタになります）

```rust,ignore
let a: String = "foo".to_string();
let x: u8 = 1;

// let b: &Foo = &a;
let b = TraitObject {
# //     // store the data
    // データを保存
    data: &a,
# //     // store the methods
    // メソッドを保存
    vtable: &Foo_for_String_vtable
};

// let y: &Foo = x;
let y = TraitObject {
# //     // store the data
    // データを保存
    data: &x,
# //     // store the methods
    // メソッドを保存
    vtable: &Foo_for_u8_vtable
};

// b.method();
(b.vtable.method)(b.data);

// y.method();
(y.vtable.method)(y.data);
```

<!-- ## Object Safety -->
## オブジェクトの安全性

<!-- Not every trait can be used to make a trait object. For example, vectors implement -->
<!-- `Clone`, but if we try to make a trait object: -->
全てのトレイトがトレイトオブジェクトとして使えるわけではありません。
例えば、ベクタは `Clone` を実装していますが、トレイトオブジェクトを作ろうとすると、

```ignore
let v = vec![1, 2, 3];
let o = &v as &Clone;
```

<!-- We get an error: -->
エラーが発生します。

```text
error: cannot convert to a trait object because trait `core::clone::Clone` is not object-safe [E0038]
let o = &v as &Clone;
        ^~
note: the trait cannot require that `Self : Sized`
let o = &v as &Clone;
        ^~
```

<!-- The error says that `Clone` is not ‘object-safe’. Only traits that are -->
<!-- object-safe can be made into trait objects. A trait is object-safe if both of -->
<!-- these are true: -->
エラーは `Clone` が「オブジェクト安全」(object-safe)でないと言っています。
トレイトオブジェクトにできるのはオブジェクト安全なトレイトのみです。
以下の両方が真であるならばトレイトはオブジェクト安全であるといえます。

<!-- * the trait does not require that `Self: Sized` -->
<!-- * all of its methods are object-safe -->
* トレイトが `Self: Sized` を要求しないこと
* トレイトのメソッド全てがオブジェクト安全であること

<!-- So what makes a method object-safe? Each method must require that `Self: Sized` -->
<!-- or all of the following: -->
では何がメソッドをオブジェクト安全にするのでしょう？
各メソッドは `Self: Sized` を要求するか、以下の全てを満足しなければなりません。

<!-- * must not have any type parameters -->
<!-- * must not use `Self` -->
* どのような型パラメータも持ってはならない
* `Self` を使ってはならない

<!-- Whew! As we can see, almost all of these rules talk about `Self`. A good intuition -->
<!-- is “except in special circumstances, if your trait’s method uses `Self`, it is not -->
<!-- object-safe.” -->
ひゃー！
見ての通り、これらルールのほとんどは `Self` について話しています。
「特別な状況を除いて、トレイトのメソッドで `Self` を使うとオブジェクト安全ではなくなる」と考えるのが良いでしょう。
