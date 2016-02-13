% リリースチャネル
<!-- % Release Channels -->

<!-- The Rust project uses a concept called ‘release channels’ to manage releases. -->
<!-- It’s important to understand this process to choose which version of Rust -->
<!-- your project should use. -->
Rustプロジェクトではリリースを管理するために「リリースチャネル」という考え方を採用しています。どのバージョンのRustを使用するか決めるためには、この考え方を理解することが重要になります。

<!-- # Overview -->
# 概要

<!-- There are three channels for Rust releases: -->
Rustのリリースには以下の3つのチャネルがあります。

* Nightly
* Beta
* Stable

<!-- New nightly releases are created once a day. Every six weeks, the latest -->
<!-- nightly release is promoted to ‘Beta’. At that point, it will only receive -->
<!-- patches to fix serious errors. Six weeks later, the beta is promoted to -->
<!-- ‘Stable’, and becomes the next release of `1.x`. -->
新しいnightlyリリースは毎日作られます。6週間ごとに、最新のnightlyリリースが「Beta」に格上げされます。これ以降は深刻なエラーを修正するパッチのみが受け付けられます。さらに6週間後、betaは「Stable」に格上げされ、次の「1.x」リリースになります。

<!-- This process happens in parallel. So every six weeks, on the same day, -->
<!-- nightly goes to beta, beta goes to stable. When `1.x` is released, at -->
<!-- the same time, `1.(x + 1)-beta` is released, and the nightly becomes the -->
<!-- first version of `1.(x + 2)-nightly`. -->
このプロセスは並行して行われます。つまり6週間毎の同じ日に、nightlyはbetaに、betaはstableになります。「1.x」がリリースされると同時に「1.(x + 1)-beta」がリリースされ、nightlyは「1.(x + 2)-nightly」の最初のバージョンになる、ということです。

<!-- # Choosing a version -->
# バージョンを選ぶ

<!-- Generally speaking, unless you have a specific reason, you should be using the -->
<!-- stable release channel. These releases are intended for a general audience. -->
一般的に言って、特別な理由がなければstableリリースチャネルを使うべきです。このリリースは一般のユーザ向けになっています。

<!-- However, depending on your interest in Rust, you may choose to use nightly -->
<!-- instead. The basic tradeoff is this: in the nightly channel, you can use -->
<!-- unstable, new Rust features. However, unstable features are subject to change, -->
<!-- and so any new nightly release may break your code. If you use the stable -->
<!-- release, you cannot use experimental features, but the next release of Rust -->
<!-- will not cause significant issues through breaking changes. -->
しかしRustに特に関心のある方は、代わりにnightlyを選んでも構いません。基本的な交換条件は次の通りです。nightlyチャネルを選ぶと不安定で新しいフィーチャを使うことができます。しかし、不安定なフィーチャは変更されやすく、新しいnightlyリリースでソースコードが動かなくなってしまうかもしれません。stableリリースを使えば、実験的なフィーチャを使うことはできませんが、Rustのバージョンが上がっても破壊的な変更によるトラブルは起きないでしょう。

<!-- # Helping the ecosystem through CI -->
# CIによるエコシステム支援

<!-- What about beta? We encourage all Rust users who use the stable release channel -->
<!-- to also test against the beta channel in their continuous integration systems. -->
<!-- This will help alert the team in case there’s an accidental regression. -->
betaとはどういうチャネルでしょうか？stableリリースチャネルを使う全てのユーザは、継続的インテグレーションシステムを使ってbetaリリースに対してもテストすることを推奨しています。こうすることで、突発的なリグレッションに備えることができます。

<!-- Additionally, testing against nightly can catch regressions even sooner, and so -->
<!-- if you don’t mind a third build, we’d appreciate testing against all channels. -->
さらに、nightlyに対してもテストすることでより早くリグレッションを捉えることができます。もし差し支えなければ、この3つ目のビルドを含めた全てのチャネルに対してテストしてもらえると嬉しいです。

<!-- As an example, many Rust programmers use [Travis](https://travis-ci.org/) to -->
<!-- test their crates, which is free for open source projects. Travis [supports -->
<!-- Rust directly][travis], and you can use a `.travis.yml` file like this to -->
<!-- test on all channels: -->
例えば、多くのRustプログラマが [Travis](https://travis-ci.org/) をクレートのテストに使っています。(このサービスはオープンソースプロジェクトについては無料で使えます) Travisは [Rustを直接サポート][travis] しており、「`.travis.yml`」に以下のように書くことですべてのチャネルに対するテストを行うことができます。

```yaml
language: rust
rust:
  - nightly
  - beta
  - stable

matrix:
  allow_failures:
    - rust: nightly
```

[travis]: http://docs.travis-ci.com/user/languages/rust/

<!-- With this configuration, Travis will test all three channels, but if something -->
<!-- breaks on nightly, it won’t fail your build. A similar configuration is -->
<!-- recommended for any CI system, check the documentation of the one you’re -->
<!-- using for more details. -->
この設定で、Travisは3つ全てのチャネルに対してテストを行いますが、nightlyで何かおかしくなったとしてもビルドが失敗にはなりません。他のCIシステムでも同様の設定をお勧めします。詳細はお使いのシステムのドキュメントを参照してください。
