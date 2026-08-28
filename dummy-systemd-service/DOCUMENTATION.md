# Desglose Técnico: Arquitectura de Servicios con Systemd

## 1. Estructura de la Unidad (`dummy.service`)

```ini
[Unit]
Description=Dummy Long Running Background Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/dummy.sh
Restart=always
RestartSec=5
User=root
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
2. Explicación de Secciones y Directivas
Sección [Unit]
Description: Nombre descriptivo para visualización en systemctl status y logs de arranque.

After=network.target: Orden de dependencias; garantiza que el servicio no intente ejecutarse hasta que los servicios básicos de red estén disponibles.

Sección [Service]
Type=simple: Modelo estándar de ejecución donde el proceso iniciado por ExecStart es el proceso principal del servicio.

ExecStart=/usr/local/bin/dummy.sh: Ruta absoluta requerida al ejecutable.

Restart=always: Política de tolerancia a fallos. Si el proceso termina inesperadamente, recibe una señal SIGKILL o se detiene con error, systemd lo regenera automáticamente.

RestartSec=5: Intervalo de espera (en segundos) antes de intentar reiniciar el proceso caído para evitar bucles rápidos de sobrecarga.

StandardOutput / StandardError: Redirige los flujos stdout y stderr a systemd-journald.

Sección [Install]
WantedBy=multi-user.target: Define el target del sistema donde se crea el enlace simbólico al ejecutar systemctl enable, permitiendo el inicio automático en el arranque estándar del sistema operativo.

3. Pruebas de Resiliencia y Ciclo de Vida
El mecanismo de reinicio automático se valida enviando una señal terminal al PID activo:

Bash
sudo kill -9 $(systemctl show --property MainPID --value dummy)
systemd captura la terminación del proceso (status=9/KILL), espera el lapso configurado en RestartSec y crea un nuevo proceso asignando un PID distinto sin intervención manual.
