% Glossary

Not every Rustacean has a background in systems programming, nor in computer
science, so we've added explanations of terms that might be unfamiliar.

### Abstract Syntax Tree

When a compiler is compiling your program, it does a number of different things.
One of the things that it does is turn the text of your program into an
‘abstract syntax tree’, or ‘AST’. This tree is a representation of the structure
of your program. For example, `2 + 3` can be turned into a tree:

```text
  +
 / \
2   3
```

And `2 + (3 * 4)` would look like this:

```text
  +
 / \
2   *
   / \
  3   4
```

### Arity

Arity refers to the number of arguments a function or operation takes.

```rust
let x = (2, 3);
let y = (4, 6);
let z = (8, 2, 6);
```

In the example above `x` and `y` have arity 2. `z` has arity 3.

### Bounds

Bounds are constraints on a type or [trait][traits]. For example, if a bound
is placed on the argument a function takes, types passed to that function
must abide by that constraint.

[traits]: traits.html

### DST (Dynamically Sized Type)

A type without a statically known size or alignment. ([more info][link])

[link]: ../nomicon/exotic-sizes.html#dynamically-sized-types-dsts

### 式

コンピュータプログラミングに於いて、式は値、定数、変数、演算子、1つの値へと評価される関数の組み合わせです。
例えば、`2 + (3 * 4)`は値14を返す式です。式が副作用を持ちうることに意味はありません。
例えば、ある式に含まれる関数がただ値を返す以外にも何か作用をするかもしれません。



### 式指向言語

早期のプログラミング言語では[式][]と[文][]は文法上違うものでした。式は値を持ち、文は何かをします。
しかしながら後の言語ではこれらの溝は埋まり式で何かを出来るようになり文が値を持てるようになりました。
式指向言語では(ほとんど)全ての文が式であり値を返します。同時にこれらの式文はより大きな式の一部を成します。


[式]: glossary.html#式
[文]: glossary.html#文

### 文

コンピュータプログラミングに於いて、文とはコンピュータに何かしらの作用をさせるプログラミング言語の最小要素です。
