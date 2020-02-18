#!/bin/bash
echo "Iniciando..."
printf "Digite a Senha do Repositorio: "

read -s senha  # O -s é para não mostra a senha

echo "Instalando o Docker"
curl -sSL https://get.docker.com | sh


sudo usermod -aG docker pi


sudo systemctl enable docker

apt-get install -y docker-compose

SERVICE=hamachi
if P=$(pgrep $SERVICE)
then
    echo "$SERVICE is running, PID is $P"
else
    echo "$SERVICE is not running"
    if [ -e /sys/class/net/eth0 ]; then
        MAC=$(cat /sys/class/net/eth0/address)
    else
        MAC=$(cat /sys/class/net/wlan0/address)
    fi

    wget https://www.vpn.net/installers/logmein-hamachi-2.1.0.203-armhf.tgz
    tar -zxvf logmein-hamachi-2.1.0.203-armhf.tgz
    cd logmein-hamachi-2.1.0.203-armhf
    ./install.sh
    /etc/init.d/logmein-hamachi start
    hamachi login
    echo "Logando Hamachi Pause por 20 segundos"
    sleep 10
    hamachi attach eltonss.eng@gmail.com
    echo "Anexando conta do Hamachi Pause por 10 segundos"
    sleep 10
    hamachi set-nick $MAC
    echo "Set Nickname $MAC Hamachi Pause por 15 segundos"
    sleep 10
    cd ..
fi




echo "Baixando os Containes"
if [ ! -d "autodomodocker/mqtt" ]
then
git clone https://autodomum:$senha@bitbucket.org/autodomum_05/autodomodocker.git
chmod -R 777 autodomodocker/mqtt
cd autodomodocker/mqtt
else
chmod -R 777 autodomodocker/mqtt
cd autodomodocker/mqtt
git pull
fi


if [ -e "/dev/ttyACM0" ]
then
sudo chmod -R 777 /dev/ttyACM0
fi
docker-compose up


#Criando a Pasta Secundaria
