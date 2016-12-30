% 食事する哲学者
<!-- % Dining Philosophers -->

<!-- For our second project, let’s look at a classic concurrency problem. It’s -->
<!-- called ‘the dining philosophers’. It was originally conceived by Dijkstra in -->
<!-- 1965, but we’ll use a lightly adapted version from [this paper][paper] by Tony -->
<!-- Hoare in 1985. -->
私たちの2番目のプロジェクトとして、古典的な並行処理問題を考えていきましょう。「食事する哲学者(the dining philosophers)」とよばれる問題です。
オリジナルは1965年にダイクストラ(Dijkstra)により考案されましたが、ここではトニー・ホーア(Tony Hoare)による1985年の [この論文][paper] を少しばかり脚色したバージョンを用います。

[paper]: http://www.usingcsp.com/cspbook.pdf

<!-- > In ancient times, a wealthy philanthropist endowed a College to accommodate -->
<!-- > five eminent philosophers. Each philosopher had a room in which they could -->
<!-- > engage in their professional activity of thinking; there was also a common -->
<!-- > dining room, furnished with a circular table, surrounded by five chairs, each -->
<!-- > labelled by the name of the philosopher who was to sit in it. They sat -->
<!-- > anticlockwise around the table. To the left of each philosopher there was -->
<!-- > laid a golden fork, and in the center stood a large bowl of spaghetti, which -->
<!-- > was constantly replenished. A philosopher was expected to spend most of -->
<!-- > their time thinking; but when they felt hungry, they went to the dining -->
<!-- > room, sat down in their own chair, picked up their own fork on their left, -->
<!-- > and plunged it into the spaghetti. But such is the tangled nature of -->
<!-- > spaghetti that a second fork is required to carry it to the mouth. The -->
<!-- > philosopher therefore had also to pick up the fork on their right. When -->
<!-- > they were finished they would put down both their forks, get up from their -->
<!-- > chair, and continue thinking. Of course, a fork can be used by only one -->
<!-- > philosopher at a time. If the other philosopher wants it, they just have -->
<!-- > to wait until the fork is available again. -->
> 昔々、裕福な慈善家が、5人の高名な哲学者が宿泊できるカレッジを寄付しました。それぞれの哲学者には思索活動にふさわしい部屋が与えられました;
> また共用のダイニングルームもあり、そこには丸いテーブルが置かれ、5人それぞれが専用で使うイス5脚で取り囲まれていました。
> 彼らはテーブルを反時計回りに座ります。哲学者の左側にはそれぞれ金のフォークが配され、
> 中央には大きなボウルに入ったスパゲッティが常に補充されていました。哲学者は大半の時間を思慮に費やすのですが;
> 空腹になった時は、ダイニングルームに出向き、自分専用のイスに座り、左側のフォークを取上げ、スパゲッティに突き刺します。
> しかし、絡まり合ったスパゲッティを口元まで運ぶには2本目のフォークが必要でした。なので哲学者は自分の右側にあるフォークも使う必要がありました。
> 食べ終わったら両側のフォークを元に戻し、席から立ちあがって、思索活動を続けます。
> もちろん、1本のフォークは同時に1人の哲学者しか使えません。他の哲学者が食事したければ、
> フォークが再び戻されるまで待たねばなりません。

<!-- This classic problem shows off a few different elements of concurrency. The -->
<!-- reason is that it's actually slightly tricky to implement: a simple -->
<!-- implementation can deadlock. For example, let's consider a simple algorithm -->
<!-- that would solve this problem: -->
この古典問題は並行処理特有の要因を際立たせます。その実装にあたっては少し注意が必要となるからです:
単純な実装ではデッドロックの可能性があるのです。例えば、この問題を解く単純なアルゴリズムを考えてみましょう:

<!-- 1. A philosopher picks up the fork on their left. -->
<!-- 2. They then pick up the fork on their right. -->
<!-- 3. They eat. -->
<!-- 4. They return the forks. -->
1. 哲学者は左側のフォークを取上げます。
2. 続いて右側のフォークを取上げます。
3. 食事をします。
4. 2本のフォークを戻します。

<!-- Now, let’s imagine this sequence of events: -->
さて、このような一連の出来事を想像してみましょう:

