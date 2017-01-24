Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.hostname = 'xenial64'
  config.vm.provider 'virtualbox' do |v|
    v.name = 'xenial64_legacy_network_names'
  end

  config.push.define 'atlas' do |push|
    push.app = 'leifcr/xenial64_legacy_network_names'
  end

  config.vm.provision 'file', source: './setup.sh', destination: '/tmp/setup.sh'
  config.vm.provision 'file', source: './cleanup.sh', destination: '/tmp/cleanup.sh'
  config.vm.provision 'shell', inline: 'echo "Setting up grub"; /bin/bash /tmp/setup.sh; rm -rf /tmp/setup.sh;'
end
