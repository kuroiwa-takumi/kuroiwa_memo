# SQL: UNIONについて理解を深める

## はじめに
- 

## 前提条件
- 使用する言語、フレームワーク、ライブラリのバージョンは以下になります。
    - Java: 17
    - Spring Boot: 3.1.4
    - Gradle: 8.3
    - OpenAPI Generator 6.6 -> https://github.com/OpenAPITools/openapi-generator
        - jarをダウンロードして、javaコマンドで実行します！：https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/6.6.0/

## OpenAPI定義の作成
- まずは自動生成するコードの元となるOpenAPI定義を作成します。
    - 今回は、OpenAPIの定義をyamlで書いていきます。
    - 今後、**todoリストのアプリケーションを実装予定**なので、**todoリストアプリで使用するAPIを定義**していきます。
    - 作成したOpenAPI定義は、以下のリポジトリにあります。
        - XXXX

## アプリケーションコードの構成
- 今回は以下のような構成にしました。
    - 自動生成されたコードの出力先は`presentation/generated`ディレクトリ配下にしてます！
    - `presentation/generated`配下に作成された自動生成のコードは手を入れずに、アプリケーションコードを作成していきます。（`Generation Gapパターン`）

```markdown
├── application
├── domain
├── infrastructure
├── openapi ※ OpenAPI定義＆コード生成用の設定ファイル、shellを配置
└── presentation
　　　　├── XXXController.java
　　　　└── generated ※ OpenAPI Generatorで生成したコードを配置
```

## OpenAPI Generatorのコード生成
- OpenAPI Generatorを使って、OpenAPI定義からコードを自動生成します。
    - `openapi`ディレクトリ直下に以下のようなshellを作成しました。
    - 以下のshellを実行すると、OpenAPI Generatorでコードが生成されます。

generate.sh
```shell
#!/bin/bash

echo "Starting OpenAPI code generation..."

# シェルスクリプトのディレクトリパスを取得
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 出力ディレクトリの設定
OUTPUT_PATH="$DIR/../"

# 出力ディレクトリの内容を削除
echo "Deleting existing OpenAPI generated code..."
rm -rf "${OUTPUT_PATH:?}/*"

echo "Starting OpenAPI code generation..."

java -jar "$DIR/openapi-generator-cli-6.6.0.jar" generate \
  -i "$DIR/openapi.yaml" \
  -g spring \
  -o "$OUTPUT_PATH" \
  -c "$DIR/openapi.json"

# コード生成が成功したかを確認
if [ $? -eq 0 ]; then
    echo "OpenAPI code generation completed successfully!"
else
    echo "OpenAPI code generation failed!"
fi
```
openapi.json
```json
{
  "groupId": "com.kuroiwa",
  "artifactId": "todo-api-generated",
  "artifactVersion": "0.0.1-SNAPSHOT",
  "apiPackage": "com.kuroiwa.todo.presentation.generated.api",
  "modelPackage": "com.kuroiwa.todo.presentation.generated.model",
  "java17": true,
  "components": {},
  "info": {},
  "library": "spring-boot",
  "interfaceOnly": true,
  "dateLibrary": "java8",
  "openapi": "3.0.3"
}
```
shellを実行すると、以下のようなコードが自動生成されます。
![img_1.png](img_1.png)

## コードを完成させる
- 自動生成されたコードを使って、アプリケーションコードを完成させていきます。

```java
```

## 最後に
- OpenAPI Generatorを使って、OpenAPI定義からコードを自動生成し、Spring Boot上で使えるようにしました。
- また、今回は、Generation Gapパターンでコードを生成しました。
    - 今後、コードを生成する際は、Generation Gapパターンでコードを生成することを意識していきます。
- 次回以降では、今回作成したコードをベースに、todoリストアプリを作成していきます。

## 参考
- [第1回 OpenAPI Generator を使ったコード生成](https://developer.mamezou-tech.com/blogs/2022/06/04/openapi-generator-1/)
- [OpenAPI Generatorのコード生成とSpring Frameworkのカスタムデータバインディングを共存させる](https://techblog.zozo.com/entry/coexistence-of-openapi-and-spring)
- [Spring Boot 3.0へのバージョンアップで発生した問題点と対応内容](https://techblog.zozo.com/entry/springboot-version-up-to-3)
- [SpringBoot×OpenAPI入門　〜Generation gapパターンで作るOpenAPI〜](https://qiita.com/haruto167/items/219bb0b0167804d0c922)
