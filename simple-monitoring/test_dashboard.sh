#!/bin/bash
set -euo pipefail

# Validar que stress-ng este instalado
if ! command -v stress-ng &> /dev/null; then
    echo "[!] stress-ng no esta instalado. Instalando..."
    sudo dnf install -y stress-ng
fi

CORES=$(nproc)
DURATION=60

echo "[+] Generando carga de estres en la CPU..."
echo "[+] Nucleos detectados: $CORES"
echo "[+] Duracion: $DURATION segundos"
echo "[i] Observa en tiempo real tu dashboard en http://localhost:19999 para ver la alarma dispararse."

stress-ng --cpu "$CORES" --timeout "${DURATION}s" --metrics-brief

echo "[✓] Prueba de estres finalizada. La carga de CPU retornara a su estado normal."
