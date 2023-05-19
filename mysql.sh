
echo -e "\e[36m>>>>>>>>> Disable mysql 8 version <<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>> copy mysql repo <<<<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>> Install mysql  <<<<<<<<<<\e[0m"

yum install mysql-community-server -y

echo -e "\e[36m>>>>>>>>> Start Mysql  <<<<<<<<<<\e[0m"

systemctl enable mysqld
systemctl start mysqld

echo -e "\e[36m>>>>>>>>> reset Mysql password <<<<<<<<<<\e[0m"

mysql_secure_installation --set-root-pass RoboShop@1

