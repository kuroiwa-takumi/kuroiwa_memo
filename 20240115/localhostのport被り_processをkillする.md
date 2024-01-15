title: "localhostのport被り_processをkillする"

## 概要
- Spring Bootを作ってローカルで開発をしている際、以下のようなエラーが出てアプリケーションが起動できないことがあります。

```shell
{"timestamp":"2024-01-15T11:03:04.682+09:00","@version":"1","message":"\n\nError starting ApplicationContext. To display the conditions report re-run your application with 'debug' enabled.","logger_name":"org.springframework.boot.autoconfigure.logging.ConditionEvaluationReportLoggingListener","thread_name":"main","severity":"INFO","severity_value":20000,"type":"SYSTEM"}
{"timestamp":"2024-01-15T11:03:04.692+09:00","@version":"1","message":"\n\n***************************\nAPPLICATION FAILED TO START\n***************************\n\nDescription:\n\nWeb server failed to start. Port 8080 was already in use.\n\nAction:\n\nIdentify and stop the process that's listening on port 8080 or configure this application to listen on another port.\n","logger_name":"org.springframework.boot.diagnostics.LoggingFailureAnalysisReporter","thread_name":"main","severity":"ERROR","severity_value":40000,"type":"SYSTEM"}
```

- キーワードとしては以下！
  - `Web server failed to start. Port 8080 was already in use.`: 8080ポートが既に使われている
  - `Identify and stop the process that's listening on port 8080 or configure this application to listen on another port.`: 8080ポートを使っているプロセスを特定して、停止するか、別のポートを使うように設定する

- この記事では、上記エラーが出た際の解決する方法を紹介します。

## なんで8080ポートを使っているプロセスがあるの？
- Spring Bootのアプリケーションを起動すると、デフォルトで8080ポートを使ってアプリケーションが起動します。
  - 参考：[How to Configure Spring Boot Tomcat](https://www.baeldung.com/spring-boot-configure-tomcat#1-server-address-and-port)
- Spring BootにはJavaのWebアプリケーションを動かす為に必要なApplication Server(=Tomcat)が内蔵されています。
  - このApplication Serverがデフォルトで8080ポートを使ってアプリケーションを起動します。
  - 参考：[1. Spring Boot の導入](https://spring.pleiades.io/spring-boot/docs/current/reference/html/getting-started.html#getting-started.introducing-spring-boot)
- 以前実行したプロセスが残っていたりすると、すでに8080ポートを使っているよ！というエラーが表示されます。

## 対象環境
- 以下の環境で確認しています。
  - macOS Sonoma 14.0.0
  - Spring Boot 3.2.1
  - Java 17

- 基本的には、Spring Bootのバージョンに関わらず、同じような対応で解決できると思います！

## 作業手順
- 以下の手順で解決していきます。
  - 1. 8080ポートを使っているプロセスを特定する
  - 2. 8080ポートを使っているプロセスを停止する
  - 3. Spring Bootのアプリケーションを起動する

### 1. 8080ポートを使っているプロセスを特定する
- 8080ポートを使っているプロセスを特定するには、以下のコマンドを実行します。

コマンド
```shell
$ lsof -i :8080
```
```shell
% lsof -i :8080
COMMAND   PID           USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
java    19945 takumi.kuroiwa  115u  IPv6 0x72b80f8311dfac81      0t0  TCP *:http-alt (LISTEN)
```

### 2. 8080ポートを使っているプロセスを停止する
- 8080ポートを使っているプロセスを停止するには、以下のコマンドを実行します。

コマンド
```shell
$ kill -9 <PID>
```
```shell
$ kill -9 19945
```

- プロセスをkillした後、再度8080ポートを使っているプロセスを特定するコマンドを実行して、プロセスが停止していることを確認します。

```shell
$ lsof -i :8080
```

### 3. Spring Bootのアプリケーションを起動する
- 8080ポートを使っているプロセスを停止した後、Spring Bootのアプリケーションを起動します。
  - 無事にアプリケーションが起動できることを確認します。

## まとめ
- 結構ちょくちょく直面するので、覚えておくと便利です！
  - shellとかにしておくと、すぐに8080ポートを使っているプロセスを停止できるのでいいかもです！

- 例：指定したポートを使っているプロセスをkillするshell
```shell
#!/bin/bash

# ユーザーにポート番号を尋ねる
echo "Please enter the port number:"
read port

# 指定されたポートを使用しているプロセスをリストアップ
echo "Processes using port $port:"
lsof -i :$port

# ユーザーにPIDを尋ねる
echo "Please enter the PID of the process you want to kill:"
read pid

# プロセスを終了
kill -9 $pid

echo "Process $pid has been killed."
```

## 参考
- [【ps・kill】実行中のプロセス表示と強制終了](https://qiita.com/shuntaro_tamura/items/4016868bda604baeac3c)
