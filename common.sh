app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

#rm -f $log_file


func_print_head() {
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<<<\e[0m"
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<<<\e[0m" &>>$log_file
 }

func_stat_check() {
     if [ $1 -eq 0 ]; then
        echo -e "\e[32mSUCCESS\e[0m"
      else
        echo -e "\e[31mFailure\e[0m"
        echo "refer the log file /tmp/roboshop.log for more information"
        exit 1
      fi
 }

func_schema_setup() {

  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copy MongoDB Repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    func_stat_check $?

    func_print_head "Install Mongodb client"
    yum install mongodb-org-shell -y &>>$log_file
    func_stat_check $?

    func_print_head "Load Schema"
    mongo --host mongodb-dev.bhaskar77.online </app/schema/${component}.js &>>$log_file
    func_stat_check $?
fi

  if [ "$schema_setup" == "mysql" ]; then

    func_print_head "Install Mysql"
    yum install mysql -y &>>$log_file
    func_stat_check $?

    func_print_head "Load schema"
    mysql -h mysql-dev.bhaskar77.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
    func_stat_check $?
fi
}

func_app_prereq() {

    func_print_head "Add app User"
    id ${app_user} &>>/tmp/roboshop.log
    if [ $? -ne 0 ]; then
      useradd ${app_user} &>>/tmp/roboshop.log
    fi
    func_stat_check $?

    func_print_head "Create app directory"
    rm -rf /app &>>$log_file
    mkdir /app &>>$log_file
    func_stat_check $?

    func_print_head "Download app content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    func_stat_check $?

    func_print_head "Extract app content"
    cd /app
    unzip /tmp/${component}.zip &>>$log_file
    func_stat_check $?
}

func_systemd_setup() {

  func_print_head "Setup systemd service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  func_stat_check $?

  func_print_head "Start service file"
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_stat_check $?

}

func_nodejs() {

  func_print_head "configuring NodeJS repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_stat_check $?

  func_print_head "Install NodeJS"
  yum install nodejs -y &>>$log_file
  func_stat_check $?

  func_app_prereq

  func_print_head "Install NodJS dependencies"
  npm install &>>$log_file
  func_stat_check $?

  func_schema_setup

  func_systemd_setup
}

func_java() {

  func_print_head "Install maven"
  yum install maven -y &>>$log_file
  func_stat_check $?

  func_app_prereq

  func_print_head "Download Maven Dependencies"
  mvn clean package &>>$log_file
  func_stat_check $?

  mv target/${component}-1.0.jar ${component}.jar &>>$log_file

  func_schema_setup
  func_systemd_setup
}

func_python() {

 func_print_head "Install Python"
 yum install python36 gcc python3-devel -y &>>$log_file
 func_stat_check $?

 func_app_prereq

 func_print_head "Install Python dependencies"

 pip3.6 install -r requirements.txt &>>$log_file
 func_stat_check $?

 func_print_head "Update password in system service file"

 sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service &>>$log_file
 func_stat_check $?

 func_systemd_setup

}