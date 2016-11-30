% 構文の索引
<!-- % Syntax Index -->

<!-- ## Keywords -->
## キーワード

<!-- * `as`: primitive casting, or disambiguating the specific trait containing an item.  See [Casting Between Types (`as`)], [Universal Function Call Syntax (Angle-bracket Form)], [Associated Types]. -->
<!-- * `break`: break out of loop.  See [Loops (Ending Iteration Early)]. -->
<!-- * `const`: constant items and constant raw pointers.  See [`const` and `static`], [Raw Pointers]. -->
<!-- * `continue`: continue to next loop iteration.  See [Loops (Ending Iteration Early)]. -->
<!-- * `crate`: external crate linkage.  See [Crates and Modules (Importing External Crates)]. -->
<!-- * `else`: fallback for `if` and `if let` constructs.  See [`if`], [`if let`]. -->
<!-- * `enum`: defining enumeration.  See [Enums]. -->
<!-- * `extern`: external crate, function, and variable linkage.  See [Crates and Modules (Importing External Crates)], [Foreign Function Interface]. -->
<!-- * `false`: boolean false literal.  See [Primitive Types (Booleans)]. -->
<!-- * `fn`: function definition and function pointer types.  See [Functions]. -->
<!-- * `for`: iterator loop, part of trait `impl` syntax, and higher-ranked lifetime syntax.  See [Loops (`for`)], [Method Syntax]. -->
<!-- * `if`: conditional branching.  See [`if`], [`if let`]. -->
<!-- * `impl`: inherent and trait implementation blocks.  See [Method Syntax]. -->
<!-- * `in`: part of `for` loop syntax.  See [Loops (`for`)]. -->
<!-- * `let`: variable binding.  See [Variable Bindings]. -->
<!-- * `loop`: unconditional, infinite loop.  See [Loops (`loop`)]. -->
<!-- * `match`: pattern matching.  See [Match]. -->
<!-- * `mod`: module declaration.  See [Crates and Modules (Defining Modules)]. -->
<!-- * `move`: part of closure syntax.  See [Closures (`move` closures)]. -->
<!-- * `mut`: denotes mutability in pointer types and pattern bindings.  See [Mutability]. -->
<!-- * `pub`: denotes public visibility in `struct` fields, `impl` blocks, and modules.  See [Crates and Modules (Exporting a Public Interface)]. -->
<!-- * `ref`: by-reference binding.  See [Patterns (`ref` and `ref mut`)]. -->
<!-- * `return`: return from function.  See [Functions (Early Returns)]. -->
<!-- * `Self`: implementor type alias.  See [Traits]. -->
<!-- * `self`: method subject.  See [Method Syntax (Method Calls)]. -->
<!-- * `static`: global variable.  See [`const` and `static` (`static`)]. -->
<!-- * `struct`: structure definition.  See [Structs]. -->
<!-- * `trait`: trait definition.  See [Traits]. -->
<!-- * `true`: boolean true literal.  See [Primitive Types (Booleans)]. -->
<!-- * `type`: type alias, and associated type definition.  See [`type` Aliases], [Associated Types]. -->
<!-- * `unsafe`: denotes unsafe code, functions, traits, and implementations.  See [Unsafe]. -->
<!-- * `use`: import symbols into scope.  See [Crates and Modules (Importing Modules with `use`)]. -->
<!-- * `where`: type constraint clauses.  See [Traits (`where` clause)]. -->
<!-- * `while`: conditional loop.  See [Loops (`while`)]. -->
* `as`: プリミティブのキャスト。あるいはあるアイテムを含むトレイトの曖昧性の排除。 [型間のキャスト (`as`)] 、 [共通の関数呼び出し構文 (山括弧形式)] 、 [関連型] 参照。
* `break`: ループからの脱却。[ループ (反復の早期終了)] 参照。
* `const`: 定数および定数ポインタ。 [`const` と `static`] 、 [生ポインタ] 参照。
* `continue`: 次の反復への継続。 [ループ (反復の早期終了)] 参照。
* `crate`: 外部クレートのリンク。 [クレートとモジュール (外部クレートのインポート)] 参照
* `else`: `if` と `if let` が形成するフォールバック。 [`if`] 、 [`if let`] 参照。
* `enum`: 列挙型の定義。 [列挙型] 参照。
* `extern`: 外部クレート、関数、変数のリンク。  [クレートとモジュール (外部クレートのインポート)]、 [他言語関数インターフェイス] 参照。
* `false`: ブーリアン型の偽値のリテラル。 [プリミティブ型 (ブーリアン型)] 参照。
* `fn`: 関数定義及び関数ポインタ型。 [関数] 参照。
* `for`: イテレータループ、 トレイト `impl`  構文の一部、 あるいは 高階ライフタイム構文。  [ループ (`for`)] 、 [メソッド構文] 参照。
* `if`: 条件分岐  [`if`] 、 [`if let`] 参照。
* `impl`: 継承及びトレイト実装のブロック。 [メソッド構文] 参照。
* `in`: `for` ループ構文の一部。 [ループ (`for`)] 参照。
* `let`: 変数束縛。 [変数束縛] 参照。
* `loop`: 条件無しの無限ループ。 [ループ (`loop`)] 参照。
* `match`: パターンマッチ。 [マッチ] 参照。
* `mod`: モジュール宣言。   [クレートとモジュール (モジュールを定義する)] 参照。
* `move`: クロージャ構文の一部。 [クロージャ (`move` クロージャ)] 参照。
* `mut`: ポインタ型とパターン束縛におけるミュータビリティを表す。 [ミュータビリティ] 参照。
* `pub`: `struct` のフィールド、 `impl` ブロック、 モジュールにおいて可視性を表す。 [クレートとモジュール (パブリックなインターフェースのエクスポート)] 参照。
* `ref`: 参照束縛。 [パターン (`ref` と `ref mut`)] 参照。
* `return`: 関数からのリターン。 [関数 (早期リターン)] 参照。
* `Self`: 実装者の型のエイリアス。 [トレイト] 参照。
* `self`: メソッドの主語。 [メソッド構文 (メソッド呼び出し)] 参照。
* `static`: グローバル変数。 [`const` と `static` (`static`)] 参照。
* `struct`: 構造体定義。 [構造体] 参照。
* `trait`: トレイト定義。 [トレイト] 参照。
* `true`: ブーリアン型の真値のリテラル。 [プリミティブ型 (ブーリアン型)] 参照。
* `type`: 型エイリアス、または関連型定義。 [`type` エイリアス] 、 [関連型] 参照。
* `unsafe`: アンセーフなコード、関数、トレイト、そして実装を表す。 [Unsafe] 参照。
* `use`: スコープにシンボルをインポートする。 [クレートとモジュール (`use` でモジュールをインポートする)] 参照。
* `where`: 型制約節。 [トレイト (`where` 節)] 参照。
* `while`: 条件付きループ。 [ループ (`while`)] 参照。

