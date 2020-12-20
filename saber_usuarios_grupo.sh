#!/bin/bash

echo '--------------------------------------------------'
echo 'INFORMACIÓN DE USUARIOS PERTENECIENTES A UN GRUPO.'
echo '--------------------------------------------------'


read -p 'Ingrese el nombre del grupo: ' grupo
echo ''

lngrupo=$(cat /etc/group | tr ":" " " | grep -i -E "\<^$grupo\>")

if [[ ! -z $lngrupo ]]; then

	users=$(echo $lngrupo | cut -d " " -f 4 | tr "," " ")

	if [[ -z $users ]]; then

		echo 'Grupo existe pero no tiene usuarios.'

	else
		
		for i in $users; do
			echo '+++++++++++++++++++++++++++++++++++++++++++'
			echo "USUARIO: $i" 
			echo ''
			echo "El ultimo inicio de sesión de este usuario fue el $(grep -E "systemd.*opened.*$i" /var/log/auth.log | tail -n 1 | tr -s " " | cut -d " " -f 1-3)"
			home_dir=$(grep -E "$i" /etc/passwd | rev | cut -d ":" -f 2 | rev)
			echo -n "Su carpeta personal es: $home_dir. "
			echo "El espacio que ocupa esta carpeta es: $(du -sh "$home_dir" 2> /dev/null | tr "\t" " " | cut -d " " -f 1)"
			echo '+++++++++++++++++++++++++++++++++++++++++++'
			echo ''
		done
	fi
else
	echo 'Grupo ingresado no existe.'
fi

