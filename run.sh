#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"

case "${1:-help}" in
  dev)
    docker compose \
      -f docker-compose.yml \
      -f docker-compose.development.yml \
      up
    ;;
  stop)
    docker compose down
    ;;
  build)
    ln -sf "$ROOT/.env.production" "$ROOT/.env"
    docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      build --no-cache
    ;;
  clean)
    docker system prune -af
    docker volume prune -f
    ;;
  migrate)
    docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      run --rm migrate
    ;;
  start)
    docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      up -d
    ;;
  deploy)
    "$0" clean
    "$0" build
    "$0" migrate
    "$0" start
    ;;
  logs)
    docker compose logs -f
    ;;
  *)
    echo "Usage: ./run.sh {dev|build|migrate|start|stop|logs|deploy}"
    ;;
esac