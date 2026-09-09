# Automated Web Server Deployment on AWS EC2

![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-Server_22.04_LTS-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-Web_Server-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Bash](https://img.shields.io/badge/Shell-Automation-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)

Aprovisionamiento y despliegue automatizado de un servidor web estático en la nube pública de **Amazon Web Services (AWS)** utilizando una instancia virtual **EC2**, autenticación criptográfica vía **SSH** y el servidor web **Nginx** sobre **Ubuntu Server**.

---

## Descripción General

El proyecto demuestra el ciclo de vida de administración de servidores remotos en entornos Cloud: aprovisionamiento de capacidad de cómputo, configuración de políticas perimetrales de cortafuegos mediante **AWS Security Groups**, transferencia segura de artefactos y automatización del despliegue desde un nodo local (Fedora/Linux) hacia la nube mediante un script de orquestación en Bash.

### Puntos Clave

- **Infraestructura Cloud:** configuración de cómputo en AWS mediante Amazon EC2.
- **Perímetro de red y seguridad:** configuración de reglas de tráfico entrante (*Inbound Rules*) mediante Security Groups.
- **Automatización desasistida:** script de shell (`deploy.sh`) que gestiona conexión SSH remota, aprovisionamiento de paquetes y transferencia de archivos mediante SCP.
- **Servicio Web:** instalación, habilitación y arranque de Nginx como servicio administrado por Systemd en Ubuntu.
- **Despliegue remoto:** transferencia automatizada de la aplicación web hacia el servidor EC2.

---

## Especificaciones de Infraestructura AWS

| Componente | Configuración Técnica | Propósito |
| :--- | :--- | :--- |
| **Servicio** | Amazon Elastic Compute Cloud (EC2) | Cómputo virtual en la nube |
| **AMI** | Ubuntu Server 22.04 / 24.04 LTS | Sistema operativo base |
| **Tipo de Instancia** | `t2.micro` o `t3.micro` | Instancia de bajo consumo |
| **Autenticación** | Llave RSA / ED25519 (`.pem`) | Administración remota mediante SSH |
| **Security Group** | Puerto 22 (SSH) y Puerto 80 (HTTP) | Administración y acceso web |
| **Servidor Web** | Nginx | Entrega de contenido HTTP |
| **Protocolo** | HTTP | Acceso al sitio web |

---

## Estructura del Repositorio

```text
.
├── deploy.sh       # Script Bash para aprovisionamiento y despliegue remoto
├── index.html      # Aplicación web estática
├── .gitignore      # Exclusión de credenciales privadas
└── README.md       # Documentación técnica del proyecto
```

---

## Requisitos Previos

### Workstation Local

El equipo desde donde se ejecutará el despliegue debe contar con:

- Linux (Fedora, Debian, Ubuntu) o macOS.
- Terminal Unix.
- Cliente `ssh`.
- Cliente `scp`.
- Comando `chmod`.
- Git.

Verifica SSH:

```bash
ssh -V
```

Verifica SCP:

```bash
scp -V
```

---

### AWS Cloud

Se requiere:

- Una cuenta de AWS.
- Una instancia EC2 activa en estado `Running`.
- Una dirección IPv4 pública.
- Una AMI de Ubuntu Server.
- Una clave privada `.pem`.
- Un Security Group correctamente configurado.

---

# Configuración del Security Group

El Security Group debe permitir únicamente el tráfico necesario.

| Tipo | Protocolo | Puerto | Origen | Propósito |
| :--- | :--- | :---: | :--- | :--- |
| SSH | TCP | `22` | Tu IP pública | Administración remota |
| HTTP | TCP | `80` | `0.0.0.0/0` | Acceso al sitio web |

Para mayor seguridad, el puerto SSH debería limitarse a la dirección IP pública desde donde se administra el servidor.

El puerto HTTP puede mantenerse accesible públicamente cuando el servidor debe entregar una página web.

---

# Guía de Uso

## 1. Clonar el Repositorio

Clona el proyecto:

```bash
git clone https://github.com/WalterJuniorBarreto/aws-ec2-deployment.git
```

Ingresa al directorio:

```bash
cd aws-ec2-deployment
```

---

## 2. Revisar los Archivos

Comprueba que los archivos principales estén presentes:

```bash
ls -la
```

Deberías encontrar:

```text
aws-ec2-deployment/
├── deploy.sh
├── index.html
├── .gitignore
└── README.md
```

---

## 3. Proteger la Clave Privada

AWS requiere que la clave privada utilizada para SSH tenga permisos restrictivos.

Ejecuta:

```bash
chmod 400 /ruta/a/tu/ec2-key.pem
```

También puedes utilizar:

```bash
chmod 600 /ruta/a/tu/ec2-key.pem
```

La opción recomendada para una clave privada utilizada directamente mediante SSH es `400`, ya que deja el archivo únicamente con permisos de lectura para el propietario.

Verifica los permisos:

```bash
ls -l /ruta/a/tu/ec2-key.pem
```

---

# Conexión Manual de Diagnóstico

Antes de ejecutar la automatización, es recomendable validar que la conexión SSH funcione correctamente.

Utiliza:

```bash
ssh -i /ruta/a/tu/ec2-key.pem ubuntu@<IP_PUBLICA_EC2>
```

Ejemplo:

```bash
ssh -i ~/.ssh/ec2-key.pem ubuntu@203.0.113.10
```

Si la conexión es correcta, aparecerá una terminal correspondiente al servidor Ubuntu.

Para salir:

```bash
exit
```

---

# Despliegue Automatizado

## 1. Conceder Permisos de Ejecución

Asigna permisos al script:

```bash
chmod +x deploy.sh
```

---

## 2. Ejecutar el Despliegue

Ejecuta:

```bash
./deploy.sh <IP_PUBLICA_EC2> /ruta/a/tu/ec2-key.pem
```

Ejemplo:

```bash
./deploy.sh 203.0.113.10 ~/.ssh/ec2-key.pem
```

El script automatiza las operaciones necesarias para preparar el servidor y desplegar la aplicación web.

---

# Flujo de Automatización

El proceso puede representarse de la siguiente manera:

```text
                  Workstation
                Fedora / Linux
                       |
                       v
                  deploy.sh
                       |
          +------------+------------+
          |                         |
          v                         v
        SSH                        SCP
          |                         |
          v                         v
   Servidor EC2              index.html
          |                         |
          v                         |
     Ubuntu Server                 |
          |                         |
          v                         |
      apt update                   |
          |                         |
          v                         |
     Instalar Nginx                |
          |                         |
          +------------+------------+
                       |
                       v
                /var/www/html/
                       |
                       v
                  index.html
                       |
                       v
                    Nginx
                       |
                       v
                   HTTP :80
```

---

# Operaciones Realizadas por `deploy.sh`

El script realiza automáticamente tareas similares a las siguientes:

### 1. Conexión al servidor

Utiliza SSH para ejecutar comandos remotamente:

```bash
ssh -i "$KEY_PATH" ubuntu@"$SERVER_IP"
```

### 2. Actualización de paquetes

```bash
sudo apt update
```

### 3. Instalación de Nginx

```bash
sudo apt install -y nginx
```

### 4. Habilitación del servicio

```bash
sudo systemctl enable nginx
```

### 5. Inicio del servicio

```bash
sudo systemctl start nginx
```

### 6. Transferencia de la aplicación

El archivo `index.html` se transfiere mediante SCP:

```bash
scp -i "$KEY_PATH" index.html ubuntu@"$SERVER_IP":/tmp/index.html
```

### 7. Instalación de la página

Posteriormente se mueve el archivo al directorio utilizado por Nginx:

```bash
sudo mv /tmp/index.html /var/www/html/index.html
```

### 8. Reinicio de Nginx

```bash
sudo systemctl restart nginx
```

---

# Verificación del Despliegue

Una vez finalizado el proceso, verifica que Nginx esté ejecutándose correctamente.

```bash
ssh -i /ruta/a/tu/ec2-key.pem ubuntu@<IP_PUBLICA_EC2>
```

Luego ejecuta:

```bash
sudo systemctl status nginx
```

El resultado esperado debe mostrar:

```text
Active: active (running)
```

---

# Verificación desde el Navegador

Abre cualquier navegador e ingresa:

```text
http://<IP_PUBLICA_EC2>
```

Ejemplo:

```text
http://203.0.113.10
```

Si la configuración es correcta, se mostrará el contenido definido en:

```text
index.html
```

---

# Verificación mediante Curl

También puedes comprobar la respuesta HTTP directamente desde tu máquina local:

```bash
curl -I http://<IP_PUBLICA_EC2>
```

Una respuesta esperada sería:

```text
HTTP/1.1 200 OK
Server: nginx
```

El código:

```text
200 OK
```

indica que el servidor respondió correctamente a la solicitud HTTP.

---

# Verificación del Contenido

Para consultar directamente el contenido HTML desde la terminal:

```bash
curl http://<IP_PUBLICA_EC2>
```

Esto debería devolver el contenido HTML servido por Nginx.

---

# Administración de Nginx

Una vez desplegado el servidor, Nginx puede administrarse mediante Systemd.

## Consultar Estado

```bash
sudo systemctl status nginx
```

## Iniciar Nginx

```bash
sudo systemctl start nginx
```

## Detener Nginx

```bash
sudo systemctl stop nginx
```

## Reiniciar Nginx

```bash
sudo systemctl restart nginx
```

## Habilitar Nginx al Arranque

```bash
sudo systemctl enable nginx
```

## Deshabilitar Nginx del Arranque

```bash
sudo systemctl disable nginx
```

---

# Diagnóstico de Nginx

## Verificar Configuración

Antes de reiniciar Nginx, puedes comprobar que la configuración sea válida:

```bash
sudo nginx -t
```

Una respuesta correcta debería ser similar a:

```text
syntax is ok
test is successful
```

---

## Consultar Logs de Acceso

```bash
sudo tail -f /var/log/nginx/access.log
```

---

## Consultar Logs de Error

```bash
sudo tail -f /var/log/nginx/error.log
```

---

# Seguridad

## Higiene de Credenciales

Las claves privadas nunca deben subirse al repositorio.

El archivo `.gitignore` debe incluir:

```gitignore
# Claves privadas de AWS
*.pem
*.key

# Credenciales
.env

# Archivos temporales
*.tmp
```

Esto evita incluir accidentalmente credenciales privadas dentro del control de versiones.

---

## Permisos de la Clave

La clave privada debe contar con permisos restrictivos:

```bash
chmod 400 ec2-key.pem
```

Verifica:

```bash
ls -l ec2-key.pem
```

El propietario debe ser el único usuario con acceso al archivo.

---

# Seguridad de Red

El Security Group debe exponer únicamente los puertos necesarios.

Configuración recomendada:

```text
Internet
   |
   +---- TCP 80 ----> Nginx
   |
   +---- TCP 22 ----> SSH
                         |
                         v
                    Administración
```

El puerto `22` debería limitarse a una IP o rango de confianza siempre que sea posible.

El puerto `80` puede permanecer público cuando se necesita ofrecer el sitio web a Internet.

---

# Estructura de la Aplicación en el Servidor

Después del despliegue, Nginx utilizará:

```text
/var/www/html/
```

La estructura esperada será:

```text
/var/www/html/
└── index.html
```

Nginx será responsable de entregar este archivo cuando un cliente realice una solicitud HTTP.

---

# Arquitectura del Proyecto

```text
                         AWS CLOUD
┌─────────────────────────────────────────────────────┐
│                                                     │
│                  EC2 Ubuntu Server                  │
│                                                     │
│        ┌──────────────────────────────────┐         │
│        │             Nginx                │         │
│        │                                  │         │
│        │        /var/www/html/            │         │
│        │             │                    │         │
│        │             └── index.html       │         │
│        └──────────────────────────────────┘         │
│                       │                             │
│                       │ HTTP :80                   │
└───────────────────────┼─────────────────────────────┘
                        │
                        v
                     Internet
                        ^
                        |
                 Usuario / Navegador


                WORKSTATION LOCAL
              Fedora / Linux / macOS
                        |
                        v
                   deploy.sh
                   /       \
                  /         \
                 v           v
               SSH          SCP
                 \           /
                  \         /
                   v       v
                  AWS EC2
```

---

# Flujo de Despliegue

```text
1. Crear instancia EC2
          |
          v
2. Configurar Security Group
          |
          v
3. Obtener IP pública
          |
          v
4. Descargar clave .pem
          |
          v
5. Configurar permisos de clave
          |
          v
6. Probar conexión SSH
          |
          v
7. Ejecutar deploy.sh
          |
          v
8. Instalar Nginx
          |
          v
9. Transferir index.html
          |
          v
10. Configurar /var/www/html
          |
          v
11. Iniciar Nginx
          |
          v
12. Verificar HTTP
```

---

# Problemas Comunes

## Permission denied al utilizar la clave

Si SSH muestra un error relacionado con permisos de la clave:

```text
Permissions 0644 for 'ec2-key.pem' are too open
```

Ejecuta:

```bash
chmod 400 ec2-key.pem
```

---

## Connection timed out

Si la conexión SSH genera un timeout:

```text
ssh: connect to host <IP> port 22: Connection timed out
```

Comprueba:

1. Que la instancia EC2 esté en estado `Running`.
2. Que la IP pública sea correcta.
3. Que el Security Group permita TCP `22`.
4. Que el origen de la regla SSH incluya tu IP.
5. Que la instancia tenga conectividad de red.

---

## Nginx no responde

Comprueba el estado:

```bash
sudo systemctl status nginx
```

Verifica la configuración:

```bash
sudo nginx -t
```

Comprueba el puerto:

```bash
sudo ss -tlnp | grep :80
```

Y revisa los logs:

```bash
sudo tail -f /var/log/nginx/error.log
```

---

# Comandos Principales

## Clonar

```bash
git clone https://github.com/WalterJuniorBarreto/aws-ec2-deployment.git
```

## Entrar al proyecto

```bash
cd aws-ec2-deployment
```

## Proteger clave

```bash
chmod 400 /ruta/a/tu/ec2-key.pem
```

## Probar SSH

```bash
ssh -i /ruta/a/tu/ec2-key.pem ubuntu@<IP_PUBLICA_EC2>
```

## Dar permisos al script

```bash
chmod +x deploy.sh
```

## Ejecutar despliegue

```bash
./deploy.sh <IP_PUBLICA_EC2> /ruta/a/tu/ec2-key.pem
```

## Verificar Nginx

```bash
sudo systemctl status nginx
```

## Probar HTTP

```bash
curl -I http://<IP_PUBLICA_EC2>
```

## Ver logs de Nginx

```bash
sudo tail -f /var/log/nginx/access.log
```

---

# Buenas Prácticas

El proyecto aplica diferentes prácticas recomendadas:

- No almacenar claves privadas dentro del repositorio.
- Utilizar `.gitignore` para excluir archivos sensibles.
- Utilizar permisos restrictivos para claves SSH.
- Limitar el acceso SSH mediante Security Groups.
- Exponer únicamente los puertos necesarios.
- Automatizar tareas repetitivas mediante Bash.
- Validar la conexión SSH antes del despliegue.
- Verificar el estado de Nginx después de la instalación.
- Validar la configuración de Nginx mediante `nginx -t`.
- Comprobar la respuesta HTTP mediante `curl`.
- Mantener separadas las credenciales de la lógica de automatización.

---

# Tecnologías Utilizadas

| Tecnología | Uso |
| :--- | :--- |
| AWS EC2 | Infraestructura de cómputo en la nube |
| Ubuntu Server | Sistema operativo del servidor |
| Nginx | Servidor web |
| SSH | Administración remota segura |
| SCP | Transferencia segura de archivos |
| Bash | Automatización del despliegue |
| Systemd | Administración de servicios |
| Git | Control de versiones |
| Security Groups | Control de tráfico de red |

---

# Objetivos del Proyecto

Este proyecto busca demostrar conocimientos prácticos en:

- Computación en la nube.
- Amazon EC2.
- Administración de servidores Linux.
- Configuración de Security Groups.
- SSH.
- SCP.
- Bash scripting.
- Automatización de despliegues.
- Nginx.
- Systemd.
- Administración de servicios.
- Transferencia segura de archivos.
- Gestión de claves privadas.
- Diagnóstico de servicios.
- Conceptos básicos de DevOps.

---

# Resultado Final

Después de completar correctamente el proceso, se obtiene una arquitectura como la siguiente:

```text
                       AWS
                        |
                        v
                 ┌─────────────┐
                 │    EC2      │
                 │   Ubuntu    │
                 └──────┬──────┘
                        |
                        v
                 ┌─────────────┐
                 │    Nginx   │
                 └──────┬──────┘
                        |
                        v
                /var/www/html/
                        |
                        v
                   index.html
                        |
                        v
                    HTTP :80
                        |
                        v
                 Usuario final
```

El resultado es un servidor web funcional desplegado sobre AWS EC2, configurado mediante automatización Bash y accesible mediante HTTP.

---

# Actualización del README y Push a Git

Si el archivo se creó accidentalmente como `README.me`, puedes renombrarlo:

```bash
cd ~/Projects_Linux/aws-ec2-deployment

mv README.me README.md 2>/dev/null || true
```

Verifica el archivo:

```bash
ls -la
```

Después, agrega el README al área de staging:

```bash
git add README.md
```

Crea el commit:

```bash
git commit -m "docs: actualizar README.md profesional para despliegue AWS EC2"
```

Finalmente, sube los cambios al repositorio:

```bash
git push origin main
```

---

# Flujo Completo de Git

También puedes realizar el proceso completo de la siguiente manera:

```bash
cd ~/Projects_Linux/aws-ec2-deployment

mv README.me README.md 2>/dev/null || true

git add README.md

git commit -m "docs: actualizar README.md profesional para despliegue AWS EC2"

git push origin main
```

---

# Licencia

Este proyecto puede utilizarse con fines educativos y demostrativos para practicar conceptos de AWS, Linux, Bash, Nginx, SSH, Systemd, automatización de servidores y DevOps.
