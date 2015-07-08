
#include '::puppet'
class { '::puppet' :
  manage_repos => false,
}
class { '::puppet::master' :
  server_type     => 'puppetserver',
  basemodulepath  => '/etc/puppet/modules:/usr/share/puppet/modules:site',
  hiera_backends  => {
    'yaml' => {
      'datadir' => '/etc/puppet/environments/%{environment}/hiera',
    }
  },
  hiera_hierarchy => [
    'node/%{::clientcert}',
    'app_tier/%{::app_tier}',
    'global' ],
}



