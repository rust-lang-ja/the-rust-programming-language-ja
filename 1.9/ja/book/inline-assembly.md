% インラインアセンブリ
<!-- % Inline Assembly -->

<!-- For extremely low-level manipulations and performance reasons, one -->
<!-- might wish to control the CPU directly. Rust supports using inline -->
<!-- assembly to do this via the `asm!` macro. -->
極めて低レベルな技巧やパフォーマンス上の理由から、CPUを直接コントロールしたいと思う人もいるでしょう。
Rustはそのような処理を行うために、インラインアセンブリを `asm!` マクロによってサポートしています。

```ignore
# // asm!(assembly template
asm!(アセンブリのテンプレート
# //   : output operands
   : 出力オペランド
# //   : input operands
   : 入力オペランド
# //   : clobbers
   : 破壊されるデータ
# //   : options
   : オプション
   );
```

<!-- Any use of `asm` is feature gated (requires `#![feature(asm)]` on the -->
<!-- crate to allow) and of course requires an `unsafe` block. -->
`asm` のいかなる利用もフィーチャーゲートの対象です（利用するには `#![feature(asm)]` がクレートに必要になります）。
そしてもちろん `unsafe` ブロックも必要です。

<!-- &gt; **Note**: the examples here are given in x86/x86-64 assembly, but -->
<!-- &gt; all platforms are supported. -->
> **メモ**: ここでの例はx86/x86-64のアセンブリで示されますが、すべてのプラットフォームがサポートされています。

<!-- ## Assembly template -->
## アセンブリテンプレート

<!-- The `assembly template` is the only required parameter and must be a -->
<!-- literal string (i.e. `""`) -->
`アセンブリテンプレート` のみが要求されるパラメータであり、文字列リテラル (例: `""`) である必要があります。

```rust
#![feature(asm)]

#[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
fn foo() {
    unsafe {
        asm!("NOP");
    }
}

# // other platforms
// その他のプラットフォーム
#[cfg(not(any(target_arch = "x86", target_arch = "x86_64")))]
fn foo() { /* ... */ }

fn main() {
    // ...
    foo();
    // ...
}
```

<!-- (The `feature(asm)` and `#[cfg]`s are omitted from now on.) -->
以後は、 `feature(asm)` と `#[cfg]` は省略して示します。

<!-- Output operands, input operands, clobbers and options are all optional -->
<!-- but you must add the right number of `:` if you skip them: -->
出力オペランド、入力オペランド、破壊されるデータ、オプションはすべて省略可能ですが、省略する場合でも正しい数の `:` を書く必要があります。

```rust
# #![feature(asm)]
# #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
# fn main() { unsafe {
asm!("xor %eax, %eax"
    :
    :
    : "{eax}"
   );
# } }
```

<!-- Whitespace also doesn't matter: -->
空白も必要ではありません:

```rust
# #![feature(asm)]
# #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
# fn main() { unsafe {
asm!("xor %eax, %eax" ::: "{eax}");
# } }
```

<!-- ## Operands -->
## オペランド

<!-- Input and output operands follow the same format: `: -->
<!-- "constraints1"(expr1), "constraints2"(expr2), ..."`. Output operand -->
<!-- expressions must be mutable lvalues, or not yet assigned: -->
入力と出力のオペランドは、 `: "制約1"(式1), "制約2"(式2), ...` というフォーマットに従います。
出力オペランドの式は変更可能な左辺値か、アサインされていない状態でなければなりません。

```rust
# #![feature(asm)]
# #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
fn add(a: i32, b: i32) -> i32 {
    let c: i32;
    unsafe {
        asm!("add $2, $0"
             : "=r"(c)
             : "0"(a), "r"(b)
             );
    }
    c
}
# #[cfg(not(any(target_arch = "x86", target_arch = "x86_64")))]
# fn add(a: i32, b: i32) -> i32 { a + b }

fn main() {
    assert_eq!(add(3, 14159), 14162)
}
```

<!-- If you would like to use real operands in this position, however, -->
<!-- you are required to put curly braces `{}` around the register that -->
<!-- you want, and you are required to put the specific size of the -->
<!-- operand. This is useful for very low level programming, where -->
<!-- which register you use is important: -->
もし本当のオペランドをここで利用したい場合、波括弧 `{}` で利用したいレジスタの周りを囲む必要があり、また、オペランドの特有のサイズを書く必要があります。
これは、どのレジスタを利用するかが重要となる、ごく低レベルのプログラミングで有用です。

