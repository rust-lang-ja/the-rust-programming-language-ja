% ベンチマークテスト
<!-- % Benchmark tests -->

<!-- Rust supports benchmark tests, which can test the performance of your -->
<!-- code. Let's make our `src/lib.rs` look like this (comments elided): -->
Rustはコードのパフォーマンスをテストできるベンチマークテストをサポートしています。
早速、`src/lib.rc`を以下のように作っていきましょう(コメントは省略しています):

```rust,ignore
#![feature(test)]

extern crate test;

pub fn add_two(a: i32) -> i32 {
    a + 2
}

#[cfg(test)]
mod tests {
    use super::*;
    use test::Bencher;

    #[test]
    fn it_works() {
        assert_eq!(4, add_two(2));
    }

    #[bench]
    fn bench_add_two(b: &mut Bencher) {
        b.iter(|| add_two(2));
    }
}
```

<!-- Note the `test` feature gate, which enables this unstable feature. -->
不安定なベンチマークのフィーチャーを有効にするため、 `test` フィーチャーゲートを利用していることに注意して下さい。

<!-- We've imported the `test` crate, which contains our benchmarking support. -->
<!-- We have a new function as well, with the `bench` attribute. Unlike regular -->
<!-- tests, which take no arguments, benchmark tests take a `&mut Bencher`. This -->
<!-- `Bencher` provides an `iter` method, which takes a closure. This closure -->
<!-- contains the code we'd like to benchmark. -->
ベンチマークテストのサポートを含んだ `test` クレートをインポートしています。
また、 `bench` アトリビュートのついた新しい関数を定義しています。
引数を取らない通常のテストとは異なり、ベンチマークテストは `&mut Bencher` を引数に取ります。
`Bencher` はベンチマークしたいコードを含んだクロージャを引数に取る `iter` メソッドを提供しています。

<!-- We can run benchmark tests with `cargo bench`: -->
ベンチマークテストは以下のように `cargo bench` のようにして実施できます:

```bash
$ cargo bench
   Compiling adder v0.0.1 (file:///home/steve/tmp/adder)
     Running target/release/adder-91b3e234d4ed382a

running 2 tests
test tests::it_works ... ignored
test tests::bench_add_two ... bench:         1 ns/iter (+/- 0)

test result: ok. 0 passed; 0 failed; 1 ignored; 1 measured
```

<!-- Our non-benchmark test was ignored. You may have noticed that `cargo bench` -->
<!-- takes a bit longer than `cargo test`. This is because Rust runs our benchmark -->
<!-- a number of times, and then takes the average. Because we're doing so little -->
<!-- work in this example, we have a `1 ns/iter (+/- 0)`, but this would show -->
<!-- the variance if there was one. -->
ベンチマークでないテストは無視されます。
`cargo bench` が `cargo test` よりも時間がかかることにお気づきになったかもしれません。
これは、Rustがベンチマークをかなりの回数繰り返し実行し、その結果の平均を取るためです。
今回のコードでは非常に小さな処理しか行っていないために、 `1 ns/iter (+/- 0)` という結果を得ました、
しかし、この結果は変動することがあるでしょう。

<!-- Advice on writing benchmarks: -->
以下は、ベンチマークを書くときのアドバイスです:


<!-- * Move setup code outside the `iter` loop; only put the part you want to measure inside -->
<!-- * Make the code do "the same thing" on each iteration; do not accumulate or change state -->
<!-- * Make the outer function idempotent too; the benchmark runner is likely to run -->
<!--   it many times -->
<!-- *  Make the inner `iter` loop short and fast so benchmark runs are fast and the -->
<!--    calibrator can adjust the run-length at fine resolution -->
<!-- * Make the code in the `iter` loop do something simple, to assist in pinpointing -->
<!--   performance improvements (or regressions) -->
* セットアップのコードを `iter` の外に移し、計測したい箇所のみを `iter` の中に書きましょう。
* それぞれの繰り返しでコードが「同じこと」をするようにし、集計をしたり状態を変更したりといったことはしないで下さい。
* 利用している外部の関数についても冪等にしましょう、ベンチマークはその関数をおそらく何度も実行します。
* 内側の `iter` ループを短く高速にしましょう、そうすることでベンチマークの実行は高速になり、キャリブレータは実行の長さをより良い制度で補正できるようになります。
* パフォーマンスの向上(または低下)をピンポイントで突き止められるように、`iter` ループ中のコードの処理を簡潔にしましょう。

