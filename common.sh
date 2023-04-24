app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log
# rm -f $log_file

print_head() {
  func_print_head "\e[36m>>>>>>>>> $1 <<<<<<<<<<\e[0m"
  func_print_head "\e[36m>>>>>>>>> $1 <<<<<<<<<<\e[0m" &>>$log_file

}
 func_stat_check() {
 if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo "Refer the log file /tmp/roboshop.log for more information"
    exit
  fi
  }
func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then

    func_print_head "Copy MongoDB repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
    func_stat_check $?

   func_print_head "Install MongoDB Client"
   yum install mongodb-org-shell -y &>>$log_file
   func_stat_check $?

   func_print_head "load schema"
   mongo --host mongodb-dev.bhaskar77.online </app/schema/${component}.js &>>$log_file
   func_stat_check $?

  fi

  if [ "$schema_setup" == "mysql"]; then

     func_print_head "Install MySql client"
     yum install mysql -y &>>$log_file
     func_stat_check $?

      func_print_head "Load schema"
   mysql -h mysql-dev.bhaskar77.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql &>>$log_file
      func_stat_check $?

    fi
}
fucn_app_prereq() {

 func_print_head "Create application user"
 id ${app_user} &>>/tmp/roboshop.log
 if [ "$? -ne 0"]; then
  useradd ${app_user} &>>/tmp/roboshop.log
  fi

  func_stat_check $?

  func_print_head "Create application directory"
  rm -rf /app
  mkdir /app &>>$log_file
  func_stat_check $?

  func_print_head "Download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  cd /app
  func_stat_check $?

  func_print_head "unzip app content"
  unzip /tmp/${component}.zip &>>$log_file
  func_stat_check $?

}

func_systemd_setup() {

    func_print_head "setup systemd services"

    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    func_stat_check $?

    func_print_head "restart ${component} services"

    systemctl daemon-reload &>>$log_file
    systemctl enable ${component} &>>$log_file
    systemctl restart ${component} &>>$log_file

}

func_nodejs() {
  func_print_head "Install NodeJs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_stat_check $?

  func_print_head "Install NodeJs"
  yum install nodejs -y &>>$log_file

  func_stat_check $?

  func_app_prereq

  func_print_head "Install npm dependencies"

  npm install &>>$log_file

  func_stat_check $?

  Func_schema_setup

  func_systemd_service


}

func_java() {

  func_print_head "Install Maven"
  yum install maven -y &>>/$log_file

  func_stat_check $?

  func_app_prereq

  func_print_head "Download maven dependencies"
  mvn clean package &>>$log_file
  func_stat_check $?
  mv target/${component}-1.0.jar ${component}.jar

  Func_schema_setup
  func_systemd_service

}