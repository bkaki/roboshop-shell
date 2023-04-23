app_user=roboshop
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_nodejs() {
  echo -e "\e[36m>>>>>>>>> Install NodeJs repos <<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[36m>>>>>>>>> Install NodeJs <<<<<<<<<<\e[0m"
  yum install nodejs -y

  echo -e "\e[36m>>>>>>>>> Create Application cart <<<<<<<<<<\e[0m"
  useradd ${app_user}

  echo -e "\e[36m>>>>>>>>> Create Application directory <<<<<<<<<<\e[0m"
  rm -rf /app
  mkdir /app

  echo -e "\e[36m>>>>>>>>> Create App content <<<<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  echo -e "\e[36m>>>>>>>>> unzip App content <<<<<<<<<<\e[0m"
  unzip /tmp/${component}.zip

  echo -e "\e[36m>>>>>>>>> Install npm dependencies <<<<<<<<<<\e[0m"
  npm install

  echo -e "\e[36m>>>>>>>>> Copy cart systemd file <<<<<<<<<<\e[0m"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

}

