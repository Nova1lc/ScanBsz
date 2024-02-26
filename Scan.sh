#!/bin/bash!

banner='
+++++++++++++++++++++++++++++
+                              +
+   Scan - BSZ!   +
+                              +
+++++++++++++++++++++++++++++
'

echo "$banner"

# Verifica si se proporcionó una dirección IP como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 <dirección_ip>"
    exit 1
fi

ip=$1

# Escanea los puertos utilizando nmap
echo "Escaneando puertos en $ip..."
nmap_output=$(nmap -p-  --open $ip)

# Filtra los puertos abiertos
open_ports=$(echo "$nmap_output" | grep -E '^[0-9]+/tcp' | cut -d '/' -f 1 | tr '\n' ',' | sed 's/,$//')

if [ -z "$open_ports" ]; then
    echo "No se encontraron puertos abiertos en $ip."
    exit 0
fi

echo "Puertos abiertos encontrados: $open_ports"

# Esto escanea las vulnerabilidades utilizando nmap con el script de vulners
echo "Escaneando vulnerabilidades en los puertos..."
nmap_vulners_output=$(nmap -sV --script vulners -p $open_ports $ip)

echo "Resultados del escaneo de vulnerabilidades:"
echo "$nmap_vulners_output"

