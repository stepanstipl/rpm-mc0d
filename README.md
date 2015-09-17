[![wercker status](https://app.wercker.com/status/69ac6e7720dc29fb400f1cac13f4e523/s/master "wercker status")](https://app.wercker.com/project/bykey/69ac6e7720dc29fb400f1cac13f4e523)
# rpm-mc0d
RPM packages for mc0d - https://github.com/puppetlabs/mc0d, MCollective 0mq broker. 

*Currently building from my fork https://github.com/stepanstipl/mc0d which has some fixes for CentOS and 0mq 4.1*

Interesting files
-----------------
- **mc0d.spec** - Spec file for mc0d
- **zeromq.spec** - Spec file for 0mq library, needed to build with curve encryption/libsodium support, updated one published by Saltstack team.

Usage
-----
Pretty much clone this repo and run `vagrant up` and grab zeromq and mc0d RPMs from `output` folder. Provisioning step of Vagrant build will take care of building the specs. Use any CentOS 7 machine in Vagrantfile.

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
