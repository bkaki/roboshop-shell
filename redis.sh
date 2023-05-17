
echo -e "\e[36m>>>>>>>>>>>> Install Redis Repo file <<<<<<<<<<<<\e[om"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y


echo -e "\e[36m>>>>>>>>Install redis <<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y
yum install redis -y

echo -e "\e[36m>>>>>>>>>> update redis listen address <<<<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf

echo -e "\e[36m>>>>>>>>>> Systemd service file <<<<<<<<<<\e[0m"

systemctl enable redis
systemctl restart redis