title: Spring Security デフォルト表示されるログイン画面のユーザーIDとパスワード

## 概要
- Spring Securityを導入した際に、デフォルト表示されるログイン画面のユーザーとパスワードを紹介
  - Spring Securityの動作を初めてみる人向け

## 対象環境
- 以下の環境で確認しています。
    - macOS Sonoma 14.0.0
    - Spring Boot 3.2.2
    - Spring Security 5.5.1
    - Java 17
    - Gradleアプリケーション

### Spring Securityを含んだSpring Bootアプリケーションを作成
- [Spring initializr](https://start.spring.io/)を使ってSpring Bootアプリケーションを作成
  - Spring Securityを依存関係に追加しておく
- `build.gradle`に以下のように記述

```groovy
plugins {
	id 'java'
	id 'org.springframework.boot' version '3.2.2'
	id 'io.spring.dependency-management' version '1.1.4'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'

java {
	sourceCompatibility = '17'
}

repositories {
	mavenCentral()
}

dependencies {
	implementation 'org.springframework.boot:spring-boot-starter-security'
	implementation 'org.springframework.boot:spring-boot-starter-web'
	testImplementation 'org.springframework.boot:spring-boot-starter-test'
	testImplementation 'org.springframework.security:spring-security-test'
}

tasks.named('test') {
	useJUnitPlatform()
}
```

### Spring Bootアプリケーションを起動
- 作成したSpring Bootアプリケーションを起動
  - Spring Securityのデフォルト設定でログイン画面が表示されることを確認
- Spring Bootアプリケーション起動時に、以下のログが出力されることを確認
  - `Using generated security password: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`
  - このパスワードがデフォルトのパスワードになる

## まとめ
- デフォルトパスワードを使用するケースはほぼないと思うので、このパスワードを使うことはないと思う・・・
  - Spring Securityを初めて使う人は、このパスワードを使ってログインしてみると、Spring Securityの動作を確認できるので、試してみるといいかも
