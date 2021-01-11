#!/bin/bash
cd $HOME/Documents/mis_scripts/

# fecha y hora en la que se hace el backup.
FECHA=$(date +%d-%m-%Y-%H-%M-%S)

# nombre del fichero.
NOMBREEMPAQUE=$HOME/backups/backup-$FECHA.tar

# orden que hace el empaquetao de los archivos a respaldar.
tar -cf $NOMBREEMPAQUE * -g $HOME/log-copias/incremental.log

# verifica si el empaquetado que se ha hecho tiene algun fichero
# si tiene se comprime con zip
if [ ! "$(tar -tf $NOMBREEMPAQUE)" = "" ]; then
	zip -j $NOMBREEMPAQUE.zip $NOMBREEMPAQUE &> /dev/null
fi

# para todo los casos asi tenga o no el empaquetado ficheros dentro
# se borra por que ya no se usara
rm $NOMBREEMPAQUE