<!-- 1. Philosopher 1 begins the algorithm, picking up the fork on their left. -->
<!-- 2. Philosopher 2 begins the algorithm, picking up the fork on their left. -->
<!-- 3. Philosopher 3 begins the algorithm, picking up the fork on their left. -->
<!-- 4. Philosopher 4 begins the algorithm, picking up the fork on their left. -->
<!-- 5. Philosopher 5 begins the algorithm, picking up the fork on their left. -->
<!-- 6. ... ? All the forks are taken, but nobody can eat! -->
1. 1番目の哲学者は、アルゴリズムに従って左側のフォークを取上げます。
2. 2番目の哲学者は、アルゴリズムに従って左側のフォークを取上げます。
3. 3番目の哲学者は、アルゴリズムに従って左側のフォークを取上げます。
4. 4番目の哲学者は、アルゴリズムに従って左側のフォークを取上げます。
5. 5番目の哲学者は、アルゴリズムに従って左側のフォークを取上げます。
6. ...?全てのフォークが取られたのに、誰も食事できません!

<!-- There are different ways to solve this problem. We’ll get to our solution in -->
<!-- the tutorial itself. For now, let’s get started and create a new project with -->
<!-- `cargo`: -->
この問題を解決する方法はいくつかあります。チュートリアルでは独自の解法をとります。
さっそく、 `cargo` を使って新規プロジェクトを作り始めましょう:

```bash
$ cd ~/projects
$ cargo new dining_philosophers --bin
$ cd dining_philosophers
```

<!-- Now we can start modeling the problem itself. We’ll start with the philosophers -->
<!-- in `src/main.rs`: -->
それでは、問題をモデル化するところから始めましょう。 `src/main.rs` にて、哲学者から手を付けていきます:

```rust
struct Philosopher {
    name: String,
}

impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }
}

fn main() {
    let p1 = Philosopher::new("Judith Butler");
    let p2 = Philosopher::new("Gilles Deleuze");
    let p3 = Philosopher::new("Karl Marx");
    let p4 = Philosopher::new("Emma Goldman");
    let p5 = Philosopher::new("Michel Foucault");
}
```

> 訳注: ソースコード中に登場する哲学者は、ジュディス・バトラー(Judith Butler)、ジル・ドゥルーズ(Gilles Deleuze)、
> カール・マルクス(Karl Marx)、エマ・ゴールドマン(Emma Goldman)、ミシェル・フーコー(Michel Foucault)の5人。

<!-- Here, we make a [`struct`][struct] to represent a philosopher. For now, -->
<!-- a name is all we need. We choose the [`String`][string] type for the name, -->
<!-- rather than `&str`. Generally speaking, working with a type which owns its -->
<!-- data is easier than working with one that uses references. -->
ここでは、哲学者を表す [`struct` (構造体) ][struct] を作ります。まずは名前だけで十分でしょう。
名前には `&str` 型ではなく [`String`][string] 型を選びました。一般的に、データを所有する型を用いた方が、
データを参照する型の利用よりも簡単になります。

[struct]: structs.html
[string]: strings.html

<!-- Let’s continue: -->
では続けましょう:

```rust
# struct Philosopher {
#     name: String,
# }
impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }
}
```

<!-- This `impl` block lets us define things on `Philosopher` structs. In this case, -->
<!-- we define an ‘associated function’ called `new`. The first line looks like this: -->
この `impl` ブロックは `Philosopher` 構造体に関する定義を与えます。ここでは、 `new` という「関連関数(associated function)」を定義します。
最初の行は次の通りです:

```rust
# struct Philosopher {
#     name: String,
# }
# impl Philosopher {
fn new(name: &str) -> Philosopher {
#         Philosopher {
#             name: name.to_string(),
#         }
#     }
# }
```

<!-- We take one argument, a `name`, of type `&str`. This is a reference to another -->
<!-- string. It returns an instance of our `Philosopher` struct. -->
関数は `&str` 型の引数1つ、 `name` をとります。これは他の文字列への参照です。そして `Philosopher` 構造体のインスタンスを返します。

```rust
# struct Philosopher {
#     name: String,
# }
# impl Philosopher {
#    fn new(name: &str) -> Philosopher {
Philosopher {
    name: name.to_string(),
}
#     }
# }
```

<!-- This creates a new `Philosopher`, and sets its `name` to our `name` argument. -->
<!-- Not just the argument itself, though, as we call `.to_string()` on it. This -->
<!-- will create a copy of the string that our `&str` points to, and give us a new -->
<!-- `String`, which is the type of the `name` field of `Philosopher`. -->
関数は新しい `Philosopher` インスタンスを作成し、その `name` フィールドに引数 `name` を設定します。
ここでは引数を直接設定するのではなく、 `.to_string()` を呼び出しています。これにより `&str` が指す文字列のコピーが作られ、
`Philosopher` の `name` フィールド型に合わせた新しい `String` が得られます。

