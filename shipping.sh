script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input mysql root password Missing
 exit
fi

component=shipping
shcema_setup=mysql
func_java



