#Package {
#  allow_virtual => true,
#}

#include ::epel
#Yumrepo<| |> -> Package <| |>
#include ::puppetdb
#class { '::puppet::master':
#  server_type               => 'puppetserver',
#  server_version            => '3.8.1',
#  java_ram                  => '1532M',
#  environmentpath           => "${codedir}/environments",
#  basemodulepath            => "${confdir}/modules:/usr/share/puppet/modules:site",
#  hiera_eyaml_key_directory => "${codedir}/hiera_eyaml_keys",
#  hieradata_path            => "${confdir}/hieradata",
#  hiera_backends            => {
#    'yaml' => {
#      'datadir' => '/etc/puppet/hieradata/%{environment}'
#    }
#  },
#
#}

#include '::puppet'
class { '::puppet' :
  manage_repos => false,
}
class { '::puppet::master' :
  server_type      => 'puppetserver',
  hiera_hierarchy  => [
    'node/%{::clientcert}',
    'app_tier/%{::app_tier}',
    'global' ],
}



