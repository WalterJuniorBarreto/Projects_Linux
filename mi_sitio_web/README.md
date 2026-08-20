# Despliegue de Sitio Web Estático con Nginx y Rsync

Automatización del flujo de sincronización y entrega de archivos para un sitio web estático utilizando Nginx como servidor web y Rsync sobre SSH como mecanismo de transporte.

## Descripción

Este proyecto documenta la configuración de un servidor web Nginx en Linux y la creación de un script de despliegue en Bash. Mediante el uso de `rsync`, el flujo transfiere únicamente los archivos modificados desde el entorno de trabajo local hacia el directorio raíz del servidor web, reduciendo el consumo de ancho de banda y los tiempos de actualización.

## Estructura del Repositorio

```text
.
├── deploy.sh           # Script de automatización del despliegue
├── public/             # Directorio con los archivos fuente del sitio web
│   ├── index.html
│   └── style.css
├── README.md           # Resumen general y guía de uso
└── DOCUMENTATION.md    # Desglose técnico de comandos y arquitectura

Requisitos Previos
Sistema operativo basado en Linux (Fedora, Debian, Ubuntu, RHEL).

Servidor web Nginx instalado y en ejecución.

Utilidad rsync y cliente/servidor OpenSSH configurados.

Permisos de escritura para el usuario de despliegue en el directorio web de Nginx.

Instalación y Configuración del Servidor
1. Instalación e Inicio de Nginx
Bash
sudo dnf install nginx -y
sudo systemctl enable --now nginx
2. Configuración de Reglas de Cortafuegos
Habilitar el tráfico HTTP (puerto 80):

Bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
3. Ajuste de Permisos en el Directorio Web
Asignar la propiedad del directorio raíz de Nginx al usuario local para permitir transferencias sin elevación de privilegios:

Bash
sudo chown -R $USER:$USER /usr/share/nginx/html
Uso del Script de Despliegue
Asignar permisos de ejecución al script:

Bash
chmod +x deploy.sh
Ejecutar el despliegue:

Bash
./deploy.sh
Verificar la disponibilidad del sitio ingresando a http://localhost o la dirección IP del servidor en el navegador.
