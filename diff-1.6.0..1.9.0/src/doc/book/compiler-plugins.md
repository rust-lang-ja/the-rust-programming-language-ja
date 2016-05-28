--- a/src/doc/book/compiler-plugins.md
+++ b/src/doc/book/compiler-plugins.md
@@ -8,12 +8,12 @@ extend the compiler's behavior with new syntax extensions, lint checks, etc.
 A plugin is a dynamic library crate with a designated *registrar* function that
 registers extensions with `rustc`. Other crates can load these extensions using
 the crate attribute `#![plugin(...)]`.  See the
-[`rustc_plugin`](../rustc_plugin/index.html) documentation for more about the
+`rustc_plugin` documentation for more about the
 mechanics of defining and loading a plugin.
 
 If present, arguments passed as `#![plugin(foo(... args ...))]` are not
 interpreted by rustc itself.  They are provided to the plugin through the
-`Registry`'s [`args` method](../rustc_plugin/registry/struct.Registry.html#method.args).
+`Registry`'s `args` method.
 
 In the vast majority of cases, a plugin should *only* be used through
 `#![plugin]` and not through an `extern crate` item.  Linking a plugin would
@@ -30,7 +30,7 @@ of a library.
 Plugins can extend Rust's syntax in various ways. One kind of syntax extension
 is the procedural macro. These are invoked the same way as [ordinary
 macros](macros.html), but the expansion is performed by arbitrary Rust
-code that manipulates [syntax trees](../syntax/ast/index.html) at
+code that manipulates syntax trees at
 compile time.
 
 Let's write a plugin
@@ -120,11 +120,8 @@ The advantages over a simple `fn(&str) -> u32` are:
 
 In addition to procedural macros, you can define new
 [`derive`](../reference.html#derive)-like attributes and other kinds of
-extensions.  See
-[`Registry::register_syntax_extension`](../rustc_plugin/registry/struct.Registry.html#method.register_syntax_extension)
-and the [`SyntaxExtension`
-enum](https://doc.rust-lang.org/syntax/ext/base/enum.SyntaxExtension.html).  For
-a more involved macro example, see
+extensions.  See `Registry::register_syntax_extension` and the `SyntaxExtension`
+enum.  For a more involved macro example, see
 [`regex_macros`](https://github.com/rust-lang/regex/blob/master/regex_macros/src/lib.rs).
 
 
@@ -132,7 +129,7 @@ a more involved macro example, see
 
 Some of the [macro debugging tips](macros.html#debugging-macro-code) are applicable.
 
-You can use [`syntax::parse`](../syntax/parse/index.html) to turn token trees into
+You can use `syntax::parse` to turn token trees into
 higher-level syntax elements like expressions:
 
 ```ignore
@@ -148,30 +145,21 @@ Looking through [`libsyntax` parser
 code](https://github.com/rust-lang/rust/blob/master/src/libsyntax/parse/parser.rs)
 will give you a feel for how the parsing infrastructure works.
 
-Keep the [`Span`s](../syntax/codemap/struct.Span.html) of
-everything you parse, for better error reporting. You can wrap
-[`Spanned`](../syntax/codemap/struct.Spanned.html) around
-your custom data structures.
-
-Calling
-[`ExtCtxt::span_fatal`](../syntax/ext/base/struct.ExtCtxt.html#method.span_fatal)
-will immediately abort compilation. It's better to instead call
-[`ExtCtxt::span_err`](../syntax/ext/base/struct.ExtCtxt.html#method.span_err)
-and return
-[`DummyResult`](../syntax/ext/base/struct.DummyResult.html),
-so that the compiler can continue and find further errors.
-
-To print syntax fragments for debugging, you can use
-[`span_note`](../syntax/ext/base/struct.ExtCtxt.html#method.span_note) together
-with
-[`syntax::print::pprust::*_to_string`](https://doc.rust-lang.org/syntax/print/pprust/index.html#functions).
-
-The example above produced an integer literal using
-[`AstBuilder::expr_usize`](../syntax/ext/build/trait.AstBuilder.html#tymethod.expr_usize).
+Keep the `Span`s of everything you parse, for better error reporting. You can
+wrap `Spanned` around your custom data structures.
+
+Calling `ExtCtxt::span_fatal` will immediately abort compilation. It's better to
+instead call `ExtCtxt::span_err` and return `DummyResult` so that the compiler
+can continue and find further errors.
+
+To print syntax fragments for debugging, you can use `span_note` together with
+`syntax::print::pprust::*_to_string`.
+
+The example above produced an integer literal using `AstBuilder::expr_usize`.
 As an alternative to the `AstBuilder` trait, `libsyntax` provides a set of
-[quasiquote macros](../syntax/ext/quote/index.html).  They are undocumented and
-very rough around the edges.  However, the implementation may be a good
-starting point for an improved quasiquote as an ordinary plugin library.
+quasiquote macros. They are undocumented and very rough around the edges.
+However, the implementation may be a good starting point for an improved
+quasiquote as an ordinary plugin library.
 
 
 # Lint plugins
@@ -239,12 +227,11 @@ foo.rs:4 fn lintme() { }
 
 The components of a lint plugin are:
 
-* one or more `declare_lint!` invocations, which define static
-  [`Lint`](../rustc/lint/struct.Lint.html) structs;
+* one or more `declare_lint!` invocations, which define static `Lint` structs;
 
 * a struct holding any state needed by the lint pass (here, none);
 
-* a [`LintPass`](../rustc/lint/trait.LintPass.html)
+* a `LintPass`
   implementation defining how to check each syntax element. A single
   `LintPass` may call `span_lint` for several different `Lint`s, but should
   register them all through the `get_lints` method.
diff --git a/src/doc/book/concurrency.md b/src/doc/book/concurrency.md
