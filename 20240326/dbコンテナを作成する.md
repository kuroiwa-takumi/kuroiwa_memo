- **※ 本記事は作業ログです**
- 最近、DB絡みで色々と検証することが増えたのでDBコンテナを立てておきたい
  - 色々なDBを使うことがあるので、それぞれのDBを使うためのコンテナを作成します
  - 今回は「MySQL」, 「PostgreSQL」のコンテナ
  - SQL Serverも作りたかったのですが、色々と設定が必要なので後回し・・・

## 環境
- M1 Mac
- Docker Desktop for Mac

## docker-compose.ymlを作成する
- 「PostgreSQL」, 「SQL Server」のコンテナを作成するための`docker-compose.yml`を作成していきます

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:latest  # MySQLの最新版を使用
    environment:
      MYSQL_ROOT_PASSWORD: example
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql

  postgres:
    image: postgres:latest  # PostgreSQLの最新版を使用
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: example
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data

# データを永続化するためにボリュームを定義
volumes:
  mysql-data:
  postgres-data:
```

## コンテナを起動する
- `docker-compose.yml`があるディレクトリで以下のコマンドを実行します
- 以下のコマンドを`init.sh`に記述しておく

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
```shell
takumi.kuroiwa % sh init.sh
# docker compose -p db-sample down -v
[+] Running 5/5
 ✔ Container mysql-container       Removed                                                                                                                                                                              0.0s 
 ✔ Container postgres-container    Removed                                                                                                                                                                              0.2s 
 ✔ Volume db-sample_mysql-data     Removed                                                                                                                                                                              0.1s 
 ✔ Volume db-sample_postgres-data  Removed                                                                                                                                                                              0.1s 
 ✔ Network db-sample_default       Removed                                                                                                                                                                              0.1s 
# docker compose -p db-sample up -d
[+] Running 5/5
 ✔ Network db-sample_default         Created                                                                                                                                                                            0.0s 
 ✔ Volume "db-sample_mysql-data"     Created                                                                                                                                                                            0.0s 
 ✔ Volume "db-sample_postgres-data"  Created                                                                                                                                                                            0.0s 
 ✔ Container mysql-container         Started                                                                                                                                                                            0.6s 
 ✔ Container postgres-container      Started                                                                                                                                                                            0.6s 

# docker compose ps
NAME                 IMAGE               COMMAND                  SERVICE             CREATED             STATUS                  PORTS
mysql-container      mysql:latest        "docker-entrypoint.s…"   mysql               1 second ago        Up Less than a second   0.0.0.0:3306->3306/tcp, 33060/tcp
postgres-container   postgres:latest     "docker-entrypoint.s…"   postgres            1 second ago        Up Less than a second   0.0.0.0:5432->5432/tcp
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

