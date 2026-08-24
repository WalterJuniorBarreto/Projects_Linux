#!/bin/bash
set -euo pipefail

echo "[+] Instalando herramientas y dependencias..."
sudo dnf install -y curl stress-ng firewalld

echo "[+] Habilitando el servicio firewalld..."
sudo systemctl enable --now firewalld

echo "[+] Instalando Netdata mediante el script oficial Kickstart..."
curl https://get.netdata.cloud/kickstart.sh > /tmp/netdata-kickstart.sh
sh /tmp/netdata-kickstart.sh --non-interactive

echo "[+] Configurando regla de firewall para el puerto 19999..."
sudo firewall-cmd --permanent --add-port=19999/tcp
sudo firewall-cmd --reload

echo "[+] Configurando la alarma personalizada de CPU (>80%)..."
sudo mkdir -p /etc/netdata/health.d/
sudo tee /etc/netdata/health.d/cpu_usage.conf > /dev/null <<'EOF'
 alarm: 10min_cpu_usage_custom
    on: system.cpu
lookup: average -1m unaligned of user,system,softirq,irq,guest
 units: %
 every: 10s
  warn: $this > 70
  crit: $this > 80
 delay: down 1m
  info: El uso promedio de CPU supero el 80% en el ultimo minuto
EOF

echo "[+] Recargando alarmas de Netdata e iniciando servicio..."
sudo systemctl enable --now netdata
sudo netdatacli reload-health || true

echo "[✓] Instalación completada. Accede al dashboard en: http://localhost:19999"
