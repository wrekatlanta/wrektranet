#!/bin/bash
set -e

# Boostraps a Wrektranet dev box. This is primarily for use with Vagrant on a
# Ubuntu box, could be used on any real Ubuntu box, in theory.
#
# REQUIRES:
# Download of the "Oracle InstantClient RPM files for Linux x86-64" from
# <http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html>.
# These files are: basic, sqlplus, and SDK (listed as 'devel' for the RPM).
# Download those files, and put them in the top-level Wrektranet git directory.
#
# Here's a rough set of steps that will be taken to get everything provisioned:
#   01. Setup a simple directory structure.
#   02. Update apt-get
#   03. Install needed mysql packages with apt-get
#   04. Convert the RPM files to DEB files, and install them.
#   05. Setup ORACLE environment variables and symlinks
#   06. Install RVM
#   07. Install Node.js
#   08. Download the correct ruby version with RVM
#   09. Install bundler
#   10. Install project dependencies
#
# That should settle everything. Rails is downloaded as a Gem dependency, so
# no worries about that. Let's get started.




cd /home/vagrant

# 1. Move files around, get the version of the oracle client
# mkdir -p oracle_raws/
cd wrektranet/
# for file in $(ls | grep 'oracle-instantclient');
#     do cp $file /home/vagrant/oracle_raws/;
# done

# cd /home//oracle_raws
# ORACLE_CLIENT_VERSION=$(ls |
#                         grep 'oracle' |
#                         sed 's/oracle-instantclient\([0-9]*.[0-9]*\).*/\1/p' |
#                         head -n1)
cd /home/vagrant

# 2. Update apt-get
printf "Updating apt-get..."
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes dist-upgrade
printf "done\n"

# 3. Install neeeded mysql packages
printf "Installing libaio1..."
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install libaio1
printf "done\n"

printf "Installing mysql-server..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
printf "done\n"

# 4. Convert/install RPM files
# printf "Installing alien..."
# sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install alien
# printf "done\n"
# cd oracle_raws/
# for file in $(ls);
#     do printf "Converting $file to .deb file...";
#     sudo alien -i $file > /dev/null;
#     printf "done\n";
# done

# 5. Setup Oracle env files and symlinks
# echo "
# export ORACLE_HOME=/usr/lib/oracle/$ORACLE_CLIENT_VERSION/client64
# export PATH=\$PATH:\$ORACLE_HOME/bins
# export LD_LIBRARY_PATH=/usr/lib/oracle/$ORACLE_CLIENT_VERSION/client64/lib/\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}" > oracle.sh

# sudo mv oracle.sh /etc/profile.d/oracle.sh
# sudo chmod o+r /etc/profile.d/oracle.sh
# sudo ln -s /usr/include/oracle/$ORACLE_CLIENT_VERSION/client64 /usr/lib/oracle/$ORACLE_CLIENT_VERSION/client64/include
# source /etc/profile.d/oracle.sh


# 6. Install RVM
printf "Installing curl..."
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install curl
printf "done\n"

RVM_KEY=409B6B1796C275462A1703113804BB82D39DC0E3
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB > /dev/null

printf "Installing RVM..."
curl -sSL https://get.rvm.io | bash -s stable --ruby
printf "done\n"
source /home/.rvm/scripts/rvm

sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove --assume-yes

# 7. Install Node.js
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
printf "Installing nodejs..."
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install -y nodejs
printf "done\n"

# 8. Download project ruby version (if there's an automated way for RVM to do
# this, go ahead and replace what's here with that).
cd /home/vagrant/wrektranet
RUBY_VERSION=$(cat Gemfile |
               grep "^ruby" |
               sed "s/ruby '\([0-9]*\.[0-9]*\.[0-9]*\)'/\1/")
#FULL_VERSION=ruby-$RUBY_VERSION-$NANO_VERSION
printf "Installing $RUBY_VERSION..."
rvm install 2.5.9 > /dev/null
printf "done\n"
rvm --default use 2.5.9

# 9. Install bundler and git
printf "Installing git..."
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install git
printf "dont\n"

printf "Installing bundler..."
# not sure what version
gem install bundler
printf "done\n"

# 10. Install project dependencies
printf "Installing libmysqlclient-dev..."
sudo DEBIAN_FRONTEND=noninteractive apt-get --assume-yes install libmysqlclient-dev
printf "done\n"
printf "Running bundle install..."
bundle install --without=oracle --verbose
printf "done\n"

exit 0
