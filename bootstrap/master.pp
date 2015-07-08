
#include '::puppet'
class { '::puppet' :
  manage_repos => false,
}
class { '::puppet::master' :
  server_type     => 'puppetserver',
  basemodulepath  => '/etc/puppet/modules:/usr/share/puppet/modules:site',
  hiera_hierarchy => [
    'node/%{::clientcert}',
    'app_tier/%{::app_tier}',
    'global' ],
}



