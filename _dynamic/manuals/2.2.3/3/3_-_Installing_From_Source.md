---
layout: manpage
title: Download Instructions
meta: 2.2.3
---
# {{ page.title }}

Cobbler is licensed under the General Public License (GPL), version
2 or later. You can download it, free of charge, using the links
below.

## Latest Source

The latest source code (it's all Python) is available through [git](https://github.com/cobbler/cobbler).

Potential contributors should read
[here](Patch Process).

## Source RPMs

Source RPMs can be obtained from your distribution mirror.

However, you can also download the source and "make install" or build a package from it, or build
SRPMs from there.

This project aims for regular releases but is focused on upstream development.

## Installing

Install instructions vary slightly by distribution:

### Installing from RPM For Fedora Users

        yum install cobbler # on the boot server
        yum install cobbler-web # on the boot server (optional)
        yum install koan # on target systems (optional)

### Installing For RHEL and CentOS Users

The latest stable releases of Cobbler and Koan are included in
Extras Packages For Enterprise Linux and can be installed with yum,
this is recommended for most users.

Since EPEL's main repository currently updates only monthly,
there's the possibility of enabling "EPEL testing" for those users
wanting more frequent updates.

Additionally, to EL4 users to take advantage of all features of
Cobbler, they will want to upgrade yum and yum-utils to newer
versions, as tools like yumdownloader and reposync are needed by
commands such as "cobbler import" and "cobbler reposync". RHEL4
will not have these packages installed by default, though it is
recommended that you install it.

The links to EPEL are included below, you should configure your
server in /etc/yum.repos.d to attach to the "stable" and/or
"testing" repos in EPEL to ensure you can get updates.

CentOS users will also want to ensure redhat-rpm-config is
installed.

A description of how to enable EPEL on your machine is available
here:

[http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F]
(http://fedoraproject.org/wiki/EPEL\#How\_can\_I\_use\_these\_extra\_packages.3F)

Following the list of available repos:

For EL 6 i386:

-   [http://download.fedoraproject.org/pub/epel/6/i386](http://download.fedoraproject.org/pub/epel/6/i386)
-   [http://download.fedoraproject.org/pub/epel/testing/6/i386](http://download.fedoraproject.org/pub/epel/testing/6/i386)

For EL 6 x86\_64

-   [http://download.fedoraproject.org/pub/epel/6/x86_64](http://download.fedoraproject.org/pub/epel/6/x86\_64)
-   [http://download.fedoraproject.org/pub/epel/testing/6/x86_64](http://download.fedoraproject.org/pub/epel/testing/6/x86\_64)

For EL 5 i386:

-   [http://download.fedoraproject.org/pub/epel/5/i386](http://download.fedoraproject.org/pub/epel/5/i386)
-   [http://download.fedoraproject.org/pub/epel/testing/5/i386](http://download.fedoraproject.org/pub/epel/testing/5/i386)

For EL 5 x86\_64:

-   [http://download.fedoraproject.org/pub/epel/5/x86_64](http://download.fedoraproject.org/pub/epel/5/x86\_64)
-   [http://download.fedoraproject.org/pub/epel/testing/5/x86_64](http://download.fedoraproject.org/pub/epel/testing/5/x86\_64)

For EL 4 i386:

-   [http://download.fedoraproject.org/pub/epel/4/i386](http://download.fedoraproject.org/pub/epel/4/i386)
-   [http://download.fedoraproject.org/pub/epel/testing/4/i386](http://download.fedoraproject.org/pub/epel/testing/4/i386)

For EL 4 x86\_64:

-   [http://download.fedoraproject.org/pub/epel/4/x86_64](http://download.fedoraproject.org/pub/epel/4/x86\_64)
-   [http://download.fedoraproject.org/pub/epel/testing/4/x86_64](http://download.fedoraproject.org/pub/epel/testing/4/x86\_64)

### Installing for SuSE Users

The latest stable releases of Cobbler and Koan are included in the
Systems Management repository for SuSE (OpenSuSE / SLES) and can be
installed with zypper.

For current SuSE releases (i586 + x86\_64):

-   [http://download.opensuse.org/repositories/systemsmanagement/](http://download.opensuse.org/repositories/systemsmanagement/)

## Building From Source

### Source RPM Build Instructions for Fedora

-   Install python-setuptools and python-devel from yum
-   rpmbuild --rebuild cobbler\*.src.rpm
-   install the RPM, which is now built in
    /usr/src/redhat/RPMS/noarch
-   satisfy any dependencies you have by using yum and the stock
    Fedora repos

### Source RPM Build Instructions for RHEL4

-   For starters, grab python-setuptools, python-cheetah, and yum
    from EPEL and install them. These are found in the main EPEL repo,
    not EPEL testing -- here's the link: i386 and x86\_64.
-   now rpmbuild --rebuild cobbler\*.src.rpm
-   install the RPM, which is now built in
    /usr/src/redhat/RPMS/noarch
-   satisfy any dependencies you have by using yum and the EPEL 4
    repos

### Source RPM Build Instructions for RHEL 4/5

-   Grab python-setuptools and python-cheetah from EPEL and install
    them. These are found in the main EPEL repo, not EPEL testing --
    here's the link: i386 and x86\_64.
-   now rpmbuild --rebuild cobbler\*.src.rpm
-   install the RPM, which is now built in
    /usr/src/redhat/RPMS/noarch
-   satisfy any dependencies you have by using yum and the EPEL 5
    repos

### Building a DEB package

-   Install pbuilder (aptitude install pbuilder). This tool can
    build our package in a chroot-environment, so any errors in the
    packaging- or setup-scripts can't destroy your system.
-   Create the chroot. For lenny, this would be: "pbuilder --create
    --distribution lenny".
-   Run pdebuild.
-   A package should end up in /var/cache/pbuilder/result/
