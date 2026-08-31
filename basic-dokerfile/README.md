# Basic Dockerfile: Hello Captain Container

Implementación de un contenedor Docker ligero basado en Alpine Linux que demuestra la construcción de imágenes, ejecución efímera y el paso dinámico de argumentos mediante `ENTRYPOINT` y `CMD`.

## Estructura del Proyecto

```text
.
├── Dockerfile      # Definición de la imagen de contenedor (Alpine base)
├── test.sh         # Script de pruebas automatizadas para validar salidas
└── README.md       # Guía de uso y documentación técnica
Requisitos Previos
Docker Engine instalado y en ejecución (docker --version).

Permisos para interactuar con el socket de Docker (usuario en el grupo docker o privilegios sudo).

Uso Rápido
1. Construir la imagen
Bash
docker build -t hello-captain .
2. Ejecutar con el valor por defecto
Bash
docker run --rm hello-captain
Salida: Hello, Captain!

3. Ejecutar pasando un nombre como argumento
Bash
docker run --rm hello-captain Walter!
Salida: Hello, Walter!

4. Ejecutar pruebas automatizadas
Bash
chmod +x test.sh
./test.sh
Conceptos Clave
Imagen Base (alpine:latest): Proporciona un entorno Linux mínimo y seguro (~5 MB) para reducir tiempos de descarga y superficie de ataque.

Patrón ENTRYPOINT + CMD:

ENTRYPOINT ["echo", "Hello,"]: Define el comando inmutable que siempre se ejecutará al iniciar el contenedor.

CMD ["Captain!"]: Define el argumento predeterminado, el cual puede ser sobrescrito fácilmente por el usuario desde la línea de comandos en tiempo de ejecución.
EOF


---

**Paso 2: Registrar y subir los cambios a Git**

Ejecuta los siguientes comandos para hacer commit y enviar tus cambios a tu repositorio:

```bash
git add .
git commit -m "Implementacion completa de Dockerfile basico, pruebas automatizadas y README"
git push origin main
