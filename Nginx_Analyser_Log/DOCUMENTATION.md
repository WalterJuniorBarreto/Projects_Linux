# Estructura del Script y Comandos Utilizados

## 1. Modo Estricto (Seguridad)

El script inicia con directivas de seguridad para asegurar su correcta ejecución:
*   `set -euo pipefail`: 
    *   `-e`: Detiene la ejecución si cualquier comando falla.
    *   `-u`: Trata las variables no definidas como errores.
    *   `-o pipefail`: Evita que los errores se oculten dentro de una cadena de tuberías (`|`).

## 2. Validaciones de Entrada

El script verifica que el entorno de ejecución sea válido antes de procesar datos:
*   `if [ $# -eq 0 ]`: Comprueba que el usuario haya proporcionado exactamente un argumento (la ruta del archivo de log).
*   `if [ ! -f "$LOG_FILE" ]`: El operador `-f` verifica que la ruta proporcionada corresponda a un archivo regular existente y no a un directorio o enlace roto.

## 3. Pipeline de Procesamiento de Datos

El núcleo del script se basa en encadenar comandos estándar de Linux mediante tuberías (`|`) para transformar el texto crudo en métricas. El patrón general utilizado es:

`awk -> sort -> uniq -> sort -> head -> awk (formateo final)`

### Detalle de los Comandos:

*   **`awk '{print $N}'`**: Lee el archivo línea por línea y extrae una columna específica, usando el espacio como delimitador predeterminado.
    *   `$1`: Extrae la Dirección IP.
    *   `$7`: Extrae la Ruta (Path) solicitada.
    *   `$9`: Extrae el Código de Estado (Status Code).
*   **`awk -F\" '{print $6}'`**: Para extraer el Agente de Usuario (User Agent), se cambia el delimitador a comillas dobles (`-F\"`) y se extrae la sexta columna resultante, ya que este dato contiene espacios internos.
*   **`sort`**: Ordena alfabéticamente la lista de datos extraídos. Esto es un requisito técnico obligatorio para que el siguiente comando funcione correctamente.
*   **`uniq -c`**: Colapsa las líneas duplicadas consecutivas en una sola y añade un prefijo numérico indicando cuántas veces apareció esa línea (`count`).
*   **`sort -nr`**: Vuelve a ordenar la lista, pero esta vez numéricamente (`-n`) basándose en el conteo, y en orden inverso/descendente (`-r`), colocando los elementos más frecuentes en la parte superior.
*   **`head -n 5`**: Trunca la salida para mostrar únicamente las primeras 5 líneas de la lista ordenada.
*   **`awk '{print ...}'` (Bloque final)**: Reorganiza la salida resultante para que coincida exactamente con el formato visual requerido por el proyecto (ej. "Valor - N requests").
