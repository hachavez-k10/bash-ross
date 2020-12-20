#!/bin/bash
# Script para verificar el ultimo inicio de sesión de usuarios de un grupo específico.

# Hecho con todo mi <3 para Ross Yalico, aunque se que no entiendes nada jaja

echo '--------------------------------------------------'
echo 'INFORMACIÓN DE USUARIOS PERTENECIENTES A UN GRUPO.'
echo '--------------------------------------------------'


read -p 'Ingrese el nombre del grupo: ' grupo
echo ''

linea_grupo=$(cat /etc/group | tr ":" " " | grep -i -E "\<^$grupo\>")

if [[ ! -z $linea_grupo ]]; then

	lista_users=$(echo $linea_grupo | cut -d " " -f 4 | tr "," " ")

	if [[ -z $lista_users ]]; then

		echo 'Grupo existe pero no tiene usuarios.'

	else
		
		for user in $lista_users; do
			echo '+++++++++++++++++++++++++++++++++++++++++++'
			echo "USUARIO: $user" 
			echo ''
			echo "El ultimo inicio de sesión de este usuario fue el $(grep -E "systemd.*opened.*$user" /var/log/auth.log | tail -n 1 | tr -s " " | cut -d " " -f 1-3)"
			pers_dir=$(grep -E "$user" /etc/passwd | rev | cut -d ":" -f 2 | rev)
			echo -n "Su carpeta personal es: $pers_dir. "
			echo "El espacio que ocupa esta carpeta es: $(du -sh "$pers_dir" 2> /dev/null | tr "\t" " " | cut -d " " -f 1)"
			echo '+++++++++++++++++++++++++++++++++++++++++++'
			echo ''
		done
	fi
else
	echo 'Grupo ingresado no existe.'
fi

