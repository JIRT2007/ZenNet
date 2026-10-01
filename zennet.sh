#!/bin/bash
clear

# === ARCHIVO DE LOG ===
LOG="$HOME/ZenNet/scan.log"
if [ ! -f "$LOG" ]; then
	touch "$LOG"
fi

puertos_gen=( 21 22 23 25 53 80 443 3306 8080 )

cat << "EOF"

 ███████████                     ██████   █████           █████   
▒█▒▒▒▒▒▒███                     ▒▒██████ ▒▒███           ▒▒███    
▒     ███▒    ██████  ████████   ▒███▒███ ▒███   ██████  ███████  
     ███     ███▒▒███▒▒███▒▒███  ▒███▒▒███▒███  ███▒▒███▒▒▒███▒   
    ███     ▒███████  ▒███ ▒███  ▒███ ▒▒██████ ▒███████   ▒███    
  ████     █▒███▒▒▒   ▒███ ▒███  ▒███  ▒▒█████ ▒███▒▒▒    ▒███ ███
 ███████████▒▒██████  ████ █████ █████  ▒▒█████▒▒██████   ▒▒█████ 
▒▒▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒▒  ▒▒▒▒ ▒▒▒▒▒ ▒▒▒▒▒    ▒▒▒▒▒  ▒▒▒▒▒▒     ▒▒▒▒▒  
==================================================================
         SIMPLE BASH NETWORK SCAN - DEVELOPED BY JIRT2007                             
==================================================================		  
EOF
echo " " | tee -a "$LOG"
echo "================== $(date) ==================" | tee -a "$LOG"

# === LECTURA DE DIRECCION IP ===
	# "ip -o" formatea la salida para que cada interfaz aparezca en una sola linea.	
	# "-4 addr show" se encarga de filtrar para mostrar interfaces y direcciones IPv4.
	# "grep -v ' lo '" filtra para quitar coincidencias (grep inverso).
	# "awk '{print $2, "->", $4}' filtra la segunda y cuarta columna."
	# "cut -d/ -f1" la flag -d elimina todo lo que sigue a /.
	# "head -n1" toma lo sobrante que seria la dirección IP.
	LOCALIP=$(ip -o -4 addr show |grep -v ' lo ' | awk '{print $4}' | cut -d/ -f1 | head -n1)

# === LECTURA DE SUBRED ===
	# "cut -d. -f1-3" filtrar solo los primeros tres campos separados por un punto.
	SUBRED=$(echo "$LOCALIP" | cut -d. -f1-3)

# === ping A TODAS LAS IP ===
	# "ping -c 1" envia solo un paquete ICMP al destino especificado.
	# "-W 1" si no lo regresa en un segundo lo da por fallido.
	# "2> /dev/null" envia la salida a la nada para no llenar la terminal de texto.
	for i in {1..254}; do
		PING=$(ping -c 1 -W 1 "${SUBRED}.${i}" 2> /dev/null)
		if echo "$PING" | grep -iq "ttl="; then

		# === ESCANEO DE PORTS GENERICOS ===
			# "timeout 1" detiene el comando despues de un segundo.
			# "bash -c" Lanza un proceso hijo para ejecutar el contenido entre comillas.
			# "echo >" escribe datos de salida.
			# "/dev/tcp/IP/PORT" Caracteristica del sistema de archivos de Bash para sockets TCP  
			PUERTOS="" 
			for port in "${puertos_gen[@]}"; do
				timeout 1 bash -c "echo > /dev/tcp/${SUBRED}.${i}/${port}" 2>/dev/null && \
					
				# === IDENTIFICAR SERVICIOS ===
					# "grep -w" busqueda exacta del contenido entre comillas.
					# "/etc/services" el archivo que contiene la tabla de nombres de servicio y sus números de puerto/protocolo.
					# "head -n1" limita la salida a únicamente la primera línea. 
					SERVICIO=$(grep -w "${port}/tcp" /etc/services | awk '{print $1}' | head -n1) && \ 
					
					PUERTOS="${PUERTOS} ${port} ${SERVICIO}"
			done
			
		
		# === LECTURA DE TIME TO LIFE ===
			TTL=$(echo "$PING" | grep -i "ttl=" | awk -F'ttl=' '{print $2}' | awk '{print $1}')

		# === LECTURA DE DIRECCION MAC ===
			# "awk -v ip="${SUBRED}.${i}"" filtra las IP como una variable interna en awk.
			# "'$1 == ip'" flag de awk que busca la primera fila de /proc/net/arp.
			# "{print $4}" imprime la cuarta linea del archivo donde estan las MAC.
			# "/proc/net/arp" el kernel almacena la cache con las IP-MAC descubiertas en las red. 
			MAC=$(awk -v ip="${SUBRED}.${i}" '$1 == ip {print $4}' /proc/net/arp)
		
			# "-z" detecta si la variable esta vacia.
			if [ -z "$MAC" ]; then
				MAC="MAC NOT DETECTED"
			fi

		# "\n" ejecuta un salto de linea.
		RESULTADO="\nIP LOCAL: ${SUBRED}.${i} | MAC: ${MAC} | TTL: ${TTL} \nOPEN PORTS:${PUERTOS}"
		
		# === ENVIAR SALIDA AL LOG ===
			# "tee -a" envia la salida para que se acumule al final de $LOG 
		echo -e "$RESULTADO"| tee -a "$LOG" 	
		fi
	done
