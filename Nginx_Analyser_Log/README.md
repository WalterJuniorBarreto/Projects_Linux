# Nginx Log Analyser

Una herramienta de línea de comandos (CLI) escrita en Bash diseñada para analizar archivos `access.log` de Nginx y extraer estadísticas clave de rendimiento y tráfico web.

## Descripción

Al administrar servidores web en producción, los archivos de registro pueden contener millones de líneas. Esta herramienta automatiza el análisis de estos registros mediante el uso eficiente de utilidades nativas de Linux (`awk`, `sort`, `uniq`, `head`), proporcionando un resumen inmediato de la actividad del servidor sin necesidad de software de monitoreo de terceros.

## Características

El script procesa el archivo de registro y extrae la siguiente información:
*   Top 5 Direcciones IP con mayor cantidad de solicitudes.
*   Top 5 Rutas (Paths) más solicitadas.
*   Top 5 Códigos de estado HTTP de respuesta (Status Codes).
*   Top 5 Agentes de usuario (User Agents).

## Requisitos

*   Sistema operativo basado en Unix/Linux.
*   Herramientas estándar instaladas (`bash`, `gawk/awk`, `coreutils`).
*   Un archivo de registro de Nginx con el formato estándar combinado (Combined Log Format).

## Instalación

1. Crear o descargar el archivo del script:
   ```bash
   nano nginx-log-analyser.sh