<!-- ## Operators and Symbols -->
## 演算子とシンボル

<!-- * `!` (`ident!(…)`, `ident!{…}`, `ident![…]`): denotes macro expansion.  See [Macros]. -->
<!-- * `!` (`!expr`): bitwise or logical complement.  Overloadable (`Not`). -->
<!-- * `!=` (`var != expr`): nonequality comparison.  Overloadable (`PartialEq`). -->
<!-- * `%` (`expr % expr`): arithmetic remainder.  Overloadable (`Rem`). -->
<!-- * `%=` (`var %= expr`): arithmetic remainder & assignment. Overloadable (`RemAssign`). -->
<!-- * `&` (`expr & expr`): bitwise and.  Overloadable (`BitAnd`). -->
<!-- * `&` (`&expr`): borrow.  See [References and Borrowing]. -->
<!-- * `&` (`&type`, `&mut type`, `&'a type`, `&'a mut type`): borrowed pointer type.  See [References and Borrowing]. -->
<!-- * `&=` (`var &= expr`): bitwise and & assignment. Overloadable (`BitAndAssign`). -->
<!-- * `&&` (`expr && expr`): logical and. -->
<!-- * `*` (`expr * expr`): arithmetic multiplication.  Overloadable (`Mul`). -->
<!-- * `*` (`*expr`): dereference. -->
<!-- * `*` (`*const type`, `*mut type`): raw pointer.  See [Raw Pointers]. -->
<!-- * `*=` (`var *= expr`): arithmetic multiplication & assignment. Overloadable (`MulAssign`). -->
<!-- * `+` (`expr + expr`): arithmetic addition.  Overloadable (`Add`). -->
<!-- * `+` (`trait + trait`, `'a + trait`): compound type constraint.  See [Traits (Multiple Trait Bounds)]. -->
<!-- * `+=` (`var += expr`): arithmetic addition & assignment. Overloadable (`AddAssign`). -->
<!-- * `,`: argument and element separator.  See [Attributes], [Functions], [Structs], [Generics], [Match], [Closures], [Crates and Modules (Importing Modules with `use`)]. -->
<!-- * `-` (`expr - expr`): arithmetic subtraction.  Overloadable (`Sub`). -->
<!-- * `-` (`- expr`): arithmetic negation.  Overloadable (`Neg`). -->
<!-- * `-=` (`var -= expr`): arithmetic subtraction & assignment. Overloadable (`SubAssign`). -->
<!-- * `->` (`fn(…) -> type`, `|…| -> type`): function and closure return type.  See [Functions], [Closures]. -->
<!-- * `-> !` (`fn(…) -> !`, `|…| -> !`): diverging function or closure. See [Diverging Functions]. -->
<!-- * `.` (`expr.ident`): member access.  See [Structs], [Method Syntax]. -->
<!-- * `..` (`..`, `expr..`, `..expr`, `expr..expr`): right-exclusive range literal. -->
<!-- * `..` (`..expr`): struct literal update syntax.  See [Structs (Update syntax)]. -->
<!-- * `..` (`variant(x, ..)`, `struct_type { x, .. }`): "and the rest" pattern binding.  See [Patterns (Ignoring bindings)]. -->
<!-- * `...` (`...expr`, `expr...expr`) *in an expression*: inclusive range expression. See [Iterators]. -->
<!-- * `...` (`expr...expr`) *in a pattern*: inclusive range pattern.  See [Patterns (Ranges)]. -->
<!-- * `/` (`expr / expr`): arithmetic division.  Overloadable (`Div`). -->
<!-- * `/=` (`var /= expr`): arithmetic division & assignment. Overloadable (`DivAssign`). -->
<!-- * `:` (`pat: type`, `ident: type`): constraints.  See [Variable Bindings], [Functions], [Structs], [Traits]. -->
<!-- * `:` (`ident: expr`): struct field initializer.  See [Structs]. -->
<!-- * `:` (`'a: loop {…}`): loop label.  See [Loops (Loops Labels)]. -->
<!-- * `;`: statement and item terminator. -->
<!-- * `;` (`[…; len]`): part of fixed-size array syntax.  See [Primitive Types (Arrays)]. -->
<!-- * `<<` (`expr << expr`): left-shift.  Overloadable (`Shl`). -->
<!-- * `<<=` (`var <<= expr`): left-shift & assignment. Overloadable (`ShlAssign`). -->
<!-- * `<` (`expr < expr`): less-than comparison.  Overloadable (`PartialOrd`). -->
<!-- * `<=` (`var <= expr`): less-than or equal-to comparison.  Overloadable (`PartialOrd`). -->
<!-- * `=` (`var = expr`, `ident = type`): assignment/equivalence.  See [Variable Bindings], [`type` Aliases], generic parameter defaults. -->
<!-- * `==` (`var == expr`): equality comparison.  Overloadable (`PartialEq`). -->
<!-- * `=>` (`pat => expr`): part of match arm syntax.  See [Match]. -->
<!-- * `>` (`expr > expr`): greater-than comparison.  Overloadable (`PartialOrd`). -->
<!-- * `>=` (`var >= expr`): greater-than or equal-to comparison.  Overloadable (`PartialOrd`). -->
<!-- * `>>` (`expr >> expr`): right-shift.  Overloadable (`Shr`). -->
<!-- * `>>=` (`var >>= expr`): right-shift & assignment. Overloadable (`ShrAssign`). -->
<!-- * `@` (`ident @ pat`): pattern binding.  See [Patterns (Bindings)]. -->
<!-- * `^` (`expr ^ expr`): bitwise exclusive or.  Overloadable (`BitXor`). -->
<!-- * `^=` (`var ^= expr`): bitwise exclusive or & assignment. Overloadable (`BitXorAssign`). -->
<!-- * `|` (`expr | expr`): bitwise or.  Overloadable (`BitOr`). -->
<!-- * `|` (`pat | pat`): pattern alternatives.  See [Patterns (Multiple patterns)]. -->
<!-- * `|` (`|…| expr`): closures.  See [Closures]. -->
<!-- * `|=` (`var |= expr`): bitwise or & assignment. Overloadable (`BitOrAssign`). -->
<!-- * `||` (`expr || expr`): logical or. -->
<!-- * `_`: "ignored" pattern binding.  See [Patterns (Ignoring bindings)]. -->
* `!` (`ident!(…)`, `ident!{…}`, `ident![…]`): マクロ展開を表す。 [マクロ] 参照
* `!` (`!expr`): ビット毎、あるいは論理の補数。 オーバロード可能 (`Not`)。
* `!=` (`var != expr`): 非等価性比較。オーバーロード可能 (`PartialEq`)。
* `%` (`expr % expr`): 算術剰余算。オーバーロード可能 (`Rem`)。
* `%=` (`var %= expr`): 算術剰余算をして代入。 オーバーロード可能 (`RemAssign`)。
* `&` (`expr & expr`):ビット毎の論理積。 オーバーロード可能 (`BitAnd`)。
* `&` (`&expr`): 借用。 [参照と借用] 参照
* `&` (`&type`, `&mut type`, `&'a type`, `&'a mut type`): 借用されたポインタの型。 [参照と借用] 参照。
* `&=` (`var &= expr`): ビット毎の論理積をして代入。オーバーロード可能 (`BitAndAssign`)。
* `&&` (`expr && expr`): 論理積。
* `*` (`expr * expr`): 算術乗算。 オーバーロード可能 (`Mul`)。
* `*` (`*expr`): 参照外し。
* `*` (`*const type`, `*mut type`): 生ポインタ。 [生ポインタ] 参照。
* `*=` (`var *= expr`): 算術乗算をして代入。オーバーロード可能 (`MulAssign`)。
* `+` (`expr + expr`): 算術加算。オーバーロード可能 (`Add`)。
* `+` (`trait + trait`, `'a + trait`): 合成型制約。 [トレイト (複数のトレイト境界)] 参照。
* `+=` (`var += expr`): 算術加算をして代入。 オーバーロード可能 (`AddAssign`)。
* `,`: 引数または要素の区切り。  [アトリビュート] 、 [関数] 、 [構造体] 、 [ジェネリクス] 、 [マッチ] 、 [クロージャ] 、 [クレートとモジュール (`use` でモジュールをインポートする)] 参照。
* `-` (`expr - expr`): 算術減算。オーバーロード可能 (`Sub`)。
* `-` (`- expr`): 算術負。オーバーロード可能 (`Neg`)。
* `-=` (`var -= expr`): 算術減算をして代入。 オーバーロード可能 (`SubAssign`)。
* `->` (`fn(…) -> type`, `|…| -> type`): 関数とクロージャの返り型。 [関数] 、[クロージャ] 参照。
* `-> !` (`fn(…) -> !`, `|…| -> !`): ダイバージング関数またはクロージャ。 [ダイバージング関数] 参照。
* `.` (`expr.ident`): メンバへのアクセス。 [構造体] 、 [メソッド構文] 参照。
* `..` (`..`, `expr..`, `..expr`, `expr..expr`): 右に開な区間のリテラル。
* `..` (`..expr`): 構造体リテラルのアップデート構文。[構造体 (アップデート構文)]参照。
* `..` (`variant(x, ..)`, `struct_type { x, .. }`): 「〜と残り」のパターン束縛。 [パターン (束縛の無視)] 参照。
* `...` (`...expr`, `expr...expr`) *式内で*: 閉区間式。[イテレータ] 参照
* `...` (`expr...expr`) *パターン内で*: 閉区間パターン。 [パターン (レンジ)] 参照
* `/` (`expr / expr`): 算術除算。オーバーロード可能 (`Div`)。
* `/=` (`var /= expr`): 算術除算と代入。オーバーロード可能 (`DivAssign`)。
* `:` (`pat: type`, `ident: type`): 制約。[変数束縛] 、 [関数] 、 [構造体] 、 [トレイト] 参照。
* `:` (`ident: expr`): 構造体のフィールドの初期化。 [構造体] 参照。
* `:` (`'a: loop {…}`): ループラベル。 [ループ (ループラベル)] 参照。
* `;`: 文またはアイテムの区切り。
* `;` (`[…; len]`): 固定長配列構文の一部。 [プリミティブ型 (配列)] 参照。
* `<<` (`expr << expr`): 左シフト。オーバーロード可能 (`Shl`)。
* `<<=` (`var <<= expr`): 左シフトして代入。 オーバーロード可能 (`ShlAssign`)。
* `<` (`expr < expr`): 「より小さい」の比較。オーバーロード可能 (`PartialOrd`)。
* `<=` (`var <= expr`): 「以下」の比較。オーバーロード可能 (`PartialOrd`)。
* `=` (`var = expr`, `ident = type`): 代入/等価比較。 [変数束縛] 、 [`type` エイリアス]、 ジェネリックパラメータのデフォルトを参照。
* `==` (`var == expr`): 等価性比較。オーバーロード可能 (`PartialEq`)。
* `=>` (`pat => expr`): マッチの腕の構文の一部。 [マッチ] 参照。
* `>` (`expr > expr`): 「より大きい」の比較。オーバーロード可能 (`PartialOrd`)。
* `>=` (`var >= expr`): 「以上」の比較。オーバーロード可能 (`PartialOrd`)。
* `>>` (`expr >> expr`): 右シフト。オーバーロード可能 (`Shr`)。
* `>>=` (`var >>= expr`): 右シフトして代入。 オーバーロード可能 (`ShrAssign`)。
* `@` (`ident @ pat`): パターン束縛。 [パターン (束縛)] 参照。
* `^` (`expr ^ expr`): ビット毎の排他的論理和。オーバーロード可能 (`BitXor`)。
* `^=` (`var ^= expr`): ビット毎の排他的論理和をして代入。オーバーロード可能 (`BitXorAssign`)。
* `|` (`expr | expr`): ビット毎の論理和。 オーバーロード可能 (`BitOr`)。
* `|` (`pat | pat`): パターンの「または」。 [パターン (複式パターン)] 参照
* `|` (`|…| expr`): クロージャ。[クロージャ] 参照。
* `|=` (`var |= expr`): ビット毎の論理和をして代入。オーバーロード可能 (`BitOrAssign`)。
* `||` (`expr || expr`): 論理和。
* `_`: 「無視」するパターン束縛。 [パターン (束縛の無視)]。

