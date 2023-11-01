# Docker Composeによるデータベースコンテナの作成手順
この手順書では、Docker Composeを使用してMySQL、PostgreSQL、SQLServerのコンテナを立ち上げる方法を説明します。

- Docker Compose: 複数のコンテナを効率的に操作するためのツール

## 1. docker-composeの設定
以下の内容でdocker-compose.ymlを作成します。
```yaml
version: '3'

services:
  mysql:
    image: mysql:latest
    container_name: mysql-container
    environment:
      MYSQL_ROOT_PASSWORD: my-secret-pw
      MYSQL_DATABASE: mydatabase
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql

  postgres:
    image: postgres:latest
    container_name: postgres-container
    environment:
      POSTGRES_PASSWORD: mysecretpassword
      POSTGRES_DB: mydatabase
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data

  sqlserver:
    image: mcr.microsoft.com/mssql/server:latest
    container_name: sqlserver-container
    environment:
      ACCEPT_EULA: "Y"
      SA_PASSWORD: YourStrong!Passw0rd
    ports:
      - "1433:1433"
    volumes:
      - sqlserver-data:/var/opt/mssql

volumes:
  mysql-data:
  postgres-data:
  sqlserver-data:
```

## 2. 各データベースの初期テーブルの作成
### 2.1 MySQL
- コンテナへの接続
```bash
docker exec -it mysql-container mysql -u root -pmydatabase
```
- テーブルの作成
```sql
CREATE TABLE example (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255)
);
```
### 2.2 PostgreSQL
- コンテナへの接続
```
docker exec -it postgres-container psql -U postgres -d mydatabase
```
- テーブルの作成
```sql
CREATE TABLE example (
id SERIAL PRIMARY KEY,
name TEXT
);
```

## 2.3 SQLServer
- コンテナへの接続
```shell
docker exec -it sqlserver-container /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'YourStrong!Passw0rd'
```
- テーブルの作成

```sql
USE MyDatabase;

CREATE TABLE example (
id INT PRIMARY KEY IDENTITY(1,1),
name NVARCHAR(255)
);
```