<!-- Why not accept a `String` directly? It’s nicer to call. If we took a `String`, -->
<!-- but our caller had a `&str`, they’d have to call this method themselves. The -->
<!-- downside of this flexibility is that we _always_ make a copy. For this small -->
<!-- program, that’s not particularly important, as we know we’ll just be using -->
<!-- short strings anyway. -->
なぜ引数に直接 `String` を受付けないのかって?いい質問です。仮に `String` をとるとしたら、呼出し元は `&str` 値をもっていますから、
呼び出し元でメソッドを呼ぶ必要がでてしまいます。この利便性の代償として、 _常に_ コピーが作られてしまいます。
今回のプログラムでは、短い文字列しか与えないことが分かっているため、これは大して重要な問題ではありません。

<!-- One last thing you’ll notice: we just define a `Philosopher`, and seemingly -->
<!-- don’t do anything with it. Rust is an ‘expression based’ language, which means -->
<!-- that almost everything in Rust is an expression which returns a value. This is -->
<!-- true of functions as well — the last expression is automatically returned. Since -->
<!-- we create a new `Philosopher` as the last expression of this function, we end -->
<!-- up returning it. -->
最後の注意点として: ここは `Philosopher` を定義しただけで、何もしていないように見えます。Rust言語は「式ベース(expression based)」なので、
Rustではほとんどが値を返す式となります。関数についても同じことが言え―最後の式が自動的に戻り値となります。
ここでは関数内の最後の式で新しい `Philosopher` を生成し、それを戻り値としているのです。

<!-- This name, `new()`, isn’t anything special to Rust, but it is a convention for -->
<!-- functions that create new instances of structs. Before we talk about why, let’s -->
<!-- look at `main()` again: -->
この `new()` という名前、Rustにとって特別な意味を持ちませんが、構造体の新しいインスタンスを生成する関数としてよく用いられます。
その理由について話す前に、再び `main()` を見ていきましょう:

```rust
# struct Philosopher {
#     name: String,
# }
#
# impl Philosopher {
#     fn new(name: &str) -> Philosopher {
#         Philosopher {
#             name: name.to_string(),
#         }
#     }
# }
#
fn main() {
    let p1 = Philosopher::new("Judith Butler");
    let p2 = Philosopher::new("Gilles Deleuze");
    let p3 = Philosopher::new("Karl Marx");
    let p4 = Philosopher::new("Emma Goldman");
    let p5 = Philosopher::new("Michel Foucault");
}
```

<!-- Here, we create five variable bindings with five new philosophers. -->
<!-- If we _didn’t_ define -->
<!-- that `new()` function, it would look like this: -->
ここでは、5つの新しい哲学者に対して5つの変数束縛を作ります。仮に `new` 関数を定義 _しない_ なら、次のように書く必要があります:

```rust
# struct Philosopher {
#     name: String,
# }
fn main() {
    let p1 = Philosopher { name: "Judith Butler".to_string() };
    let p2 = Philosopher { name: "Gilles Deleuze".to_string() };
    let p3 = Philosopher { name: "Karl Marx".to_string() };
    let p4 = Philosopher { name: "Emma Goldman".to_string() };
    let p5 = Philosopher { name: "Michel Foucault".to_string() };
}
```

<!-- That’s much noisier. Using `new` has other advantages too, but even in -->
<!-- this simple case, it ends up being nicer to use. -->
これでは面倒ですよね。 `new` の利用には他の利点もありますが、今回のような単純なケースでも、
利用側コードをシンプルにできるのです。

<!-- Now that we’ve got the basics in place, there’s a number of ways that we can -->
<!-- tackle the broader problem here. I like to start from the end first: let’s -->
<!-- set up a way for each philosopher to finish eating. As a tiny step, let’s make -->
<!-- a method, and then loop through all the philosophers, calling it: -->
下準備が終ったので、ここでの残る問題、哲学者の問題に取り組める多くの方法があります。
まずは逆順に: 哲学者が食事を終わらせる部分から始めていきましょう。この小さなステップでは、
メソッドを1つ作り、全ての哲学者に対して呼び出します:

```rust
struct Philosopher {
    name: String,
}

impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }

    fn eat(&self) {
        println!("{} is done eating.", self.name);
    }
}

fn main() {
    let philosophers = vec![
        Philosopher::new("Judith Butler"),
        Philosopher::new("Gilles Deleuze"),
        Philosopher::new("Karl Marx"),
        Philosopher::new("Emma Goldman"),
        Philosopher::new("Michel Foucault"),
    ];

    for p in &philosophers {
        p.eat();
    }
}
```

