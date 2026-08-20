# Desglose Técnico del Entorno y Parámetros

## 1. Automatización con Bash (`deploy.sh`)

* `set -euo pipefail`:
    * `-e`: Detiene la ejecución del script de inmediato si algún comando devuelve un código de error distinto de cero.
    * `-u`: Trata el uso de variables no inicializadas como un error fatal.
    * `-o pipefail`: Asegura que una tubería (`|`) falle si cualquiera de sus comandos individuales falla, no solo el último.

## 2. Herramienta de Sincronización (`rsync`)

El comando base ejecutado es:
```bash
rsync -avz --delete "$LOCAL_DIR" "${SERVER}:${REMOTE_DIR}"
-a (--archive): Modo archivo. Preserva recursivamente la estructura de directorios, enlaces simbólicos, permisos de archivos, marcas de tiempo, grupos y propietarios.

-v (--verbose): Proporciona información detallada en la salida estándar sobre los archivos que se están transfiriendo.

-z (--compress): Comprime los fragmentos de datos durante el tránsito de red para optimizar la velocidad y reducir el ancho de banda consumido.

--delete: Elimina del servidor de destino cualquier archivo que ya no exista en el directorio local de origen, asegurando paridad exacta entre ambos entornos.

Sintaxis de rutas: La barra final en ./public/ indica a rsync que copie el contenido del directorio en lugar del directorio en sí.

3. Servidor Web (nginx)
Directorio Raíz (DocumentRoot): En sistemas basados en Fedora/RHEL, el directorio predeterminado es /usr/share/nginx/html (a diferencia de /var/www/html en entornos Debian/Ubuntu).

Gestión de Permisos (chown): chown -R $USER:$USER /usr/share/nginx/html permite que el proceso de despliegue por SSH opere de forma no interactiva sin requerir elevación mediante sudo, preservando el principio de mínimo privilegio.

4. Servicio de Cortafuegos (firewalld)
sudo firewall-cmd --permanent --add-service=http: Añade la regla de apertura para el puerto 80/TCP de forma persistente en la zona activa.

sudo firewall-cmd --reload: Recarga la configuración del cortafuegos en memoria sin interrumpir las conexiones establecidas.
