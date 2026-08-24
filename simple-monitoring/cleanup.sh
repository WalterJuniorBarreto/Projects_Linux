#!/bin/bash
set -euo pipefail

echo "[+] Deteniendo y deshabilitando el servicio Netdata..."
sudo systemctl stop netdata || true
sudo systemctl disable netdata || true

echo "[+] Ejecutando desinstalador de Netdata..."
if [ -f /usr/libexec/netdata/netdata-uninstaller.sh ]; then
    sudo /usr/libexec/netdata/netdata-uninstaller.sh --yes --force
elif [ -f /etc/netdata/netdata-uninstaller.sh ]; then
    sudo /etc/netdata/netdata-uninstaller.sh --yes --force
else
    echo "[!] Buscando script de desinstalacion..."
    UNINSTALLER=$(sudo find / -name "netdata-uninstaller.sh" 2>/dev/null | head -n 1 || true)
    if [ -n "$UNINSTALLER" ]; then
        sudo "$UNINSTALLER" --yes --force
    else
        echo "[!] No se encontro el desinstalador automatico. Limpiando binarios manualmente..."
        sudo rm -rf /etc/netdata /var/lib/netdata /var/cache/netdata /usr/share/netdata /usr/libexec/netdata
    fi
fi

echo "[+] Cerrando puerto 19999 en el cortafuegos..."
sudo firewall-cmd --permanent --remove-port=19999/tcp || true
sudo firewall-cmd --reload || true

echo "[+] Limpiando archivos temporales y paquetes de prueba..."
sudo rm -f /tmp/netdata-kickstart.sh

echo "[✓] Limpieza completada. Netdata ha sido removido del sistema."
