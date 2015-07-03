Package {
  allow_virtual => true,
}

class { 'r10k':
  version           => '1.5.1',
  sources           => {
    'puppet' => {
      'remote'  => 'git@github.com:Brawnd0/puppet-ctrl.git',
      'basedir' => "${::settings::confdir}/environments",
      'prefix'  => false,
    },
  },
  manage_modulepath => false,
  provider => 'gem',
}
