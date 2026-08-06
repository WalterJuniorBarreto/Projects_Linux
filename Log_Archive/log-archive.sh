#!/bin/bash

# ==============================================================================
# CLI Tool: log-archive
# Descripción: Archiva y comprime directorios de logs manteniendo trazabilidad.
# ==============================================================================

set -euo pipefail

# --- CONFIGURACION
ARCHIVE_DESTINATION="${HOME}/archives"
HISTORY_LOG="${ARCHIVE_DESTINATION}/archive_history.log"

# --- COLORES PARA LA TERMINAL ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' 

# --- FUNCIONES ---
mostrar_ayuda() {
    echo -e "${YELLOW}Uso: log-archive <directorio_de_logs>${NC}"
    echo "Ejemplo: log-archive /var/log"
    echo "Ejemplo: log-archive ~/mis_proyectos/logs"
    exit 1
}

# -- VALIDACIONES ---
if [ $# -eq 0 ]; then
    echo -e "${RED}[ERROR] Falta el argumento del directorio.${NC}"
    mostrar_ayuda
fi

TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}[ERROR] El directorio '$TARGET_DIR' no existe o no es válido.${NC}"
    exit 1
fi

# ---  PREPARACIÓN ---
mkdir -p "$ARCHIVE_DESTINATION"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BASENAME=$(basename "$TARGET_DIR")

ARCHIVE_NAME="${ARCHIVE_DESTINATION}/logs_archive_${BASENAME}_${TIMESTAMP}.tar.gz"

# --- EJECUCIÓN Y COMPRESIÓN ---
echo -e "Archivando logs de: ${YELLOW}$TARGET_DIR${NC}..."

if tar -czf "$ARCHIVE_NAME" -C "$(dirname "$TARGET_DIR")" "$BASENAME" 2>/dev/null; then
    echo -e "${GREEN}[ÉXITO] Archivo creado exitosamente:${NC} $ARCHIVE_NAME"
    
    # --- AUDITORÍA ---
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Archivado: $TARGET_DIR -> $ARCHIVE_NAME" >> "$HISTORY_LOG"
    echo -e "Registro guardado en: ${YELLOW}$HISTORY_LOG${NC}"
else
    echo -e "${RED}[ERROR] Falló la compresión. Verifica los permisos del directorio.${NC}"
    exit 1
fi