<!-- ## Other Syntax -->
## 他の構文

<!-- Various bits of standalone stuff. -->

<!-- * `'ident`: named lifetime or loop label.  See [Lifetimes], [Loops (Loops Labels)]. -->
<!-- * `…u8`, `…i32`, `…f64`, `…usize`, …: numeric literal of specific type. -->
<!-- * `"…"`: string literal.  See [Strings]. -->
<!-- * `r"…"`, `r#"…"#`, `r##"…"##`, …: raw string literal, escape characters are not processed. See [Reference (Raw String Literals)]. -->
<!-- * `b"…"`: byte string literal, constructs a `[u8]` instead of a string. See [Reference (Byte String Literals)]. -->
<!-- * `br"…"`, `br#"…"#`, `br##"…"##`, …: raw byte string literal, combination of raw and byte string literal. See [Reference (Raw Byte String Literals)]. -->
<!-- * `'…'`: character literal.  See [Primitive Types (`char`)]. -->
<!-- * `b'…'`: ASCII byte literal. -->
<!-- * `|…| expr`: closure.  See [Closures]. -->
* `'ident`: 名前付きライフタイムまたはループラベル。 [ライフタイム] 、 [ループ (ループラベル)] 参照。
* `…u8`, `…i32`, `…f64`, `…usize`, …: その型の数値リテラル。
* `"…"`: 文字列リテラル。 [文字列] 参照。
* `r"…"`, `r#"…"#`, `r##"…"##`, …: 生文字列リテラル、 エスケープ文字は処理されない。 [リファレンス (生文字列リテラル)] 参照。
* `b"…"`: バイト列リテラル、文字列ではなく `[u8]` を作る。 [リファレンス (バイト列リテラル)] 参照。
* `br"…"`, `br#"…"#`, `br##"…"##`, …: 生バイト列リテラル。生文字列とバイト列リテラルの組み合わせ。 [リファレンス (生バイト列リテラル)] 参照
* `'…'`: 文字リテラル。 [プリミティブ型 (`char`)] 参照。
* `b'…'`: ASCIIバイトリテラル。
* `|…| expr`: クロージャ。 [クロージャ] 参照。

