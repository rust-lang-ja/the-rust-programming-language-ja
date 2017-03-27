% 他言語関数インターフェイス
<!-- % Foreign Function Interface -->

<!-- # Introduction -->
# 導入

<!-- This guide will use the [snappy](https://github.com/google/snappy) -->
<!-- compression/decompression library as an introduction to writing bindings for -->
<!-- foreign code. Rust is currently unable to call directly into a C++ library, but -->
<!-- snappy includes a C interface (documented in -->
<!-- [`snappy-c.h`](https://github.com/google/snappy/blob/master/snappy-c.h)). -->
このガイドでは、他言語コードのためのバインディングを書く導入に [snappy](https://github.com/google/snappy) という圧縮・展開ライブラリを使います。
Rustは現在、C++ライブラリを直接呼び出すことができませんが、snappyはCのインターフェイスを持っています（ドキュメントが [`snappy-c.h`](https://github.com/google/snappy/blob/master/snappy-c.h) にあります）。

<!-- ## A note about libc -->
## libcについてのメモ

<!-- Many of these examples use [the `libc` crate][libc], which provides various -->
<!-- type definitions for C types, among other things. If you’re trying these -->
<!-- examples yourself, you’ll need to add `libc` to your `Cargo.toml`: -->
これらの例の多くは [`libc`クレート][libc] を使っています。これは、主にCの様々な型の定義を提供するものです。
もしこれらの例を自分で試すのであれば、次のように `libc` を `Cargo.toml` に追加する必要があるでしょう。

```toml
[dependencies]
libc = "0.2.0"
```

[libc]: https://crates.io/crates/libc

<!-- and add `extern crate libc;` to your crate root. -->
そして、クレートのルートに `extern crate libc;` を追加しましょう。

<!-- ## Calling foreign functions -->
## 他言語関数の呼出し

<!-- The following is a minimal example of calling a foreign function which will -->
<!-- compile if snappy is installed: -->
次のコードは、snappyがインストールされていればコンパイルできる他言語関数を呼び出す最小の例です。

```no_run
# #![feature(libc)]
extern crate libc;
use libc::size_t;

#[link(name = "snappy")]
extern {
    fn snappy_max_compressed_length(source_length: size_t) -> size_t;
}

fn main() {
    let x = unsafe { snappy_max_compressed_length(100) };
    println!("max compressed length of a 100 byte buffer: {}", x);
}
```

<!-- The `extern` block is a list of function signatures in a foreign library, in -->
<!-- this case with the platform's C ABI. The `#[link(...)]` attribute is used to -->
<!-- instruct the linker to link against the snappy library so the symbols are -->
<!-- resolved. -->
`extern` ブロックは他言語ライブラリの中の関数のシグネチャ、この例ではそのプラットフォーム上のC ABIによるもののリストです。
`#[link(...)]` アトリビュートは、シンボルが解決できるように、リンカに対してsnappyのライブラリをリンクするよう指示するために使われています。

<!-- Foreign functions are assumed to be unsafe so calls to them need to be wrapped -->
<!-- with `unsafe {}` as a promise to the compiler that everything contained within -->
<!-- truly is safe. C libraries often expose interfaces that aren't thread-safe, and -->
<!-- almost any function that takes a pointer argument isn't valid for all possible -->
<!-- inputs since the pointer could be dangling, and raw pointers fall outside of -->
<!-- Rust's safe memory model. -->
他言語関数はアンセーフとみなされるので、それらを呼び出すには、この中に含まれているすべてのものが本当に安全であるということをコンパイラに対して約束するために、 `unsafe {}` で囲まなければなりません。
Cライブラリは、スレッドセーフでないインターフェイスを公開していることがありますし、ポインタを引数に取る関数のほとんどは、ポインタがダングリングポインタになる可能性を有しているので、すべての入力に対して有効なわけではありません。そして、生ポインタはRustの安全なメモリモデルから外れてしまいます。

<!-- When declaring the argument types to a foreign function, the Rust compiler can -->
<!-- not check if the declaration is correct, so specifying it correctly is part of -->
<!-- keeping the binding correct at runtime. -->
他言語関数について引数の型を宣言するとき、Rustのコンパイラはその宣言が正しいかどうかを確認することができません。それを正しく指定することは実行時にバインディングを正しく動作させるために必要なことです。

<!-- The `extern` block can be extended to cover the entire snappy API: -->
`extern` ブロックはsnappyのAPI全体をカバーするように拡張することができます。

```no_run
# #![feature(libc)]
extern crate libc;
use libc::{c_int, size_t};

#[link(name = "snappy")]
extern {
    fn snappy_compress(input: *const u8,
                       input_length: size_t,
                       compressed: *mut u8,
                       compressed_length: *mut size_t) -> c_int;
    fn snappy_uncompress(compressed: *const u8,
                         compressed_length: size_t,
                         uncompressed: *mut u8,
                         uncompressed_length: *mut size_t) -> c_int;
    fn snappy_max_compressed_length(source_length: size_t) -> size_t;
    fn snappy_uncompressed_length(compressed: *const u8,
                                  compressed_length: size_t,
                                  result: *mut size_t) -> c_int;
    fn snappy_validate_compressed_buffer(compressed: *const u8,
                                         compressed_length: size_t) -> c_int;
}
# fn main() {}
```

<!-- # Creating a safe interface -->
# 安全なインターフェイスの作成

<!-- The raw C API needs to be wrapped to provide memory safety and make use of higher-level concepts -->
<!-- like vectors. A library can choose to expose only the safe, high-level interface and hide the unsafe -->
<!-- internal details. -->
生のC APIは、メモリの安全性を提供し、ベクタのようなもっと高レベルの概念を使うようにラップしなければなりません。
ライブラリは安全で高レベルなインターフェイスのみを公開するように選択し、アンセーフな内部の詳細を隠すことができます。

<!-- Wrapping the functions which expect buffers involves using the `slice::raw` module to manipulate Rust -->
<!-- vectors as pointers to memory. Rust's vectors are guaranteed to be a contiguous block of memory. The -->
<!-- length is number of elements currently contained, and the capacity is the total size in elements of -->
<!-- the allocated memory. The length is less than or equal to the capacity. -->
バッファを期待する関数をラップするには、Rustのベクタをメモリへのポインタとして操作するために `slice::raw` モジュールを使います。
Rustのベクタは隣接したメモリのブロックであることが保証されています。
その長さは現在含んでいる要素の数で、容量は割り当てられたメモリの要素の合計のサイズです。
長さは、容量以下です。

```rust
# #![feature(libc)]
# extern crate libc;
# use libc::{c_int, size_t};
# unsafe fn snappy_validate_compressed_buffer(_: *const u8, _: size_t) -> c_int { 0 }
# fn main() {}
pub fn validate_compressed_buffer(src: &[u8]) -> bool {
    unsafe {
        snappy_validate_compressed_buffer(src.as_ptr(), src.len() as size_t) == 0
    }
}
```

<!-- The `validate_compressed_buffer` wrapper above makes use of an `unsafe` block, but it makes the -->
<!-- guarantee that calling it is safe for all inputs by leaving off `unsafe` from the function -->
<!-- signature. -->
上の `validate_compressed_buffer` ラッパは `unsafe` ブロックを使っていますが、関数のシグネチャを `unsafe` から外すことによって、その呼出しがすべての入力に対して安全であることが保証されています。

<!-- The `snappy_compress` and `snappy_uncompress` functions are more complex, since a buffer has to be -->
<!-- allocated to hold the output too. -->
結果を保持するようにバッファを割り当てなければならないため、 `snappy_compress` 関数と `snappy_uncompress` 関数はもっと複雑です。

<!-- The `snappy_max_compressed_length` function can be used to allocate a vector with the maximum -->
<!-- required capacity to hold the compressed output. The vector can then be passed to the -->
<!-- `snappy_compress` function as an output parameter. An output parameter is also passed to retrieve -->
<!-- the true length after compression for setting the length. -->
`snappy_max_compressed_length` 関数は、圧縮後の結果を保持するために必要な最大の容量のベクタを割り当てるために使うことができます。
そして、そのベクタは結果を受け取るための引数として`snappy_compress`関数に渡されます。
結果を受け取るための引数は、長さをセットするために、圧縮後の本当の長さを取得するためにも渡されます。

```rust
# #![feature(libc)]
# extern crate libc;
# use libc::{size_t, c_int};
# unsafe fn snappy_compress(a: *const u8, b: size_t, c: *mut u8,
#                           d: *mut size_t) -> c_int { 0 }
# unsafe fn snappy_max_compressed_length(a: size_t) -> size_t { a }
# fn main() {}
pub fn compress(src: &[u8]) -> Vec<u8> {
    unsafe {
        let srclen = src.len() as size_t;
        let psrc = src.as_ptr();

        let mut dstlen = snappy_max_compressed_length(srclen);
        let mut dst = Vec::with_capacity(dstlen as usize);
        let pdst = dst.as_mut_ptr();

        snappy_compress(psrc, srclen, pdst, &mut dstlen);
        dst.set_len(dstlen as usize);
        dst
    }
}
```

<!-- Decompression is similar, because snappy stores the uncompressed size as part of the compression -->
<!-- format and `snappy_uncompressed_length` will retrieve the exact buffer size required. -->
snappyは展開後のサイズを圧縮フォーマットの一部として保存していて、 `snappy_uncompressed_length` が必要となるバッファの正確なサイズを取得するため、展開も同様です。

```rust
# #![feature(libc)]
# extern crate libc;
# use libc::{size_t, c_int};
# unsafe fn snappy_uncompress(compressed: *const u8,
#                             compressed_length: size_t,
#                             uncompressed: *mut u8,
#                             uncompressed_length: *mut size_t) -> c_int { 0 }
# unsafe fn snappy_uncompressed_length(compressed: *const u8,
#                                      compressed_length: size_t,
#                                      result: *mut size_t) -> c_int { 0 }
# fn main() {}
pub fn uncompress(src: &[u8]) -> Option<Vec<u8>> {
    unsafe {
        let srclen = src.len() as size_t;
        let psrc = src.as_ptr();

        let mut dstlen: size_t = 0;
        snappy_uncompressed_length(psrc, srclen, &mut dstlen);

        let mut dst = Vec::with_capacity(dstlen as usize);
        let pdst = dst.as_mut_ptr();

        if snappy_uncompress(psrc, srclen, pdst, &mut dstlen) == 0 {
            dst.set_len(dstlen as usize);
            Some(dst)
        } else {
            None // SNAPPY_INVALID_INPUT
        }
    }
}
```

<!-- For reference, the examples used here are also available as a [library on -->
<!-- GitHub](https://github.com/thestinger/rust-snappy). -->
参考のために、ここで使った例は [GitHub上のライブラリ](https://github.com/thestinger/rust-snappy) としても置いておきます。

<!-- # Destructors -->
# デストラクタ

<!-- Foreign libraries often hand off ownership of resources to the calling code. -->
<!-- When this occurs, we must use Rust's destructors to provide safety and guarantee -->
<!-- the release of these resources (especially in the case of panic). -->
他言語ライブラリはリソースの所有権を呼出先のコードに手渡してしまうことがあります。
そういうことが起きる場合には、安全性を提供し、それらのリソースが解放されることを保証するために、Rustのデストラクタを使わなければなりません（特にパニックした場合）。

<!-- For more about destructors, see the [Drop trait](../std/ops/trait.Drop.html). -->
デストラクタについて詳しくは、[Dropトレイト](../std/ops/trait.Drop.html)を見てください。

<!-- # Callbacks from C code to Rust functions -->
# CのコードからRustの関数へのコールバック

<!-- Some external libraries require the usage of callbacks to report back their -->
<!-- current state or intermediate data to the caller. -->
<!-- It is possible to pass functions defined in Rust to an external library. -->
<!-- The requirement for this is that the callback function is marked as `extern` -->
<!-- with the correct calling convention to make it callable from C code. -->
外部のライブラリの中には、現在の状況や中間的なデータを呼出元に報告するためにコールバックを使わなければならないものがあります。
Rustで定義された関数を外部のライブラリに渡すことは可能です。
これをするために必要なのは、Cのコードから呼び出すことができるように正しい呼出規則に従って、コールバック関数を `extern` としてマークしておくことです。

<!-- The callback function can then be sent through a registration call -->
<!-- to the C library and afterwards be invoked from there. -->
そして、登録呼出しを通じてコールバック関数をCのライブラリに送ることができるようになり、後でそれらから呼び出すことができるようになります。

<!-- A basic example is: -->
基本的な例は次のとおりです。

<!-- Rust code: -->
これがRustのコードです。

```no_run
extern fn callback(a: i32) {
    println!("I'm called from C with value {0}", a);
}

#[link(name = "extlib")]
extern {
   fn register_callback(cb: extern fn(i32)) -> i32;
   fn trigger_callback();
}

fn main() {
    unsafe {
        register_callback(callback);
# //        trigger_callback(); // Triggers the callback
        trigger_callback(); // コールバックをトリガする
    }
}
```

<!-- C code: -->
これがCのコードです。

```c
typedef void (*rust_callback)(int32_t);
rust_callback cb;

int32_t register_callback(rust_callback callback) {
    cb = callback;
    return 1;
}

void trigger_callback() {
  cb(7); // Rustのcallback(7)を呼び出す
}
```

<!-- In this example Rust's `main()` will call `trigger_callback()` in C, -->
<!-- which would, in turn, call back to `callback()` in Rust. -->
この例では、Rustの `main()` がCの `trigger_callback()` を呼び出し、今度はそれが、Rustの `callback()` をコールバックしています。

<!-- ## Targeting callbacks to Rust objects -->
## Rustのオブジェクトを対象にしたコールバック

<!-- The former example showed how a global function can be called from C code. -->
<!-- However it is often desired that the callback is targeted to a special -->
<!-- Rust object. This could be the object that represents the wrapper for the -->
<!-- respective C object. -->
先程の例では、グローバルな関数をCのコードから呼ぶための方法を示してきました。
しかし、特別なRustのオブジェクトをコールバックの対象にしたいことがあります。
これは、そのオブジェクトをそれぞれCのオブジェクトのラッパとして表現することで可能になります。

<!-- This can be achieved by passing an raw pointer to the object down to the -->
<!-- C library. The C library can then include the pointer to the Rust object in -->
<!-- the notification. This will allow the callback to unsafely access the -->
<!-- referenced Rust object. -->
これは、そのオブジェクトへの生ポインタをCライブラリに渡すことで実現できます。
そして、CのライブラリはRustのオブジェクトへのポインタをその通知の中に含むことができるようになります。
これにより、そのコールバックは参照されるRustのオブジェクトにアンセーフな形でアクセスできるようになります。

<!-- Rust code: -->
これがRustのコードです。

```no_run
#[repr(C)]
struct RustObject {
    a: i32,
#    // other members
    // その他のメンバ
}

extern "C" fn callback(target: *mut RustObject, a: i32) {
    println!("I'm called from C with value {0}", a);
    unsafe {
#        // Update the value in RustObject with the value received from the callback
        // コールバックから受け取った値でRustObjectの中の値をアップデートする
        (*target).a = a;
    }
}

#[link(name = "extlib")]
extern {
   fn register_callback(target: *mut RustObject,
                        cb: extern fn(*mut RustObject, i32)) -> i32;
   fn trigger_callback();
}

fn main() {
#    // Create the object that will be referenced in the callback
    // コールバックから参照されるオブジェクトを作成する
    let mut rust_object = Box::new(RustObject { a: 5 });

    unsafe {
        register_callback(&mut *rust_object, callback);
        trigger_callback();
    }
}
```

<!-- C code: -->
これがCのコードです。

```c
typedef void (*rust_callback)(void*, int32_t);
void* cb_target;
rust_callback cb;

int32_t register_callback(void* callback_target, rust_callback callback) {
    cb_target = callback_target;
    cb = callback;
    return 1;
}

void trigger_callback() {
  cb(cb_target, 7); // Rustのcallback(&rustObject, 7)を呼び出す
}
```

<!-- ## Asynchronous callbacks -->
## 非同期コールバック

<!-- In the previously given examples the callbacks are invoked as a direct reaction -->
<!-- to a function call to the external C library. -->
<!-- The control over the current thread is switched from Rust to C to Rust for the -->
<!-- execution of the callback, but in the end the callback is executed on the -->
<!-- same thread that called the function which triggered the callback. -->
先程の例では、コールバックは外部のCライブラリへの関数呼出しに対する直接の反応として呼びだされました。
実行中のスレッドの制御はコールバックの実行のためにRustからCへ、そしてRustへと切り替わりますが、最後には、コールバックはコールバックを引き起こした関数を呼び出したものと同じスレッドで実行されます。

<!-- Things get more complicated when the external library spawns its own threads -->
<!-- and invokes callbacks from there. -->
<!-- In these cases access to Rust data structures inside the callbacks is -->
<!-- especially unsafe and proper synchronization mechanisms must be used. -->
<!-- Besides classical synchronization mechanisms like mutexes, one possibility in -->
<!-- Rust is to use channels (in `std::sync::mpsc`) to forward data from the C -->
<!-- thread that invoked the callback into a Rust thread. -->
外部のライブラリが独自のスレッドを生成し、そこからコールバックを呼び出すときには、事態はもっと複雑になります。
そのような場合、コールバックの中のRustのデータ構造へのアクセスは特にアンセーフであり、適切な同期メカニズムを使わなければなりません。
ミューテックスのような古典的な同期メカニズムの他にも、Rustではコールバックを呼び出したCのスレッドからRustのスレッドにデータを転送するために（ `std::sync::mpsc` の中の）チャネルを使うという手もあります。

<!-- If an asynchronous callback targets a special object in the Rust address space -->
<!-- it is also absolutely necessary that no more callbacks are performed by the -->
<!-- C library after the respective Rust object gets destroyed. -->
<!-- This can be achieved by unregistering the callback in the object's -->
<!-- destructor and designing the library in a way that guarantees that no -->
<!-- callback will be performed after deregistration. -->
もし、非同期のコールバックがRustのアドレス空間の中の特別なオブジェクトを対象としていれば、それぞれのRustのオブジェクトが破壊された後、Cのライブラリからそれ以上コールバックが実行されないようにすることが絶対に必要です。
これは、オブジェクトのデストラクタでコールバックの登録を解除し、登録解除後にコールバックが実行されないようにライブラリを設計することで実現できます。

<!-- # Linking -->
# リンク

<!-- The `link` attribute on `extern` blocks provides the basic building block for -->
<!-- instructing rustc how it will link to native libraries. There are two accepted -->
<!-- forms of the link attribute today: -->
`extern` ブロックの中の `link` アトリビュートは、rustcに対してネイティブライブラリをどのようにリンクするかを指示するための基本的な構成ブロックです。
今のところ、2つの形式のlinkアトリビュートが認められています。

<!-- * `#[link(name = "foo")]` -->
<!-- * `#[link(name = "foo", kind = "bar")]` -->
* `#[link(name = "foo")]`
* `#[link(name = "foo", kind = "bar")]`

<!-- In both of these cases, `foo` is the name of the native library that we're -->
<!-- linking to, and in the second case `bar` is the type of native library that the -->
<!-- compiler is linking to. There are currently three known types of native -->
<!-- libraries: -->
これらのどちらの形式でも、 `foo` はリンクするネイティブライブラリの名前で、2つ目の形式の `bar` はコンパイラがリンクするネイティブライブラリの種類です。
3つのネイティブライブラリの種類が知られています。

<!-- * Dynamic - `#[link(name = "readline")]` -->
<!-- * Static - `#[link(name = "my_build_dependency", kind = "static")]` -->
<!-- * Frameworks - `#[link(name = "CoreFoundation", kind = "framework")]` -->
* ダイナミック - `#[link(name = "readline")]`
* スタティック - `#[link(name = "my_build_dependency", kind = "static")]`
* フレームワーク - `#[link(name = "CoreFoundation", kind = "framework")]`

<!-- Note that frameworks are only available on OSX targets. -->
フレームワークはOSXターゲットでのみ利用可能であることに注意しましょう。

<!-- The different `kind` values are meant to differentiate how the native library -->
<!-- participates in linkage. From a linkage perspective, the Rust compiler creates -->
<!-- two flavors of artifacts: partial (rlib/staticlib) and final (dylib/binary). -->
<!-- Native dynamic library and framework dependencies are propagated to the final -->
<!-- artifact boundary, while static library dependencies are not propagated at -->
<!-- all, because the static libraries are integrated directly into the subsequent -->
<!-- artifact. -->
異なる `kind` の値はリンク時のネイティブライブラリの使われ方の違いを意味します。
リンクの視点からすると、Rustコンパイラは2種類の生成物を作ります。
部分生成物（rlib/staticlib）と最終生成物（dylib/binary）です。
ネイティブダイナミックライブラリとフレームワークの依存関係は最終生成物を作るときまで伝播され解決されますが、スタティックライブラリの依存関係は全く伝えません。なぜなら、スタティックライブラリはその後に続く生成物に直接統合されてしまうからです。

<!-- A few examples of how this model can be used are: -->
このモデルをどのように使うことができるのかという例は次のとおりです。

<!-- * A native build dependency. Sometimes some C/C++ glue is needed when writing -->
<!--   some Rust code, but distribution of the C/C++ code in a library format is just -->
<!--   a burden. In this case, the code will be archived into `libfoo.a` and then the -->
<!--   Rust crate would declare a dependency via `#[link(name = "foo", kind = -->
<!--   "static")]`. -->
* ネイティブビルドの依存関係。
  ときどき、Rustのコードを書くときにC/C++のグルーが必要になりますが、ライブラリの形式でのC/C++のコードの配布は重荷でしかありません。
  このような場合、 コードは `libfoo.a` にアーカイブされ、それからRustのクレートで `#[link(name = "foo", kind = "static")]` によって依存関係を宣言します。

<!--   Regardless of the flavor of output for the crate, the native static library -->
<!--   will be included in the output, meaning that distribution of the native static -->
<!--   library is not necessary. -->
   クレートの成果物の種類にかかわらず、ネイティブスタティックライブラリは成果物に含まれます。これは、ネイティブスタティックライブラリの配布は不要だということを意味します。

<!-- * A normal dynamic dependency. Common system libraries (like `readline`) are -->
<!--   available on a large number of systems, and often a static copy of these -->
<!--   libraries cannot be found. When this dependency is included in a Rust crate, -->
<!--   partial targets (like rlibs) will not link to the library, but when the rlib -->
<!--   is included in a final target (like a binary), the native library will be -->
<!--   linked in. -->
*  通常のダイナミックな依存関係。
   （ `readline` のような）一般的なシステムライブラリは多くのシステムで利用可能となっていますが、それらのライブラリのスタティックなコピーは見付からないことがしばしばあります。
   この依存関係をRustのクレートに含めるときには、（rlibのような）部分生成物のターゲットはライブラリをリンクしませんが、（binaryのような）最終生成物にrlibを含めるときには、ネイティブライブラリはリンクされます。

<!-- On OSX, frameworks behave with the same semantics as a dynamic library. -->
OSXでは、フレームワークはダイナミックライブラリと同じ意味で振る舞います。

<!-- # Unsafe blocks -->
# アンセーフブロック

<!-- Some operations, like dereferencing raw pointers or calling functions that have been marked -->
<!-- unsafe are only allowed inside unsafe blocks. Unsafe blocks isolate unsafety and are a promise to -->
<!-- the compiler that the unsafety does not leak out of the block. -->
生ポインタの参照外しやアンセーフであるとマークされた関数の呼出しなど、いくつかの作業はアンセーフブロックの中でのみ許されます。
アンセーフブロックはアンセーフ性を隔離し、コンパイラに対してアンセーフ性がブロックの外に漏れ出さないことを約束します。

<!-- Unsafe functions, on the other hand, advertise it to the world. An unsafe function is written like -->
<!-- this: -->
一方、アンセーフな関数はそれを全世界に向けて広告します。
アンセーフな関数はこのように書きます。

```rust
unsafe fn kaboom(ptr: *const i32) -> i32 { *ptr }
```

<!-- This function can only be called from an `unsafe` block or another `unsafe` function. -->
この関数は `unsafe` ブロック又は他の `unsafe` な関数からのみ呼び出すことができます。

<!-- # Accessing foreign globals -->
# 他言語のグローバル変数へのアクセス

<!-- Foreign APIs often export a global variable which could do something like track -->
<!-- global state. In order to access these variables, you declare them in `extern` -->
<!-- blocks with the `static` keyword: -->
他言語APIはしばしばグローバルな状態を追跡するようなことをするためのグローバル変数をエクスポートします。
それらの値にアクセスするために、それらを `extern` ブロックの中で `static` キーワードを付けて宣言します。

```no_run
# #![feature(libc)]
extern crate libc;

#[link(name = "readline")]
extern {
    static rl_readline_version: libc::c_int;
}

fn main() {
    println!("You have readline version {} installed.",
             rl_readline_version as i32);
}
```

<!-- Alternatively, you may need to alter global state provided by a foreign -->
<!-- interface. To do this, statics can be declared with `mut` so we can mutate -->
<!-- them. -->
あるいは、他言語インターフェイスが提供するグローバルな状態を変更しなければならないこともあるかもしれません。
これをするために、スタティックな値を変更することができるように `mut` 付きで宣言することができます。

```no_run
# #![feature(libc)]
extern crate libc;

use std::ffi::CString;
use std::ptr;

#[link(name = "readline")]
extern {
    static mut rl_prompt: *const libc::c_char;
}

fn main() {
    let prompt = CString::new("[my-awesome-shell] $").unwrap();
    unsafe {
        rl_prompt = prompt.as_ptr();

        println!("{:?}", rl_prompt);

        rl_prompt = ptr::null();
    }
}
```

<!-- Note that all interaction with a `static mut` is unsafe, both reading and -->
<!-- writing. Dealing with global mutable state requires a great deal of care. -->
`static mut` の付いた作用は全て、読込みと書込みの双方についてアンセーフであることに注意しましょう。
グローバルでミュータブルな状態の扱いには多大な注意が必要です。

<!-- # Foreign calling conventions -->
# 他言語呼出規則

<!-- Most foreign code exposes a C ABI, and Rust uses the platform's C calling convention by default when -->
<!-- calling foreign functions. Some foreign functions, most notably the Windows API, use other calling -->
<!-- conventions. Rust provides a way to tell the compiler which convention to use: -->
他言語で書かれたコードの多くはC ABIをエクスポートしていて、Rustは他言語関数の呼出しのときのデフォルトとしてそのプラットフォーム上のCの呼出規則を使います。
他言語関数の中には、特にWindows APIですが、他の呼出規則を使うものもあります。
Rustにはコンパイラに対してどの規則を使うかを教える方法があります。

```rust
# #![feature(libc)]
extern crate libc;

#[cfg(all(target_os = "win32", target_arch = "x86"))]
#[link(name = "kernel32")]
#[allow(non_snake_case)]
extern "stdcall" {
    fn SetEnvironmentVariableA(n: *const u8, v: *const u8) -> libc::c_int;
}
# fn main() { }
```

<!-- This applies to the entire `extern` block. The list of supported ABI constraints -->
<!-- are: -->
これは `extern` ブロック全体に適用されます。
サポートされているABIの規則は次のとおりです。

* `stdcall`
* `aapcs`
* `cdecl`
* `fastcall`
* `Rust`
* `rust-intrinsic`
* `system`
* `C`
* `win64`

<!-- Most of the abis in this list are self-explanatory, but the `system` abi may -->
<!-- seem a little odd. This constraint selects whatever the appropriate ABI is for -->
<!-- interoperating with the target's libraries. For example, on win32 with a x86 -->
<!-- architecture, this means that the abi used would be `stdcall`. On x86_64, -->
<!-- however, windows uses the `C` calling convention, so `C` would be used. This -->
<!-- means that in our previous example, we could have used `extern "system" { ... }` -->
<!-- to define a block for all windows systems, not just x86 ones. -->
このリストのABIのほとんどは名前のとおりですが、 `system` ABIは少し変わっています。
この規則はターゲットのライブラリを相互利用するために適切なABIを選択します。
例えば、x86アーキテクチャのWin32では、使われるABIは `stdcall` になります。
しかし、x86_64では、Windowsは `C` の呼出規則を使うので、 `C` が使われます。
先程の例で言えば、 `extern "system" { ... }` を使って、x86のためだけではなく全てのWindowsシステムのためのブロックを定義することができるということです。

<!-- # Interoperability with foreign code -->
# 他言語コードの相互利用

<!-- Rust guarantees that the layout of a `struct` is compatible with the platform's -->
<!-- representation in C only if the `#[repr(C)]` attribute is applied to it. -->
<!-- `#[repr(C, packed)]` can be used to lay out struct members without padding. -->
<!-- `#[repr(C)]` can also be applied to an enum. -->
`#[repr(C)]` アトリビュートが適用されている場合に限り、Rustは `struct` のレイアウトとそのプラットフォーム上のCでの表現方法との互換性を保証します。
`#[repr(C, packed)]` を使えば、パディングなしで構造体のメンバをレイアウトすることができます。
`#[repr(C)]` は列挙型にも適用することができます。

<!-- Rust's owned boxes (`Box<T>`) use non-nullable pointers as handles which point -->
<!-- to the contained object. However, they should not be manually created because -->
<!-- they are managed by internal allocators. References can safely be assumed to be -->
<!-- non-nullable pointers directly to the type.  However, breaking the borrow -->
<!-- checking or mutability rules is not guaranteed to be safe, so prefer using raw -->
<!-- pointers (`*`) if that's needed because the compiler can't make as many -->
<!-- assumptions about them. -->
Rust独自のボックス（ `Box<T>` ）は包んでいるオブジェクトを指すハンドルとして非ヌルポインタを使います。
しかし、それらは内部のアロケータによって管理されるため、手で作るべきではありません。
参照は型を直接指す非ヌルポインタとみなすことが安全にできます。
しかし、借用チェックやミュータブルについてのルールが破られた場合、安全性は保証されません。生ポインタについてはコンパイラは借用チェックやミュータブルほどには仮定を置かないので、必要なときには、生ポインタ（ `*` ）を使いましょう。

<!-- Vectors and strings share the same basic memory layout, and utilities are -->
<!-- available in the `vec` and `str` modules for working with C APIs. However, -->
<!-- strings are not terminated with `\0`. If you need a NUL-terminated string for -->
<!-- interoperability with C, you should use the `CString` type in the `std::ffi` -->
<!-- module. -->
ベクタと文字列は基本的なメモリレイアウトを共有していて、 `vec` モジュールと `str` モジュールの中のユーティリティはC APIで扱うために使うことができます。
ただし、文字列は `\0` で終わりません。
Cと相互利用するためにNUL終端の文字列が必要であれば、 `std::ffi` モジュールの `CString` 型を使う必要があります。

<!-- The [`libc` crate on crates.io][libc] includes type aliases and function -->
<!-- definitions for the C standard library in the `libc` module, and Rust links -->
<!-- against `libc` and `libm` by default. -->
[crates.ioの`libc`クレート][libc] は `libc` モジュール内にCの標準ライブラリの型の別名や関数の定義を含んでいて、Rustは `libc` と `libm` をデフォルトでリンクします。

<!-- # The "nullable pointer optimization" -->
# 「ヌルになり得るポインタの最適化」

<!-- Certain types are defined to not be `null`. This includes references (`&T`, -->
<!-- `&mut T`), boxes (`Box<T>`), and function pointers (`extern "abi" fn()`). -->
<!-- When interfacing with C, pointers that might be null are often used. -->
<!-- As a special case, a generic `enum` that contains exactly two variants, one of -->
<!-- which contains no data and the other containing a single field, is eligible -->
<!-- for the "nullable pointer optimization". When such an enum is instantiated -->
<!-- with one of the non-nullable types, it is represented as a single pointer, -->
<!-- and the non-data variant is represented as the null pointer. So -->
<!-- `Option<extern "C" fn(c_int) -> c_int>` is how one represents a nullable -->
<!-- function pointer using the C ABI. -->
いくつかの型は非 `null` であると定義されています。
このようなものには、参照（ `&T` 、 `&mut T` ）、ボックス（ `Box<T>` ）、そして関数ポインタ（ `extern "abi" fn()` ）があります。
Cとのインターフェイスにおいては、ヌルになり得るポインタが使われることがしばしばあります。
特別な場合として、ジェネリックな `enum` がちょうど2つのバリアントを持ち、そのうちの1つが値を持っていなくてもう1つが単一のフィールドを持っているとき、それは「ヌルになり得るポインタの最適化」の対象になります。
そのような列挙型が非ヌルの型でインスタンス化されたとき、それは単一のポインタとして表現され、データを持っていない方のバリアントはヌルポインタとして表現されます。
`Option<extern "C" fn(c_int) -> c_int>` は、C ABIで使われるヌルになり得る関数ポインタの表現方法の1つです。

<!-- # Calling Rust code from C -->
# CからのRustのコードの呼出し

<!-- You may wish to compile Rust code in a way so that it can be called from C. This is -->
<!-- fairly easy, but requires a few things: -->
RustのコードをCから呼び出せる方法でコンパイルしたいときがあるかもしれません。
これは割と簡単ですが、いくつか必要なことがあります。

```rust
#[no_mangle]
pub extern fn hello_rust() -> *const u8 {
    "Hello, world!\0".as_ptr()
}
# fn main() {}
```

<!-- The `extern` makes this function adhere to the C calling convention, as -->
<!-- discussed above in "[Foreign Calling -->
<!-- Conventions](ffi.html#foreign-calling-conventions)". The `no_mangle` -->
<!-- attribute turns off Rust's name mangling, so that it is easier to link to. -->
`extern` は先程「 [他言語呼出規則](ffi.html#foreign-calling-conventions) 」で議論したように、この関数をCの呼出規則に従うようにします。
`no_mangle` アトリビュートはRustによる名前のマングリングをオフにして、リンクしやすいようにします。

<!-- # FFI and panics -->
# FFIとパニック

<!-- It’s important to be mindful of `panic!`s when working with FFI. A `panic!` -->
<!-- across an FFI boundary is undefined behavior. If you’re writing code that may -->
<!-- panic, you should run it in another thread, so that the panic doesn’t bubble up -->
<!-- to C: -->
FFIを扱うときに `panic!` に注意することは重要です。
FFIの境界をまたぐ `panic!` の動作は未定義です。
もしあなたがパニックし得るコードを書いているのであれば、他のスレッドで実行して、パニックがCに波及しないようにすべきです。

```rust
use std::thread;

#[no_mangle]
pub extern fn oh_no() -> i32 {
    let h = thread::spawn(|| {
        panic!("Oops!");
    });

    match h.join() {
        Ok(_) => 1,
        Err(_) => 0,
    }
}
# fn main() {}
```

<!-- # Representing opaque structs -->
# オペーク構造体の表現

<!-- Sometimes, a C library wants to provide a pointer to something, but not let you -->
<!-- know the internal details of the thing it wants. The simplest way is to use a -->
<!-- `void *` argument: -->
ときどき、Cのライブラリが何かのポインタを要求してくるにもかかわらず、その要求されているものの内部的な詳細を教えてくれないことがあります。
最も単純な方法は `void *` 引数を使うことです。

```c
void foo(void *arg);
void bar(void *arg);
```

<!-- We can represent this in Rust with the `c_void` type: -->
Rustではこれを `c_void` 型で表現することができます。

```rust
# #![feature(libc)]
extern crate libc;

extern "C" {
    pub fn foo(arg: *mut libc::c_void);
    pub fn bar(arg: *mut libc::c_void);
}
# fn main() {}
```

<!-- This is a perfectly valid way of handling the situation. However, we can do a bit -->
<!-- better. To solve this, some C libraries will instead create a `struct`, where -->
<!-- the details and memory layout of the struct are private. This gives some amount -->
<!-- of type safety. These structures are called ‘opaque’. Here’s an example, in C: -->
これはその状況に対処するための完全に正当な方法です。
しかし、もっとよい方法があります。
これを解決するために、いくつかのCライブラリでは、代わりに `struct` を作っています。そこでは構造体の詳細とメモリレイアウトはプライベートです。
これは型の安全性をいくらか満たします。
それらの構造体は「オペーク」と呼ばれます。
これがCによる例です。

```c
struct Foo; /* Fooは構造体だが、その内容は公開インターフェイスの一部ではない */
struct Bar;
void foo(struct Foo *arg);
void bar(struct Bar *arg);
```

<!-- To do this in Rust, let’s create our own opaque types with `enum`: -->
これをRustで実現するために、`enum`で独自のオペーク型を作りましょう。

```rust
pub enum Foo {}
pub enum Bar {}

extern "C" {
    pub fn foo(arg: *mut Foo);
    pub fn bar(arg: *mut Bar);
}
# fn main() {}
```

<!-- By using an `enum` with no variants, we create an opaque type that we can’t -->
<!-- instantiate, as it has no variants. But because our `Foo` and `Bar` types are -->
<!-- different, we’ll get type safety between the two of them, so we cannot -->
<!-- accidentally pass a pointer to `Foo` to `bar()`. -->
バリアントなしの `enum` を使って、バリアントがないためにインスタンス化できないオペーク型を作ります。
しかし、 `Foo` 型と `Bar` 型は異なる型であり、2つものの間の型の安全性を満たすので、 `Foo` のポインタを間違って `bar()` に渡すことはなくなります。
