% 関連型
<!-- % Associated Types -->

<!-- Associated types are a powerful part of Rust’s type system. They’re related to -->
<!-- the idea of a ‘type family’, in other words, grouping multiple types together. That -->
<!-- description is a bit abstract, so let’s dive right into an example. If you want -->
<!-- to write a `Graph` trait, you have two types to be generic over: the node type -->
<!-- and the edge type. So you might write a trait, `Graph<N, E>`, that looks like -->
<!-- this: -->
関連型は、Rust型システムの強力な部分です。関連型は、「タイプファミリー」というアイデアと関連が有ります、
言い換えると、複数の方をグルーピングするものです。この説明はすこし抽象的なので、実際の例を見ていきましょう。
例えば、 `Graph` トレイトを定義したいとしましょう、このとき `Graph` トレイトは頂点の方と、辺の型についてジェネリックとなることになります。
なので、以下のように`Graph<N, E>` と書きたくなるでしょう:

```rust
trait Graph<N, E> {
    fn has_edge(&self, &N, &N) -> bool;
    fn edges(&self, &N) -> Vec<E>;
    // etc
}
```

<!-- While this sort of works, it ends up being awkward. For example, any function -->
<!-- that wants to take a `Graph` as a parameter now _also_ needs to be generic over -->
<!-- the `N`ode and `E`dge types too: -->
たしかに、上のようなコードは動作します、しかしこのような `Graph` の定義は少し扱いづらいです。
たとえば、任意の `Graph` を引数に取る関数は、 _同時に_ `N` と `E` についてもジェネリックとなることになります:

```rust,ignore
fn distance<N, E, G: Graph<N, E>>(graph: &G, start: &N, end: &N) -> u32 { ... }
```

<!-- Our distance calculation works regardless of our `Edge` type, so the `E` stuff in -->
<!-- this signature is just a distraction. -->
上のような距離を計算するdistance関数は、辺の型に関係がありません、そのためシグネチャにふくまれる `E` に関連する部分は邪魔でしかありません。

<!-- What we really want to say is that a certain `E`dge and `N`ode type come together -->
<!-- to form each kind of `Graph`. We can do that with associated types: -->
本当に表現したいことは、辺の型 `E` や頂点の型 `N` がそれぞれの `Graph` について決まっているということです。
それは、以下のように関連型を用いて表現することができます:

```rust
trait Graph {
    type N;
    type E;

    fn has_edge(&self, &Self::N, &Self::N) -> bool;
    fn edges(&self, &Self::N) -> Vec<Self::E>;
    // etc
}
```

<!-- Now, our clients can be abstract over a given `Graph`: -->
このようにすると、`Graph` を使った関数は以下のように書くことができます:

```rust,ignore
fn distance<G: Graph>(graph: &G, start: &G::N, end: &G::N) -> u32 { ... }
```

<!-- No need to deal with the `E`dge type here! -->
もう `E` について扱う必要はありません!


<!-- Let’s go over all this in more detail. -->
もっと詳しく見ていきましょう。

<!-- ## Defining associated types -->
## 関連型を定義する

<!-- Let’s build that `Graph` trait. Here’s the definition: -->
早速、`Graph` トレイトを定義しましょう。以下がその定義です:

```rust
trait Graph {
    type N;
    type E;

    fn has_edge(&self, &Self::N, &Self::N) -> bool;
    fn edges(&self, &Self::N) -> Vec<Self::E>;
}
```

<!-- Simple enough. Associated types use the `type` keyword, and go inside the body -->
<!-- of the trait, with the functions. -->
十分にシンプルです。関連型を定義するには `type` キーワードを使います、そしてトレイトの本体や関数で利用します。

<!-- These `type` declarations can have all the same thing as functions do. For example, -->
<!-- if we wanted our `N` type to implement `Display`, so we can print the nodes out, -->
<!-- we could do this: -->
これらの `type` 宣言は、関数におけるものと同じ物を指定することができます。
たとえば、 `N` 型が `Display` を実装していて欲しい時、つまり私達が頂点を出力したい時、以下のようにして指定することができます:

