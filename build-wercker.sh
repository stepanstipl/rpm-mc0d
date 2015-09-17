#!/bin/bash

# General build tools and environment
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm -ivh epel-release-7-5.noarch.rpm
yum install -y rpm-build gcc-c++ git rpmdevtools yum-utils
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}Kdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

# Install cmake EXTRA - WE NEED AT LEAST 2.8.12
wget http://archives.fedoraproject.org/pub/archive/fedora/linux/releases/20/Everything/x86_64/os/Packages/c/cmake-2.8.12.1-1.fc20.x86_64.rpm
yum install -y cmake-2.8.12.1-1.fc20.x86_64.rpm

# Simplified build process ZeroMQ with libsodium / curve enabled
yum-builddep -y zeromq.spec
# yum-builddep doesn't catch this
yum install -y libsodium-devel
spectool -g -R zeromq.spec
rpmbuild -ba --with libsodium zeromq.spec

# We copy all output artefacts here
rm -rf output
mkdir output
cp ~/rpmbuild/RPMS/x86_64/{zeromq-*.rpm,zeromq-devel-*.rpm} ./output/
yum install -y ./output/zeromq*.rpm

# And finally build mc0d rpm
yum-builddep -y mc0d.spec
spectool -g -R mc0d.spec
cp -n mc0d.{service,sysconfig,logger.config} ~/rpmbuild/SOURCES/

rpmbuild -ba mc0d.spec
cp -n ~/rpmbuild/RPMS/x86_64/mc0d-*.rpm ./output/
