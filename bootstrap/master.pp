Package {
      allow_virtual => true,
}

include ::epel
Yumrepo<| |> -> Package <| |>
class { '::puppet::profile::master':
    server_type    => 'puppetserver',
    basemodulepath => '/etc/puppet/modules:site',
    java_ram       => '2g',
    server_version => '3.8.1',
}

#include ::puppetdb
#class { '::puppet::master':
#      storeconfigs   => true,
#        environments => directory,
#}
