apt-get -y install gnupg pwgen
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
apt-get -y update && apt-get install -y mongodb-org
systemctl daemon-reload &&  systemctl enable mongod.service &&  systemctl restart mongod.service &&  systemctl --type=service --state=active | grep mongod


wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  apt-key add -
apt -y install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | tee  /etc/apt/sources.list.d/elastic-7.x.list
apt -y update && apt -y install elasticsearch-oss
echo "cluster.name: graylog
action.auto_create_index: false" | tee /etc/elasticsearch/elasticsearch.yml
chown -R elasticsearch /usr/share/elasticsearch/
systemctl daemon-reload && systemctl enable elasticsearch.service && systemctl restart elasticsearch.service && systemctl --type=service --state=active | grep elasticsearch

wget https://packages.graylog2.org/repo/packages/graylog-5.0-repository_latest.deb
dpkg -i graylog-5.0-repository_latest.deb
apt-get -y update && apt-get -y install graylog-server

PASSWORD_SECRET=$(pwgen -N 1 -s 96)

sed -i 's/password_secret =/password_secret = '$PASSWORD_SECRET'/g' /etc/graylog/server/server.conf
sed -i "s/root_password_sha2 = /root_password_sha2=e7b35bf8870d4b6701dcce6fa652a661149da30eadb1e94b7fdcc830e8af7e52/g" /etc/graylog/server/server.conf
sed -i "s/#http_bind_address = 127.0.0.1:9000/http_bind_address = 0.0.0.0:9000/g" /etc/graylog/server/server.conf

systemctl daemon-reload && systemctl enable graylog-server && systemctl restart graylog-server && systemctl --type=service --state=active | grep graylog-server

CPU_AVX_SUPPORT=$(cat /proc/cpuinfo | grep avxad)
if [ -z "$CPU_AVX_SUPPORT" ]; 
then
 echo ""
 echo "========================= WARNING ============================"
 echo "Graylog's VM CPU currently doesn't support AVX instruction, so MongoDB service won't work."
 echo "If you're using Proxmox, please go to through your VM Hardware > Processors and"
 echo "change 'Type' field value to 'Host'"
 echo "==============================================================="
 echo ""
fi