script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>> Configuring NodeJs Repos <<<<<<<<<<\e[0m"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>> Add Application user <<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "e\[36m>>>>>>>>> create app directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download app content <<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[36m>>>>>>>>>>> Unzip app content <<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>> Install NodJS dependencies <<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>> Copy Catalogue SystemD file <<<<<<<<<<<\e[0m"
cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>> Start Catalogue service  <<<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>>>>> Copy MongoDB Repo  <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>> Install Mongodb client >>>>>>\e[om"

yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<\e[0m"
mongo --host mongodb-dev.bhaskar77.online </app/schema/catalogue.js
