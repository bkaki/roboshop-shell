app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[36m>>>>>>>>> $1 <<<<<<<<<<\e[0m"

}

func_nodejs() {
 print_head "Install NodeJs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head "Install NodeJs"
  yum install nodejs -y

  print_head "Create Application cart"
  useradd ${app_user}

  print_head "Create Application directory"
  rm -rf /app
  mkdir /app

  print_head "Create App content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head "unzip App content"
  unzip /tmp/${component}.zip

  print_head "Install npm dependencies"
  npm install

  print_head "Copy cart systemd file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

}

