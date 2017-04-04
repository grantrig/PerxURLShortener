debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
apt-get update
echo "installing mysql"
apt-get install -y mysql-server
apt-get install libmysqlclient-dev -y


