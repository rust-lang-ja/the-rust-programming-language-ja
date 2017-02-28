% 関連型
<!-- % Associated Types -->

<!-- Associated types are a powerful part of Rust’s type system. They’re related to -->
<!-- the idea of a ‘type family’, in other words, grouping multiple types together. That -->
<!-- description is a bit abstract, so let’s dive right into an example. If you want -->
<!-- to write a `Graph` trait, you have two types to be generic over: the node type -->
<!-- and the edge type. So you might write a trait, `Graph<N, E>`, that looks like -->
<!-- this: -->
関連型は、Rust型システムの強力な部分です。
関連型は、「型族」という概念と関連があり、言い換えると、複数の型をグループ化するものです。
この説明はすこし抽象的なので、実際の例を見ていきましょう。
例えば、 `Graph` トレイトを定義したいとしましょう、このときジェネリックになる２つの型: 頂点の型、辺の型 が存在します。
そのため、以下のように `Graph<N, E>` と書きたくなるでしょう:

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
たしかに上のようなコードは動作しますが、この `Graph` の定義は少し扱いづらいです。
たとえば、任意の `Graph` を引数に取る関数は、 _さらに_ 頂点 `N` と辺 `E` の型についてもジェネリックになる必要があります:

```rust,ignore
fn distance<N, E, G: Graph<N, E>>(graph: &G, start: &N, end: &N) -> u32 { ... }
```

<!-- Our distance calculation works regardless of our `Edge` type, so the `E` stuff in -->
<!-- this signature is a distraction. -->
この距離を計算する関数distanceは、辺の型に関わらず動作します、そのためシグネチャに含まれる `E` に関連する部分は邪魔になります。

<!-- What we really want to say is that a certain `E`dge and `N`ode type come together -->
<!-- to form each kind of `Graph`. We can do that with associated types: -->
本当に表現したいのは、それぞれの `Graph` は、辺 `E` と頂点 `N` で構成されていることです。
それは、以下のように関連型を用いて表現できます:

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
こうすると、使う側では、個々の `Graph` をより抽象的なものとして扱えます:

```rust,ignore
fn distance<G: Graph>(graph: &G, start: &G::N, end: &G::N) -> u32 { ... }
```

<!-- No need to deal with the `E`dge type here! -->
ここでは、頂点 `E` 型を扱わずに済んでいます！

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
非常にシンプルですね。関連型には `type` キーワードを使い、そしてトレイトの本体にある関数で利用します。

<!-- These `type` declarations can have all the same thing as functions do. For example, -->
<!-- if we wanted our `N` type to implement `Display`, so we can print the nodes out, -->
<!-- we could do this: -->
これらの `type` 宣言は、関数で利用できるものと同じものが全て利用できます。
たとえば、頂点を表示するため `N` 型には `Display` を実装してほしいなら、以下のように指定できます:

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
通常のトレイトと同様に、関連型を使っているトレイトは実装するために `impl` を利用します。
以下は、シンプルなGraphの実装例です:

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

<!-- This silly implementation always returns `true` and an empty `Vec<Edge>`, but it -->
<!-- gives you an idea of how to implement this kind of thing. We first need three -->
<!-- `struct`s, one for the graph, one for the node, and one for the edge. If it made -->
<!-- more sense to use a different type, that would work as well, we’re going to -->
<!-- use `struct`s for all three here. -->
この、いささか単純過ぎる実装では、常に `true` と空の `Vec<Edge>` を返します。
しかし、関連型をどう定義したらよいのかを教えてくれます。
まず、はじめに3つの `struct` が必要です。
グラフのためにひとつ、頂点のためにひとつ、辺のためにひとつです。
もし異なる型を利用するのが適切ならば、そうしても構いません。
今回はこの3つの `struct` を用います。

<!-- Next is the `impl` line, which is an implementing like any other trait. -->
次は `impl` の行です。
これは他のトレイトを実装するときと同様です。

<!-- From here, we use `=` to define our associated types. The name the trait uses -->
<!-- goes on the left of the `=`, and the concrete type we’re `impl`ementing this -->
<!-- for goes on the right. Finally, we use the concrete types in our function -->
<!-- declarations. -->
そして、`=` を関連型を定義するために利用します。
トレイトが利用する名前は `=` の左側にある名前で、実装に用いる具体的な型は右側にあるものになります。
最後に、具体的な型を関数の宣言に利用します。

<!-- ## Trait objects with associated types -->
## 関連型を伴うトレイト

<!-- There’s one more bit of syntax we should talk about: trait objects. If you -->
<!-- try to create a trait object from a trait with an associated type, like this: -->
すこし触れておきたい構文のひとつに、トレイトオブジェクトがあります。
もし、トレイトオブジェクトを以下のように関連型を持つトレイトから作成しようとした場合:

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

<!-- You’ll get two errors: -->
以下の様なエラーが発生します:

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

<!-- We can’t create a trait object like this, because we don’t know the associated -->
<!-- types. Instead, we can write this: -->
上のようにしてトレイトオブジェクトを作ることはできません。
なぜなら関連型について知らないからです。
代わりに以下のように書けます:

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

<!-- The `N=Node` syntax allows us to provide a concrete type, `Node`, for the `N` -->
<!-- type parameter. Same with `E=Edge`. If we didn’t provide this constraint, we -->
<!-- couldn’t be sure which `impl` to match this trait object to. -->
`N=Node` 構文を用いて型パラメータ `N` に対して具体的な型 `Node` を指定できます。
`E=Edge` についても同様です。
もしこの制約を指定しなかった場合、このトレイトオブジェクトに対してどの `impl` がマッチするのか定まりません。
