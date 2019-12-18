#!/bin/bash
echo "Iniciando..."
printf "Digite a Senha do Repositorio: "

read -s senha  # O -s é para não mostra a senha

curl -sSL https://get.docker.com | sh


sudo usermod -aG docker pi


sudo systemctl enable docker

apt-get install -y docker-compose


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
