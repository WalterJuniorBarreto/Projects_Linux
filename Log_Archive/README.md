# Log Archive Tool

Una herramienta de línea de comandos (CLI) escrita en Bash para archivar, comprimir y gestionar directorios de logs en sistemas operativos Linux. 

## Descripción

En entornos de servidores, los archivos de registro pueden crecer rápidamente y consumir gran parte del almacenamiento disponible. `log-archive` permite empaquetar directorios enteros de logs en un archivo comprimido (`.tar.gz`), anexando una marca de tiempo precisa en el nombre del archivo para facilitar su posterior identificación. Además, mantiene un archivo de auditoría para rastrear qué directorios fueron archivados y cuándo.

## Características

*   **Compresión Eficiente**: Utiliza `tar` y `gzip` para reducir el tamaño de los archivos de texto.
*   **Nomenclatura Dinámica**: Genera nombres de archivo únicos basados en la fecha y hora de ejecución (formato: `YYYYMMDD_HHMMSS`).
*   **Trazabilidad de Auditoría**: Registra cada operación exitosa en un archivo `archive_history.log`.
*   **Seguridad Estricta**: Construido con `set -euo pipefail` para fallar rápidamente ante variables indefinidas o errores en los comandos de compresión.
*   **Rutas Relativas Limpias**: Comprime los directorios sin guardar la ruta absoluta completa, facilitando la extracción futura.

## Requisitos

*   Sistema operativo basado en Unix/Linux (Fedora, Ubuntu, Debian, CentOS, etc.)
*   Permisos de lectura sobre el directorio de logs que se desea archivar.
*   Utilidades GNU estándar: `bash`, `tar`, `date`, `basename`, `dirname`.

## Instalación

1. Clona o descarga el archivo del script:
   ```bash
   nano log-archive.sh
