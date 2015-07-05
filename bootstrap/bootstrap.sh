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

service iptables stop
if [ ! $(grep single-request-reopen /etc/sysconfig/network) ]; then
    #sysctl -w net.ipv6.conf.all.disable_ipv6=1
    #sysctl -w net.ipv6.conf.default.disable_ipv6=1
    echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf
    echo 'RES_OPTIONS=single-request-reopen' >> /etc/sysconfig/network 
    echo 'NETWORKING_IPV6=no' >> /etc/sysconfig/network

fi
rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
yum install -y git rubygems
gem install bundle

TOPDIR=`git rev-parse --show-toplevel`

cd ${TOPDIR}/
bundle install --path=vendor/bundle --binstubs=bin/

# Add bootstrap modules
MODPATH=$$TOPDIR/tmp/bootstrap/modules
mkdir -p $MODPATH
./bin/puppet module install --modulepath=$MODPATH zack/r10k --version 2.8.2
#./bin/puppet module install --modulepath=$MODPATH maestrodev/rvm --version 1.12.0
./bin/puppet module install --modulepath=$MODPATH hunner/hiera --version 1.1.1
./bin/puppet module install --modulepath=$MODPATH stahnma/epel --version 1.0.2
./bin/puppet module install --modulepath=$MODPATH puppetlabs/puppetdb --version 4.3.0
./bin/puppet module install --modulepath=$MODPATH abstractit-puppet --version 1.3.1


exit
#puppet module install --modulepath=$MODPATH stephenrjohnson/puppet --version 1.3.1
#puppet module install --modulepath=$MODPATH abstractit-puppet --version 1.3.1
#puppet module install --modulepath=$MODPATH hunner/hiera --version 1.1.1

# Configure the master, hiera, and r10k services
#puppet apply --modulepath=$MODPATH master.pp && \
puppet apply --modulepath=$MODPATH hiera.pp && \
  puppet apply --modulepath=$MODPATH r10k.pp


# If everything went well, deploy using r10k
r10k deploy environment -p

# If everything is successful, run puppet, otherwise alert
if [ $? -eq 0 ]
then
  puppet agent -t
  chkconfig puppet on
  service puppet start
else
  echo "Some part of the bootstrap process failed. Investigate the errors and proceed with manual bootstrapping."
  echo ""
  echo "See https://github.com/puppetinabox/documentation#bootstrap for the steps."
  echo ""
fi
