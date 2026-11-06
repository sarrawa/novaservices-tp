#!/usr/bin/env bash
# Exécuté sur la VM. Usage : bash deploy.sh IMAGE@sha256:... VERSION_ATTENDUE
set -uo pipefail

IMAGE_REF="${1:?Usage: deploy.sh IMAGE@DIGEST VERSION}"
EXPECTED_VERSION="${2:?Usage: deploy.sh IMAGE@DIGEST VERSION}"
PORT="${APP_PORT:-8080}"
NAME="application-tp"
STATE_DIR="$HOME/.application-tp"
CURRENT="$STATE_DIR/current"   # contenu : "<image@digest> <version>"
mkdir -p "$STATE_DIR"

start() {
  docker pull "$1" || return 1
  docker rm -f "$NAME" >/dev/null 2>&1 || true
  docker run -d --name "$NAME" --restart unless-stopped -p "$PORT:8000" "$1" >/dev/null
}

wait_ok() {  # $1 = version attendue ; délai max 60 s
  for _ in $(seq 1 30); do
    if curl -fsS "http://localhost:$PORT/health" >/dev/null 2>&1; then
      v="$(curl -fsS "http://localhost:$PORT/version" 2>/dev/null || true)"
      if [[ "$v" == *"$1"* ]]; then return 0; fi
    fi
    sleep 2
  done
  return 1
}

PREV_REF=""; PREV_VER=""
if [[ -f "$CURRENT" ]]; then read -r PREV_REF PREV_VER < "$CURRENT"; fi

echo ">> Déploiement de $IMAGE_REF (version $EXPECTED_VERSION)"
if start "$IMAGE_REF" && wait_ok "$EXPECTED_VERSION"; then
  echo "$IMAGE_REF $EXPECTED_VERSION" > "$CURRENT"
  echo ">> OK : /health et /version conformes"
  exit 0
fi

echo ">> ECHEC du déploiement, journaux du conteneur :"
docker logs --tail 50 "$NAME" 2>&1 || true

if [[ -n "$PREV_REF" ]]; then
  echo ">> Retour arrière vers $PREV_REF"
  if start "$PREV_REF" && wait_ok "$PREV_VER"; then
    echo ">> Rollback OK (version $PREV_VER rétablie)"
  else
    echo ">> Rollback ECHEC, intervention manuelle nécessaire"
  fi
else
  echo ">> Aucune version précédente connue, pas de rollback possible"
fi
exit 1   # le job reste rouge pour conserver le diagnostic
