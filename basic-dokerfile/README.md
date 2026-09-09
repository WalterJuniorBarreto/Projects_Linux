# Lightweight Containerization with Dockerfile

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Alpine Linux](https://img.shields.io/badge/Alpine_Linux-0D597F?style=for-the-badge&logo=alpine-linux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash_Testing-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)

Implementación y diseño de una imagen de contenedor Docker optimizada basada en **Alpine Linux**, orientada a demostrar los principios fundamentales de empaquetado de software, ciclo de vida efímero y el patrón desacoplado de ejecución de procesos mediante **`ENTRYPOINT`** y **`CMD`**.

---

## Descripción General

Este proyecto aborda las bases de la contenerización y empaquetado ligero en entornos Linux.

Se crea una imagen minimalista con una superficie de ataque reducida y un arranque inmediato, acompañada de un script de pruebas automatizadas (`test.sh`) que valida el comportamiento determinista del contenedor ante argumentos por defecto y dinámicos.

### Aspectos Técnicos Destacados

- **Minimalismo y Seguridad:** construcción sobre Alpine Linux, reduciendo el peso de la imagen y la cantidad de componentes innecesarios.
- **Patrón de Ejecución Flexible:** configuración desacoplada mediante `ENTRYPOINT` y `CMD`, permitiendo utilizar valores predeterminados o argumentos dinámicos.
- **Ciclo de Vida Efímero:** uso de `--rm` para eliminar automáticamente el contenedor una vez finalizada su ejecución.
- **Pruebas Automatizadas:** script en Bash para validar rápidamente las salidas esperadas.
- **Empaquetado Reproducible:** definición de la imagen mediante un `Dockerfile`.

---

## Estructura del Repositorio

```text
.
├── Dockerfile      # Instrucciones de construcción de la imagen
├── test.sh         # Script de validación automatizada
└── README.md       # Documentación técnica y guía de ejecución
```

---

## Requisitos Previos

### Motor de Contenedores

Se requiere tener instalado Docker Engine o un motor compatible.

Verifica la instalación:

```bash
docker --version
```

También puedes comprobar información adicional del motor:

```bash
docker info
```

### Permisos

El usuario debe tener permisos para ejecutar comandos Docker.

En sistemas donde Docker requiere privilegios administrativos:

```bash
sudo docker --version
```

Si el usuario pertenece al grupo `docker`, normalmente podrá ejecutar:

```bash
docker --version
```

sin utilizar `sudo`.

### Entorno de Pruebas

Se requiere una terminal compatible con Bash o POSIX Shell.

---

# Guía de Uso

## 1. Construir la Imagen Docker

Desde el directorio raíz del proyecto, ejecuta:

```bash
docker build -t hello-captain .
```

### Explicación del comando

| Parámetro | Función |
| :--- | :--- |
| `docker build` | Construye una imagen a partir de un Dockerfile |
| `-t hello-captain` | Asigna el nombre y etiqueta a la imagen |
| `.` | Utiliza el directorio actual como contexto de construcción |

Después de finalizar la construcción, verifica que la imagen exista:

```bash
docker images
```

Deberías encontrar una imagen similar a:

```text
REPOSITORY      TAG       IMAGE ID       CREATED          SIZE
hello-captain   latest    xxxxxxxxxxxx   seconds ago      ...
```

---

# 2. Ejecutar con el Parámetro por Defecto

Ejecuta el contenedor utilizando el valor definido en `CMD`:

```bash
docker run --rm hello-captain
```

### Salida Esperada

```text
Hello, Captain!
```

La opción `--rm` indica que Docker debe eliminar automáticamente el contenedor cuando finalice su ejecución.

---

# 3. Ejecutar Pasando Argumentos Dinámicos

Es posible reemplazar el argumento definido originalmente en `CMD`.

Ejecuta:

```bash
docker run --rm hello-captain Walter!
```

### Salida Esperada

```text
Hello, Walter!
```

En este caso, `ENTRYPOINT` continúa ejecutándose, pero el valor definido en `CMD` es reemplazado por el argumento proporcionado desde la línea de comandos.

---

# 4. Ejecutar con Otro Argumento

También puedes utilizar cualquier otro nombre:

```bash
docker run --rm hello-captain Docker!
```

Salida:

```text
Hello, Docker!
```

Otro ejemplo:

```bash
docker run --rm hello-captain Linux!
```

Salida:

```text
Hello, Linux!
```

---

# Pruebas Automatizadas

El archivo:

```text
test.sh
```

contiene pruebas para verificar automáticamente el comportamiento esperado del contenedor.

Primero asigna permisos de ejecución:

```bash
chmod +x test.sh
```

Luego ejecuta:

```bash
./test.sh
```

También puedes ejecutarlo mediante Bash:

```bash
bash test.sh
```

---

## Ejemplo de Validación

El script puede comprobar casos como:

```text
Caso 1:
docker run --rm hello-captain

Esperado:
Hello, Captain!


Caso 2:
docker run --rm hello-captain Walter!

Esperado:
Hello, Walter!
```

Si las salidas coinciden con los valores esperados, las pruebas se consideran exitosas.

---

# Dockerfile

El archivo `Dockerfile` define las instrucciones utilizadas para construir la imagen.

Una implementación básica puede utilizar:

```dockerfile
FROM alpine:latest

ENTRYPOINT ["echo", "Hello,"]
CMD ["Captain!"]
```

---

# Conceptos Clave de Contenerización

## 1. ¿Por qué Alpine Linux?

La imagen:

```text
alpine:latest
```

está basada en Alpine Linux, una distribución orientada a ser pequeña, simple y eficiente.

Sus principales ventajas para este proyecto son:

- Tamaño reducido.
- Menor cantidad de paquetes instalados.
- Menor superficie de ataque.
- Descargas más rápidas.
- Menor consumo de almacenamiento.
- Adecuada para contenedores pequeños y procesos específicos.

En lugar de utilizar una distribución completa como Ubuntu o Debian, el proyecto utiliza una imagen minimalista que contiene únicamente los componentes necesarios para ejecutar el proceso.

---

# 2. `ENTRYPOINT` vs `CMD`

Una de las partes fundamentales del proyecto es comprender la diferencia entre `ENTRYPOINT` y `CMD`.

| Directiva | Implementación | Propósito Técnico |
| :--- | :--- | :--- |
| **`ENTRYPOINT`** | `["echo", "Hello,"]` | Define el ejecutable principal que se ejecutará al iniciar el contenedor. |
| **`CMD`** | `["Captain!"]` | Define los argumentos predeterminados para `ENTRYPOINT`. |

Con esta configuración:

```dockerfile
ENTRYPOINT ["echo", "Hello,"]
CMD ["Captain!"]
```

Docker ejecutará conceptualmente:

```bash
echo "Hello," "Captain!"
```

Por lo tanto, la salida será:

```text
Hello, Captain!
```

---

# 3. Reemplazo de `CMD`

Si ejecutamos:

```bash
docker run --rm hello-captain Walter!
```

Docker reemplaza el valor definido en `CMD`.

La ejecución conceptual pasa a ser:

```bash
echo "Hello," "Walter!"
```

Resultado:

```text
Hello, Walter!
```

El `ENTRYPOINT` permanece igual:

```text
echo Hello,
```

Mientras que el argumento proporcionado por `CMD` cambia:

```text
Captain!
```

por:

```text
Walter!
```

---

# Funcionamiento de `ENTRYPOINT`

`ENTRYPOINT` define el proceso principal que ejecutará el contenedor.

En este proyecto:

```dockerfile
ENTRYPOINT ["echo", "Hello,"]
```

El ejecutable principal es:

```text
echo
```

y recibe como argumento:

```text
Hello,
```

Los argumentos adicionales proporcionados mediante `docker run` se agregan después.

Por ejemplo:

```bash
docker run --rm hello-captain Walter!
```

produce conceptualmente:

```bash
echo Hello, Walter!
```

---

# Funcionamiento de `CMD`

`CMD` proporciona valores predeterminados para el proceso definido en `ENTRYPOINT`.

En el proyecto:

```dockerfile
CMD ["Captain!"]
```

Si no se proporciona ningún argumento adicional:

```bash
docker run --rm hello-captain
```

Docker utilizará:

```text
Captain!
```

Pero si proporcionamos otro argumento:

```bash
docker run --rm hello-captain Walter!
```

el valor:

```text
Captain!
```

es reemplazado por:

```text
Walter!
```

---

# Ciclo de Vida del Contenedor

El ciclo de vida básico del proyecto puede representarse así:

```text
                  Dockerfile
                      |
                      v
               docker build
                      |
                      v
              Imagen Docker
              hello-captain
                      |
                      v
                docker run
                      |
                      v
                Contenedor
                      |
                      v
                 ENTRYPOINT
                      |
                      v
                    CMD
                      |
                      v
                   echo
                      |
                      v
                Resultado
                      |
                      v
              Contenedor finaliza
                      |
                      v
                  --rm
                      |
                      v
             Contenedor eliminado
```

---

# Uso de `--rm`

La opción:

```bash
--rm
```

permite eliminar automáticamente el contenedor cuando termina su proceso principal.

Ejemplo:

```bash
docker run --rm hello-captain
```

Sin `--rm`, el contenedor finalizado podría permanecer registrado en Docker.

Puedes comprobar los contenedores existentes mediante:

```bash
docker ps -a
```

El uso de `--rm` resulta especialmente útil para contenedores efímeros utilizados en pruebas o tareas puntuales.

---

# Imágenes vs Contenedores

Es importante diferenciar ambos conceptos.

## Imagen

La imagen es una plantilla inmutable utilizada para crear contenedores.

En este proyecto:

```text
hello-captain
```

es la imagen.

Puedes visualizarla mediante:

```bash
docker images
```

---

## Contenedor

El contenedor es una instancia en ejecución de una imagen.

Por ejemplo:

```bash
docker run hello-captain
```

crea un contenedor utilizando la imagen:

```text
hello-captain
```

La relación puede representarse así:

```text
Dockerfile
    |
    v
Imagen
    |
    +----------+
    |          |
    v          v
Contenedor  Contenedor
```

---

# Inspección de la Imagen

Para consultar las imágenes disponibles:

```bash
docker images
```

También puedes utilizar:

```bash
docker image ls
```

Para inspeccionar los metadatos:

```bash
docker inspect hello-captain
```

---

# Inspección de Contenedores

Si ejecutas el contenedor sin `--rm`:

```bash
docker run hello-captain
```

puedes consultar los contenedores:

```bash
docker ps -a
```

Esto permite observar contenedores que ya finalizaron.

---

# Eliminar la Imagen

Si deseas eliminar la imagen:

```bash
docker rmi hello-captain
```

Si existe algún contenedor creado previamente utilizando la imagen, puede ser necesario eliminarlo primero.

Puedes consultar:

```bash
docker ps -a
```

Y eliminar un contenedor específico:

```bash
docker rm <CONTAINER_ID>
```

---

# Reconstrucción de la Imagen

Si modificas el `Dockerfile`, debes reconstruir la imagen:

```bash
docker build -t hello-captain .
```

Para forzar una reconstrucción sin utilizar la caché:

```bash
docker build --no-cache -t hello-captain .
```

---

# Flujo de Trabajo Completo

El flujo recomendado para trabajar con este proyecto es:

```text
1. Modificar Dockerfile
          |
          v
2. Construir imagen
          |
          v
   docker build
          |
          v
3. Ejecutar contenedor
          |
          v
    docker run
          |
          v
4. Verificar resultado
          |
          v
5. Ejecutar test.sh
          |
          v
6. Validar comportamiento
```

---

# Comandos Principales

## Construir la Imagen

```bash
docker build -t hello-captain .
```

## Listar Imágenes

```bash
docker images
```

## Ejecutar con Valor Predeterminado

```bash
docker run --rm hello-captain
```

## Ejecutar con Argumento Personalizado

```bash
docker run --rm hello-captain Walter!
```

## Ejecutar las Pruebas

```bash
chmod +x test.sh
./test.sh
```

## Listar Contenedores

```bash
docker ps -a
```

## Inspeccionar Imagen

```bash
docker inspect hello-captain
```

## Eliminar Imagen

```bash
docker rmi hello-captain
```

## Reconstruir sin Caché

```bash
docker build --no-cache -t hello-captain .
```

---

# Buenas Prácticas

El proyecto aplica diferentes prácticas relacionadas con la contenerización:

- Utilizar imágenes base pequeñas cuando sea apropiado.
- Mantener el `Dockerfile` simple y legible.
- Utilizar `ENTRYPOINT` para definir el proceso principal.
- Utilizar `CMD` para proporcionar argumentos predeterminados.
- Utilizar `--rm` para contenedores temporales.
- Automatizar validaciones mediante scripts.
- Evitar instalar paquetes innecesarios.
- Mantener separados los archivos de configuración y documentación.
- Reconstruir la imagen después de modificar el `Dockerfile`.
- Verificar el comportamiento del contenedor mediante pruebas automatizadas.

---

# Objetivos del Proyecto

Este proyecto busca demostrar conocimientos prácticos en:

- Docker.
- Contenedores.
- Imágenes Docker.
- Dockerfile.
- Alpine Linux.
- `ENTRYPOINT`.
- `CMD`.
- Argumentos dinámicos.
- Contenedores efímeros.
- Bash scripting.
- Automatización de pruebas.
- Ciclo de vida de contenedores.
- Empaquetado de aplicaciones.
- Conceptos fundamentales de DevOps.

---

# Resultado Esperado

Después de construir correctamente la imagen:

```bash
docker build -t hello-captain .
```

La ejecución:

```bash
docker run --rm hello-captain
```

debe producir:

```text
Hello, Captain!
```

Mientras que:

```bash
docker run --rm hello-captain Walter!
```

debe producir:

```text
Hello, Walter!
```

Finalmente, las pruebas automatizadas:

```bash
./test.sh
```

deben validar ambos escenarios correctamente.

---

# Licencia

Este proyecto puede utilizarse con fines educativos y demostrativos para practicar conceptos de Docker, Linux, Bash, Alpine Linux, contenerización y fundamentos de DevOps.
