#!/bin/bash
set -euo pipefail

echo "[+] Ejecutando prueba 1: Valor por defecto..."
DEFAULT_OUTPUT=$(docker run --rm hello-captain)
echo "    Salida: $DEFAULT_OUTPUT"

if [ "$DEFAULT_OUTPUT" = "Hello, Captain!" ]; then
    echo "    [✓] Prueba 1 superada."
else
    echo "    [X] Prueba 1 fallo."
    exit 1
fi

echo "[+] Ejecutando prueba 2: Argumento dinamico (DevOps)..."
CUSTOM_OUTPUT=$(docker run --rm hello-captain DevOps!)
echo "    Salida: $CUSTOM_OUTPUT"

if [ "$CUSTOM_OUTPUT" = "Hello, DevOps!" ]; then
    echo "    [✓] Prueba 2 superada."
else
    echo "    [X] Prueba 2 fallo."
    exit 1
fi

echo "[✓] Todas las pruebas pasaron exitosamente."
