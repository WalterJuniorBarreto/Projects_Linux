SSH Remote Server Setup
Setup a basic remote linux server and configure it to allow SSH.

Start building, submit solution and get feedback from the community.

Start Working
2
Submit Solution
5 upvotes
10 upvotes
The goal of this project is to learn and practice the basics of Linux. You are required to setup a remote linux server and configure it to allow SSH connections.

Requirements
You are required to setup a remote linux server and configure it to allow SSH connections.

Register and setup a remote linux server on any provider e.g. a simple droplet on DigitalOcean which gives you $200 in free credits with the link. Alternatively, use AWS or any other provider.

Create two new SSH key pairs and add them to your server.

You should be able to connect to your server using both SSH keys.

You should be able to use the following command to connect to your server using both SSH keys.

bash

ssh -i <path-to-private-key> user@server-ip
Also, look into setting up the configuration in ~/.ssh/config to allow you to connect to your server using the following command.

bash

ssh <alias>
The only outcome of this project is that you should be able to SSH into your server using both SSH keys. Future projects will cover other aspects of server setup and configuration.

Stretch goal: install and configure fail2ban to prevent brute force attacks.

Important Note for Solution Submission
Do not push your private key to any public repository. The solution to this project should just contain one README.md file with the steps you took to complete the project.

After completing this project, you will have a basic understanding of how to setup a remote linux server and configure it to allow SSH connections. Future projects will cover other aspects of server setup.

2. Generación de Pares de Claves
Crear dos identidades criptográficas independientes en la máquina cliente:

Bash
ssh-keygen -t ed25519 -C "clave1_proyecto" -f ~/.ssh/id_ed25519_key1
ssh-keygen -t ed25519 -C "clave2_proyecto" -f ~/.ssh/id_ed25519_key2
3. Distribución de Claves Públicas
Copiar las claves públicas al archivo de autorización del usuario en el host:

Bash
ssh-copy-id -i ~/.ssh/id_ed25519_key1.pub usuario@host
ssh-copy-id -i ~/.ssh/id_ed25519_key2.pub usuario@host
4. Conexión Explícita por Identidad
Comprobar el acceso sin requerimiento de contraseña usando ambas identidades:

Bash
ssh -i ~/.ssh/id_ed25519_key1 usuario@host
ssh -i ~/.ssh/id_ed25519_key2 usuario@host
5. Configuración de Alias de Host
Definir bloques de conexión en ~/.ssh/config para evitar la inserción manual de direcciones IP, puertos y rutas de archivo:

Plaintext
Host server-nodo-1
    HostName host
    User usuario
    IdentityFile ~/.ssh/id_ed25519_key1

Host server-nodo-2
    HostName host
    User usuario
    IdentityFile ~/.ssh/id_ed25519_key2
Acceso simplificado:

Bash
ssh server-nodo-1
6. Despliegue de Fail2Ban
Instalar y activar el servicio de monitoreo de registros y bloqueo dinámico:

Bash
sudo dnf install fail2ban -y
sudo systemctl enable --now fail2ban
