#!/bin/bash

choose_storage_location(){
  # Ask to the user on which partition he wants to install all of this.
  # Search for all partitions and set the largest free available as default. Ex:
  # 1 - /home (free 20G)
  # 2- /srv (free 40G)
  echo 'Choose storage location'
}

input_domain_name(){
  echo -e -n '\033[1;30;47mType the domain name to use. This is the domain name' \
   'used for the public interface : \033[0m'
  read domain_name
  echo -e "The website should be available at http://$domain_name, you are "\
  "agree with that ? [yes or no ]"
  read answer
  if [ "$answer" = "yes" ] || [ "$answer" = "y" ]; then
    eval "$domain_name"
  else
    input_domain_name
  fi
}

get_deb_dependancies() {
    local path=HoopConfigFiles
}

# Script to install Hoop easily
echo -e '---------------------------------'
echo -e '-  Welcome on Hoop Installation -'
echo -e '---------------------------------\n'
echo -e 'This script is here to help you in the installation
on your Hoop service. Please provide :\n\n'
echo -e '\t A valid domain name \n'

echo 'We generated automatically a new strong password for the hoop
database. /!\ Caution : You should not change the password of
the hoop database manually.'

input_domain_name

echo 'Install dependancies it should take some times ...'
export DEBIAN_FRONTEND=noninteractive
# Add mariadb repository
DEBIAN_FRONTEND=noninteractive apt install -y software-properties-common
DEBIAN_FRONTEND=noninteractive apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
DEBIAN_FRONTEND=noninteractive add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://de-rien.fr/mariadb/repo/10.1/debian jessie main'
DEBIAN_FRONTEND=noninteractive apt update

# apt install mkpasswd git pip

# generate a random root password for the root database user
root_password=$(mkpasswd -s "")
hoop_password=$(mkpasswd -s "")
echo "root_password: $root_password" > config.yaml
echo "hoop_password: $hoop_password" >> config.yaml

sudo debconf-set-selections <<< "mariadb-server10.1 mysql-server/root_password password $root_password"
sudo debconf-set-selections <<< "mariadb-server10.1 mysql-server/root_password_again password $root_password"

DEBIAN_FRONTEND=noninteractive apt install -q -q -y python python2.7 python3 python3.4 python-pip git-core zlib1g-dev \
  python-imaging libjpeg-dev python-dev mysql-client mariadb-server ufw

pip install virtualenv virtualenvwrapper

# Create the hoop database with credentials
mysql -u root -p"$root_password" -e " \
CREATE DATABASE hoop; \
CREATE USER 'hoop'@'localhost' IDENTIFIED BY '"$hoop_password"'; \
GRANT ALL PRIVILEGES ON hoop.* TO 'hoop'@'localhost'; \
FLUSH PRIVILEGES;"

echo 'Creating a new user for the web Interface'

# create user hoop
adduser --disabled-password --gecos --quiet hoop
## switch on hoop user
su - hoop << EOF
mkdir /home/hoop/.virtualenv
pip install --user virtualenv virtualenvwrapper
cd /home/hoop && git clone https://framagit.org/Archerfou/Hoop.git
python -m virtualenv /home/hoop/.virtualenv/hoop
source /home/hoop/.virtualenv/hoop/bin/activate
pip install -r /home/hoop/Hoop/requirements.txt
python /home/hoop/Hoop/HoopInterface/manage.py makemigrations
python /home/hoop/Hoop/HoopInterface/manage.py migrate
echo "export WORKON_HOME=/home/hoop/.virtualenv" >> /home/hoop/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/hoop/.bashrc
EOF

# create vmail user and group for mailboxes
# Set rights on folder for vmail group

# copy services configuration files
# cp -r Hoop/HoopConfigFiles/mail/dovecot/* /etc/dovecot/
# cp -r Hoop/HoopConfigFiles/mail/postfix/* /etc/postfix

# Set the database storage in the user

# Update the password for services
# find /etc/dovecot/ -type f | xargs sed -i  's/mailuserpass/DB_PASSWORD/g'
# find /etc/postfix/ -type f | xargs sed -i  's/mailuserpass/DB_PASSWORD/g'

# Install Nginx and configure with wsgi automatically

# Install certbot to generate a certificate automatically

# Configure UFW

# Install Mailpile
