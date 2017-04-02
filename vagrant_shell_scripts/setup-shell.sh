#echo "export LANG=en_US.UTF-8" >> ~/.bash_profile
#echo "export LC_ALL=en_US.UTF-8" >> ~/.bash_profile
git config --global user.name "Grant"
git config --global user.email grant@arsemporium.com


echo "Setting password to vagrant"
USERNAME=`whoami`
PASSWORD='vagrant'
echo "$USERNAME:$PASSWORD" | sudo chpasswd

file=/bin/zsh
if [ -e "$file" ]; then
    echo 'Changing shell to zsh'
    sudo chsh -s /bin/zsh $USERNAME
else
    echo "No ZSH shell exists, not changing shell"
fi

echo "HISTFILE=.zhistory" >> ~/.zshrc
