require 'spec_helper'

describe 'puppet::master', :type => :class do
  context 'On a Ubuntu 12.04 system' do
    let(:params) {
      { :type => 'self' }
    }
    let(:node) { 'master.copperfroghosting.net' }
    let :facts do
      { :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :ipaddress => '192.168.1.111',
        :environment => 'production',
        :domain => 'copperfroghosting.net'
      }
    end
  
    it { should include_class('puppet::params') }
    it { should include_class('puppet') }
    it { should include_class('puppet::install') }
    it { should include_class('puppet::configure') }
    it { should include_class('puppet::service') }

    it { should contain_package('puppetmaster') }

    it { should contain_file('/etc/puppet').with(
      'ensure'  => 'directory',
      'owner'   => 'puppet',
      'group'   => 'root',
      'require' => 'Class[Puppet::Install]'
      )
    }
    it { should contain_file('/etc/puppet/puppet.conf').with(
      'ensure'  => 'file',
      'require' => 'File[/etc/puppet]'
      )
    }
    it 'should have a file puppet.conf with the correct contents' do
      verify_template(subject, '/etc/puppet/puppet.conf', [
        'vardir = /var/lib/puppet',
        'logdir = /var/log/puppet',
        'rundir = /var/run/puppet',
        'ssldir = /etc/puppet/ssl',
        'modulepath = /etc/puppet/modules',
        'user = puppet',
        'group = puppet',
        'archive_file_server = master.copperfroghosting.net',
        'certname = master.copperfroghosting.net',
        'server = master.copperfroghosting.net',
        '\[master\]',
        'certname = master.copperfroghosting.net',
        'dns_alt_names = puppet,puppet.copperfroghosting.net,master,master.copperfroghosting.net',
        '\[testing\]\n\s*modulepath = /etc/puppet/environments/testing/modules:/etc/puppet/modules\n\s*manifest = /etc/puppet/environments/testing/manifests/site.pp',
        '\[development\]\n\s*modulepath = /etc/puppet/environments/development/modules:/etc/puppet/modules\n\s*manifest = /etc/puppet/environments/development/manifests/site.pp',
      ])
    end  
    it { should contain_file('/etc/puppet/auth.conf').with(
      'ensure'  => 'file',
      'require' => 'File[/etc/puppet]'
      )
    }
    it 'should have a file auth.conf with the correct contents' do
      verify_template(subject, '/etc/puppet/puppet.conf', [
        '# This file is controlled by puppet. Do NOT edit! #',
      ])
    end  
    it { should contain_file('/etc/default/puppet').with(
      'ensure'  => 'file',
      'require' => 'Class[Puppet::Install]'
      )
    }
    it { should contain_augeas('/etc/default/puppet').with(
      'context' => '/files/etc/default/puppet',
      'lens'    => 'Shellvars.lns',
      'incl'    => '/etc/default/puppet',
      'require' => 'File[/etc/default/puppet]'
      )
    }
    # Needs fix in https://github.com/domcleal/rspec-puppet-augeas/issues/1 first
    # Commenting test out until fixed.
    #describe_augeas '/etc/default/puppet', :lens => 'Shellvars.lns', :target => '/etc/default/puppet' do
    #  it 'should change the contents of /etc/default/puppet' do
    #    should execute.with_change
    #    aug_get('START').should == 'yes'
    #    should execute.idempotently
    #  end
    #end
    it { should contain_file('/etc/puppet/fileserver.conf').with(
      'ensure'  => 'file',
      'require' => 'File[/etc/puppet]',
      'notify'  => 'Service[puppetmaster]'
      )
    }
    it 'should have a file fileserver.conf with the correct contents' do
      verify_template(subject, '/etc/puppet/fileserver.conf', [
        '# This file is controlled by puppet. Do NOT edit! #',
      ])
    end  
    it { should contain_file('/var/lib/puppet/reports').with(
      'ensure'  => 'directory',
      'owner'   => 'puppet',
      'group'   => 'puppet',
      'recurse' => true
      )
    }
    it { should contain_file('/etc/puppet/ssl').with(
      'ensure'  => 'directory',
      'owner'   => 'puppet',
      'group'   => 'root',
      'mode'    => '0771'
      )
    }
    it { should contain_file('/etc/puppet/manifests').with(
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'recurse' => true,
      'require' => 'File[/etc/puppet]'
      )
    }
    it { should contain_file('/etc/puppet/modules').with(
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'recurse' => true,
      'require' => 'File[/etc/puppet]'
      )
    }
    it { should contain_file('/etc/puppet/manifests/site.pp').with(
      'ensure'  => 'file',
      'require' => 'File[/etc/puppet/manifests]'
      )
    }
    it 'should have a file site.pp with the correct contents' do
      verify_template(subject, '/etc/puppet/manifests/site.pp', [
        'server => \'master.copperfroghosting.net\',',
        'node /master.copperfroghosting.net/ \{'
      ])
    end  
    it { should contain_file('/etc/puppet/environments').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/puppet]'
      )
    }
    it { should contain_file('/etc/puppet/environments/testing').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/puppet]'
      )
    }
    it { should contain_file('/etc/puppet/environments/testing/modules').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/puppet]'
      )
    }
    it { should contain_file('/etc/puppet/environments/testing/manifests').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/puppet]'
      )
    }
    it { should contain_file('/etc/puppet/environments/development').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/puppet]'
      )
    }
    it { should contain_file('/etc/puppet/environments/development/modules').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/puppet]'
      )
    }
    it { should contain_file('/etc/puppet/environments/development/manifests').with(
      'ensure'  => 'directory',
      'require' => 'File[/etc/puppet]'
      )
    }
      
    it { should contain_service('puppetmaster').with(
      'ensure'     => 'running',
      'enable'     => 'true',
      'require'    => 'Class[Puppet::Master::Install]'
      )
    }
  end
end