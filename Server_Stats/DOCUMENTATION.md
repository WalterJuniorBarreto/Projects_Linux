## Estructura del Script y Comandos Utilizados

### 1. Variables de Estilo y Color
El script utiliza códigos de escape ANSI para formatear la salida en pantalla y facilitar la lectura rápida mediante colores (Azul, Verde, Amarillo):

* **`GREEN` (`\033[0;32m`):** Encabezados principales.
* **`BLUE` (`\033[0;34m`):** Marcos y separadores visuales.
* **`YELLOW` (`\033[1;33m`):** Subtítulos de cada sección de métricas.
* **`NC` (`\033[0m`):** *No Color / Reset* para restaurar el formato por defecto de la terminal.

> **Nota:** Se utiliza `echo -e` para habilitar la interpretación de estos caracteres de escape.

---

### 2. Información del Sistema
Extrae datos generales sobre la salud y estado del sistema operativo combinando tuberías (`|`):

* **OS Version:** `grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"'`
  * **`grep`:** Filtra la línea descriptiva del sistema operativo.
  * **`cut`:** Separa el parámetro usando `=` como delimitador y extrae el valor.
  * **`tr -d '"'`:** Elimina las comillas dobles para presentar una cadena limpia.
* **Uptime:** `uptime -p`
  * Reporta el tiempo continuo transcurrido desde el último encendido o reinicio en formato amigable (*pretty*).
* **Load Average:** `uptime | awk -F'load average:' '{ print $2 }'`
  * Muestra la carga promedio de la CPU en los intervalos de 1, 5 y 15 minutos.
* **Logged in Users:** `who | wc -l`
  * Lista las sesiones activas en el servidor y las cuenta usando `wc -l`.

---

### 3. Uso Total de CPU
Mide el porcentaje de consumo actual del procesador:

* `CPU_IDLE=$(top -bn1 | grep "%Cpu(s)" | awk '{print $8}' | cut -d',' -f1)`
  * Ejecuta una captura única en modo batch de `top` y extrae el porcentaje en reposo (*idle*).
* `CPU_USAGE=$(awk "BEGIN {print 100 - $CPU_IDLE}")`
  * Utiliza `awk` en modo `BEGIN` a modo de calculadora de punto flotante para restar el % ocioso a 100 y obtener el uso real sin arrojar errores por decimales en Bash.

---

### 4. Uso Total de Memoria RAM
Analiza el comportamiento de la memoria física mediante el comando `free -m` (valores en Megabytes):

* **Memoria Total / Usada / Libre:**
  * Extrae la segunda (`$2`), tercera (`$3`) y cuarta (`$4`) columna del patrón `/Mem:/`.
* **Cálculo del Porcentaje de Uso:**
  * `awk "BEGIN {printf \"%.2f\", ($MEM_USED/$MEM_TOTAL)*100}"`
  * Aplica la regla de tres para el porcentaje y utiliza `printf "%.2f"` para redondear el resultado formateado a **exactamente 2 decimales**.

---

### 5. Uso Total de Disco (`/`)
Mide la ocupación de almacenamiento del punto de montaje raíz utilizando `df -h /`:

* **`df -h /`:** Inspecciona la partición principal con tamaños legibles para humanos (`G`, `M`).
* **`awk 'NR==2 {print $X}'`:** Se ubica estrictamente en la fila 2 (`NR==2`) para ignorar los encabezados de la tabla y extrae:
  * **`$2`:** Espacio Total.
  * **`$3`:** Espacio Usado.
  * **`$4`:** Espacio Libre.
  * **`$5`:** Porcentaje de Uso ya calculado por el SO.

---

### 6. Top 5 Procesos por Consumo de CPU y Memoria RAM
Identifica las aplicaciones o procesos que están consumiendo más recursos en el sistema:

* `ps -eo pid,ppid,%mem,cmd --sort=-%mem | head -n 6`
  * **`ps -eo`:** Especifica de forma personalizada las columnas a mostrar (PID, PPID, % Memoria/CPU, Comando).
  * **`--sort=-%mem`:** Ordena el listado de forma descendente (el signo `-` indica mayor a menor).
  * **`head -n 6`:** Muestra los primeros 6 resultados (1 fila de encabezado + los 5 procesos principales).
  * **`awk '{printf "%-8s %-8s %-10s %-50s\n", ...}'`:** Formatea cada columna con un ancho e indentación fijos (`%-8s`, etc.) para asegurar una alineación tabular impecable en pantalla.