<!-- Let’s look at `main()` first. Rather than have five individual variable -->
<!-- bindings for our philosophers, we make a `Vec<T>` of them instead. `Vec<T>` is -->
<!-- also called a ‘vector’, and it’s a growable array type. We then use a -->
<!-- [`for`][for] loop to iterate through the vector, getting a reference to each -->
<!-- philosopher in turn. -->
最初は `main()` から見ていきます。哲学者たちに5つの変数束縛を個別に行うのではなく、代わりに `Vec<T>` を用いました。
`Vec<T>` は「ベクタ(vector)」とも呼ばれる、可変長の配列型です。ベクタの走査には [`for`][for] ループを使っているため、
それぞれの哲学者への参照が順番に得られれます。

[for]: loops.html#for

<!-- In the body of the loop, we call `p.eat()`, which is defined above: -->
ループ本体の中では、上記で定義した `p.eat()` を呼び出します:

```rust,ignore
fn eat(&self) {
    println!("{} is done eating.", self.name);
}
```

<!-- In Rust, methods take an explicit `self` parameter. That’s why `eat()` is a -->
<!-- method, but `new` is an associated function: `new()` has no `self`. For our -->
<!-- first version of `eat()`, we just print out the name of the philosopher, and -->
<!-- mention they’re done eating. Running this program should give you the following -->
<!-- output: -->
Rustでは、メソッドは明示的な `self` パラメータを取ります。なので `eat()` はメソッドとなり、
`new()` は `self` を取らないため関連関数となります。最初の `eat()` バージョンでは、哲学者の名前と、
食事が終わったことを表示するだけです。このプログラムを実行すると次の出力がえられるはずです:

```text
Judith Butler is done eating.
Gilles Deleuze is done eating.
Karl Marx is done eating.
Emma Goldman is done eating.
Michel Foucault is done eating.
```

<!-- Easy enough, they’re all done! We haven’t actually implemented the real problem -->
<!-- yet, though, so we’re not done yet! -->
これだけなら簡単ですね、出来ました!私たちはまだ真の問題を実装していませんから、実際のところは出来ていませんけど!

<!-- Next, we want to make our philosophers not just finish eating, but actually -->
<!-- eat. Here’s the next version: -->
続いて、哲学者たちが一瞬で食事を終えるのではなく、本当に食事するようにしたいです。これが次のバージョンです:

```rust
use std::thread;
use std::time::Duration;

struct Philosopher {
    name: String,
}

impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }

    fn eat(&self) {
        println!("{} is eating.", self.name);

        thread::sleep(Duration::from_millis(1000));

        println!("{} is done eating.", self.name);
    }
}

fn main() {
    let philosophers = vec![
        Philosopher::new("Judith Butler"),
        Philosopher::new("Gilles Deleuze"),
        Philosopher::new("Karl Marx"),
        Philosopher::new("Emma Goldman"),
        Philosopher::new("Michel Foucault"),
    ];

    for p in &philosophers {
        p.eat();
    }
}
```

<!-- Just a few changes. Let’s break it down. -->
大した変更はありません。順に見ていきましょう。

```rust,ignore
use std::thread;
```

<!-- `use` brings names into scope. We’re going to start using the `thread` module -->
<!-- from the standard library, and so we need to `use` it. -->
`use` は名前をスコープに持ち込みます。標準ライブラリから `thread` モジュールを使いたいので、 `use` が必要になります。

```rust,ignore
    fn eat(&self) {
        println!("{} is eating.", self.name);

        thread::sleep(Duration::from_millis(1000));

        println!("{} is done eating.", self.name);
    }
```

<!-- We now print out two messages, with a `sleep` in the middle. This will -->
<!-- simulate the time it takes a philosopher to eat. -->
今回は間に `sleep` を挟んで、2つのメッセージを出力します。これで哲学者が食事をする時間をシミュレートしましょう。

<!-- If you run this program, you should see each philosopher eat in turn: -->
このプログラムを実行すると、哲学者たちが順番に食事する様子がわかります:

```text
Judith Butler is eating.
Judith Butler is done eating.
Gilles Deleuze is eating.
Gilles Deleuze is done eating.
Karl Marx is eating.
Karl Marx is done eating.
Emma Goldman is eating.
Emma Goldman is done eating.
Michel Foucault is eating.
Michel Foucault is done eating.
```

<!-- Excellent! We’re getting there. There’s just one problem: we aren’t actually -->
<!-- operating in a concurrent fashion, which is a core part of the problem! -->
素晴らしい!ここまで来ました。残る問題はたった1つ: この問題の核心である並行性に関して、実際には手を付けていませんね!