<!-- ## Gotcha: optimizations -->
## 注意点: 最適化

<!-- There's another tricky part to writing benchmarks: benchmarks compiled with -->
<!-- optimizations activated can be dramatically changed by the optimizer so that -->
<!-- the benchmark is no longer benchmarking what one expects. For example, the -->
<!-- compiler might recognize that some calculation has no external effects and -->
<!-- remove it entirely. -->
ベンチマークを書くときに気をつけなければならないその他の点は: 最適化を有効にしてコンパイルしたベンチマークは劇的に最適化され、
もはや本来ベンチマークしたかったコードとは異なるという点です。
たとえば、コンパイラは幾つかの計算がなにも外部に影響を及ぼさないことを認識してそれらの計算を取り除くかもしれません。

```rust,ignore
#![feature(test)]

extern crate test;
use test::Bencher;

#[bench]
fn bench_xor_1000_ints(b: &mut Bencher) {
    b.iter(|| {
        (0..1000).fold(0, |old, new| old ^ new);
    });
}
```

<!-- gives the following results -->
このベンチマークは以下の様な結果となります

```text
running 1 test
test bench_xor_1000_ints ... bench:         0 ns/iter (+/- 0)

test result: ok. 0 passed; 0 failed; 0 ignored; 1 measured
```

<!-- The benchmarking runner offers two ways to avoid this. Either, the closure that -->
<!-- the `iter` method receives can return an arbitrary value which forces the -->
<!-- optimizer to consider the result used and ensures it cannot remove the -->
<!-- computation entirely. This could be done for the example above by adjusting the -->
<!-- `b.iter` call to -->
ベンチマークランナーはこの問題を避ける2つの手段を提供します。
`iter` メソッドが受け取るクロージャは任意の値を返すことができ、
オプティマイザに計算の結果が利用されていると考えさせ、その計算を取り除くことができないと保証することができます。
これは、上のコードにおいて `b.iter` の呼出を以下のようにすることで可能です:

```rust
# struct X;
# impl X { fn iter<T, F>(&self, _: F) where F: FnMut() -> T {} } let b = X;
b.iter(|| {
    // note lack of `;` (could also use an explicit `return`).
    (0..1000).fold(0, |old, new| old ^ new)
});
```

<!-- Or, the other option is to call the generic `test::black_box` function, which -->
<!-- is an opaque "black box" to the optimizer and so forces it to consider any -->
<!-- argument as used. -->
もう一つの方法としては、ジェネリックな `test::black_box` 関数を呼び出すという手段が有ります、
`test::black_box` 関数はオプティマイザにとって不透明な「ブラックボックス」であり、
オプティマイザに引数のどれもが利用されていると考えさせることができます。

```rust
#![feature(test)]

extern crate test;

# fn main() {
# struct X;
# impl X { fn iter<T, F>(&self, _: F) where F: FnMut() -> T {} } let b = X;
b.iter(|| {
    let n = test::black_box(1000);

    (0..n).fold(0, |a, b| a ^ b)
})
# }
```

<!-- Neither of these read or modify the value, and are very cheap for small values. -->
<!-- Larger values can be passed indirectly to reduce overhead (e.g. -->
<!-- `black_box(&huge_struct)`). -->
2つの手段のどちらも値を読んだり変更したりせず、小さな値に対して非常に低コストです。
大きな値は、オーバーヘッドを減らすために間接的に渡すことができます(例: `black_box(&huge_struct)`)。

<!-- Performing either of the above changes gives the following benchmarking results -->
上記のどちらかの変更を施すことでベンチマークの結果は以下のようになります

```text
running 1 test
test bench_xor_1000_ints ... bench:       131 ns/iter (+/- 3)

test result: ok. 0 passed; 0 failed; 0 ignored; 1 measured
```

<!-- However, the optimizer can still modify a testcase in an undesirable manner -->
<!-- even when using either of the above. -->
しかしながら、上のどちらかの方法をとったとしても依然オプティマイザはテストケースを望まない形で変更する場合があります。
