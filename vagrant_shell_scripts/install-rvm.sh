echo "Adding gpg Key for RVM"
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3

echo "Installing RVM"
\curl -L https://get.rvm.io | bash -s stable --ruby

echo "Sourcing .profile"	
source ~/.profile

rvm install 2.3.3
rvm use ruby 2.3.3 --default

source ~/.profile

echo "Installing Rails"
gem install rails --no-rdoc --no-ri 

gem install rubocop
gem install rspec
