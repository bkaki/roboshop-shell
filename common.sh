app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[35m>>>>>>>>> $1 <<<<<<<<<<\e[0m"
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
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    func_stat_check $?

    func_print_head "Install Mongodb client"
    yum install mongodb-org-shell -y
    func_stat_check $?

    func_print_head "Load Schema"
    mongo --host mongodb-dev.bhaskar77.online </app/schema/${component}.js
    func_stat_check $?
fi

  if [ "$schema_setup" == "mysql" ]; then

    func_print_head "Install Mysql"
    yum install mysql -y
    func_stat_check $?

    func_print_head "Load schema"
    mysql -h mysql-dev.bhaskar77.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
    func_stat_check $?
fi
}

Func_app_prereq() {

    func_print_head "Add app User"
    useradd ${app_user} >/tmp/roboshop.log
    func_stat_check $?

    func_print_head "Create app directory"
    rm -rf /app
    mkdir /app
    func_stat_check $?

    func_print_head "Download app content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
    func_stat_check $?

    func_print_head "Extract app content"
    cd /app
    unzip /tmp/${component}.zip
    func_stat_check $?
}

func_systemd_setup() {

  func_print_head "Setup systemd service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  func_stat_check $?

  func_print_head "Start service file"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
  func_stat_check $?

}

func_nodejs() {
  func_print_head "configuring NodeJS repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  func_stat_check $?

  func_print_head "Install NodeJS"
  yum install nodejs -y
  func_stat_check $?

  func_app_prereq

  func_print_head "Install NodJS dependencies"
  npm install
  func_stat_check $?

  func_schema_setup
  func_systemd_setup
}

func_java() {

  func_print_head "Install maven"
  yum install maven -y >/tmp/roboshop.log
  func_stat_check $?

  Func_app_prereq

  func_print_head "Download Maven Dependencies"
  mvn clean package
  func_stat_check $?

  mv target/${component}-1.0.jar ${component}.jar

  func_schema_setup
  func_systemd_setup
}