#!/usr/bin/env bash

##--------------------------------------------------------------------------------------------##
##                       Constantes
##Diretórios
DOWNLOADS="$HOME/Downloads/programas"

##URL's
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_VIVALDI="https://downloads.vivaldi.com/stable/vivaldi-stable_5.2.2623.24-1_amd64.deb"

#CORES

VERMELHO='\e[1;91m'
VERDE='\e[1;92m'
SEM_COR='\e[0m'

##--------------------------------------------------------------------------------------------##
##                       Funções

apt_update(){
  sudo apt update && sudo apt dist-upgrade
}

##Removendo trava do apt

travas_apt(){
  sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
}

##--------------------------------------------------------------------------------------------##
##                       Preparando para instalação
travas_apt

## Adicionando/Confirmando arquitetura de 32 bits ##
sudo dpkg --add-architecture i386

## Instalando codec para suportar html5 no vivald
sudo apt install chromium-codecs-ffmpeg-extra

## Atualizando o repositório ##
sudo apt update -y

PROGRAMAS_PARA_INSTALAR=(
  snapd
  steam-installer
  steam-devices
  gparted
  gnome-sushi 
  folder-color
  git
)

##--------------------------------------------------------------------------------------------##
##                       Baixando e intslando programas externos

echo -e "${VERDE}[INFO] - Baixando pacotes .deb${SEM_COR}"

mkdir "$DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"       -P "$DOWNLOADS"
wget -c "$URL_VIVALDI"       -P "$DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
echo -e "${VERDE}[INFO] - Instalando pacotes .deb baixados${SEM_COR}"
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

## Instalando pacotes .deb baixados na sessão anterior ##
echo -e "${VERDE}[INFO] - Instalando pacotes .deb baixados${SEM_COR}"
sudo dpkg -i $DOWNLOADS/*.deb

# Instalar programas no apt
echo -e "${VERDE}[INFO] - Instalando pacotes apt do repositório${SEM_COR}"

travas_apt

for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    sudo apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

## Instalando pacotes Flatpak ##

  echo -e "${VERDE}[INFO] - Instalando pacotes flatpak${SEM_COR}"

  flatpak install flathub com.spotify.Client -y
  flatpak install flathub com.bitwarden.desktop -y
  flatpak install flathub org.qbittorrent.qBittorrent -y
  flatpak install flathub com.visualstudio.code -y

## Instalando pacotes Snap ##

echo -e "${VERDE}[INFO] - Instalando pacotes snap${SEM_COR}"

sudo snap install authy -y

##--------------------------------------------------------------------------------------------##
##                       Pós-instalação
apt_update -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
nautilus -q
apt_update -y
