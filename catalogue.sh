echo -e "\e[36m>>>>>>>>> Configuring NodeJs Repos <<<<<<<<<<\e[0m"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>> Add user <<<<<<<<<\e[0m"
useradd roboshop

echo -e "e\[36m>>>>>>>>> Add app directory <<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>>>>> Download application content <<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[36m>>>>>>>>>>> Unzip app directory <<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>> Install dependencies <<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>> Copy service file <<<<<<<<<<<\e[0m"
cp calalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>> System service file <<<<<<<<\e[0m"

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>>>>> Download Repo file <<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>> Install Mongodb >>>>>>\e[om"

yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<\e[0m"
mongo --host mongodb-dev.bhaskar77.online </app/schema/catalogue.js