<!-- To make our philosophers eat concurrently, we need to make a small change. -->
<!-- Here’s the next iteration: -->
哲学者たちを並行に食事させるには、小さな変更を加える必要があります。これが次のイテレーションです:

```rust
use std::thread;
use std::time::Duration;

struct Philosopher {
    name: String,
}

impl Philosopher {
    fn new(name: &str) -> Philosopher {
        Philosopher {
            name: name.to_string(),
        }
    }

    fn eat(&self) {
        println!("{} is eating.", self.name);

        thread::sleep(Duration::from_millis(1000));

        println!("{} is done eating.", self.name);
    }
}

fn main() {
    let philosophers = vec![
        Philosopher::new("Judith Butler"),
        Philosopher::new("Gilles Deleuze"),
        Philosopher::new("Karl Marx"),
        Philosopher::new("Emma Goldman"),
        Philosopher::new("Michel Foucault"),
    ];

    let handles: Vec<_> = philosophers.into_iter().map(|p| {
        thread::spawn(move || {
            p.eat();
        })
    }).collect();

    for h in handles {
        h.join().unwrap();
    }
}
```

<!-- All we’ve done is change the loop in `main()`, and added a second one! Here’s the -->
<!-- first change: -->
`main()` 内のループ変更と、1ヵ所の追加で全部です!まずは前半の変更から:

```rust,ignore
let handles: Vec<_> = philosophers.into_iter().map(|p| {
    thread::spawn(move || {
        p.eat();
    })
}).collect();
```

<!-- While this is only five lines, they’re a dense five. Let’s break it down. -->
たった5行ですが、内容の濃い5行になっています。では見ていきましょう。

```rust,ignore
let handles: Vec<_> =
```

<!-- We introduce a new binding, called `handles`. We’ve given it this name because -->
<!-- we are going to make some new threads, and that will return some handles to those -->
<!-- threads that let us control their operation. We need to explicitly annotate -->
<!-- the type here, though, due to an issue we’ll talk about later. The `_` -->
<!-- is a type placeholder. We’re saying “`handles` is a vector of something, but you -->
<!-- can figure out what that something is, Rust.” -->
ここでは新しい束縛、 `handles` を導入します。今から新しいスレッドを作成していきますが、
スレッドはそのスレッドを制御するハンドルを返すのでこの名前としました。後ほど議論する問題があるため、
ここでは明示的な型アノテーションが必要となります。 `_` は型プレースホルダです。
つまり「 `handles` は何らかの型のベクトルとするが、その型が何であるかはRustが解決せよ。」と言っています。

```rust,ignore
philosophers.into_iter().map(|p| {
```

<!-- We take our list of philosophers and call `into_iter()` on it. This creates an -->
<!-- iterator that takes ownership of each philosopher. We need to do this to pass -->
<!-- them to our threads. We take that iterator and call `map` on it, which takes a -->
<!-- closure as an argument and calls that closure on each element in turn. -->
哲学者のリストに対して `into_iter()` を呼び出します。このメソッドは、哲学者の所有権を持つイテレータを生成します。
スレッドに各要素を渡すため、このようにしました。イテレータに対して `map` を呼び出し、その引数として要素毎に順番に呼ばれるクロージャを渡します。

```rust,ignore
    thread::spawn(move || {
        p.eat();
    })
```

<!-- Here’s where the concurrency happens. The `thread::spawn` function takes a closure -->
<!-- as an argument and executes that closure in a new thread. This closure needs -->
<!-- an extra annotation, `move`, to indicate that the closure is going to take -->
<!-- ownership of the values it’s capturing. In this case, it's the `p` variable of the -->
<!-- `map` function. -->
ここが並行実行される部分です。 `thread::spawn` 関数はクロージャを1つ引数にとり、新しいスレッド上でそのクロージャを実行します。
このクロージャは特別なアノテーション、 `move` を必要とします。これによりキャプチャする値の所有権がクロージャ内へと移動されます。
今回のケースでは、 `map` 関数の変数 `p` が該当します。

<!-- Inside the thread, all we do is call `eat()` on `p`. Also note that -->
<!-- the call to `thread::spawn` lacks a trailing semicolon, making this an -->
<!-- expression. This distinction is important, yielding the correct return -->
<!-- value. For more details, read [Expressions vs. Statements][es]. -->
スレッド内では、 `p` に対して `eat()` を呼び出しておしまいです。 `thread::spawn` 呼び出しの末尾にセミコロンを置かないことで、
式としている点に注意してください。正しい戻り値を返すために、この区別は重要です。詳細については、
[式 vs. 文][es] を参照ください。

