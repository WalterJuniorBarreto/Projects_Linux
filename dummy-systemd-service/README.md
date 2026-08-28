# Dummy Systemd Service

Implementación y gestión de un servicio en segundo plano (daemon) de larga duración administrado mediante `systemd` en Linux.

## Descripción

Este proyecto demuestra la creación, configuración del ciclo de vida y monitoreo de un servicio persistente que registra actividad cada 10 segundos tanto en `/var/log/dummy-service.log` como en el sistema central de logs (`journald`), incluyendo políticas de auto-reinicio ante caídas imprevistas.

## Estructura del Repositorio

```text
.
├── dummy.sh          # Script de la aplicación en segundo plano
├── dummy.service     # Definición de la unidad de servicio systemd
├── install.sh        # Automatización de instalación y despliegue
├── uninstall.sh      # Limpieza y desinstalación completa
├── README.md         # Guía de uso rápido y comandos
└── DOCUMENTATION.md  # Análisis técnico de directivas y comportamiento
Guía de Uso Rápido
Instalación y Puesta en Marcha
Bash
./install.sh
Comandos de Gestión del Servicio
Iniciar: sudo systemctl start dummy

Detener: sudo systemctl stop dummy

Habilitar al arranque: sudo systemctl enable dummy

Deshabilitar al arranque: sudo systemctl disable dummy

Consultar estado: sudo systemctl status dummy

Monitoreo de Logs
Vía Journald: sudo journalctl -u dummy -f

Vía archivo local: sudo tail -f /var/log/dummy-service.log

Desinstalación
Bash
./uninstall.sh

