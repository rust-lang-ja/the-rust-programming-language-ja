# Rust文書の和訳リポジトリ [![CircleCI](https://circleci.com/gh/rust-lang-ja/the-rust-programming-language-ja.svg?style=svg)](https://circleci.com/gh/rust-lang-ja/the-rust-programming-language-ja)

[TRPL](https://doc.rust-lang.org/book/)を主としたRustドキュメントの翻訳プロジェクトです。
余力があれば他の文書の翻訳もするかもしれません。

飜訳文書は[こちら](http://rust-lang-ja.github.io/the-rust-programming-language-ja/1.6/book/)にあります。

## ビルド方法

`rustbook`コマンドが必要です。

```
make RUSTBOOK=/path/to/rustbook
```

`rustbook`コマンドのインストール方法については、Wikiページの「[rustbookのインストール方法](https://github.com/rust-lang-ja/the-rust-programming-language-ja/wiki/rustbook%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E6%96%B9%E6%B3%95)」を参照してください。

## CI 継続的インテグレーション

本リポジトリでは、CIサービスを活用し、PR（プルリクエスト）に対してHTMLの自動生成を行っています。詳しくはWikiページの「[CI 継続的インテグレーション](https://github.com/rust-lang-ja/the-rust-programming-language-ja/wiki/CI-%E7%B6%99%E7%B6%9A%E7%9A%84%E3%82%A4%E3%83%B3%E3%83%86%E3%82%B0%E3%83%AC%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3)」を参照してください。

## ライセンス

元のドキュメントはRustのソースと同じくApache2.0とMITのデュアルライセンスです。

翻訳ドキュメントも同じくApache2.0とMITのデュアルライセンスとします。