[es]: functions.html#expressions-vs-statements

```rust,ignore
}).collect();
```

<!-- Finally, we take the result of all those `map` calls and collect them up. -->
<!-- `collect()` will make them into a collection of some kind, which is why we -->
<!-- needed to annotate the return type: we want a `Vec<T>`. The elements are the -->
<!-- return values of the `thread::spawn` calls, which are handles to those threads. -->
<!-- Whew! -->
最後に、 `map` 呼び出しの結果をまとめ上げます。 `collect()` は何らかのコレクション型を生成しますが、要求する戻り値型アノテーションを必要とします:
ここでは `Vec<T>` です。またその要素は `thread::spawn` 呼び出しの戻り値、つまり各スレッドへのハンドルとなっています。
フゥー!

```rust,ignore
for h in handles {
    h.join().unwrap();
}
```

<!-- At the end of `main()`, we loop through the handles and call `join()` on them, -->
<!-- which blocks execution until the thread has completed execution. This ensures -->
<!-- that the threads complete their work before the program exits. -->
`main()` の最後に、ハンドルへの `join()` 呼び出しをループし、各スレッド実行が完了するまで実行をブロックします。
これにより、プログラム終了前にスレッド処理が完了すると保証します。

<!-- If you run this program, you’ll see that the philosophers eat out of order! -->
<!-- We have multi-threading! -->
このプログラムを実行すると、哲学者たちが順不同に食事するさまが見られるでしょう!
マルチスレッド処理だ!

```text
Judith Butler is eating.
Gilles Deleuze is eating.
Karl Marx is eating.
Emma Goldman is eating.
Michel Foucault is eating.
Judith Butler is done eating.
Gilles Deleuze is done eating.
Karl Marx is done eating.
Emma Goldman is done eating.
Michel Foucault is done eating.
```

<!-- But what about the forks? We haven’t modeled them at all yet. -->
あれ、フォークはどこ行ったの?まだモデル化していませんでしたね。

<!-- To do that, let’s make a new `struct`: -->
という訳で、新しい `struct` を作っていきましょう:

```rust
use std::sync::Mutex;

struct Table {
    forks: Vec<Mutex<()>>,
}
```

<!-- This `Table` has a vector of `Mutex`es. A mutex is a way to control -->
<!-- concurrency: only one thread can access the contents at once. This is exactly -->
<!-- the property we need with our forks. We use an empty tuple, `()`, inside the -->
<!-- mutex, since we’re not actually going to use the value, just hold onto it. -->
この `Table` は `Mutex` のベクトルを保持します。ミューテックスは並行処理を制御するための機構です:
その内容へ同時アクセスできるのは1スレッドに限定されます。これは正に今回のフォークに求められる性質です。
単に保持するだけで、実際に値を使うあても無いため、ミューテックスの中身は空タプル `()` とします。

<!-- Let’s modify the program to use the `Table`: -->
プログラムで `Table` を使うよう変更しましょう:

```rust
use std::thread;
use std::time::Duration;
use std::sync::{Mutex, Arc};

struct Philosopher {
    name: String,
    left: usize,
    right: usize,
}

impl Philosopher {
    fn new(name: &str, left: usize, right: usize) -> Philosopher {
        Philosopher {
            name: name.to_string(),
            left: left,
            right: right,
        }
    }

    fn eat(&self, table: &Table) {
        let _left = table.forks[self.left].lock().unwrap();
        thread::sleep(Duration::from_millis(150));
        let _right = table.forks[self.right].lock().unwrap();

        println!("{} is eating.", self.name);

        thread::sleep(Duration::from_millis(1000));

        println!("{} is done eating.", self.name);
    }
}

struct Table {
    forks: Vec<Mutex<()>>,
}

fn main() {
    let table = Arc::new(Table { forks: vec![
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
    ]});

    let philosophers = vec![
        Philosopher::new("Judith Butler", 0, 1),
        Philosopher::new("Gilles Deleuze", 1, 2),
        Philosopher::new("Karl Marx", 2, 3),
        Philosopher::new("Emma Goldman", 3, 4),
        Philosopher::new("Michel Foucault", 0, 4),
    ];

    let handles: Vec<_> = philosophers.into_iter().map(|p| {
        let table = table.clone();

        thread::spawn(move || {
            p.eat(&table);
        })
    }).collect();

    for h in handles {
        h.join().unwrap();
    }
}
```

<!-- Lots of changes! However, with this iteration, we’ve got a working program. -->
<!-- Let’s go over the details: -->
変更がたくさん!とはいえ、このイテレーションで、動作するプログラムが出来ました。細かく見ていきましょう:

