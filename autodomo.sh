#!/bin/bash

clear

cat font1.sh 

echo "Iniciando..."
#printf "Digite a Senha do Repositorio: "

#read -s senha  # O -s é para não mostra a senha

echo "Instalando o Docker"
curl -sSL https://get.docker.com | sh


sudo usermod -aG docker pi


sudo systemctl enable docker

apt-get install -y docker-compose

apt-get install -y nodejs

apt-get install -y npm

npm install -g pm2

clear

cat font1.sh 

echo "Instalando Hamachi"

SERVICE=hamachi
if P=$(pgrep $SERVICE)
then
    if [ -e /sys/class/net/eth0 ]
    then
        MAC=$(cat /sys/class/net/eth0/address)
    elif [ -e /sys/class/net/wlan0 ]
    then
        MAC=$(cat /sys/class/net/wlan0/address)
    else
        MAC=$$
    fi

    echo "$SERVICE is running, PID is $P"
    sudo systemctl stop logmein-hamachi
    cd /var/lib/logmein-hamachi
    sudo rm *
    echo "Iniciando Hamachi"
    sudo systemctl start logmein-hamachi
    echo "Anexando conta do Hamachi"
    sudo hamachi attach eltonss.eng@gmail.com
    echo "Set Nickname $MAC Hamachi"
    sudo hamachi set-nick $MAC
    echo "Logando Hamachi"
    sudo hamachi login
    cd ..
else
    echo "$SERVICE is not running"
    if [ -e /sys/class/net/eth0 ]
    then
        MAC=$(cat /sys/class/net/eth0/address)
    elif [ -e /sys/class/net/wlan0 ]
    then
        MAC=$(cat /sys/class/net/wlan0/address)
    else
        MAC=$$
    fi
    echo "Instalando Hamachi"
    wget https://www.vpn.net/installers/logmein-hamachi-2.1.0.203-armhf.tgz
    tar -zxvf logmein-hamachi-2.1.0.203-armhf.tgz
    cd logmein-hamachi-2.1.0.203-armhf
    ./install.sh
    echo "Esperando 20 Segundos"
    sleep 20
    echo "Iniciando Hamachi"
    sudo systemctl start logmein-hamachi
    echo "Anexando conta do Hamachi"
    sudo hamachi attach eltonss.eng@gmail.com
    echo "Set Nickname $MAC Hamachi"
    sudo hamachi set-nick $MAC
    echo "Logando Hamachi"
    sudo hamachi login
    cd ..
fi



echo "Baixando os Containes"
if [ ! -d "Lais/mqtt" ]
then
git clone https://github.com/eltonssilva/Lais.git
chmod -R 777 Lais/mqtt
cd Lais/mqtt
else
chmod -R 777 Lais/mqtt
cd Lais/mqtt
git pull
fi


npm install ./kdb/devautodomo

sudo pm2 start /home/autodomo/Lais/mqtt/kdb/devautodomo/kdb.js --exp-backoff-restart-delay=20
sudo pm2 save
sudo pm2 startup

if [ -e "/dev/ttyACM0" ]
then
sudo chmod -R 777 /dev/ttyACM0
fi
docker-compose up


#Criando a Pasta Secundaria
