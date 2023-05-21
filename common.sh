app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head () {
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<<<\e[0m"
}

schema_setup() {
echo -e "\e[36m>>>>>>>>>> Copy MongoDB Repo  <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>> Install Mongodb client >>>>>>\e[om"

yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<<\e[0m"
mongo --host mongodb-dev.bhaskar77.online </app/schema/${component}.js
}

func_nodejs() {
print_head "configuring NodeJS repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "Install NodeJS"
yum install nodejs -y

print_head "Add Application user"
useradd ${app_user}

create "app directory"
rm -rf /app
mkdir /app

print_head "Download app content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

print_head "Unzip app content"
cd /app
unzip /tmp/${component}.zip

print_head "Install NodJS dependencies"
npm install

print_head "Copy Catalogue SystemD file"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

print_head "Start Catalogue service"

systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}

schema_setup

}