```rust,ignore
use std::sync::{Mutex, Arc};
```

<!-- We’re going to use another structure from the `std::sync` package: `Arc<T>`. -->
<!-- We’ll talk more about it when we use it. -->
ここでは `std::sync` パッケージからもう一つの構造体: `Arc<T>` を利用します。その詳細は使うときに説明します。

```rust,ignore
struct Philosopher {
    name: String,
    left: usize,
    right: usize,
}
```

<!-- We need to add two more fields to our `Philosopher`. Each philosopher is going -->
<!-- to have two forks: the one on their left, and the one on their right. -->
<!-- We’ll use the `usize` type to indicate them, as it’s the type that you index -->
<!-- vectors with. These two values will be the indexes into the `forks` our `Table` -->
<!-- has. -->
`Philosopher` に2つのフィールドを追加する必要があります。哲学者はそれぞれ2本のフォークを使います:
1本は左手に、もう1本は右手に。フォークの表現はベクトルのインデックスに対応するため、ここでは `usize` 型を使います。
2つの値は `Table` が保持する `forks` のインデクス値を表しています。

```rust,ignore
fn new(name: &str, left: usize, right: usize) -> Philosopher {
    Philosopher {
        name: name.to_string(),
        left: left,
        right: right,
    }
}
```

<!-- We now need to construct those `left` and `right` values, so we add them to -->
<!-- `new()`. -->
インスタンス生成時に `left` と `right` の値が必要になりますから、 `new()` を拡張しました。

```rust,ignore
fn eat(&self, table: &Table) {
    let _left = table.forks[self.left].lock().unwrap();
    thread::sleep(Duration::from_millis(150));
    let _right = table.forks[self.right].lock().unwrap();

    println!("{} is eating.", self.name);

    thread::sleep(Duration::from_millis(1000));

    println!("{} is done eating.", self.name);
}
```

<!-- We have three new lines. We’ve added an argument, `table`. We access the -->
<!-- `Table`’s list of forks, and then use `self.left` and `self.right` to access -->
<!-- the fork at that particular index. That gives us access to the `Mutex` at that -->
<!-- index, and we call `lock()` on it. If the mutex is currently being accessed by -->
<!-- someone else, we’ll block until it becomes available. We have also a call to -->
<!-- `thread::sleep` between the moment the first fork is picked and the moment the -->
<!-- second forked is picked, as the process of picking up the fork is not -->
<!-- immediate. -->
新しい行が3つあります。新しい引数 `table` も追加しました。 `Table` が保持するフォークのリストにアクセスし、
フォークにアクセスするため `self.left` と `self.right` をインデクス値に用います。そのインデクスから `Mutex` が得られたら、
`lock()` を呼び出します。ミューテックスが別スレッドから並行アクセスされていた場合は、有効になるまでブロックされるでしょう。
またフォークを取上げる操作が一瞬で終わらないよう、最初のフォークを取上げてから2つ目のフォークを取上げるまでの間に `thread::sleep` を呼び出します。

<!-- The call to `lock()` might fail, and if it does, we want to crash. In this -->
<!-- case, the error that could happen is that the mutex is [‘poisoned’][poison], -->
<!-- which is what happens when the thread panics while the lock is held. Since this -->
<!-- shouldn’t happen, we just use `unwrap()`. -->
`lock()` 呼び出しは失敗する可能性があり、その場合は、プログラムをクラッシュさせます。この状況は、ミューテックスが [「poisoned」][poison] 状態、
つまりロック保持中のスレッドがパニックした場合にしか発生しません。つまり今は起こりえないため、単に `unwrap()` を使っています。

[poison]: ../std/sync/struct.Mutex.html#poisoning

<!-- One other odd thing about these lines: we’ve named the results `_left` and -->
<!-- `_right`. What’s up with that underscore? Well, we aren’t planning on -->
<!-- _using_ the value inside the lock. We just want to acquire it. As such, -->
<!-- Rust will warn us that we never use the value. By using the underscore, -->
<!-- we tell Rust that this is what we intended, and it won’t throw a warning. -->
もう一つの変わった点として: 結果を `_left` と `_right` と名づけました。このアンダースコアはなにもの?
ええと、ロック内ではこれらの値を _使う_ 予定がありません。単にロックを獲得したいだけです。
そうなると、Rustは値が未使用だと警告してくるでしょう。アンダースコアを使えば、Rustにこちらの意図を伝えることができ、
警告されなくなるのです。

