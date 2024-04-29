## 検証用のDBコンテナを作成する - SQLServer編 -
- **※ 本記事は作業ログです**
- 前回の記事では「MySQL」, 「PostgreSQL」のコンテナを作成しました
  - 今回は「SQLServer」のコンテナを作成します

### 参考
- [クイック スタート:Docker を使用して SQL Server Linux コンテナー イメージを実行する](https://learn.microsoft.com/ja-jp/sql/linux/quickstart-install-connect-docker?view=sql-server-ver16&tabs=cli&pivots=cs1-bash)
- [初期化済みSQL ServerのDockerイメージの作り方](https://zenn.dev/nuits_jp/articles/2022-09-05-initialized-sql-server-container)

## 概要
- SQLServerのコンテナイメージはデフォルトで初期化スクリプトを実行する仕組みがなさそうだった
  - エントリポイントスクリプトを作成して、初期化スクリプトを実行するようにするようにします

### Dockerfileを作成する
```dockerfile
# Microsoftの公式Docker HubリポジトリからSQL Server 2022の最新イメージをベースとして使用
FROM mcr.microsoft.com/mssql/server:2022-latest

# コンテナ内のスクリプトのパス
ENV INIT_SCRIPT_PATH /usr/src/app/init.sql

# 初期スクリプトをコンテナにコピー
COPY init_sqlserver.sql $INIT_SCRIPT_PATH

# SQL Serverが起動してから初期スクリプトを実行するシェルスクリプト
COPY --chmod=+x entrypoint_sqlserver.sh /usr/src/app/entrypoint.sh

# エントリポイントをカスタムスクリプトに設定
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
```
### docker-compose.yml
```yaml

```


```shell
# Docker Composeを使用してコンテナを停止し、ボリュームを削除する
echo '# docker compose -p db-sample down -v'
docker compose -p db-sample down -v

echo '# docker compose -p db-sample up -d'
docker compose -p db-sample up -d

echo ''
echo '# docker compose ps'
docker compose -p db-sample ps
```
```shell
sh ./init.sh
```


## コンテナに接続する
- `mysql`, `postgres`コンテナに接続してみます

```shell
# MySQLに接続
echo '# docker exec -it mysql-container mysql -u root -p'
docker exec -it mysql-container mysql -u root -p

# PostgreSQLに接続
echo '# docker exec -it postgres-container psql -U postgres -d sample_db'
docker exec -it postgres-container psql -U postgres -d sample_db
```

## 最後に
- これで、MySQL, PostgreSQLのコンテナが立ち上がり、接続できるようになりました
  - 今後はこれらのコンテナをベースに、色々と検証を行っていきます

