#!/bin/bash

# SQL Serverのデフォルトのエントリポイントをバックグラウンドで起動
/opt/mssql/bin/sqlservr &

# SQL Serverが起動するのを待つ
echo "Waiting for SQL Server to start..."
sleep 60s

# 初期スクリプトを実行
echo "Running initial script..."
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'password' -i $INIT_SCRIPT_PATH

# SQL Serverのプロセスをフォアグラウンドに持ってくる
wait $!
