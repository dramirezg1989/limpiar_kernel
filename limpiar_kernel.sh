#!/bin/bash

OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')
CURKERNEL=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
OLDKERNELS=$(dpkg -l|awk '{print $2}'|grep -E $LINUXPKG |grep -vE $METALINUXPKG|grep -v $CURKERNEL)
AMARILLO="\033[1;33m"
ROJO="\033[0;31m"
COLORFIN="\033[0m"

if [ $USER != root ]; then
echo -e $ROJO"Error: se debe ejecutar como root"
echo -e $AMARILLO"Saliendo..."$COLORFIN
exit 0
fi

echo -e $AMARILLO"Limpiando la cache apt..."$COLORFIN
aptitude clean

echo -e $AMARILLO"Eliminando viejos ficheros de configuracion..."$COLORFIN
sudo aptitude purge $OLDCONF

echo -e $AMARILLO"Eliminando viejos kernels..."$COLORFIN
sudo aptitude purge $OLDKERNELS

echo -e $AMARILLO"Eliminando los residuos..."$COLORFIN
rm -rf /root/.local/share/Trash/*/** &> /dev/null

update-grub

echo -e $AMARILLO"¡Script ejecutado correctamente!"$COLORFIN
