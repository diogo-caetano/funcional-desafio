#!/bin/sh
echo "Parando nginx"
systemctl stop nginx

echo "Desligando máquina"
systemctl poweroff