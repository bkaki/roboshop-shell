script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input mysql root password Missing
  exit
fi


func_print_head "\e[36m>>>>>>>>> Disable MySQl 8 version <<<<<<<<<<\e[0m"
dnf module disable mysql -y

func_print_head "\e[36m>>>>>>>>> copy MySQl repo file  <<<<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

func_print_head "\e[36m>>>>>>>>> Install MySQl  <<<<<<<<<<\e[0m"
yum install mysql-community-server -y

func_print_head "\e[36m>>>>>>>>> start MySQl  <<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

func_print_head "\e[36m>>>>>>>>> Restart MySQl password  <<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password}
