case "${1:-help}" in
  dev)
    set -a && source .env.development && set +a
    ENV=development docker compose \
      -f docker-compose.yml \
      -f docker-compose.development.yml \
      up
    ;;
  stop)
    docker compose down
    ;;
  deploy)
    "$0" build
    set -a && source .env.production && set +a
    ENV=production docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      run --rm migrate
    "$0" start
    ;;
  start)
    set -a && source .env.production && set +a
    ENV=production docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      up -d
    ;;
  build)
    set -a && source .env.production && set +a
    ENV=production docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      build
    ;;
  logs)
    docker compose logs -f
    ;;
  *)
    echo "Usage: ./run.sh {dev|build|start|stop|logs|deploy}"
    ;;
esac