```rust
use std::fmt;

trait Graph {
    type N: fmt::Display;
    type E;

    fn has_edge(&self, &Self::N, &Self::N) -> bool;
    fn edges(&self, &Self::N) -> Vec<Self::E>;
}
```

<!-- ## Implementing associated types -->
## 関連型を実装する

<!-- Just like any trait, traits that use associated types use the `impl` keyword to -->
<!-- provide implementations. Here’s a simple implementation of Graph: -->
通常のトレイトと同様に、関連型を使っているトレイト

```rust
# trait Graph {
#     type N;
#     type E;
#     fn has_edge(&self, &Self::N, &Self::N) -> bool;
#     fn edges(&self, &Self::N) -> Vec<Self::E>;
# }
struct Node;

struct Edge;

struct MyGraph;

impl Graph for MyGraph {
    type N = Node;
    type E = Edge;

    fn has_edge(&self, n1: &Node, n2: &Node) -> bool {
        true
    }

    fn edges(&self, n: &Node) -> Vec<Edge> {
        Vec::new()
    }
}
```

This silly implementation always returns `true` and an empty `Vec<Edge>`, but it
gives you an idea of how to implement this kind of thing. We first need three
`struct`s, one for the graph, one for the node, and one for the edge. If it made
more sense to use a different type, that would work as well, we’re just going to
use `struct`s for all three here.

Next is the `impl` line, which is just like implementing any other trait.

From here, we use `=` to define our associated types. The name the trait uses
goes on the left of the `=`, and the concrete type we’re `impl`ementing this
for goes on the right. Finally, we use the concrete types in our function
declarations.

## Trait objects with associated types

There’s one more bit of syntax we should talk about: trait objects. If you
try to create a trait object from an associated type, like this:

```rust,ignore
# trait Graph {
#     type N;
#     type E;
#     fn has_edge(&self, &Self::N, &Self::N) -> bool;
#     fn edges(&self, &Self::N) -> Vec<Self::E>;
# }
# struct Node;
# struct Edge;
# struct MyGraph;
# impl Graph for MyGraph {
#     type N = Node;
#     type E = Edge;
#     fn has_edge(&self, n1: &Node, n2: &Node) -> bool {
#         true
#     }
#     fn edges(&self, n: &Node) -> Vec<Edge> {
#         Vec::new()
#     }
# }
let graph = MyGraph;
let obj = Box::new(graph) as Box<Graph>;
```

You’ll get two errors:

```text
error: the value of the associated type `E` (from the trait `main::Graph`) must
be specified [E0191]
let obj = Box::new(graph) as Box<Graph>;
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
24:44 error: the value of the associated type `N` (from the trait
`main::Graph`) must be specified [E0191]
let obj = Box::new(graph) as Box<Graph>;
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

We can’t create a trait object like this, because we don’t know the associated
types. Instead, we can write this:

```rust
# trait Graph {
#     type N;
#     type E;
#     fn has_edge(&self, &Self::N, &Self::N) -> bool;
#     fn edges(&self, &Self::N) -> Vec<Self::E>;
# }
# struct Node;
# struct Edge;
# struct MyGraph;
# impl Graph for MyGraph {
#     type N = Node;
#     type E = Edge;
#     fn has_edge(&self, n1: &Node, n2: &Node) -> bool {
#         true
#     }
#     fn edges(&self, n: &Node) -> Vec<Edge> {
#         Vec::new()
#     }
# }
let graph = MyGraph;
let obj = Box::new(graph) as Box<Graph<N=Node, E=Edge>>;
```

The `N=Node` syntax allows us to provide a concrete type, `Node`, for the `N`
type parameter. Same with `E=Edge`. If we didn’t provide this constraint, we
couldn’t be sure which `impl` to match this trait object to.