<!-- Path-related syntax -->

<!-- * `ident::ident`: path.  See [Crates and Modules (Defining Modules)]. -->
<!-- * `::path`: path relative to the crate root (*i.e.* an explicitly absolute path).  See [Crates and Modules (Re-exporting with `pub use`)]. -->
<!-- * `self::path`: path relative to the current module (*i.e.* an explicitly relative path).  See [Crates and Modules (Re-exporting with `pub use`)]. -->
<!-- * `super::path`: path relative to the parent of the current module.  See [Crates and Modules (Re-exporting with `pub use`)]. -->
<!-- * `type::ident`, `<type as trait>::ident`: associated constants, functions, and types.  See [Associated Types]. -->
<!-- * `<type>::…`: associated item for a type which cannot be directly named (*e.g.* `<&T>::…`, `<[T]>::…`, *etc.*).  See [Associated Types]. -->
<!-- * `trait::method(…)`: disambiguating a method call by naming the trait which defines it. See [Universal Function Call Syntax]. -->
<!-- * `type::method(…)`: disambiguating a method call by naming the type for which it's defined. See [Universal Function Call Syntax]. -->
<!-- * `<type as trait>::method(…)`: disambiguating a method call by naming the trait _and_ type. See [Universal Function Call Syntax (Angle-bracket Form)]. -->
* `ident::ident`: パス。[クレートとモジュール (モジュールを定義する)] 参照。
* `::path`: クレートのルートからの相対パス (*つまり* 明示的な絶対パス)。 [クレートとモジュール (`pub use` による再エクスポート)] 参照。
* `self::path`: 現在のモジュールからの相対パス (*つまり* 明示的な相対パス)。 [クレートとモジュール (`pub use` による再エクスポート)] 参照。
* `super::path`: 現在のモジュールの親からの相対パス。 [クレートとモジュール (`pub use` による再エクスポート)] 参照。
* `type::ident`, `<type as trait>::ident`: 関連定数、関数、型。 [関連型] 参照。
* `<type>::…`: 直接名前付けられない型の関連アイテム (*例えば* `<&T>::…` 、 `<[T]>::…` 、 *など*)。 [関連型] 参照。
*  `trait::method(…)`: メソッドを定義したトレイトを指定することによるメソッド呼び出しの曖昧性排除。 [共通の関数呼び出し構文] 参照。
* `type::method(…)`: そのメソッドが定義された型を指定することによるメソッド呼び出しの曖昧性排除。 [共通の関数呼び出し構文] 参照。
* `<type as trait>::method(…)`: メソッドを定義したトレイト *及び* 型を指定することによるメソッド呼び出しの曖昧性排除。 [共通の関数呼び出し構文 (山括弧形式)] 参照。

