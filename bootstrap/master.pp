#Package {
#  allow_virtual => true,
#}

#include ::epel
#Yumrepo<| |> -> Package <| |>
#include ::puppetdb
class { '::puppet::profile::master':
  basemodulepath => '/etc/puppet/modules:site',
  java_ram => '1532M'
}
