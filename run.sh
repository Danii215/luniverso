case "${1:-help}" in
  dev)
    ENV=development docker compose \
      -f docker-compose.yml \
      -f docker-compose.development.yml \
      up
    ;;
  start)
    ENV=production docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      up -d
    ;;
  stop)
    docker compose down
    ;;
  build)
    ENV=production docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      build
    ;;
  deploy)
    "$0" build
    # Roda migrations antes de subir
    ENV=production docker compose \
      -f docker-compose.yml \
      -f docker-compose.production.yml \
      run --rm migrate
    "$0" start
    ;;
  logs)
    docker compose logs -f
    ;;
  *)
    echo "Usage: ./run.sh {dev|build|start|stop|logs|deploy}"
    ;;
esac
