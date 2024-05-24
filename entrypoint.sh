#!/bin/bash
set -e

# Rails に対応したファイル server.pid が存在しているかもしれないので削除する。
rm -f /app/tmp/pids/server.pid

NODE_ENV=production yarn build
CSS_ENV=production yarn build:css

RAILS_ENV=production bundle exec rails assets:clobber
RAILS_ENV=production bundle exec rails assets:precompile
RAILS_ENV=production bundle exec rails assets:clean
RAILS_ENV=production bundle exec rails db:create
RAILS_ENV=production bundle exec rails db:migrate

bundle exec ridgepole -c config/database.yml -E production --apply -f db/schemas/Schemafile

# コンテナーのプロセスを実行する。（Dockerfile 内の CMD に設定されているもの。）
exec "$@"

echo "entrypoint.sh DONE DONE DONE DONE DONE DONE !!!! "