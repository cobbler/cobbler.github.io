---
layout: manpage
title: SELinux With Cobbler
meta: 2.2.3
---
Providing working policies for SElinux (and AppArmor) is the responsibility of downstream (e.g. your Linux or repo vendor). Unfortunately, every now and then issues tend to pop up on the mailing lists or in the issue tracker. Since we're really not in the position to resolve SElinux issues, all reported bugs will be closed. All we can do is try to document these issues here, hopefully the community is able to provide some feedback/workarounds/fixes.

### Fedora 16 / RHEL6 / CentOS6 - Python MemoryError

Obscure error message for which a solution is unknown. The workaround is to disable SElinux.

     Starting cobbler daemon: Traceback (most recent call last):
     File "/usr/bin/cobblerd", line 76, in main
     api = cobbler_api.BootAPI(is_cobblerd=True)
     File "/usr/lib/python2.6/site-packages/cobbler/api.py", line 127, in init
     module_loader.load_modules()
     File "/usr/lib/python2.6/site-packages/cobbler/module_loader.py", line 62, in load_modules
     blip = import("modules.%s" % ( modname), globals(), locals(), [modname])
     File "/usr/lib/python2.6/site-packages/cobbler/modules/authn_pam.py", line 53, in
     from ctypes import CDLL, POINTER, Structure, CFUNCTYPE, cast, pointer, sizeof
     File "/usr/lib64/python2.6/ctypes/init.py", line 546, in
     CFUNCTYPE(c_int)(lambda: None)
     MemoryError

### Fedora 14

While many users with SELinux distributions opt to turn SELinux off, you may wish to keep it on.  For Fedora 14 you might want to amend the selinux policy settings:

       /usr/sbin/semanage fcontext -a -t public_content_rw_t "/var/lib/tftpboot/.*"
       /usr/sbin/semanage fcontext -a -t public_content_rw_t "/var/www/cobbler/images/.*"
       restorecon -R -v "/var/lib/tftpboot/"
       restorecon -R -v "/var/www/cobbler/images.*"
       # Enables cobbler to read/write public_content_rw_t
       setsebool cobbler_anon_write on
       # Enable httpd to connect to cobblerd (optional, depending on if web interface is installed)
       # Notice: If you enable httpd_can_network_connect_cobbler and you should switch httpd_can_network_connect off
       setsebool httpd_can_network_connect off
       setsebool httpd_can_network_connect_cobbler on
       #Enabled cobbler to use rsync etc.. (optional)
       setsebool cobbler_can_network_connect on
       #Enable cobbler to use CIFS based filesystems (optional)
       setsebool cobbler_use_cifs on
       # Enable cobbler to use NFS based filesystems (optional)
       setsebool cobbler_use_nfs on
       # Double check your choices
       getsebool -a|grep cobbler

For older distributions, the information suggested by "Cobbler check" should be sufficient.   This is just a few fcontext commands and setting httpd_can_network_connect.

### ProtocolError: &lt;ProtocolError for x.x.x.x:80/cobbler_api: 503 Service Temporarily Unavailable&gt;

If you see this when you run "cobbler check" or any other cobbler command, it means SELinux is blocking httpd from talking with cobblerd. The command to fix this is:

`setsebool -P httpd_can_network_connect true`
