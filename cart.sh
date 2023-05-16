echo -e "\e[36m>>>>>>>>> Configuring NodeJs Repos <<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>> Add Application user <<<<<<<<<\e[0m"
useradd roboshop

echo -e "e\[36m>>>>>>>>> create app directory <<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>> download app content <<<<<<<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip

echo -e "\e[36m>>>>>>>>>>> Unzip app content <<<<<<<<<\e[0m"
cd /app
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>> Install NodJS dependencies <<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>> Copy Cart SystemD file <<<<<<<<<<<\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>> Start cart service  <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart


