#!/bin/bash
set -euo pipefail

echo "[+] Deteniendo y deshabilitando el servicio dummy..."
sudo systemctl stop dummy.service || true
sudo systemctl disable dummy.service || true

echo "[+] Eliminando archivos del sistema..."
sudo rm -f /etc/systemd/system/dummy.service
sudo rm -f /usr/local/bin/dummy.sh
sudo rm -f /var/log/dummy-service.log

echo "[+] Recargando demonio systemd..."
sudo systemctl daemon-reload
sudo systemctl reset-failed || true

echo "[✓] Desinstalacion y limpieza completadas."
