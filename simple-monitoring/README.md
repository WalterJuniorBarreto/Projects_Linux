# Monitoreo de Infraestructura en Tiempo Real con Netdata

Configuración y automatización de un entorno de observabilidad y métricas del sistema utilizando Netdata Agent, reglas de alertas personalizadas y scripts de validación en Linux.

## Descripción del Proyecto

Este proyecto implementa una solución de monitoreo continuo para servidores Linux. Proporciona visibilidad en tiempo real sobre el uso de CPU, consumo de memoria RAM y operaciones de entrada/salida en disco (Disk I/O), integrando scripts en Bash para el aprovisionamiento automatizado, pruebas de estrés y limpieza del sistema.

## Estructura del Repositorio

```text
.
├── setup.sh              # Aprovisionamiento e instalación desatendida de Netdata
├── test_dashboard.sh     # Generador de pruebas de estrés de CPU con stress-ng
├── cleanup.sh            # Script de desinstalación y restauración del sistema
├── README.md             # Guía de inicio rápido y uso
└── DOCUMENTATION.md      # Desglose técnico de métricas, alarmas y arquitectura


Requisitos Previos
Sistema Operativo Linux (Fedora, RHEL, Ubuntu, Debian).

Privilegios de administrador (sudo).

Conexión a internet para descarga de paquetes.

Guía de Uso Rápido
1. Aprovisionamiento e Instalación
Ejecuta el script principal para instalar Netdata, habilitar el servicio en systemd, abrir el puerto en el firewall y configurar la alarma de CPU:

Bash
chmod +x *.sh
./setup.sh
2. Acceso al Dashboard
Abre tu navegador e ingresa a:

Plaintext
http://localhost:19999
3. Validación y Prueba de Carga
Para verificar la reacción del dashboard y disparar las alertas en vivo:

Bash
./test_dashboard.sh
4. Limpieza del Sistema
Para desinstalar Netdata y revertir las reglas del firewall:

Bash
./cleanup.sh
