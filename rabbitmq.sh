echo -e "\e[36m>>>>>>>>>> Setup erlang repo <<<<<<<<<<\e[0m"

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>> SInstall erlang <<<<<<<<<<\e[0m"
yum install erlang -y

echo -e "\e[36m>>>>>>>>>> Setup rabbitmq repo <<<<<<<<<<\e[0m"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>> Install Rabbitmq <<<<<<<<<<\e[0m"

yum install rabbitmq-server -y

echo -e "\e[36m>>>>>>>>>> Start system files <<<<<<<<<<\e[0m"

systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[36m>>>>>>>>>> Add application User in Rabbitmq <<<<<<<<<<\e[0m"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"



