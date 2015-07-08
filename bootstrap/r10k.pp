

class { '::r10k':
  version           => '1.5.1',
  sources           => {
    'puppet' => {
      'remote'  => 'https://github.com/Brawnd0/puppet-ctrl.git',
      'basedir' => "${::settings::confdir}/environments",
      'prefix'  => false,
    },
  },
  manage_modulepath => false,
  provider          => 'gem',
  cachedir          => '/var/cache/r10k',
}

