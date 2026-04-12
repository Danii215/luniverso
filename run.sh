#!/usr/bin/env bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
SITE="$ROOT/luniverso-site"
GAME="$ROOT/luniverso-game"
AUTH="$ROOT/luniverso-auth"

case "${1:-help}" in
  dev)
    (cd "$SITE" && node_modules/.bin/next dev) &
    (cd "$GAME" && bun run dev) &
    wait
    ;;
  build)
    echo "==> Building site..."
    (cd "$SITE" && node_modules/.bin/next build)
    echo "==> Building game..."
    (cd "$GAME" && bun run build:prod)
    echo "==> Building auth..."
    (cd "$AUTH" && bunx prisma generate && bun run build)
    echo "==> Done."
    ;;
  start)
    pm2 start "$ROOT/ecosystem.config.cjs"
    ;;
  stop)
    pm2 stop all
    ;;
  restart)
    pm2 restart all
    ;;
  logs)
    pm2 logs
    ;;
  deploy)
    "$0" build
    "$0" restart
    ;;
  *)
    echo "Usage: ./run.sh {dev|build|start|stop|restart|logs|deploy}"
    ;;
esac
