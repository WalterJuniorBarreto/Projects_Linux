#!/bin/bash
set -euo pipefail

echo "[+] Instalando el script de la aplicacion en /usr/local/bin/..."
sudo cp dummy.sh /usr/local/bin/dummy.sh
sudo chmod +x /usr/local/bin/dummy.sh

echo "[+] Instalando la unidad systemd en /etc/systemd/system/..."
sudo cp dummy.service /etc/systemd/system/dummy.service

echo "[+] Recargando systemd e iniciando servicio..."
sudo systemctl daemon-reload
sudo systemctl enable --now dummy.service

echo "[✓] Servicio dummy instalado e iniciado correctamente."
sudo systemctl status dummy.service --no-pager
