% 共通の関数呼び出し構文
<!-- % Universal Function Call Syntax -->

<!-- Sometimes, functions can have the same names. Consider this code: -->
しばしば、同名の関数が存在する時があります。たとえば、以下のコードでは:

```rust
trait Foo {
    fn f(&self);
}

trait Bar {
    fn f(&self);
}

struct Baz;

impl Foo for Baz {
    fn f(&self) { println!("Baz’s impl of Foo"); }
}

impl Bar for Baz {
    fn f(&self) { println!("Baz’s impl of Bar"); }
}

let b = Baz;
```

<!-- If we were to try to call `b.f()`, we’d get an error: -->
もしここで、 `b.f()` を呼びだそうとすると、以下の様なエラーが発生します:

```text
error: multiple applicable methods in scope [E0034]
b.f();
  ^~~
note: candidate #1 is defined in an impl of the trait `main::Foo` for the type
`main::Baz`
    fn f(&self) { println!("Baz’s impl of Foo"); }
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
note: candidate #2 is defined in an impl of the trait `main::Bar` for the type
`main::Baz`
    fn f(&self) { println!("Baz’s impl of Bar"); }
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

```

<!-- We need a way to disambiguate which method we need. This feature is called -->
<!-- ‘universal function call syntax’, and it looks like this: -->
このような場合は、どのメソッドを呼び出す必要があるのかについて曖昧性を排除する手段が必要です。
そのようなフィーチャーは 「共通の関数呼び出し構文」と呼ばれ、以下のように書けます:



```rust
# trait Foo {
#     fn f(&self);
# }
# trait Bar {
#     fn f(&self);
# }
# struct Baz;
# impl Foo for Baz {
#     fn f(&self) { println!("Baz’s impl of Foo"); }
# }
# impl Bar for Baz {
#     fn f(&self) { println!("Baz’s impl of Bar"); }
# }
# let b = Baz;
Foo::f(&b);
Bar::f(&b);
```

<!-- Let’s break it down. -->
部分的に見ていきましょう。

```rust,ignore
Foo::
Bar::
```

<!-- These halves of the invocation are the types of the two traits: `Foo` and -->
<!-- `Bar`. This is what ends up actually doing the disambiguation between the two: -->
<!-- Rust calls the one from the trait name you use. -->
まず、呼び出しのこの部分は２つのトレイト `Foo` と `Bar` の型を表しています。
この部分が、実際にどちらのトレイトのメソッドを呼び出しているのかを指定し、曖昧性を排除している箇所になります。

```rust,ignore
f(&b)
```

<!-- When we call a method like `b.f()` using [method syntax][methodsyntax], Rust -->
<!-- will automatically borrow `b` if `f()` takes `&self`. In this case, Rust will -->
<!-- not, and so we need to pass an explicit `&b`. -->
`b.f()` のように [メソッド構文][methodsyntax] を利用して呼び出した時、Rustは `f()` が `&self` を引数に取る場合自動的に `b` を借用します。
今回の場合は、そのようには呼び出していないので、明示的に `&b` を渡してやる必要があります。

[methodsyntax]: method-syntax.html

# 山括弧形式

<!-- The form of UFCS we just talked about: -->
すぐ上で説明した、以下のような共通の関数呼び出し構文:

```rust,ignore
Trait::method(args);
```

<!-- Is a short-hand. There’s an expanded form of this that’s needed in some -->
<!-- situations: -->
これは短縮形であり、時々必要になる以下の様な展開された形式もあります:

```rust,ignore
<Type as Trait>::method(args);
```

<!-- The `<>::` syntax is a means of providing a type hint. The type goes inside -->
<!-- the `<>`s. In this case, the type is `Type as Trait`, indicating that we want -->
<!-- `Trait`’s version of `method` to be called here. The `as Trait` part is -->
<!-- optional if it’s not ambiguous. Same with the angle brackets, hence the -->
<!-- shorter form. -->
`<>::` という構文は型のヒントを意味しており、 `<>` のなかに型が入ります。
この場合、型は `Type as Trait` となり、 `Trait`のバージョンの `method` が呼ばれる事を期待していることを意味しています。
`as Trait` という部分は、曖昧でない場合は省略可能です。山括弧についても同様に省略可能であり、なので先程のさらに短い形になるのです。

<!-- Here’s an example of using the longer form. -->
長い形式を用いたサンプルコードは以下の通りです:

```rust
trait Foo {
    fn foo() -> i32;
}

struct Bar;

impl Bar {
    fn foo() -> i32 {
        20
    }
}

impl Foo for Bar {
    fn foo() -> i32 {
        10
    }
}

fn main() {
    assert_eq!(10, <Bar as Foo>::foo());
    assert_eq!(20, Bar::foo());
}
```

<!-- Using the angle bracket syntax lets you call the trait method instead of the -->
<!-- inherent one. -->
山括弧構文を用いることでトレイトのメソッドを固有メソッドの代わりに呼び出すことができます。
