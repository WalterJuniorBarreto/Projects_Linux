# Desglose Técnico de Comandos y Parámetros

## 1. Gestión del Servicio SSH (`systemctl`)

* `sudo systemctl enable --now sshd`:
    * `enable`: Registra el servicio `sshd` en el inicio del sistema operativo (crea los enlaces simbólicos necesarios en `systemd`).
    * `--now`: Inicia inmediatamente el proceso del servidor sin requerir un comando `start` posterior ni reiniciar el sistema.

## 2. Generación Criptográfica (`ssh-keygen`)

* `ssh-keygen -t ed25519 -C "comentario" -f ruta_archivo`:
    * `ssh-keygen`: Utilidad estándar para crear, gestionar y convertir claves de autenticación.
    * `-t ed25519`: Especifica el algoritmo de firma digital basado en la curva Edwards 25519. Ofrece un rendimiento superior y menor tamaño de clave con una seguridad equivalente o superior a RSA de 4096 bits.
    * `-C`: Añade un comentario o etiqueta al final del archivo público para identificar rápidamente el propósito o usuario asociado.
    * `-f`: Define la ruta exacta y el nombre del archivo de salida donde se almacenarán las claves privada y pública (`.pub`).

## 3. Despliegue de Autorización (`ssh-copy-id`)

* `ssh-copy-id -i ~/.ssh/id_ed25519_key1.pub usuario@host`:
    * `ssh-copy-id`: Script de ayuda que automatiza la transferencia de claves.
    * `-i`: Especifica la ruta de la clave pública a transferir.
    * Mecanismo interno: Se autentica en el host remoto, crea el directorio `~/.ssh` con permisos `700` si no existe, y añade la clave al final de `~/.ssh/authorized_keys` asignándole permisos `600` para garantizar que otros usuarios del sistema no puedan leerla ni modificarla.

## 4. Conexión Manual con Identidad Forzada (`ssh -i`)

* `ssh -i ~/.ssh/id_ed25519_key1 usuario@host`:
    * `ssh`: Cliente del protocolo Secure Shell.
    * `-i`: Especifica la identidad privada a utilizar para resolver el desafío criptográfico enviado por el servidor, omitiendo la búsqueda automática en las claves predeterminadas del agente SSH (`id_rsa`, `id_ecdsa`).

## 5. Estructura del Archivo de Configuración (`~/.ssh/config`)

Archivo de texto plano interpretado por el cliente SSH antes de iniciar cualquier conexión:
* `Host <nombre>`: Define el alias o identificador que se utilizará en la terminal (ejemplo: `ssh server-nodo-1`).
* `HostName <direccion>`: Dirección IP o nombre de dominio (FQDN) real de la máquina a la que se debe conectar.
* `User <usuario>`: Nombre de la cuenta de usuario con la que se iniciará sesión en el sistema remoto.
* `IdentityFile <ruta>`: Ruta absoluta hacia la clave privada específica asignada a dicho host.

## 6. Monitoreo y Defensa Activa (`fail2ban`)

* `sudo dnf install fail2ban -y`: Instala el paquete y sus dependencias en distribuciones basadas en RPM (Fedora/RHEL).
* `sudo systemctl enable --now fail2ban`: Activa el demonio que lee de forma continua los registros generados por el servicio SSH.
* Mecanismo de acción:
    * Identifica patrones de fallos consecutivos en los logs de autenticación provenientes de una misma IP.
    * Al alcanzar el umbral de intentos fallidos permitidos (`maxretry`), interactúa con el subsistema de red (`firewalld`/`iptables`/`nftables`) para inyectar una regla de descarte (`REJECT` o `DROP`) para esa IP.
    * Mantiene el bloqueo durante la ventana de tiempo configurada (`bantime`), liberando la regla de forma automática tras su expiración.