<!-- Generics -->

<!-- * `path<…>` (*e.g.* `Vec<u8>`): specifies parameters to generic type *in a type*.  See [Generics]. -->
<!-- * `path::<…>`, `method::<…>` (*e.g.* `"42".parse::<i32>()`): specifies parameters to generic type, function, or method *in an expression*. -->
<!-- * `fn ident<…> …`: define generic function.  See [Generics]. -->
<!-- * `struct ident<…> …`: define generic structure.  See [Generics]. -->
<!-- * `enum ident<…> …`: define generic enumeration.  See [Generics]. -->
<!-- * `impl<…> …`: define generic implementation. -->
<!-- * `for<…> type`: higher-ranked lifetime bounds. -->
<!-- * `type<ident=type>` (*e.g.* `Iterator<Item=T>`): a generic type where one or more associated types have specific assignments.  See [Associated Types]. -->
* `path<…>` (*例えば* `Vec<u8>`): *型での* ジェネリック型のパラメータの指定。 [ジェネリクス] 。
* `path::<…>`, `method::<…>` (*例えば* `"42".parse::<i32>()`): *式での* ジェネリック型あるいは関数、メソッドの型の指定。
* `fn ident<…> …`: ジェネリック関数を定義。 [ジェネリクス] 参照。
* `struct ident<…> …`: ジェネリック構造体を定義。 [ジェネリクス] 参照。
* `enum ident<…> …`: ジェネリック列挙型を定義。 [ジェネリクス] 参照。
* `impl<…> …`: ジェネリック実装を定義。
* `for<…> type`: 高階ライフタイム境界。
* `type<ident=type>` (*例えば* `Iterator<Item=T>`): 1つ以上の関連型について指定のあるジェネリック型。 [関連型] 参照。

