%define mc0d_home /opt/mc0d
%define mc0d_user mc0d
%define mc0d_group mc0d

Name:           mc0d
Version:        0.0.3
Release:        1%{?dist}
Summary:        0mq Mcollective broker
License:        Apache License 2.0
Group: 		System Environment/Daemons
URL:            https://github.com/puppetlabs/mc0d 
Source0:        https://github.com/stepanstipl/mc0d/archive/%{version}.tar.gz#/mc0d-%{version}.tar.gz
Source1:        mc0d.service
Source2:        mc0d.sysconfig
Source3:        mc0d.logger.config
Requires(pre): 	shadow-utils
Requires: 	systemd

BuildRoot:      %{_tmppath}/%{name}-%{version}-build

BuildRequires:  boost-devel >= 1.48
BuildRequires:  log4cxx-devel
BuildRequires:  zeromq-devel >= 4.0
BuildRequires:  cmake >= 2.8.12

%description
mc0d is lightweight 0mq broker for MCollective.

%prep
%setup -q

%build
cmake ./
make

%install
%{__rm} -rf %{buildroot}
%{__mkdir} -p %{buildroot}%{mc0d_home}/bin
%{__install} -m 755 bin/mc0d %{buildroot}%{mc0d_home}/bin/mc0d

%{__mkdir} -p %{buildroot}%{_unitdir}
%{__install} -m 644 %{SOURCE1} %{buildroot}%{_unitdir}/mc0d.service

%{__mkdir} -p %{buildroot}%{_sysconfdir}/sysconfig
%{__install} -m 644 -p %{SOURCE2} %{buildroot}/%{_sysconfdir}/sysconfig/mc0d

%{__mkdir} -p %{buildroot}%{_sysconfdir}/mc0d
%{__install} -m 644 -p %{SOURCE3} %{buildroot}%{_sysconfdir}/mc0d/logger.config

%{__mkdir} -p %{buildroot}%{_localstatedir}/log/mc0d

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root,-)
%dir %{_sysconfdir}/mc0d
%{mc0d_home}/bin/mc0d

%config(noreplace) %{_sysconfdir}/mc0d/logger.config
%config(noreplace) %{_sysconfdir}/sysconfig/mc0d
%{_unitdir}/mc0d.service

%attr(-, %{mc0d_user}, %{mc0d_group}) %{_localstatedir}/log/mc0d

%post
getent group %{mc0d_group} >/dev/null || groupadd -r %{mc0d_group}
getent passwd %{mc0d_user} >/dev/null || useradd -r -g %{mc0d_group} -s /sbin/nologin -d %{mc0d_home} -c "mc0d user"  %{mc0d_user}

KEY=$(curve_keygen)
[ -f /etc/mc0d/public.key ] || echo "${KEY}" | grep PUBLIC -a1 | tail -n1 > /etc/mc0d/public.key
[ -f /etc/mc0d/private.key ] || echo "${KEY}" | grep SECRET -a1 | tail -n1 > /etc/mc0d/private.key

/usr/bin/systemctl preset mc0d.service >/dev/null 2>&1 ||:

%preun
/usr/bin/systemctl --no-reload disable mc0d.service >/dev/null 2>&1 ||:
/usr/bin/systemctl stop mc0d.service >/dev/null 2>&1 ||:

%postun
/usr/bin/systemctl daemon-reload >/dev/null 2>&1 ||:

%changelog
* Thu Jun  4 2015 Stepan Stipl <stepan@stipl.net> - 0.0.2-1
- Initial release 
