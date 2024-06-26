## Gunma.webに参加してきた
- 数年振りにGunma.webに参加してきました。
  https://gunmaweb.connpass.com/event/309951/
  - 今回のテーマは「テスト駆動開発」
    - [@t_wada]()さんの基調講演でテスト駆動開発をハンズオン体験してきました。
    - 基調講演後の「テスト駆動開発についてのLT」もとても学びが多かった！
    - 久しぶりの参加でしたが、とても学びが多かったので、得た知見をまとめていきます。


### テスト駆動開発とは？
- テスト駆動開発とは何か？
  - テスト駆動開発（TDD）とは、プログラムの開発手法の一つ、テストを先に書いてからプログラムを書く手法。
  - テスト駆動開発はプログラム開発手法、というのを前提として押さえておく

### TDDのワークフロー
- TDDのワークフローをアップデートしたブログ記事の紹介がありました。
  - [【翻訳】テスト駆動開発の定義](https://t-wada.hatenablog.jp/entry/canon-tdd-by-kent-beck)

### テスト駆動開発の実践
- テスト駆動開発を実践する！習うより慣れろ！
  - 第1,2部はチュートリアル形式！
  - 手が動くうちに、だんだんわかる！
    - 新しい技術を学ぶ時は公式チュートリアルをなぞってみるのと一緒で、手を動かしながら真似ていくと、だんだんわかってくる！

### FizzBuzzでテスト駆動開発してみよう！
- 1-100までのテストを書いていく
- 仕様を細かく分析していく！
  - やりたいことをカテゴリーに分けていく
  - テスト対象のTODOリストを作っていく

- 同じものは同じ表現にする！
  - 1から100までの数をプリントする
  - 3の倍数の時はFizzをプリントする
  - 5の倍数の時はBuzzをプリントする
  - 3と5の倍数の時はFizzBuzzをプリントする

タスクを分割しようとすると、一番大事なことはテストが複雑になると考えがち
→ 制御容易性を切り離していくと、重要な部分のテストも簡単になる

- テスト可能なものに大事なものを寄せる！

```
1から100までの数
プリントする
```
テスト容易性：高
重要度（優先度）：高
- [ ] 数を文字列に変換する
  - [ ] 1を文字列に変換する -> 仮実装
  - [ ] 2を文字列に変換する -> 三角測量
- [ ] 3の倍数の時はFizzを~~プリントする~~ 変換する
  - [ ] 3を渡すとFizzを返す -> 仮実装 <-> 本実装
- [ ] 5の倍数の時はBuzzを~~プリントする~~　変換する
  - [ ] 5を渡すとBuzzを返す -> 明白な実装
- [ ] 3と5の倍数の時はFizzBuzzを~~プリントする~~　変換する

インデントされた箇条書き
→ ツリー構造になっている

インデントされた箇条書きはテストコードで表現できる！
**仕様の構造をテストコードの構造に落とし込む！**

TODOリストのツリー構造をテストコードのツリー構造にできる！！
→ ツリーの枝の抽象度が合っていない
→ テストがそのまま詳細設計書になる！！


テスト容易性:高
- [ ] 1からnまでの数
- [ ] 1から100までの数

テスト容易性:低、観測容易性：低
- [ ] プリント

テスト容易性
- 観測容易性
  - テスト対象の取得しやすさ
  - 結果を観測しやすい（戻り値がある方がわかりやすい）
- 制御容易性
  - ex) DBを介してテストしなくちゃいけない、IoTでデバイスがないとテストできない・・・
  - 40個引数がある馬鹿でかいメソッドとか
  - テスト対象が外部の環境に依存している場合、テストが難しい
- 小ささ

- Humble Object Pattern
  - 大事なものであればあるほど、テストが用意になる！
  - 全体のテスト（DB接続とか）は別のところで担保していこうよ！

- テスト名は日本語でわかりやすく書こう！

- 3Aパターン
  - 準備：Arrange
  - 実行：Act
  - 検証：Assert

- 具体的に考えたら、考慮不足に気づく
  - 具体的に考えることが強制される！
  - 具体的なテスト名を記述すること

- レッド
- グリーン
- リファクタリング

- 作る前に使う
  - 書きやすい < 読みやすい、使いやすさ 
  - 作っちゃったものが使いづらい、、 
  - その時にはリファクタできない、、

- 作る前に使う側に向かう！
  - 存在しないクラスを使うことを考えてみる！ 
  - テストコードを書きながら、設計をしていく！

- 検証から書く！
  - テストコードが失敗したら？ → 自分の腕を疑え！！

- Q. テストコードにバグがあったらどうするの？
  - 実装コードで検証する！

- テストコードの検証の仕方は、実装コードをいじってわざと失敗させる！ （欠陥挿入）

- テストごとにassertionを書く！
  - assertionは少なく！

```java
@Test
void 数を文字列に変換する() {
  // 準備
  // Arrange
  int n = 1;
  // 実行
  // Act
  String actual = fizzBuzz.convert(n);
  // 検証
  // Assert
  assertEquals("1", actual);
}
```

- レッド
- グリーン
  - グリーンであれば、リファクタリングの調整していく 
- リファクタリング 
  - 成功している中で、リファクタリングしていく！！

2アウト、3アウトまで待とう！

JUnitの各テストメソッドは順序性はデフォルトではないよ、ランダム！（明示的に指定はできるが）

- テスト駆動開発 
  - なんとなく書かれたテスト、、テストコードから仕様は読み取れなかった、、、

- 仕様レベルの言葉を、テストコードのメソッド名まで落とし込む
  - 必要がなくなったテストは消す！！

- **テストの構造化とリファクタリング**
  - 必要十分なテストを残していく！
  - 仕様は大体ツリー構造になるので、仕様構造を表現したテストコードを書いていく！

- データベースを使ったテストを書くことになる！
  - サバンナ
  - テストサイズ
  - テストがある体験を

**テストの出力を見ている！**
- テストケースのレビューをやる！
- JUnitのキャプチャを取ってもらって、それをPRに貼ってもらう！

- 実装とテストコード
  - 感覚的に、探索的にテストにおける感覚を整えていく！
