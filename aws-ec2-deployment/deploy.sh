#!/bin/bash

set -euo pipefail

if [ "$#" -ne 2]; then
	echo "Uso: $0 107.20.29.23 ec2-key.pem"
	echo "Ejemplo: $0 4124.124124.214124 ec2-key.pem"
	exit 1
fi

EC2_IP="$1"
KEY_PATH="$2"
USER="ubuntu"

echo "Ajustando permisos de clave SSH"
chmod 400 "$KEY_PATH"

echo "Creando archivo HTML estatico localmente..."
cat << 'HTML' > index.html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Despliegue en AWS EC2</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #0f172a;
            color: #f8fafc;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            text-align: center;
            background: #1e293b;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            border: 1px solid #334155;
        }
        h1 { color: #38bdf8; margin-bottom: 0.5rem; }
        p { color: #94a3b8; font-size: 1.1rem; }
        .tag {
            display: inline-block;
            background: #0284c7;
            color: #fff;
            padding: 0.3rem 0.8rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: bold;
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>¡Servidor Web en AWS EC2 Activo!</h1>
        <p>Sitio web estatico desplegado exitosamente con Nginx y Ubuntu Server.</p>
        <span class="tag">AWS Cloud & DevOps</span>
    </div>
</body>
</html>
HTML

echo "COnectando a EC2 para aprovisionar paquetes remotos..."
ssh -o StrictHostKeyChecking=no -i "$KEY_PATH" "$USER@$EC2_IP" "sudo apt update && sudo apt install -y nginx && sudo systemctl enable --now nginx"

echo "Transfiiendo index.html al servidor remoto"
scp -o StrictHostKeyChecking=no -i "$KEY_PATH" index.html "$USER@$EC2_IP":/tmp/index.html

echo "Desplegando archivo en la ruta Nginx /var/www/html"
ssh -o StrictHostKeyChecking=no -i "$KEY_PATH" "$USER@$EC2_IP" "sudo mv /tmp/index.html /var/www/html/index.html && sudo systemctl restart nginx"

echo "Despliegue completado con exito"
echo "Accede a tu sitio web en: http://$EC2_IP"