<!-- Constraints -->

<!-- * `T: U`: generic parameter `T` constrained to types that implement `U`.  See [Traits]. -->
<!-- * `T: 'a`: generic type `T` must outlive lifetime `'a`. When we say that a type 'outlives' the lifetime, we mean that it cannot transitively contain any references with lifetimes shorter than `'a`. -->
<!-- * `T : 'static`: The generic type `T` contains no borrowed references other than `'static` ones. -->
<!-- * `'b: 'a`: generic lifetime `'b` must outlive lifetime `'a`. -->
<!-- * `T: ?Sized`: allow generic type parameter to be a dynamically-sized type.  See [Unsized Types (`?Sized`)]. -->
<!-- * `'a + trait`, `trait + trait`: compound type constraint.  See [Traits (Multiple Trait Bounds)]. -->
* `T: U`: `U` を実装する型に制約されたジェネリックパラメータ `T` 。 [トレイト] 参照。
* `T: 'a`: ジェネリック型 `T` はライフタイム `'a` より長生きしなければならない。ライフタイムが「長生きする」とは `'a` より短かい、いかなるライフタイムも推移的に含んでいないことを意味する。
* `T : 'static`: ジェネリック型Tは `'static` なもの以外の借用した参照を含んでいない。
* `'b: 'a`: ジェネリックライフタイム `'b` はライフタイム `'a` より長生きしなければならない。
* `T: ?Sized`: ジェネリック型パラメータが動的サイズ型になること許可する。 [サイズ不定型 (`?Sized`)] 参照。
* `'a + trait`, `trait + trait`: 合成型制約。 [トレイト (複数のトレイト境界)] 参照。

