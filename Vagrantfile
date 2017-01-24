Vagrant.configure('2') do |config|
  # Using chef's bento image
  config.vm.box = 'bento/ubuntu-16.04'
  # Ubuntu/xenial64 image does not use vagrant/vagrant as user
  # See https://bugs.launchpad.net/cloud-images/+bug/1569237
  # config.vm.box = 'ubuntu/xenial64'
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
