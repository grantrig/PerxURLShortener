echo "Running Apt Get Update"
apt-get update -y
echo "Install Curl"
apt-get install curl -y

echo "Install imagemagick imagemagic-dev"
apt-get install imagemagick libmagickwand-dev -y

echo "Installing git"
apt-get install git -y

echo "Install libs needed for nokogiri"
apt-get install libxslt-dev libxml2-dev -y

echo "Install file change notifier"
apt-get install incron -y

sh -c 'echo "Asia/Singapore" > /etc/timezone'
dpkg-reconfigure --frontend noninteractive tzdata

apt-get install zsh -y
