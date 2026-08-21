# Desglose Técnico del Flujo CI/CD con GitHub Actions y GitHub Pages

## 1. Arquitectura del Flujo de Trabajo (`deploy.yml`)

El archivo `.github/workflows/deploy.yml` define un flujo automatizado de integración y despliegue continuo (CI/CD) gestionado en los servidores de GitHub.

### Disparadores y Filtros de Ruta (`on.push`)

* `branches: [ main ]`: Limita la ejecución del pipeline exclusivamente a los eventos de subida de código (`push`) dirigidos a la rama de producción `main`.
* `paths: [ 'index.html' ]`: Filtro condicional que previene ejecuciones innecesarias del runner. Si un commit solo modifica archivos de documentación (`README.md`, `DOCUMENTATION.md`) o configuraciones que no alteran el código fuente web, el pipeline se omite automáticamente, ahorrando minutos de cómputo.

### Permisos de Seguridad (`permissions`)

GitHub Actions opera bajo el principio de mínimo privilegio. Para interactuar con la infraestructura de Pages, el token del runner (`GITHUB_TOKEN`) requiere permisos explícitos:

* `contents: read`: Permite clonar y leer los archivos del repositorio en el entorno de ejecución.
* `pages: write`: Autoriza la carga y publicación de paquetes web en la infraestructura de GitHub Pages.
* `id-token: write`: Permite la emisión de un token OIDC (OpenID Connect) para autenticar la identidad del despliegue de forma segura.

### Control de Concurrencia (`concurrency`)

* `group: "pages"`: Asigna todas las ejecuciones de despliegue a un grupo común.
* `cancel-in-progress: false`: Asegura que un despliegue en curso no sea cancelado si se procesa otro push inmediatamente después, garantizando la integridad de los artefactos en producción.

---

## 2. Acciones Oficiales Empleadas (`jobs.deploy.steps`)

El trabajo se ejecuta en una máquina virtual efímera con Linux (`runs-on: ubuntu-latest`) y utiliza una secuencia de acciones estandarizadas:

1. `actions/checkout@v4`: Clona el contenido del repositorio en el directorio de trabajo del runner (`$GITHUB_WORKSPACE`) para que los archivos estén accesibles durante el pipeline.
2. `actions/configure-pages@v5`: Valida y prepara la configuración del sitio dentro de GitHub Pages, inyectando metadatos base y rutas de acceso correspondientes.
3. `actions/upload-pages-artifact@v3`: Comprime y empaqueta el contenido del directorio especificado (`path: '.'`) en un archivo tar compatible con la infraestructura de almacenamiento de Pages.
4. `actions/deploy-pages@v4`: Toma el artefacto generado en el paso anterior y lo distribuye hacia los servidores de borde (Edge / CDN) de GitHub Pages, devolviendo la URL pública del entorno.

---

## 3. Modelo de Publicación en GitHub Pages

A diferencia del método clásico basado en ramas (`gh-pages`), la integración mediante **GitHub Actions** desacopla el historial de Git del proceso de compilación y despliegue:

* **Separación de responsabilidades:** No se requiere la creación de ramas secundarias ni commits automatizados generados por bots para almacenar el sitio construido.
* **Trazabilidad:** Cada publicación queda registrada como un despliegue vinculado a un commit específico y a un log detallado de auditoría en la pestaña *Actions*.
