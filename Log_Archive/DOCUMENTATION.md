# Estructura del Script y Comandos Utilizados

## 1. Modo Estricto (Seguridad)

El script inicia habilitando directivas de seguridad para evitar comportamientos inesperados:
*   `set -euo pipefail`: 
    *   `-e`: Detiene la ejecución inmediatamente si cualquier comando devuelve un código de error (distinto de 0).
    *   `-u`: Trata las variables no definidas como errores, evitando fallos silenciosos.
    *   `-o pipefail`: Asegura que si un comando falla dentro de una tubería (`|`), el error se propague y no sea enmascarado por el último comando de la cadena.

## 2. Variables de Configuración y Color

Define rutas por defecto y utiliza códigos de escape ANSI para la salida en pantalla:
*   `ARCHIVE_DESTINATION="${HOME}/archives"`: Establece la ruta absoluta donde se almacenarán los archivos comprimidos.
*   `HISTORY_LOG`: Define la ubicación del archivo de texto que servirá como bitácora de auditoría.
*   `RED (\033[0;31m)`, `GREEN (\033[0;32m)`, `YELLOW (\033[1;33m)`, `NC (\033[0m)`: Códigos para colorear el texto en la terminal y mejorar la legibilidad de errores y éxitos.

## 3. Validaciones (Clean Code)

Antes de ejecutar cualquier acción destructiva o de alto costo de procesamiento, el script verifica la entrada:
*   `if [ $# -eq 0 ]`: Comprueba si la cantidad de parámetros pasados al script (`$#`) es igual a 0. Si es así, interrumpe el proceso.
*   `if [ ! -d "$TARGET_DIR" ]`: El operador `-d` verifica si el argumento proporcionado es un directorio válido y existente en el sistema de archivos. El símbolo `!` niega la condición (es decir, "si no es un directorio").

## 4. Preparación de Nombres Dinámicos

Genera nombres de archivo únicos basados en el momento exacto de la ejecución para evitar sobreescrituras:
*   `TIMESTAMP=$(date +"%Y%m%d_%H%M%S")`: Llama al comando `date` y formatea la salida explícitamente a AñoMesDía_HoraMinutoSegundo.
*   `BASENAME=$(basename "$TARGET_DIR")`: Extrae únicamente el nombre final del directorio a comprimir (por ejemplo, de `/var/log/nginx` extrae solo `nginx`).
*   `ARCHIVE_NAME`: Concatena la ruta de destino, el nombre base y el timestamp con la extensión `.tar.gz`.

## 5. Ejecución y Compresión

Es el núcleo de la herramienta, encargado de empaquetar y comprimir los logs de forma segura:
*   `tar -czf "$ARCHIVE_NAME" -C "$(dirname "$TARGET_DIR")" "$BASENAME" 2>/dev/null`:
    *   `-c`: Crea un nuevo archivo de respaldo.
    *   `-z`: Aplica compresión gzip (reduciendo drásticamente el tamaño de los logs de texto).
    *   `-f`: Especifica que el siguiente argumento es el nombre del archivo resultante.
    *   `-C "$(dirname "$TARGET_DIR")"`: Cambia el directorio de trabajo al directorio padre antes de comprimir. Esto asegura que el archivo `.tar.gz` no contenga toda la estructura de carpetas absoluta (ej. `/var/log/...`), sino solo la carpeta objetivo.
    *   `2>/dev/null`: Redirige los errores estándar al "agujero negro" de Linux para mantener la salida de la consola limpia en caso de advertencias menores de permisos de lectura.

## 6. Auditoría y Registro

Mantiene un historial persistente de todas las operaciones exitosas:
*   `echo "[$(date +"%Y-%m-%d %H:%M:%S")] Archivado: $TARGET_DIR -> $ARCHIVE_NAME" >> "$HISTORY_LOG"`
    *   Genera una cadena de texto descriptiva.
    *   `>>`: Operador de redirección de adición. Escribe la salida al final del archivo `archive_history.log` sin borrar el contenido anterior.
