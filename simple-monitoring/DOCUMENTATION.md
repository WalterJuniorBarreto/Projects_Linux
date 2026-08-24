# Desglose Técnico de Observabilidad y Métricas

## 1. Arquitectura de Monitoreo (Netdata Agent)

Netdata opera como un demonio de monitoreo distribuido y ligero de bajo impacto:
* **Frecuencia de Muestreo:** Recolecta métricas por segundo directamente desde interfaces del kernel (`/proc`, `/sys`).
* **Puerto de Servicio:** Expone una interfaz web HTTP embebida en el puerto TCP `19999`.
* **Seguridad de Red:** Requiere la apertura explícita del puerto mediante `firewall-cmd --permanent --add-port=19999/tcp`.

---

## 2. Regla de Alerta Personalizada (`cpu_usage.conf`)

Ubicación del archivo: `/etc/netdata/health.d/cpu_usage.conf`

```ini
 alarm: 10min_cpu_usage_custom
    on: system.cpu
lookup: average -1m unaligned of user,system,softirq,irq,guest
 units: %
 every: 10s
  warn: $this > 70
  crit: $this > 80
 delay: down 1m
  info: El uso promedio de CPU supero el 80% en el ultimo minuto

Explicación de Parámetros:
on: system.cpu: Vincula la alarma a la métrica global de procesador.

lookup: average -1m: Calcula la media aritmética del uso acumulado durante el último minuto (user, system, etc.).

every: 10s: Frecuencia con la que el motor de salud recalcula el estado.

crit: $this > 80: Escala el estado a CRITICAL si la carga supera el 80%.

delay: down 1m: Histéresis para evitar alertas intermitentes (flapping); la alarma solo regresa a CLEAR si la carga se mantiene baja durante 1 minuto continuo.

3. Simulación de Carga (test_dashboard.sh)
El script utiliza stress-ng para validar el pipeline de observabilidad:

nproc: Detecta el número exacto de núcleos lógicos disponibles en el CPU.

--cpu <N>: Asigna un hilo de cálculo continuo por cada núcleo detectado para saturar la capacidad al 100%.

--timeout 60s: Mantiene el estrés computacional el tiempo necesario para superar la ventana de evaluación de la alarma (-1m).

4. Desinstalación Segura (cleanup.sh)
El proceso de limpieza:

Detiene y deshabilita la unidad netdata.service en systemctl.

Invoca el script desinstalador oficial netdata-uninstaller.sh --yes --force.

Elimina directorios residuales en /etc/netdata, /var/lib/netdata y /var/cache/netdata.

Cierra y recarga las reglas del cortafuegos en firewalld.
