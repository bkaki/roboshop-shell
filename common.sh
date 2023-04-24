app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  func_print_head "\e[36m>>>>>>>>> $1 <<<<<<<<<<\e[0m"

}
 func_status_check() {
 if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit
  fi
  }
func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then

    func_print_head "Copy MongoDB repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    func_stat_check $?

   func_print_head "Install MongoDB Client"
   yum install mongodb-org-shell -y
   func_stat_check $?

   func_print_head "load schema"
   mongo --host mongodb-dev.bhaskar77.online </app/schema/${component}.js
   func_stat_check $?

  fi

  if [ "$schema_setup" == "mysql"]; then

     func_print_head "Install MySql client"
     yum install mysql -y
     func_stat_check $?

      func_print_head "Load schema"
      mysql -h mysql-dev.bhaskar77.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
      func_stat_check $?

    fi
}
fucn_app_prereq() {

 func_print_head "Create application user"
  useradd ${app_user}
  func_stat_check $?

  func_print_head "Create application directory"
  rm -rf /app
  mkdir /app
  func_stat_check $?

  func_print_head "Download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  func_stat_check $?

  func_print_head "unzip app content"
  unzip /tmp/${component}.zip
  func_stat_check $?

}

func_systemd_setup() {

    func_print_head "setup systemd services"

    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
    func_stat_check $?

    func_print_head "restart system services"

    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component}

}

func_nodejs() {
  func_print_head "Install NodeJs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  func_stat_check $?

  func_print_head "Install NodeJs"
  yum install nodejs -y

  func_stat_check $?

  func_app_prereq

  func_print_head "Install npm dependencies"

  npm install

  func_stat_check $?

  Func_schema_setup

  func_systemd_service


}

func_java() {

  func_print_head "Install Maven"
  yum install maven -y

  func_stat_check $?

  func_app_prereq

  func_print_head "Download maven dependencies"
  mvn clean package
  func_stat_check $?
  mv target/${component}-1.0.jar ${component}.jar

  Func_schema_setup
  func_systemd_service

}