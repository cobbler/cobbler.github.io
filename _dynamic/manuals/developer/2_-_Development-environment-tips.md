---
layout: manpage
title: Development Environment
meta: 2.8.0
---

### Setup

The preferred development platform is CentOS 7. You also need EPEL, install the appropriate EPEL rpm.

    rpm -i https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

Install dependencies:

    yum install python-netaddr mod_wsgi python-simplejson pyflakes python-pep8 python-sphinx rpm-build pykickstart

Checkout code:

    git clone https://github.com/cobbler/cobbler.git

Initially, to run cobbler without using the RPM:

    cd cobbler
    make install

For each successive run, do not run make install again.  To avoid blowing away your configuration, run: 

    make webtest

This will install cobbler and restart apache/cobblerd, but move your configuration files and settings aside and restore them, rather than blindly overwriting them.

You can now run cobbler commands and access the web interface at /cobbler.

It should go without saying, but do not develop for cobbler on your main deployment server.  Develop on a dedicated VM.

### Get the source

    git clone https://github.com/cobbler/cobbler.git

### Decide which branch to work on

All work on new features should be done against the master branch. If you want to address bugs then please target the latest release branch, the maintainers will then cherry-pick those changes back into the master branch.

    git branch -r
    git checkout <branch>

### Testing Your Development Environment Is Ready

    sudo service cobblerd restart
    sudo service httpd restart
    cobbler list

If you encounter a message about apache not running or proxying cobblerd, it could be an SELinux problem.  You probably want to just enable the httpd_can_network_connect boolean, but here's a quick test of that:

    setenforce 0
    cobbler test

You should now be good to go.

### Quality Assurance

After making changes to your local git repo; please check for style errors before sending a pull request.

    make qa

### Debugging

If you need to debug a remote process, epdb provides some very nice capabilities beyond the standard python debugger, just insert a "import epdb; epdb.serve()" in your command line, and from the console:

    python -c "import epdb; epdb.connect"
