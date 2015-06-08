Vagrant.configure('2') do |config|
  config.vm.box = 'centos7-minimal'
  config.vm.hostname = "rpmbuild.vagrant"
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '1024']
  end
  config.vm.provision "shell", path: "build.sh"
end
