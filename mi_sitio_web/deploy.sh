#!/bin/bash



set -euo pipefail



SERVER="barretto@localhost"
REMOTE_DIR="/usr/share/nginx/html"
LOCAL_DIR="./public/"

echo "Iniciando despliegue hacia $SERVER...."

rsync -avz --delete  "$LOCAL_DIR" "${SERVER}:${REMOTE_DIR}"

echo "Despliegue completado con exito"


