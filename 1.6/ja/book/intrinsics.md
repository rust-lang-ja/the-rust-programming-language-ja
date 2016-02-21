% Intrinsics

<!-- > **Note**: intrinsics will forever have an unstable interface, it is -->
<!-- > recommended to use the stable interfaces of libcore rather than intrinsics -->
<!-- > directly. -->
> **メモ**: intrinsicsのインタフェースは常に不安定です、intrinsicsを直接利用するのではなく、
> libcoreの安定なインタフェースを利用することを推奨します。

<!-- These are imported as if they were FFI functions, with the special -->
<!-- `rust-intrinsic` ABI. For example, if one was in a freestanding -->
<!-- context, but wished to be able to `transmute` between types, and -->
<!-- perform efficient pointer arithmetic, one would import those functions -->
<!-- via a declaration like -->
intrinsicsは特別なABI `rust-intrinsic` を用いて、FFIの関数で有るかのようにインポートされます。
例えば、独立したコンテキストの中で型の間の `transmute` をしたい場合や、効率的なポインタ演算を行いたい場合、
それらの関数を以下ような宣言を通してインポートします

```rust
#![feature(intrinsics)]
# fn main() {}

extern "rust-intrinsic" {
    fn transmute<T, U>(x: T) -> U;

    fn offset<T>(dst: *const T, offset: isize) -> *const T;
}
```

<!-- As with any other FFI functions, these are always `unsafe` to call. -->
他のFFI関数と同様に、呼出は常に `unsafe` です。
