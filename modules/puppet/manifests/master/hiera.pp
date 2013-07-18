# == Class: puppet::master::hiera
#
# This is the Puppet Master class for the hiera configuration.
#
# === Examples
#
#  class { puppet::master::hiera : }
#
# === Authors
#
# Bernd Weber <mailto:bernd@nvisionary.com>
#
class puppet::master::hiera inherits puppet::params {
  class { 'puppet::master::hiera::install' :
    require => Class [ 'puppet::master' ],
  }
  class { 'puppet::master::hiera::configure' :
    require => Class [ 'puppet::master::hiera::install' ],
  }
}

# == Class: puppet::master::hiera::install
#
# This installs the hiera requirements.
#
# === Examples
#
#  class { puppet::master::hiera::install : }
#
class puppet::master::hiera::install {
  package { 'hiera-gpg' :
    ensure   => present,
    provider => 'gem',
  }
}

# == Class: puppet::master::hiera::configure
#
# This configures hiera for puppet masters.
#
# === Examples
#
#  class { puppet::master::hiera::configure : }
#
class puppet::master::hiera::configure {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }
  file { $puppet::params::hieraconf :
    ensure  => file,
    content => template( 'puppet/hiera.yaml.erb' ),
    require => File [ $puppet::params::confdir ],
  }
  file { $puppet::params::hierapath :
    ensure => directory,
    require => File [ $puppet::params::hieraconf ],
  }
  file { "${puppet::params::hierapath}/common.yaml" :
    ensure  => file,
    source  => "puppet:///modules/puppet/${puppet::params::hieradir}/common.yaml",
    require => File [ $puppet::params::hierapath ],
  }
  file { "${puppet::params::hierapath}/passwords.yaml" :
    ensure  => file,
    content => '---',
    replace => false,
    require => File [ $puppet::params::hierapath ],
  }
  file { "${puppet::params::hierapath}/${puppet::params::gpgdir}" :
    ensure  => directory,
    require => File [ $puppet::params::hierapath ],
  }
  file { $puppet::params::gpgpath :
    ensure  => directory,
    mode    => '0700',
    require => File [ $puppet::params::confdir ],
  }
}
