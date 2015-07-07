#
#
#
#
#
class { '::puppet::profile::master':
    server_type    => 'puppetserver',
    basemodulepath => '/etc/puppet/modules:site',
    java_ram       => '2g',
    server_version => '3.8.1',
}

