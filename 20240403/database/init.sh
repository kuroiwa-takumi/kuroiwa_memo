#!/bin/bash

set -e

CUR_DIR=$(cd "$(dirname "$0")" && pwd)

# Docker Composeを使用してコンテナを停止し、ボリュームを削除する
echo '# docker compose -p db-sample-sqlserver down -v'
docker compose -p db-sample-sqlserver down -v

echo '# docker compose -p db-sample-sqlserver up -d'
docker compose -p db-sample-sqlserver up -d

echo ''
echo '# docker compose ps'
docker compose -p db-sample-sqlserver ps
