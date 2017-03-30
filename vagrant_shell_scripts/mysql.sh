debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
apt-get update
echo "installing mysql"
apt-get install -y mysql-server libapache2-mod-auth-mysql php5-mysql
apt-get install libmysqlclient-dev -y


