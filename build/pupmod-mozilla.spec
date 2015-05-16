Summary: Mozilla Puppet Module
Name: pupmod-mozilla
Version: 4.1.0
Release: 1
License: Apache License, Version 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: puppet >= 3.3.0
Buildarch: noarch
Requires: simp-bootstrap >= 4.2.0
Obsoletes: pupmod-mozilla-test

Prefix:"/etc/puppet/environments/simp/modules"

%description
This Puppet module provides Mozilla product installation and configuration.
Currently supported
 - Firefox

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/mozilla

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/mozilla
done

mkdir -p %{buildroot}/usr/share/simp/tests/modules/mozilla

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/mozilla

%files
%defattr(0640,root,puppet,0750)
/etc/puppet/environments/simp/modules/mozilla

%post
#!/bin/sh

if [ -d /etc/puppet/environments/simp/modules/mozilla/plugins ]; then
  /bin/mv /etc/puppet/environments/simp/modules/mozilla/plugins /etc/puppet/environments/simp/modules/mozilla/plugins.bak
fi

%postun
# Post uninstall stuff

%changelog
* Fri Jan 16 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 4.1.0-1
- Changed puppet-server requirement to puppet

* Sun Mar 02 2014 Kendall Moore <kmoore@keywcorp.com> - 4.1.0-0
- Refactored manifests for hiera and puppet 3 compatibility.
- Added rspec tests for test coverage.

* Fri Nov 30 2012 Maintenance
2.0.0-4
- Created a Cucumber test to ensure that firefox installs correctly
  and is at the latest version when including mozzila in the puppet
  server manifest.

* Wed Apr 11 2012 Maintenance
2.0.0-3
- Moved mit-tests to /usr/share/simp...
- Updated pp files to better meet Puppet's recommended style guide.

* Fri Mar 02 2012 Maintenance
2.0.0-2
- Improved test stubs.

* Mon Dec 26 2011 Maintenance
2.0.0-1
- Updated the spec file to not require a separate file list.

* Tue Jan 11 2011 Maintenance
2.0.0-0
- Refactored for SIMP-2.0.0-alpha release

* Tue Oct 26 2010 Maintenance - 1-1
- Converting all spec files to check for directories prior to copy.

* Fri May 21 2010 Maintenance
1.0-0
- Code refactor and Doc update.

* Tue Apr 27 2010 Maintenance
0.1-1
- Modified to install the correct architecture package to ensure that proper
  yum dependencies are followed.

* Thu Oct 1 2009 Maintenance
0.1-0
- Initial Release
- Just installs firefox for now, nothing fancy.