```rust
# #![feature(asm)]
# #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
# unsafe fn read_byte_in(port: u16) -> u8 {
let result: u8;
asm!("in %dx, %al" : "={al}"(result) : "{dx}"(port));
result
# }
```

<!-- ## Clobbers -->
## 破壊されるデータ

<!-- Some instructions modify registers which might otherwise have held -->
<!-- different values so we use the clobbers list to indicate to the -->
<!-- compiler not to assume any values loaded into those registers will -->
<!-- stay valid. -->
いくつかのインストラクションは異なる値を持っている可能性のあるレジスタを変更する事があります。
そのため、コンパイラがそれらのレジスタに格納された値が処理後にも有効であると思わないように、破壊されるデータのリストを利用します。

```rust
# #![feature(asm)]
# #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
# fn main() { unsafe {
# // Put the value 0x200 in eax
// eaxに0x200を格納します
# // asm!("mov $$0x200, %eax" : /* no outputs */ : /* no inputs */ : "{eax}");
asm!("mov $$0x200, %eax" : /* 出力なし */ : /* 入力無し */ : "{eax}");
# } }
```

<!-- Input and output registers need not be listed since that information -->
<!-- is already communicated by the given constraints. Otherwise, any other -->
<!-- registers used either implicitly or explicitly should be listed. -->
入力と出力のレジスタは変更される可能性があることが制約によってすでに伝わっているために、リストに載せる必要はありません。
それ以外では、その他の暗黙的、明示的に利用されるレジスタをリストに載せる必要があります。

<!-- If the assembly changes the condition code register `cc` should be -->
<!-- specified as one of the clobbers. Similarly, if the assembly modifies -->
<!-- memory, `memory` should also be specified. -->
もしアセンブリが条件コードを変更する場合、レジスタ `cc` も破壊されるデータのリストに指定する必要があります。
同様に、もしアセンブリがメモリを変更する場合 `memory` もリストに指定する必要があります。

<!-- ## Options -->
## オプション

<!-- The last section, `options` is specific to Rust. The format is comma -->
<!-- separated literal strings (i.e. `:"foo", "bar", "baz"`). It's used to -->
<!-- specify some extra info about the inline assembly: -->
最後のセクション、 `options` はRust特有のものです。
`options` の形式は、コンマで区切られた文字列リテラルのリスト（例: `:"foo", "bar", "baz"`）です。
これはインラインアセンブリについての追加の情報を指定するために利用されます:

<!-- Current valid options are: -->
現在有効なオプションは以下の通りです:

<!-- 1. *volatile* - specifying this is analogous to-->
<!--    `__asm__ __volatile__ (...)` in gcc/clang.-->
<!-- 2. *alignstack* - certain instructions expect the stack to be-->
<!--    aligned a certain way (i.e. SSE) and specifying this indicates to-->
<!--    the compiler to insert its usual stack alignment code-->
<!-- 3. *intel* - use intel syntax instead of the default AT&T.-->
1. *volatile* - このオプションを指定することは、gcc/clangで `__asm__ __volatile__ (...)` を指定することと類似しています。
2. *alignstack* - いくつかのインストラクションはスタックが決まった方式（例: SSE）でアラインされていることを期待しています。
   このオプションを指定することはコンパイラに通常のスタックをアラインメントするコードの挿入を指示します。
3. *intel* - デフォルトのAT&T構文の代わりにインテル構文を利用することを意味しています。

```rust
# #![feature(asm)]
# #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
# fn main() {
let result: i32;
unsafe {
   asm!("mov eax, 2" : "={eax}"(result) : : : "intel")
}
println!("eax is currently {}", result);
# }
```

<!-- ## More Information -->
## さらなる情報

<!-- The current implementation of the `asm!` macro is a direct binding to [LLVM's -->
<!-- inline assembler expressions][llvm-docs], so be sure to check out [their -->
<!-- documentation as well][llvm-docs] for more information about clobbers, -->
<!-- constraints, etc. -->
現在の `asm!` マクロの実装は [LLVMのインラインアセンブリ表現][llvm-docs] への直接的なバインディングです。
そのため破壊されるデータのリストや、制約、その他の情報について [LLVMのドキュメント][llvm-docs] を確認してください。

[llvm-docs]: http://llvm.org/docs/LangRef.html#inline-assembler-expressions