<!-- What about releasing the lock? Well, that will happen when `_left` and -->
<!-- `_right` go out of scope, automatically. -->
ロックの解放はどうしましょう?はい、 `_left` と `_right` がスコープから抜けるとき、自動的に解放されます。

```rust,ignore
    let table = Arc::new(Table { forks: vec![
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
        Mutex::new(()),
    ]});
```

<!-- Next, in `main()`, we make a new `Table` and wrap it in an `Arc<T>`. -->
<!-- ‘arc’ stands for ‘atomic reference count’, and we need that to share -->
<!-- our `Table` across multiple threads. As we share it, the reference -->
<!-- count will go up, and when each thread ends, it will go back down. -->
続いて、 `main()` では、新しい `Table` を作って `Arc<T>` に包んでいます。「arc」は「アトミック参照カウント(atomic reference count)」を意味し、
複数スレッドから `Table` を共有するために必要となります。共有するときは参照カウントを増やし、
各スレッドの終了時にはカウントを減らします。

```rust,ignore
let philosophers = vec![
    Philosopher::new("Judith Butler", 0, 1),
    Philosopher::new("Gilles Deleuze", 1, 2),
    Philosopher::new("Karl Marx", 2, 3),
    Philosopher::new("Emma Goldman", 3, 4),
    Philosopher::new("Michel Foucault", 0, 4),
];
```

<!-- We need to pass in our `left` and `right` values to the constructors for our -->
<!-- `Philosopher`s. But there’s one more detail here, and it’s _very_ important. If -->
<!-- you look at the pattern, it’s all consistent until the very end. Monsieur -->
<!-- Foucault should have `4, 0` as arguments, but instead, has `0, 4`. This is what -->
<!-- prevents deadlock, actually: one of our philosophers is left handed! This is -->
<!-- one way to solve the problem, and in my opinion, it’s the simplest. If you -->
<!-- change the order of the parameters, you will be able to observe the deadlock -->
<!-- taking place. -->
`Philosopher` のコンストラクタには `left` と `right` の値を渡す必要があります。ここではもう1つ細かい話がありますが、
これは_非常に_重要な部分です。規則性という点では、最後以外は特に問題ありません。ムッシュ・フーコー(Foucault)は `4, 0` を引数にとるべきですが、
代わりに、 `0, 4` としています。これはデッドロックを防ぐためのものです。実は: 哲学者の一人は左利きだったのです!
これは問題解決の一つのやり方ですが、私の見立てでは、最も単純な方法です。実引数の順番を変更すれば、デッドロックが生じるのを観測できるでしょう。

```rust,ignore
let handles: Vec<_> = philosophers.into_iter().map(|p| {
    let table = table.clone();

    thread::spawn(move || {
        p.eat(&table);
    })
}).collect();
```

<!-- Finally, inside of our `map()`/`collect()` loop, we call `table.clone()`. The -->
<!-- `clone()` method on `Arc<T>` is what bumps up the reference count, and when it -->
<!-- goes out of scope, it decrements the count. This is needed so that we know how -->
<!-- many references to `table` exist across our threads. If we didn’t have a count, -->
<!-- we wouldn’t know how to deallocate it. -->
最後に、 `map()` / `collect()` ループの中で、 `table.clone()` を呼び出します。 `Arc<T>` の `clone()` メソッドにより参照カウントが増加し、
スコープ外に出たときは、参照カウントが減算されます。これは、スレッドを跨いで `table` への参照が何個あるかを知るのに必要です。
参照カウントを行わないと、いつ解放すればよいかが分からなくなってしまいます。

<!-- You’ll notice we can introduce a new binding to `table` here, and it will -->
<!-- shadow the old one. This is often used so that you don’t need to come up with -->
<!-- two unique names. -->
ここでは新しい束縛 `table` を導入して、古い方を覆い隠していることに気付くでしょう。
これは2つの異なる名前を必要としないため、よく用いられる方法です。

<!-- With this, our program works! Only two philosophers can eat at any one time, ->
<!-- and so you’ll get some output like this: -->
これで、プログラムが動くようになりました!2人の哲学者だけが同時に食事できるようになり、次のような出力がえられるでしょう:

```text
Gilles Deleuze is eating.
Emma Goldman is eating.
Emma Goldman is done eating.
Gilles Deleuze is done eating.
Judith Butler is eating.
Karl Marx is eating.
Judith Butler is done eating.
Michel Foucault is eating.
Karl Marx is done eating.
Michel Foucault is done eating.
```

<!-- Congrats! You’ve implemented a classic concurrency problem in Rust. -->
おめでとう!古典並行処理問題をRustを使って実装できましたね。
