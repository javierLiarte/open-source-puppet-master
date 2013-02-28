# == Class: puppet::params
#
# This is the Puppet parameters class. It holds all relevant modifiable parameters/
# variables for the puppet classes.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  class { puppet::params : }
#
# === Authors
#
# Bernd Weber <bernd@copperfroghosting.com>
#
# === Copyright
#
# Copyright 2013 Copper Frog LLC.
#

class puppet::params {
  $confdir          = "/etc/puppet"
  $vardir           = "/var/lib/puppet"
  $rundir           = "/var/run/puppet"
  $logdir           = "/var/log/puppet"
  $ssldir           = "${confdir}/ssl"
  $reportsdir       = "${vardir}/reports"
  $rackdir          = "/usr/share/puppet/rack"
  $environmentspath = {
    "base"        => "${confdir}/environments",
    "testing"     => "${confdir}/environments/testing",
    "development" => "${confdir}/environments/development",
  }
  $modulepath       = {
    "production"  => "${confdir}/modules",
    "testing"     => "${$environmentspath["testing"]}/modules",
    "development" => "${$environmentspath["development"]}/modules",
  }
  $manifestpath     = {
    "production"  => "${confdir}/manifests",
    "testing"     => "${$environmentspath["testing"]}/manifests",
    "development" => "${$environmentspath["development"]}/manifests",
  }
  $user             = 'puppet'
  $group            = 'puppet'
  $puppetconf       = "${confdir}/puppet.conf"
  $masterport       = '8140'
  $puppet_modules   = {
    "self"   => [ 'ruby' ],
    "apache" => [ 'apache', 'mysql', 'ruby' ],
  }
  $puppetmasterservice = {
    'self' => 'puppetmaster',
  }

  case $::operatingsystem {
    'Ubuntu' : {
      $puppet_packages    = [ "puppet" ]
      $master_packages    = {
        "self"   => "puppetmaster",
        "apache" => "puppetmaster-passenger",
      }
      $dashboard_packages = [ "puppet-dashboard" ]

      $puppet_default   = "/etc/default/puppet"
      $puppet_service   = "puppet"
    }
    default : {
      fail ( "Your Operating system $::operatingsystem is currently not supported by this class!")
    }
  }
}
