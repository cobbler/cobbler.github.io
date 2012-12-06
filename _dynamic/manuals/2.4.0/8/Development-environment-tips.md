---
layout: manpage
title: Cobbler Manual
meta: 2.4.0
---
Check out cobbler from git, all work should be done against the master branch, unless we decide to cherry-pick bugfixes back to previous releases to do releases for critical bugs.

### Setup

If using CentOS, install the appropriate EPEL rpm.  

    Ex: http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm

Install dependencies:

    yum install python-netaddr python-cheetah PyYAML mod_wsgi python-simplejson

Initially, to run cobbler without using the RPM:

    make install

For each successive run, do not run make install again.  To avoid blowing away your configuration, run: 

    make webtest

This will install cobbler and restart apache/cobblerd, but move your configuration files and settings aside and restore them, rather than blindly overwriting them.

You can now run cobbler commands and access the web interface at /cobbler.

It should go without saying, but do not develop for cobbler on your main deployment server.  Develop on a production box.

### Testing Your Development Environment Is Ready

   sudo service cobblerd restart
   sudo service httpd restart
   cobbler list

If you encounter a message about apache not running or proxying cobblerd, it could be an SELinux problem.  You probably want to just enable the httpd_can_network_connect boolean, but here's a quick test of that:

   setenforce 0
   cobbler test

You should now be good to go.

### Debugging

If you need to debug a remote process, epdb provides some very nice capabilities beyond the standard python debugger, just insert a "import epdb; epdb.serve()" in your command line, and from the console:

    python -c "import epdb; epdb.connect"
