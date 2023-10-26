apt-get -y install net-tools apt-transport-https openjdk-11-jre-headless uuid-runtime pwgen dirmngr gnupg wget
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | apt-key add -
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get -y update && apt-get install -y mongodb-org
systemctl daemon-reload &&  systemctl enable mongod.service &&  systemctl restart mongod.service &&  systemctl --type=service --state=active | grep mongod


wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | tee  /etc/apt/sources.list.d/elastic-7.x.list
apt -y update && apt -y install elasticsearch-oss
echo "cluster.name: graylog
action.auto_create_index: false" | tee /etc/elasticsearch/elasticsearch.yml
chown -R elasticsearch /usr/share/elasticsearch/
systemctl daemon-reload && systemctl enable elasticsearch.service && systemctl restart elasticsearch.service && systemctl --type=service --state=active | grep elasticsearch

wget https://packages.graylog2.org/repo/packages/graylog-4.3-repository_latest.deb
dpkg -i graylog-4.3-repository_latest.deb
apt-get -y update && apt-get -y install graylog-server

PASSWORD_SECRET=$(pwgen -N 1 -s 96)

if [ -z "$1" ]; then
 sed -i "s/root_password_sha2 =/root_password_sha2 = e7b35bf8870d4b6701dcce6fa652a661149da30eadb1e94b7fdcc830e8af7e52/g" /etc/graylog/server/server.conf
else
 NEW_PASSWORD=$(echo -n $1 | sha256sum | awk {'print $1'})
 sed -i 's/root_password_sha2 =/root_password_sha2 = '$NEW_PASSWORD'/g' /etc/graylog/server/server.conf
fi
sed -i 's/password_secret =/password_secret = '$PASSWORD_SECRET'/g' /etc/graylog/server/server.conf
sed -i "s/#http_bind_address = 127.0.0.1:9000/http_bind_address = 0.0.0.0:9000/g" /etc/graylog/server/server.conf


systemctl daemon-reload && systemctl enable graylog-server && systemctl restart graylog-server && systemctl --type=service --state=active | grep graylog-server
