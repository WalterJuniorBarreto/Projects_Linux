# Server Performance Stats

A lightweight Bash script (`server-stats.sh`) designed to analyze and display critical server performance metrics on any Linux environment.

## Features

- **System Information**: OS version, uptime, load average, and logged-in users.
- **CPU Metrics**: Total CPU usage and idle percentages.
- **Memory Stats**: Total, used, and free RAM in MB, including usage percentages.
- **Disk Usage**: Total, used, and free disk space for the root filesystem (`/`).
- **Top Resource Consumers**: Top 5 processes ordered by CPU usage and Memory usage.

## Requirements

- Linux OS (Fedora, Ubuntu, Debian, CentOS, RHEL, etc.)
- Standard Linux core utilities (`bash`, `procps` / `top`, `ps`, `awk`, `grep`)

## Installation & Usage

1. **Create the script file**:
   ```bash
   nano server-stats.sh```

2. **Grant execution permissions**:
   ```Bash
   chmod +x server-stats.sh ```

3. **Execute the script**:
   ```Bash
   ./server-stats.sh```

## Sample OutPut
======================================================
       ESTADÍSTICAS DE RENDIMIENTO DEL SERVIDOR       
======================================================

[+] Información del Sistema:
------------------------------------------------------
OS Version     : Fedora Linux 40 (Workstation Edition)
Uptime         : up 21 hours, 48 minutes
Load Average   : 0.78, 0.96, 1.20
Logged in Users: 2

[+] Uso Total de CPU:
------------------------------------------------------
CPU Usada     : 10%
CPU Libre     : 90%

[+] Uso Total de Memoria RAM:
------------------------------------------------------
Total RAM     : 15214 MB
Usada         : 10169 MB (66.84%)
Libre         : 897 MB

[+] Uso Total de Disco (/):
------------------------------------------------------
Total Disco   : 98G
Usado         : 53G (55%)
Libre         : 44G

[+] Top 5 Procesos por Uso de CPU:
------------------------------------------------------
PID      PPID     %CPU       CMD                                               
9280     3743     1.9%       /home/barretto/.local/share/code                  
...

## Project Context

This project to practice Linux system administration, Bash scripting, and core process metrics analysis.
