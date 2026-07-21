#!/bin/bash

# =================================================================================
# Nombre: server-stats.sh
# Descripcion: Script para analizar estadisticas basicas de rendimiento del sevidor.
# =================================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}==============================================="${NC}
echo -e "${GREEN}       ESTADÍSTICAS DE RENDIMIENTO DEL SERVIDOR       "${NC}
echo -e "${BLUE}======================================================"${NC}

echo -e "\n${YELLOW}[+] Informacion del SIstema:${NC}"
echo "------------------------------------------------------"
echo "OS Version     : $(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')"
echo "Uptime		: $(uptime -p)"
echo "Load Average	: $(uptime | awk -F'load average:' '{ print $2 }')"
echo "Logged in Users	: $(who | wc -l)"


echo -e "\n${YELLOW}[+] Uso Total de CPU:${NC}"
echo "------------------------------------------------------"
CPU_IDLE=$(top -bn1 | grep "%Cpu(s)" | awk '{print $8}' | cut -d',' -f1)
CPU_USAGE=$(awk "BEGIN {print 100 - $CPU_IDLE}")
echo "CPU Usada     : ${CPU_USAGE}%"
echo "CPU Libre     : ${CPU_IDLE}%"

echo -e "\n${YELLOW}[+] Uso Total de Memoria RAM:${NC}"
echo "------------------------------------------------------"
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($MEM_USED/$MEM_TOTAL)*100}")

echo "Total RAM     : ${MEM_TOTAL} MB"
echo "Usada         : ${MEM_USED} MB (${MEM_PERCENT}%)"
echo "Libre         : ${MEM_FREE} MB"

echo -e "\n${YELLOW}[+] Uso Total de Disco (/):${NC}"
echo "------------------------------------------------------"
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
DISK_PERCENT=$(df -h / | awk 'NR==2 {print $5}')

echo "Total Disco   : ${DISK_TOTAL}"
echo "Usado         : ${DISK_USED} (${DISK_PERCENT})"
echo "Libre         : ${DISK_FREE}"

echo -e "\n${YELLOW}[+] Top 5 Procesos por Uso de CPU:${NC}"
echo "------------------------------------------------------"
ps -eo pid,ppid,%mem,cmd --sort=-%mem | head -n 6 | awk '{printf "%-8s %-8s %-10s %-50s\n", $1, $2, $3"%", $4}'

echo -e "\n${YELLOW}[+] Top 5 Procesos por Uso de Memoria RAM:${NC}"
echo "------------------------------------------------------"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6 | awk '{printf "%-8s %-8s %-10s %-50s\n", $1, $2, $4"%", $3}'

echo -e "\n${BLUE}======================================================"${NC}
