script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>> Install maven <<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>> Add app User <<<<<<<<<<\e[0m"

useradd ${app_user}

echo -e "\e[36m>>>>>>>>> Create app directory <<<<<<<<<<\e[0m"

rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download app content <<<<<<<<<<\e[0m"

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[36m>>>>>>>>> Extract app content <<<<<<<<<<\e[0m"

cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>> Download Maven Dependencies <<<<<<<<<<\e[0m"

mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>> Copy systemd service file <<<<<<<<<<\e[0m"

cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>> Restart service file <<<<<<<<<<\e[0m"

systemctl enable shipping
systemctl start shipping
systemctl restart shipping

echo -e "\e[36m>>>>>>>>> Install Mysql <<<<<<<<<<\e[0m"

yum install mysql -y

echo -e "\e[36m>>>>>>>>> Load schema <<<<<<<<<<\e[0m"

mysql -h mysql-dev.bhaskar77.online -uroot -pRoboShop@1 < /app/schema/shipping.sql



