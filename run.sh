#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"

case "${1:-help}" in
  dev)
    set -a && source "$ROOT/.env.development" && set +a
    export ENV=development
    docker compose \
      -f docker-compose.yml \
      -f docker-compose.development.yml \
      up
    ;;
  stop)
    docker compose down
    ;;
  build)
    set -a && source "$ROOT/.env.production" && set +a
    export ENV=production
    docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      build
    ;;
  migrate)
    set -a && source "$ROOT/.env.production" && set +a
    export ENV=production
    docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      run --rm migrate
    ;;
  start)
    set -a && source "$ROOT/.env.production" && set +a
    export ENV=production
    docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      up -d
    ;;
  deploy)
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