<!-- Macros and attributes -->

<!-- * `#[meta]`: outer attribute.  See [Attributes]. -->
<!-- * `#![meta]`: inner attribute.  See [Attributes]. -->
<!-- * `$ident`: macro substitution.  See [Macros]. -->
<!-- * `$ident:kind`: macro capture.  See [Macros]. -->
<!-- * `$(…)…`: macro repetition.  See [Macros]. -->
* `#[meta]`: 外側のアトリビュート。  [アトリビュート] 参照。
* `#![meta]`: 内側のアトリビュート。 [アトリビュート] 参照。
* `$ident`: マクロでの置換。 [マクロ] 参照。
* `$ident:kind`: マクロでの捕捉。 [マクロ] 参照。
* `$(…)…`: マクロでの繰り返し。 [マクロ] 参照。

<!-- Comments -->

<!-- * `//`: line comment.  See [Comments]. -->
<!-- * `//!`: inner line doc comment.  See [Comments]. -->
<!-- * `///`: outer line doc comment.  See [Comments]. -->
<!-- * `/*…*/`: block comment.  See [Comments]. -->
<!-- * `/*!…*/`: inner block doc comment.  See [Comments]. -->
<!-- * `/**…*/`: outer block doc comment.  See [Comments]. -->
* `//`: ラインコメント。 [コメント] 参照。
* `//!`: 内側の行ドキュメントコメント。 [コメント] 参照。
* `///`: 外側の行ドキュメントコメント [コメント] 参照。
* `/*…*/`: ブロックコメント。 [コメント] 参照。
* `/*!…*/`: 内側のブロックドキュメントコメント。 [コメント] 参照。
* `/**…*/`: 外側のブロックドキュメントコメント。 [コメント] 参照。

<!-- Various things involving parens and tuples -->

<!-- * `()`: empty tuple (*a.k.a.* unit), both literal and type. -->
<!-- * `(expr)`: parenthesized expression. -->
<!-- * `(expr,)`: single-element tuple expression.  See [Primitive Types (Tuples)]. -->
<!-- * `(type,)`: single-element tuple type.  See [Primitive Types (Tuples)]. -->
<!-- * `(expr, …)`: tuple expression.  See [Primitive Types (Tuples)]. -->
<!-- * `(type, …)`: tuple type.  See [Primitive Types (Tuples)]. -->
<!-- * `expr(expr, …)`: function call expression.  Also used to initialize tuple `struct`s and tuple `enum` variants.  See [Functions]. -->
<!-- * `ident!(…)`, `ident!{…}`, `ident![…]`: macro invocation.  See [Macros]. -->
<!-- * `expr.0`, `expr.1`, …: tuple indexing.  See [Primitive Types (Tuple Indexing)]. -->
* `()`: 空タプル(*あるいは* ユニット)の、リテラルと型両方。
* `(expr)`: 括弧付きの式。
* `(expr,)`: 1要素タプルの式。 [プリミティブ型 (タプル)] 参照。
* `(type,)`: 1要素タプルの型。 [プリミティブ型 (タプル)] 参照。
* `(expr, …)`: タプル式。 [プリミティブ型 (タプル)] 参照。
* `(type, …)`: タプル型。 [プリミティブ型 (タプル)] 参照。
* `expr(expr, …)`: 関数呼び出し式。また、 タプル `struct` 、 タプル `enum` のヴァリアントを初期化するのにも使われる。 [関数] 参照。
* `ident!(…)`, `ident!{…}`, `ident![…]`: マクロの起動。 [マクロ] 参照。
* `expr.0`, `expr.1`, …: タプルのインデックス。 [プリミティブ型 (タプルのインデックス)] 参照。

<!-- Bracey things -->

<!-- * `{…}`: block expression. -->
<!-- * `Type {…}`: `struct` literal.  See [Structs]. -->
* `{…}`: ブロック式。
* `Type {…}`: `struct` リテラル。 [構造体] 参照。

<!-- Brackety things -->

