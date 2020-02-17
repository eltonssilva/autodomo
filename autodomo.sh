#!/bin/bash
echo "Iniciando..."
printf "Digite a Senha do Repositorio: "

read -s senha  # O -s é para não mostra a senha

curl -sSL https://get.docker.com | sh


sudo usermod -aG docker pi


sudo systemctl enable docker

apt-get install -y docker-compose

wget https://www.vpn.net/installers/logmein-hamachi-2.1.0.203-armhf.tgz
tar -zxvf logmein-hamachi-2.1.0.203-armhf.tgz
cd logmein-hamachi-2.1.0.203-armhf
./install.sh
/etc/init.d/logmein-hamachi start
hamachi login
hamachi attach eltonss.eng@gmail.com
cd ..



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