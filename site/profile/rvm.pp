# == Class: profile::rvm
#
# RVM gem and version settings
#
# === Authors
#
# Rob Nelson <rnelson0@gmail.com>
#
# === Copyright
#
# Copyright 2015 Rob Nelson
#
class profile::rvm (
  $ruby_version = 'ruby-1.9.3-p551',
  $rvm_gems = [
    'rspec-puppet',
    'puppet',
    'fpm',
    'puppet-lint',
    'puppetlabs_spec_helper',
  ]
){
  #include '::rvm'

  class { '::rvm': }

  rvm_system_ruby { $ruby_version:
    ensure      => present,
    default_use => true,
  }

  rvm_gem { $rvm_gems:
    ensure       => latest,
    ruby_version => $ruby_version,
    require      => Rvm_system_ruby[$ruby_version],
  }

  class{ 'rvm::rvmrc':
    max_time_flag => 20,
    before  => Class['rvm'],
  }
  rvm_alias {
    'myproject':
      target_ruby => $ruby_version,
      ensure      => present,
      require     => Rvm_gemset["${ruby_version}@myproject"];
  }

}