<!-- * `[…]`: array literal.  See [Primitive Types (Arrays)]. -->
<!-- * `[expr; len]`: array literal containing `len` copies of `expr`.  See [Primitive Types (Arrays)]. -->
<!-- * `[type; len]`: array type containing `len` instances of `type`.  See [Primitive Types (Arrays)]. -->
<!-- * `expr[expr]`: collection indexing.  Overloadable (`Index`, `IndexMut`). -->
<!-- * `expr[..]`, `expr[a..]`, `expr[..b]`, `expr[a..b]`: collection indexing pretending to be collection slicing, using `Range`, `RangeFrom`, `RangeTo`, `RangeFull` as the "index". -->
* `[…]`: 配列リテラル。 [プリミティブ型 (配列)] 参照。
* `[expr; len]`: `len` 個の `expr` を要素に持つ配列リテラル。 [プリミティブ型 (配列)] 参照。
* `[type; len]`: `len` 個の`type` のインスタンスを要素に持つ配列型。 [プリミティブ型 (配列)] 参照。
* `expr[expr]`: コレクションのインデックス。 オーバーロード可能(`Index`, `IndexMut`)。
* `expr[..]`, `expr[a..]`, `expr[..b]`, `expr[a..b]`: コレクションのスライスのようなコレクションのインデックス。 `Range` 、 `RangeFrom` 、 `RangeTo` 、 `RangeFull` を「インデックス」として使う。

[`const` と `static` (`static`)]: const-and-static.html#static
[`const` と `static`]: const-and-static.html
[`if let`]: if-let.html
[`if`]: if.html
[`type` エイリアス]: type-aliases.html
[関連型]: associated-types.html
[アトリビュート]: attributes.html
[型間のキャスト (`as`)]: casting-between-types.html#as
[クロージャ (`move` クロージャ)]: closures.html#move-クロージャ
[クロージャ]: closures.html
[コメント]: comments.html
[クレートとモジュール (モジュールを定義する)]: crates-and-modules.html#モジュールを定義する
[クレートとモジュール (パブリックなインターフェースのエクスポート)]: crates-and-modules.html#パブリックなインターフェースのエクスポート
[クレートとモジュール (外部クレートのインポート)]: crates-and-modules.html#外部クレートのインポート
[クレートとモジュール (`use` でモジュールをインポートする)]: crates-and-modules.html#use-でモジュールをインポートする
[クレートとモジュール (`pub use` による再エクスポート)]: crates-and-modules.html#pub-use-による再エクスポート
[ダイバージング関数]: functions.html#ダイバージング関数
[列挙型]: enums.html
[他言語関数インターフェイス]: ffi.html
[関数 (早期リターン)]: functions.html#早期リターン
[関数]: functions.html
[ジェネリクス]: generics.html
[イテレータ]: iterators.html
[ライフタイム]: lifetimes.html
[ループ (`for`)]: loops.html#for
[ループ (`loop`)]: loops.html#loop
[ループ (`while`)]: loops.html#while
[ループ (反復の早期終了)]: loops.html#反復の早期終了
[ループ (ループラベル)]: loops.html#ループラベル
[マクロ]: macros.html
[マッチ]: match.html
[メソッド構文 (メソッド呼び出し)]: method-syntax.html#メソッド呼び出し
[メソッド構文]: method-syntax.html
[ミュータビリティ]: mutability.html
[演算子とオーバーロド]: operators-and-overloading.html
[パターン (`ref` と `ref mut`)]: patterns.html#ref-と-ref-mut
[パターン (束縛)]: patterns.html#束縛
[パターン (束縛の無視)]: patterns.html#束縛の無視
[パターン (複式パターン)]: patterns.html#複式パターン
[パターン (レンジ)]: patterns.html#レンジ
[プリミティブ型 (`char`)]: primitive-types.html#char
[プリミティブ型 (配列)]: primitive-types.html#配列
[プリミティブ型 (ブーリアン型)]: primitive-types.html#ブーリアン型
[プリミティブ型 (タプルのインデックス)]: primitive-types.html#タプルのインデックス
[プリミティブ型 (タプル)]: primitive-types.html#タプル
[生ポインタ]: raw-pointers.html
[リファレンス (バイト列リテラル)]: ../reference.html#byte-string-literals
[リファレンス (生バイト列リテラル)]: ../reference.html#raw-byte-string-literals
[リファレンス (生文字列リテラル)]: ../reference.html#raw-string-literals
[参照と借用]: references-and-borrowing.html
[文字列]: strings.html
[構造体 (アップデート構文)]: structs.html#アップデート構文
[構造体]: structs.html
[トレイト (`where` 節)]: traits.html#where-節
[トレイト (複数のトレイト境界)]: traits.html#複数のトレイト境界
[トレイト]: traits.html
[共通の関数呼び出し構文]: ufcs.html
[共通の関数呼び出し構文 (山括弧形式)]: ufcs.html#山括弧形式
[Unsafe]: unsafe.html
[サイズ不定型 (`?Sized`)]: unsized-types.html#sized
[変数束縛]: variable-bindings.html
