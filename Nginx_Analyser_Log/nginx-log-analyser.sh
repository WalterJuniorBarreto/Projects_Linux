#!/bin/bash

# ==============================================================================
# CLI Tool: nginx-log-analyser
# Descripción: Analiza archivos access.log de Nginx y extrae métricas clave.
# ==============================================================================

set -euo pipefail

# --- VALIDACIONES ---
if [ $# -eq 0 ]; then
    echo "Error: Falta el archivo de registro (log)."
    echo "Uso: ./nginx-log-analyser.sh <ruta_al_archivo.log>"
    exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: El archivo '$LOG_FILE' no existe o no es válido."
    exit 1
fi

echo "Analizando el archivo: $LOG_FILE"
echo "======================================================"

# --- 1. Top 5 Direcciones IP ---
echo -e "\nTop 5 IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'

# --- 2. Top 5 Rutas  ---
echo -e "\nTop 5 most requested paths:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'

# --- 3. Top 5 Códigos de Estado ---
echo -e "\nTop 5 response status codes:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests"}'

# --- 4. Top 5 Agentes de Usuario ---
echo -e "\nTop 5 user agents:"
awk -F\" '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{count=$1; $1=""; sub(/^ /, "", $0); print $0 " - " count " requests"}'

echo -e "\n======================================================"
