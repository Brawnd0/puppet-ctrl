#!/bin/sh
#
# Goal : self contained puppet 3.8 repository 
#   - Enable development on laptop
#   - Push to upstream to rollout to production
#   - Minimal initial puppet module requirements ( zack/r10k + abstractit/puppet )
#   
#
#

# Install r10k using Gem
# Launch r10k
#   - install abstractit/puppet module
#   - 

# If redhat
if [ ! -f /etc/yum.repos.d/puppetlabs.repo ]; then
  sudo rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
fi


sudo yum install -y git rubygems
sudo gem install bundle

if [ -d '/vagrant' ]; then
    cd /vagrant
fi

TOPDIR=`git rev-parse --show-toplevel`
echo "TOPDIR = '$TOPDIR'"

cd ${TOPDIR}/
#bundle install --path=vendor/bundle --binstubs=bin/

# Add bootstrap modules
#./bin/r10k deploy environment -pv

MODPATH=$TOPDIR/environments/production/modules
#mkdir -p $MODPATH
echo "MODPATH = '$MODPATH'"

# Configure the master, hiera, and r10k services
echo "Running: sudo $TOPDIR/bin/puppet apply --modulepath=$MODPATH $TOPDIR/bootstrap/master.pp"
sudo $TOPDIR/bin/puppet apply --modulepath=$MODPATH $TOPDIR/bootstrap/master.pp 

echo "sudo $TOPDIR/bin/puppet apply --modulepath=$MODPATH $TOPDIR/bootstrap/r10k.pp"
sudo $TOPDIR/bin/puppet apply --modulepath=$MODPATH $TOPDIR/bootstrap/r10k.pp

#puppet apply --modulepath=$MODPATH $TOPDIR/bootstrap/hiera.pp && \


# If everything went well, deploy using r10k
#r10k deploy environment -p

# If everything is successful, run puppet, otherwise alert
if [ $? -eq 0 ]
then
  sudo puppet agent -t
  sudo chkconfig puppet on
  sudo service puppet start
else
  echo "Some part of the bootstrap process failed. Investigate the errors and proceed with manual bootstrapping."
  echo ""
  echo "See https://github.com/puppetinabox/documentation#bootstrap for the steps."
  echo ""
fi
