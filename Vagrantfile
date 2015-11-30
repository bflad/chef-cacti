# Base hostname
cookbook = 'cacti'

Vagrant.configure('2') do |config|
  config.berkshelf.enabled = true
  config.cache.auto_detect = true
  config.omnibus.chef_version = :latest

  config.vm.define :centos5 do |centos5|
    centos5.vm.box      = 'bento/centos-5.11'
    centos5.vm.hostname = "#{cookbook}-centos-5"
  end

  config.vm.define :centos6 do |centos6|
    centos6.vm.box      = 'bento/centos-6.7'
    centos6.vm.hostname = "#{cookbook}-centos-6"
  end

  config.vm.define :centos7 do |centos7|
    centos7.vm.box      = 'bento/centos-7.1'
    centos7.vm.hostname = "#{cookbook}-centos-7"
  end

  config.vm.define :debian7 do |debian7|
    debian7.vm.box      = 'bento/debian-7.9'
    debian7.vm.hostname = "#{cookbook}-debian-7"
  end

  config.vm.define :debian8 do |debian8|
    debian8.vm.box      = 'bento/debian-8.2'
    debian8.vm.hostname = "#{cookbook}-debian-8"
  end

  config.vm.define :fedora21 do |fedora21|
    fedora21.vm.box      = 'bento/fedora-21'
    fedora21.vm.hostname = "#{cookbook}-fedora-21"
  end

  config.vm.define :fedora22 do |fedora22|
    fedora22.vm.box      = 'bento/fedora-22'
    fedora22.vm.hostname = "#{cookbook}-fedora-22"
  end

  config.vm.define :freebsd9 do |freebsd9|
    freebsd9.vm.box      = 'bento/freebsd-9.3'
    freebsd9.vm.hostname = "#{cookbook}-freebsd-9"
  end

  config.vm.define :freebsd10 do |freebsd10|
    freebsd10.vm.box      = 'bento/freebsd-10.2'
    freebsd10.vm.hostname = "#{cookbook}-freebsd-10"
  end

  config.vm.define :opensuse13 do |opensuse13|
    opensuse13.vm.box      = 'bento/opensuse-13.2'
    opensuse13.vm.hostname = "#{cookbook}-opensuse-13"
  end

  config.vm.define :pld64 do |pld64|
    pld64.cache.auto_detect = false
    pld64.omnibus.chef_version = nil
    pld64.vm.box      = 'pld64'
    pld64.vm.box_url  = 'ftp://ftp.pld-linux.org/people/glen/vm/pld64.box'
    pld64.vm.hostname = "#{cookbook}-pld64"
  end

  config.vm.define :ubuntu1204 do |ubuntu1204|
    ubuntu1204.vm.box      = 'bento/ubuntu-12.04'
    ubuntu1204.vm.hostname = "#{cookbook}-ubuntu-1204"
  end

  config.vm.define :ubuntu1404 do |ubuntu1404|
    ubuntu1404.vm.box      = 'bento/ubuntu-14.04'
    ubuntu1404.vm.hostname = "#{cookbook}-ubuntu-1404"
  end

  config.vm.define :ubuntu1504 do |ubuntu1504|
    ubuntu1504.vm.box      = 'bento/ubuntu-15.04'
    ubuntu1504.vm.hostname = "#{cookbook}-ubuntu-1504"
  end

  config.vm.network :private_network, ip: '192.168.50.10'

  config.vm.provider 'virtualbox' do |v|
    v.customize ['modifyvm', :id, '--memory', 1024]
  end

  # Manually bootstrap Chef on platforms not supported by Omnibus, such as pld
  config.vm.provision 'shell', path: 'chef-manual-bootstrap.sh'

  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.json = {
      'mysql' => {
        'server_root_password' => 'iloverandompasswordsbutthiswilldo',
        'server_repl_password' => 'iloverandompasswordsbutthiswilldo',
        'server_debian_password' => 'iloverandompasswordsbutthiswilldo'
      }
    }
    chef.run_list = [
      "recipe[#{cookbook}]"
    ]
  end
end
