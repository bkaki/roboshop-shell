script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

echo -e "\e[36m>>>>>>>>>> Setup erlang repo <<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash


echo -e "\e[36m>>>>>>>>>> Install erlang <<<<<<<<<<\e[0m"
yum install erlang -y


echo -e "\e[36m>>>>>>>>>> Setup rabbitmq repo <<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash


echo -e "\e[36m>>>>>>>>>> Install Rabbitmq <<<<<<<<<<\e[0m"

yum install rabbitmq-server -y

echo -e "\e[36m>>>>>>>>>> Start system files <<<<<<<<<<\e[0m"

systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[36m>>>>>>>>>> Add application User in Rabbitmq <<<<<<<<<<\e[0m"

rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"



