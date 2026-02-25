---
layout: post
title: Getting Cobbler to run on CentOS
author: Milford
summary: Getting a basic Cobbler server running on CentOS together with Chef.
---

> This is a repost of the content from the following blog article [^1]

I love [Cobbler](https://fedorahosted.org/cobbler).

Cobbler + Chef in my environment means that I can go from bare metal to an active cluster node in moments with little
effort.

It is a powerful system for managing kickstart profiles, pxeboot, power, dhcp, dns etc..

Below are some notes to help get you going with just the basic feature set. It is a system you can easy go nuts with to
automate a lot of your infrastructure.

Install it from [EPEL](http://fedoraproject.org/wiki/EPEL).

```
yum -y install cobbler cobbler-web xinetd tftp
```

Fix Authentication For The Web Interface.

```
sed -i 's/authn_denyall/authn_configfile/g' /etc/cobbler/modules.conf
```

Change the password for the ‘Cobbler’ administative user.

```
htdigest /etc/cobbler/users.digest "Cobbler" cobbler
```

Set the Server Name.

```
sed -i 's/server: 127.0.0.1/server: cobbler.example.com/g' /etc/cobbler/settings
```

Set kickstarted nodes to turn off pxeboot on sucessful install.

```
sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' /etc/cobbler/settings
```

Setup Anamon to log installs to `/var/log/cobbler/anamon/<hostname>` on the cobbler server.

```
sed -i 's/anamon_enabled: 0/anamon_enabled: 1/g' /etc/cobbler/settings
```

Although we’re not running dhcpd on this server but I find it answers well to fill this out regardless.

```
sed -i 's/next_server: 127.0.0.1/next_server: 192.168.1.1/g' /etc/cobbler/settings
```

Fire cobblerd up.

```
/etc/init.d/cobblerd start
```

Swap out the cobbler_web.conf with one that will attach to a cname.

```
mv /etc/httpd/conf.d/cobbler_web.{conf,dist}
```

```
cat <<EOF > /etc/httpd/conf.d/cobbler_web.conf
<VirtualHost *:80>
ServerName cobbler.example.com
ServerAlias cobbler
SetEnvIf Request_URI ".*/op/events/user/.*" dontlog
CustomLog logs/access_log combined env=!dontlog
<Location "/cobbler_web">
SetHandler python-program
PythonHandler django.core.handlers.modpython
SetEnv DJANGO_SETTINGS_MODULE settings
# PythonOption django.root /cobbler_web
PythonDebug On
PythonPath "['/usr/share/cobbler/web/'] + sys.path"
AuthBasicAuthoritative Off
AuthType basic
AuthName "Cobbler"
Require valid-user
PythonAuthenHandler cobbler_web.views
</Location>
</VirtualHost>
EOF
```

Restart httpd.

```
/etc/init.d/httpd restart
```

To get tftpd going edit `/etc/xinetd.d/tftp`

```
set disable = no
```

Restart xinetd.

```
/etc/init.d/xinetd restart
```

Houskeeping items to pass the cobbler check (I’m not running debian).

```
cobbler get-loaders
sed -i -e 's|@dists=.*|#@dists=|'  /etc/debmirror.conf
sed -i -e 's|@arches=.*|#@arches=|'  /etc/debmirror.conf
```

On your DHCP server make sure it is pointed at the cobbler server.

```
next-server IP.OF.COBBER.SERVER;
filename "/pxelinux.0";
```

Make it auto start.

```
chkconfig cobblerd on
chkconfig xinetd on
chkconfig httpd on
```

Sync the cobbler config.

```
cobbler sync
```

And we’re good to go, now you can get to the cobbler server at `http://cobbler.example.com/cobbler_web/`

![cobblermain](/images/blog/2012/cobblermain-1024x681.png)

From here we can work in the web interface as well as through the CLI.

Lets first setup a Distro.

I run cobbler on the same node as I host my local CentOS Mirror (see this article) so to setup a distro I just need to
tell Cobbler where to find the vmlinuz and initrd.img files.

```
cobbler distro add \
  --arch=x86_64  \
  --breed=redhat \
  --os-version=rhel6 \
  --name=CentOS6 \
  --initrd=/path/to/repo/CentOS/6/os/x86_64/isolinux/initrd.img \
  --kernel=/path/to/repo/CentOS/6/os/x86_64/isolinux/vmlinuz
```

And here is what it looks like in the web interface.

![distro](/images/blog/2012/distro-1024x681.png)

Now add your local repos that we built in the previous article.

```
cobbler repo add \
  --arch=x86_64 \
  --breed=yum \
  --keep-updated=N \
  --mirror=http://repo.example.com/CentOS/6/os/x86_64/ \
  --name=CentOS6-Base 

cobbler repo add \
  --arch=x86_64 \
  --breed=yum \
  --keep-updated=N \
  --mirror=http://repo.example.com/CentOS/6/updates/x86_64/ \
  --name=CentOS6-Updates 
```

Once again, the web interface.

![repo](/images/blog/2012/distro-1024x681.png)

Now lets start building our kickstart templates. First, lets make some snippets that will be compiled into the main
kickstart file.

Place the pre-run trigger snippet here: `/var/lib/cobbler/snippets/kickstart_start`

```
#set system_name = $getVar('system_name','')
#set profile_name = $getVar('profile_name','')
#set breed = $getVar('breed','')
#set srv = $getVar('http_server','')
#set run_install_triggers = $str($getVar('run_install_triggers',''))
#set runpre = ""
#if $system_name != ''
    ## RUN PRE TRIGGER
    #if $run_install_triggers in [ "1", "true", "yes", "y" ]
        #if $breed == 'redhat'
            #set runpre = "\nwget "http://%s/cblr/svc/op/trig/mode/pre/%s/%s" -O /dev/null" % (srv, "system", system_name)
        #else if $breed == 'vmware'
            #set runpre = "\nwget "http://%s/cblr/svc/op/trig/mode/pre/%s/%s" -O /dev/null" % (srv, "system", system_name)
        #end if
    #end if
#else if $profile_name != ''
    ## RUN PRE TRIGGER
    #if $run_install_triggers in [ "1", "true", "yes", "y" ]
        #if $breed == 'redhat'
            #set runpre = "\nwget "http://%s/cblr/svc/op/trig/mode/pre/%s/%s" -O /dev/null" % (srv, "profile", profile_name)
        #else if $breed == 'vmware'
            #set runpre = "\nwget "http://%s/cblr/svc/op/trig/mode/pre/%s/%s" -O /dev/null" % (srv, "profile", profile_name)
        #end if
    #end if
#end if
#echo $runpre
```

And the post triggers snippet here: `/var/lib/cobbler/snippets/kickstart_done`

```
#set system_name = $getVar('system_name','')
#set profile_name = $getVar('profile_name','')
#set breed = $getVar('breed','')
#set os_version = $getVar('os_version','')
#set srv = $getVar('http_server','')
#set kickstart = $getVar('kickstart','')
#set run_install_triggers = $str($getVar('run_install_triggers',''))
#set pxe_just_once = $str($getVar('pxe_just_once',''))
#set nopxe = ""
#set saveks = ""
#set runpost = ""
#if $system_name != ''
    ## PXE JUST ONCE
    #if $pxe_just_once in [ "1", "true", "yes", "y" ]
        #if $breed == 'redhat'
            #set nopxe = "\nwget "http://%s/cblr/svc/op/nopxe/system/%s" -O /dev/null" % (srv, system_name)
        #else if $breed == 'vmware' and $os_version == 'esx4'
            #set nopxe = "\ncurl "http://%s/cblr/svc/op/nopxe/system/%s" -o /dev/null" % (srv, system_name)
        #else if $breed == 'vmware' and $os_version == 'esxi4'
            #set nopxe = "\nwget "http://%s/cblr/svc/op/nopxe/system/%s" -O /dev/null" % (srv, system_name)
        #end if
    #end if
    ## SAVE KICKSTART
    #if $kickstart != ''
        #if $breed == 'redhat'
            #set saveks = "\nwget "http://%s/cblr/svc/op/ks/%s/%s" -O /root/cobbler.ks" % (srv, "system", system_name)
        #else if $breed == 'vmware' and $os_version == 'esx4'
            #set saveks = "\ncurl "http://%s/cblr/svc/op/ks/%s/%s" -o /root/cobbler.ks" % (srv, "system", system_name)
        #else if $breed == 'vmware' and $os_version == 'esxi4'
            #set saveks = "\nwget "http://%s/cblr/svc/op/ks/%s/%s" -O /var/log/cobbler.ks" % (srv, "system", system_name)
        #end if
    #end if
    ## RUN POST TRIGGER
    #if $run_install_triggers in [ "1", "true", "yes", "y" ]
        #if $breed == 'redhat'
            #set runpost = "\nwget "http://%s/cblr/svc/op/trig/mode/post/%s/%s" -O /dev/null" % (srv, "system", system_name)
        #else if $breed == 'vmware' and $os_version == 'esx4'
            #set runpost = "\ncurl "http://%s/cblr/svc/op/trig/mode/post/%s/%s" -o /dev/null" % (srv, "system", system_name)
        #else if $breed == 'vmware' and $os_version == 'esxi4'
            #set runpost = "\nwget "http://%s/cblr/svc/op/trig/mode/post/%s/%s" -O /dev/null" % (srv, "system", system_name)
        #end if
    #end if
#else if $profile_name != ''
    ## SAVE KICKSTART
    #if $kickstart != ''
        #if $breed == 'redhat'
            #set saveks = "\nwget "http://%s/cblr/svc/op/ks/%s/%s" -O /root/cobbler.ks" % (srv, "profile", profile_name)
        #else if $breed == 'vmware' and $os_version == 'esx4'
            #set saveks = "\ncurl "http://%s/cblr/svc/op/ks/%s/%s" -o /root/cobbler.ks" % (srv, "profile", profile_name)
        #else if $breed == 'vmware' and $os_version == 'esxi4'
            #set saveks = "\nwget "http://%s/cblr/svc/op/ks/%s/%s" -O /var/log/cobbler.ks" % (srv, "profile", profile_name)
        #end if
    #end if
    ## RUN POST TRIGGER
    #if $run_install_triggers in [ "1", "true", "yes", "y" ]
        #if $breed == 'redhat'
            #set runpost = "\nwget "http://%s/cblr/svc/op/trig/mode/post/%s/%s" -O /dev/null" % (srv, "profile", profile_name)
        #else if $breed == 'vmware' and $os_version == 'esx4'
            #set runpost = "\ncurl "http://%s/cblr/svc/op/trig/mode/post/%s/%s" -o /dev/null" % (srv, "profile", profile_name)
        #else if $breed == 'vmware' and $os_version == 'esxi4'
            #set runpost = "\nwget "http://%s/cblr/svc/op/trig/mode/post/%s/%s" -O /dev/null" % (srv, "profile", profile_name)
        #end if
    #end if
#end if
#echo $saveks
#echo $runpost
#echo $nopxe
```

I also use cobbler to bootstrap chef. Drop it at `/var/lib/cobbler/snippets/chef-bootstrap`

```
# Chef Needs the clock to be synced.
cat <<EOF_NTP >> /etc/ntp/step-tickers
0.centos.pool.ntp.org
1.centos.pool.ntp.org
2.centos.pool.ntp.org
EOF_NTP

chkconfig ntpd on
service ntpd start

# MyRepo has the Opscode Chef full-stack installer RPM.
cat <<EOF_REPO >> /etc/yum.repos.d/MyRepo.repo
[MyRepos]
name=MyRepo
baseurl=http://repo.example.com/MyRepo/el/6/x86_64/
enabled=1
keepcache=0
gpgcheck=0
EOF_REPO

yum -y install gcc chef-full
# Installs some Gems I need.
/opt/opscode/embedded/bin/gem install mongrel --pre
/opt/opscode/embedded/bin/gem install ruby-shadow
mkdir /etc/chef
cd /etc/chef
curl -O http://chef.example.com/validation.pem
curl -O http://chef.example.com/client.rb
# Run chef-client to register the node
chef-client
chkconfig --add chef-client
chkconfig chef-client on
service chef-client start

# Run chef-client again setting up the node in our Base Profile.
cat <<EOF > /var/tmp/role.json
{ "run_list": [ "role[Base]" ] }
EOF
chef-client -j /var/tmp/role.json
```

Disk setup here. In a system’s profile you can pass `disks=single` or `disks=mirror` to pick a disk layout. I have
different disk configs for MySQL servers, Hadoop nodes, web servers etc..

`/var/lib/cobbler/snippets/disk-setup`

```
clearpart --all --initlabel

#if $disks == 'mirror'
bootloader --location=mbr --driveorder=sda,sdb
part raid.01 --size=300 --asprimary --ondisk=sda
part raid.11 --size=300 --asprimary --ondisk=sdb
part raid.02 --size=1 --grow --asprimary --ondisk=sda
part raid.12 --size=1 --grow --asprimary --ondisk=sdb
raid /boot --fstype=ext3 --device md0 --level=RAID1 raid.01 raid.11
raid pv.01 --fstype ext3 --device md1 --level=RAID1 raid.02 raid.12  
volgroup centos pv.01
logvol /         --fstype ext3 --name=root     --vgname=centos --size=10240
logvol /var      --fstype ext3 --name=var      --vgname=centos --size=10240
logvol /home     --fstype ext3 --name=home     --vgname=centos --size=5120
logvol /opt      --fstype ext3 --name=opt      --vgname=centos --size=5120
logvol swap      --fstype swap --name=swap     --vgname=centos --size=4096

#else

#if $disks == 'single'
bootloader --location=mbr --driveorder=sda
part /boot --fstype ext3 --size=300 --asprimary --ondisk=sda
part pv.01   --size=150 --grow --ondisk=sda
volgroup centos pv.01
logvol /         --fstype ext3 --name=root     --vgname=centos --size=10240
logvol /var      --fstype ext3 --name=var      --vgname=centos --size=10240
logvol /home     --fstype ext3 --name=home     --vgname=centos --size=5120
logvol /opt      --fstype ext3 --name=opt      --vgname=centos --size=5120
logvol swap      --fstype swap --name=swap     --vgname=centos --size=4096

#end if
#end if
```

I also seperate packages, since eventually I’ll setup an if/else tree for different node types.

`/var/lib/cobbler/snippets/packages`

```
@editors
@core
@base
device-mapper-multipath
-sysreport
-sendmail
-logwatch
screen
ntp
net-snmp
net-snmp-utils
system-config-date
system-switch-mail
postfix
nfs-utils
sysstat
yum-priorities
```

And finally, drop your kickstart with integrated snippets (you can generate a rootpw crypt thus: `openssl passwd -1`).

`/var/lib/cobbler/kickstarts/myCentOS6.ks`

```
authconfig --enableshadow --enablemd5
rootpw --iscrypted $1$NDnhVSEW$YeKmfHm.Fi7rRKhjpO2bF1
text
skipx
keyboard us
lang en_US.UTF-8
timezone  America/New_York
firewall --disabled
selinux --disabled
url --url=$tree
$yum_repo_stanza
$SNIPPET('network_config')
firstboot --disable
reboot
$SNIPPET('disk-setup')
install
%pre
$SNIPPET('log_ks_pre')
$kickstart_start
$SNIPPET('pre_install_network_config')
$SNIPPET('pre_anamon')
%packages
$SNIPPET('packages')
%post
$SNIPPET('log_ks_post')
$yum_config_stanza
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
$SNIPPET('chef-bootstrap')
yum -y upgrade
$SNIPPET('post_anamon')
$SNIPPET('kickstart_done')
```

Most of those snippets come with Cobbler already.

And now, lets make a profile.

```
cobbler profile add \
  --kickstart=/var/lib/cobbler/kickstarts/myCentOS6.ks \
  --repos="CentOS6-Base CentOS6-Updates" \
  --nameservers="192.168.1.1 192.168.1.2"
  --distro=CentOS6 \
  --name=CentOS6-x86_64
```

And, again with the web interface….

![profile](/images/blog/2012/profile-1024x681.png)

Sync it all with Cobbler.

```
cobbler sync
```

And now we have all the pieces in place to add a node with a RAID1 mirror that will netboot on next boot.

```
cobbler system add \
  --name=server01.example.com \
  --profile=CentOS6-x86_64 \
  --mac=1a:2b:3c:4d:5e:6f \
  --ip=192.168.1.3 \
  --subnet=255.255.255.0 \
  --hostname=server01.example.com \
  --ksmeta="disks=mirror" \
  --netboot-enabled=Y \
  --gateway=192.168.1.1
```

Here is the node in the web interface.

![node](/images/blog/2012/node-1024x681.png)

There you have it. Enable PXE booting on the node and reboot it.

You can actually follow it’s install process from the Cobbler server

```
tail -f /var/log/cobbler/anamon/server01.example.com/*
```

Within a few minutes your node will be complete.

[^1]: <https://web.archive.org/web/20140221232937/http://blog.milford.io/2012/03/getting-a-basic-cobbler-server-going-on-centos/>
