script_path=$(dirname $0)
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>> Install Nginx <<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[36m>>>>>>>>> Copy Roboshop Conf <<<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>> Remove default web content <<<<<<<<<\e[0m"

rm -rf /usr/share/nginx/html/*


echo -e "\e[36m>>>>>>>>> Download frontend content <<<<<<<<<\e[0m"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>> Extract frontend content <<<<<<<<<\e[0m"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>> Systemd service file <<<<<<<<<\e[0m"

systemctl enable nginx
systemctl restart nginx