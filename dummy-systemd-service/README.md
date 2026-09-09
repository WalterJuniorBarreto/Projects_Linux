# Linux Systemd Service Management & Automation

![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Systemd](https://img.shields.io/badge/Systemd-CC2200?style=for-the-badge&logo=debian&logoColor=white)
![Bash](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)

Implementación, empaquetado y gestión del ciclo de vida de un servicio en segundo plano (**daemon**) nativo de Linux administrado mediante **Systemd**, con soporte para autoreinicio ante fallos, redirección de logs dual (`syslog`/`journald` y archivo local) y scripts de instalación desasistida.

---

## Descripción del Proyecto

Este repositorio demuestra los fundamentos de la administración de procesos y demonios en sistemas operativos tipo UNIX.

A través de un servicio de demostración (`dummy.service`), se establece el ciclo de vida completo de una aplicación persistente: desde el registro en el subsistema `systemd`, configuración de dependencias de red y autoreparación ante caídas imprevistas (`Restart=always`), hasta la automatización de su instalación y remoción limpia del sistema de archivos.

### Características Implementadas

- **Control del demonio:** gestión estándar mediante `systemctl` (`start`, `stop`, `status`, `restart`, `enable`, `disable`).
- **Políticas de resiliencia:** configuración de reinicio automático ante terminación abrupta o fallos de ejecución mediante `Restart=always` y `RestartSec=5s`.
- **Monitoreo dual de logs:** captura de eventos en tiempo real mediante `journald` e histórico persistente en `/var/log/dummy-service.log`.
- **Automatización operativa:** scripts de shell (`install.sh` y `uninstall.sh`) para mover binarios a `/usr/local/bin`, registrar unidades en `/etc/systemd/system/` y recargar el daemon sin intervención manual.
- **Ejecución persistente:** el servicio permanece activo en segundo plano y puede ser administrado mediante las herramientas nativas de Linux.
- **Inicio automático:** configuración del servicio para iniciar automáticamente durante el arranque del sistema operativo.

---

## Estructura del Repositorio

```text
.
├── dummy.sh          # Script ejecutable principal
├── dummy.service     # Archivo unitario de configuración de systemd
├── install.sh        # Script automatizado de instalación y puesta en marcha
├── uninstall.sh      # Script de detención y eliminación del servicio
├── DOCUMENTATION.md  # Documentación técnica del proyecto
└── README.md         # Manual operativo del proyecto
```

---

## Requisitos Previos

### Sistema Operativo

Distribución Linux basada en `systemd`.

Distribuciones compatibles:

- Fedora
- Ubuntu Server
- Debian
- RHEL
- CentOS
- Arch Linux

### Herramientas

- GNU Bash
- Systemd
- Systemctl
- Journalctl
- Git

### Privilegios

Se requiere acceso administrativo mediante `sudo`, debido a que la instalación modifica directorios protegidos del sistema como:

```text
/usr/local/bin/
/etc/systemd/system/
/var/log/
```

---

# Guía de Puesta en Marcha

## 1. Clonar el Repositorio

Clona el repositorio:

```bash
git clone https://github.com/WalterJuniorBarreto/dummy-systemd-service.git
```

Ingresa al directorio:

```bash
cd dummy-systemd-service
```

---

## 2. Revisar los Archivos

Verifica que los archivos principales estén presentes:

```bash
ls -la
```

Deberías encontrar una estructura similar a:

```text
dummy-systemd-service/
├── dummy.sh
├── dummy.service
├── install.sh
├── uninstall.sh
├── DOCUMENTATION.md
└── README.md
```

---

## 3. Conceder Permisos de Ejecución

Antes de ejecutar los scripts, asigna permisos de ejecución:

```bash
chmod +x install.sh
chmod +x uninstall.sh
chmod +x dummy.sh
```

También puedes hacerlo en un solo comando:

```bash
chmod +x install.sh uninstall.sh dummy.sh
```

---

## 4. Despliegue Automatizado

Ejecuta el instalador con privilegios administrativos:

```bash
sudo ./install.sh
```

El script se encarga de realizar automáticamente las siguientes operaciones:

1. Copiar `dummy.sh` a `/usr/local/bin/`.
2. Asignar permisos de ejecución `755`.
3. Copiar `dummy.service` a `/etc/systemd/system/`.
4. Ejecutar `systemctl daemon-reload`.
5. Habilitar el servicio mediante `systemctl enable`.
6. Iniciar el servicio mediante `systemctl start`.

---

# Funcionamiento del Servicio

El proyecto utiliza un archivo de unidad de Systemd denominado:

```text
dummy.service
```

Este archivo define cómo debe ejecutarse y administrarse el proceso.

La arquitectura básica es:

```text
dummy.service
      |
      v
  systemd
      |
      v
 dummy.sh
      |
      v
Proceso en segundo plano
```

Systemd actúa como administrador del ciclo de vida del proceso.

---

# Comandos de Administración del Servicio

Una vez instalado, el servicio puede controlarse como cualquier demonio nativo de Linux.

| Acción | Comando |
| :--- | :--- |
| Consultar estado | `sudo systemctl status dummy` |
| Iniciar servicio | `sudo systemctl start dummy` |
| Detener servicio | `sudo systemctl stop dummy` |
| Reiniciar servicio | `sudo systemctl restart dummy` |
| Habilitar al arranque | `sudo systemctl enable dummy` |
| Deshabilitar del arranque | `sudo systemctl disable dummy` |
| Recargar configuración | `sudo systemctl daemon-reload` |

---

## Consultar el Estado

Para verificar si el servicio está funcionando:

```bash
sudo systemctl status dummy
```

Una salida esperada podría ser:

```text
● dummy.service - Dummy Systemd Service
     Loaded: loaded (/etc/systemd/system/dummy.service; enabled)
     Active: active (running)
```

El estado:

```text
Active: active (running)
```

indica que el proceso se encuentra ejecutándose correctamente.

---

# Inspección y Monitoreo de Logs

El servicio genera trazas periódicas que pueden consultarse mediante diferentes mecanismos.

---

## Journald

Systemd utiliza `journald` para recopilar los mensajes generados por los servicios.

Para visualizar los logs:

```bash
sudo journalctl -u dummy
```

---

## Logs en Tiempo Real

Para observar los mensajes a medida que son generados:

```bash
sudo journalctl -u dummy -f
```

La opción `-f` permite seguir los nuevos mensajes en tiempo real.

---

## Consultar Logs del Arranque Actual

Para consultar únicamente los logs generados durante el arranque actual:

```bash
sudo journalctl -u dummy -b
```

---

## Consultar Errores y Advertencias

Para mostrar únicamente eventos con prioridad de error o superior:

```bash
sudo journalctl -u dummy -p err..alert -b
```

---

# Archivo de Log Tradicional

Además de `journald`, el servicio puede registrar información en:

```text
/var/log/dummy-service.log
```

Para visualizar el contenido:

```bash
sudo cat /var/log/dummy-service.log
```

Para seguir los nuevos mensajes en tiempo real:

```bash
sudo tail -f /var/log/dummy-service.log
```

---

# Comparación de Métodos de Logging

| Método | Comando | Uso |
| :--- | :--- | :--- |
| Journald | `journalctl -u dummy` | Consulta general |
| Journald en tiempo real | `journalctl -u dummy -f` | Monitoreo |
| Logs del boot | `journalctl -u dummy -b` | Diagnóstico del arranque |
| Prioridad | `journalctl -u dummy -p err..alert -b` | Errores |
| Archivo local | `tail -f /var/log/dummy-service.log` | Histórico tradicional |

---

# Validación de Resiliencia

Una de las funcionalidades principales del proyecto es la recuperación automática del servicio ante una terminación inesperada.

La política configurada mediante Systemd utiliza:

```ini
Restart=always
RestartSec=5s
```

Esto significa que Systemd intentará iniciar nuevamente el servicio después de una terminación del proceso.

---

## 1. Identificar el PID

Primero consulta el estado del servicio:

```bash
sudo systemctl status dummy
```

También puedes obtener directamente el PID mediante:

```bash
systemctl show -p MainPID --value dummy
```

Ejemplo:

```text
12345
```

---

## 2. Forzar la Terminación del Proceso

Utiliza el PID obtenido anteriormente:

```bash
sudo kill -9 <PID>
```

Por ejemplo:

```bash
sudo kill -9 12345
```

El comando `kill -9` fuerza la terminación inmediata del proceso.

---

## 3. Verificar el Autoreinicio

Espera aproximadamente 5 segundos y consulta nuevamente:

```bash
sudo systemctl status dummy
```

También puedes comprobar el PID:

```bash
systemctl show -p MainPID --value dummy
```

El servicio debería encontrarse nuevamente en estado:

```text
Active: active (running)
```

Y deberá tener un nuevo PID.

---

## Resultado Esperado

Systemd detectará la terminación inesperada del proceso y ejecutará nuevamente el servicio después del intervalo definido por:

```text
RestartSec=5s
```

El nuevo proceso tendrá un PID diferente al anterior.

Esto demuestra la capacidad de recuperación automática del servicio ante fallos.

---

# Configuración de Systemd

El archivo:

```text
dummy.service
```

contiene las directivas necesarias para definir el comportamiento del servicio.

Una estructura típica es:

```ini
[Unit]
Description=Dummy Systemd Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/dummy.sh
Restart=always
RestartSec=5s
StandardOutput=append:/var/log/dummy-service.log
StandardError=append:/var/log/dummy-service.log

[Install]
WantedBy=multi-user.target
```

---

## Sección `[Unit]`

Esta sección contiene información general y dependencias del servicio.

Ejemplo:

```ini
[Unit]
Description=Dummy Systemd Service
After=network.target
```

### `Description`

Define una descripción legible del servicio.

### `After`

Indica que el servicio debe iniciarse después del objetivo especificado.

En este caso:

```text
network.target
```

---

# Sección `[Service]`

Define cómo se ejecutará el proceso.

```ini
[Service]
Type=simple
ExecStart=/usr/local/bin/dummy.sh
Restart=always
RestartSec=5s
```

### `Type=simple`

Indica que Systemd considera iniciado el servicio cuando comienza la ejecución del proceso especificado en `ExecStart`.

### `ExecStart`

Define el comando que ejecutará Systemd:

```text
/usr/local/bin/dummy.sh
```

### `Restart=always`

Indica que Systemd debe reiniciar el servicio cuando el proceso termine.

### `RestartSec=5s`

Define un retraso de 5 segundos antes de intentar iniciar nuevamente el servicio.

---

# Redirección de Logs

El servicio puede utilizar las siguientes directivas:

```ini
StandardOutput=append:/var/log/dummy-service.log
StandardError=append:/var/log/dummy-service.log
```

Esto permite almacenar:

- Salida estándar (`stdout`).
- Errores (`stderr`).

Dentro del archivo:

```text
/var/log/dummy-service.log
```

Al mismo tiempo, Systemd puede gestionar los mensajes mediante `journald`.

---

# Sección `[Install]`

Define cómo se integra el servicio con el proceso de arranque del sistema.

```ini
[Install]
WantedBy=multi-user.target
```

La directiva:

```text
WantedBy=multi-user.target
```

permite habilitar el servicio para que se ejecute durante el arranque normal del sistema.

---

# Flujo de Instalación

El proceso automatizado puede representarse de la siguiente manera:

```text
              install.sh
                  |
                  v
        Copiar dummy.sh
                  |
                  v
        /usr/local/bin/
                  |
                  v
        Copiar dummy.service
                  |
                  v
      /etc/systemd/system/
                  |
                  v
      systemctl daemon-reload
                  |
                  v
       systemctl enable dummy
                  |
                  v
       systemctl start dummy
                  |
                  v
          dummy.service
                  |
                  v
             dummy.sh
                  |
                  v
        Proceso en ejecución
```

---

# Ciclo de Vida del Servicio

El ciclo de vida completo puede representarse así:

```text
                  Instalación
                       |
                       v
                  Registrado
                       |
                       v
                    Start
                       |
                       v
                  Running
                       |
             +---------+---------+
             |                   |
             v                   v
          Stop                  Crash
             |                   |
             v                   v
           Stopped          Restarting
                                 |
                                 v
                              Running
```

---

# Automatización de la Instalación

El script:

```text
install.sh
```

permite realizar el proceso de instalación sin necesidad de ejecutar manualmente todos los comandos.

Las tareas principales son:

```text
1. Copiar dummy.sh
2. Configurar permisos
3. Instalar dummy.service
4. Recargar Systemd
5. Habilitar el servicio
6. Iniciar el servicio
```

Esto reduce la posibilidad de errores humanos durante la configuración.

---

# Desinstalación Completa

Para retirar completamente el servicio, ejecuta:

```bash
sudo ./uninstall.sh
```

El script de desinstalación debe encargarse de:

1. Detener el servicio.
2. Deshabilitar el servicio.
3. Eliminar el archivo de unidad.
4. Eliminar el ejecutable instalado.
5. Recargar la configuración de Systemd.
6. Eliminar los archivos de log si corresponde.

---

## Verificar la Desinstalación

Después de ejecutar el script:

```bash
sudo systemctl status dummy
```

El servicio ya no debería encontrarse disponible.

También puedes verificar que los archivos hayan sido eliminados:

```bash
ls -l /usr/local/bin/dummy.sh
```

Y:

```bash
ls -l /etc/systemd/system/dummy.service
```

Si fueron eliminados correctamente, ambos comandos deberían indicar que los archivos no existen.

---

# Comandos Principales

## Instalación

```bash
chmod +x install.sh uninstall.sh dummy.sh
sudo ./install.sh
```

## Estado

```bash
sudo systemctl status dummy
```

## Iniciar

```bash
sudo systemctl start dummy
```

## Detener

```bash
sudo systemctl stop dummy
```

## Reiniciar

```bash
sudo systemctl restart dummy
```

## Habilitar al Arranque

```bash
sudo systemctl enable dummy
```

## Deshabilitar al Arranque

```bash
sudo systemctl disable dummy
```

## Recargar Systemd

```bash
sudo systemctl daemon-reload
```

## Logs

```bash
sudo journalctl -u dummy
```

## Logs en Tiempo Real

```bash
sudo journalctl -u dummy -f
```

## Archivo de Logs

```bash
sudo tail -f /var/log/dummy-service.log
```

## Obtener PID

```bash
systemctl show -p MainPID --value dummy
```

## Desinstalar

```bash
sudo ./uninstall.sh
```

---

# Buenas Prácticas

El proyecto aplica diferentes prácticas recomendadas para la administración de servicios Linux:

- Utilizar Systemd en lugar de scripts manuales para administrar procesos.
- Mantener los archivos de unidad en `/etc/systemd/system/`.
- Utilizar rutas absolutas en `ExecStart`.
- Utilizar `systemctl daemon-reload` después de modificar archivos `.service`.
- Verificar el estado del servicio mediante `systemctl status`.
- Utilizar `journalctl` para diagnóstico.
- Configurar políticas de recuperación mediante `Restart`.
- Utilizar scripts automatizados para reducir errores manuales.
- Utilizar permisos adecuados sobre los ejecutables.
- Mantener separados los archivos de configuración, scripts y documentación.

---

# Objetivos del Proyecto

Este proyecto busca demostrar conocimientos prácticos en:

- Administración de sistemas Linux.
- Gestión de procesos y demonios.
- Systemd.
- Systemctl.
- Journald.
- Journalctl.
- Bash scripting.
- Automatización de tareas administrativas.
- Gestión del ciclo de vida de servicios.
- Recuperación automática ante fallos.
- Administración de logs.
- Permisos y rutas del sistema.
- Automatización de instalación y desinstalación.

---

# Tecnologías Utilizadas

| Tecnología | Uso |
| :--- | :--- |
| Linux | Sistema operativo |
| Systemd | Administración del servicio |
| Systemctl | Control del ciclo de vida |
| Journald | Sistema de registros |
| Journalctl | Consulta de logs |
| Bash | Automatización mediante scripts |
| Git | Control de versiones |

---

# Resultado Esperado

Después de ejecutar correctamente `install.sh`, el sistema deberá contar con:

```text
Linux
│
├── /usr/local/bin/
│   └── dummy.sh
│
├── /etc/systemd/system/
│   └── dummy.service
│
└── /var/log/
    └── dummy-service.log
```

Y el servicio deberá encontrarse en ejecución:

```text
dummy.service
       |
       v
     active
       |
       v
    running
       |
       v
    dummy.sh
```

Además, ante una terminación inesperada del proceso, Systemd deberá detectar el fallo y reiniciar automáticamente el servicio después del intervalo configurado.

---

# Licencia

Este proyecto puede utilizarse con fines educativos y demostrativos para practicar conceptos de Linux, Systemd, Bash scripting, administración de servicios y automatización de sistemas.
