# rpm-mc0d
Rpm packages for mc0d

Usage
-----
Pretty much clone this repo and run `vagrant up`. Provisioning step of Vagrant
build will take care of building the specs. Use any CentOS 7 machine in
Vagrantfile.

Issues and contibuting
----------------------
Please use GitHub issues both for problems reporting and merge requests. Any
feedback and contributions are welcome.

Todo
----
- improve init script and spec to work with RedHat/CentOS 6
- add some tests
  - built package installs without errors
  - mc0d starts
- update Vagrantfile with some public machine or publish my packer/Vagrant boxes
