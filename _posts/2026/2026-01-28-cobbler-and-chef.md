---
layout: post
title: An update to the Chef integration
author: Enno
summary: An updated version of the instructions provided by Milford in 2012
---

A few years ago (actually more than a dozen years ago), a very cool blogger wrote a nice article [^1] on how to get Cobbler
going with Chef for his infrastructure. We wanted to publish our own version of it now that Cobbler has had a few
releases since back then. To preserve his content, we have decided to repost his blog article within our own blog. For
details see [here]({% post_url /2012/2012-03-26-cobbler-on-centos %}).

The Cobbler 3.3.x release series no longer includes a Web UI based on Django. The experimental one, which is
Angular-based can be found on the GitHub repo [cobbler/cobbler-web](https://github.com/cobbler/cobbler-web). For the
purposes of this blog entry, the screenshots
of the Web UI will be skipped.

### Installing Cobbler

Since the primary development of Cobbler is based on top of openSUSE-based operating systems nowadays, openSUSE Leap
15.6 will be used in combination with the community repository that is supplied by the project.

To install Cobbler, execute the following commands:

```console
root@cobbler:~$ zypper ar https://download.opensuse.org/repositories/systemsmanagement:cobbler:release33/15.6/systemsmanagement:cobbler:release33.repo
root@cobbler:~$ zypper ref
root@cobbler:~$ zypper in cobbler dhcp-server bind
```

### Firewall Configuration

Now, to allow Cobbler (and the other services running on the host) to offer their services, execute the following
commands:

```console
root@cobbler:~$ firewall-cmd --permanent --zone=public --add-service=http
root@cobbler:~$ firewall-cmd --permanent --zone=public --add-service=https
root@cobbler:~$ firewall-cmd --permanent --zone=public --add-service=tftp
root@cobbler:~$ firewall-cmd --permanent --zone=public --add-service=dhcp
root@cobbler:~$ firewall-cmd --permanent --zone=public --add-service=dhcpv6
root@cobbler:~$ firewall-cmd --permanent --zone=public --add-service=dns
root@cobbler:~$ firewall-cmd --reload
```

### Cobbler Configuration

In previous versions of Cobbler, the authentication had to be switched to something else then "denyall". Modern versions
of Cobbler use the built-in authentication system, which defaults to "cobbler" for both username and password.
It is strongly recommended to harden this in production environments.

The default password for systems that Cobbler installs can be found in `/etc/cobbler/settings.yaml`, and the key
`default_password_crypted` contains an OpenSSL hash of the default password "cobbler". For production environments, it
is strongly recommended to change this as well. To do so use the following command:

```console
root@cobbler:~$ openssl passwd -1
```

For Cobbler to be able to generate a working PXE tree with its related services a few settings in the aforementioned
settings file have to be adjusted:

- `server`: Set this to the IP/FQDN of Cobbler inside your installation network(s).
- `anamon_enabled`: Allow RedHat-based installers to send the installation logs to Cobbler for inspection.
- `next_server_v4` and `next_server_v6`: Set this so the DHCP server can announce the IP of your TFTP server. For this
  guide, we set this to the IP of the Cobbler server.
- `manage_dhcp` & `manage_dhcp_v4`: Set to `true` so clients in the network get addresses dynamically assigned.
- `manage_dns`: Set to `true` so the hostnames are being turned into A records.
- `manage_forward_zones`: The local network fqdn that is being managed.
- `manage_reverse_zones`: The local network range that is being managed, e.g. `192.168.100`

### Enabling Services

To allow `dhcpd` to listen to a respective interface, open the file `/etc/sysconfig/dhcpd` with an editor of your choice
and set `DHCPD_INTERFACE` to the interface where your installation network is present. The entry could look like this
after the edits:

```
DHCPD_INTERFACE="eth1"
```

Now that everything is prepared, we can enable Cobbler with `systemctl enable --now cobblerd`.

To allow Cobbler to successfully synchronise your DHCPD configuration, a few adjustments need to be made to
`/etc/cobbler/dhcp.template`:

- Subnet definition
- Routers for the network
- The DNS servers for the network
- The `dynamic-bootp` range

```
...
# Adjust the subnet
subnet 192.168.1.0 netmask 255.255.255.0 {
     # Adjust the routers
     option routers             192.168.1.5;
     # Adjust the domain name servers
     option domain-name-servers 192.168.1.1;
     option subnet-mask         255.255.255.0;
     # Adjust the dynamic bootp range
     range dynamic-bootp        192.168.1.100 192.168.1.254;
     default-lease-time         21600;
     max-lease-time             43200;
     next-server                $next_server_v4;
...
```

Now to allow named to be successfully configured adjust the logging config path in `/etc/cobbler/named.template` to
`/var/log/named/default.log`.

To have everything working after the VM/machine has been rebooted, please set the HTTP, TFTP, DNS and DHCP servers to
autostart with the following commands:

```console
root@cobbler:~$ systemctl enable --now tftp.service
root@cobbler:~$ systemctl enable --now apache2.service
root@cobbler:~$ systemctl enable --now dhcpd.service
root@cobbler:~$ systemctl enable --now named.service
```

### Bootloader Setup

For systems to boot, working bootloaders are a hard requirement. Cobbler offers the `mkloaders` subcommand for this
purpose. To feed it the required data, install them with the following command:

```console
root@cobbler:~$ zypper in grub2-i386-efi grub2-x86_64-efi ipxe syslinux
```

After `zypper` has finished installing these packages, execute `cobbler mkloaders` to generate the bootloaders and
`cobbler sync` to synchronise them to the TFTP-root.

### Importing Operating System Media

Next, download the installation media (Fedora 35 in this example), so we can import it into Cobbler and provide an OS to
clients that PXE boot. The recommended way to do this is the following:

```console
root@cobbler:~$ # Create directories for ISOs
root@cobbler:~$ mkdir /var/lib/cobbler/os-images
root@cobbler:~$ mkdir /var/lib/cobbler/os-images-mounted
root@cobbler:~$ # Download Fedora 35 ISO
root@cobbler:~$ cd /var/lib/cobbler/os-images/
root@cobbler:~$ wget https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/35/Server/x86_64/iso/Fedora-Server-dvd-x86_64-35-1.2.iso
root@cobbler:~$ # Mount the ISO via adding an entry to /etc/fstab
root@cobbler:~$ mkdir /var/lib/cobbler/os-images-mounted/fedora-35
root@cobbler:~$ echo "/var/lib/cobbler/os-images/Fedora-Server-dvd-x86_64-35-1.2.iso /var/lib/cobbler/os-images-mounted/fedora-35 iso9660 loop      0      0" >> /etc/fstab
root@cobbler:~$ mount -a
```

Since the content of the ISO is now available, we can finally import it. To do so, execute the following command:

```console
root@cobbler:~$ cobbler import --name="fedora-35" --path="/var/lib/cobbler/os-images-mounted/fedora-35"
root@cobbler:~$ cobbler distro edit --name="fedora-35-x86_64" --kernel-options=""
```

Now we have a Cobbler Distro and Profile for Fedora 35. It is time to add the repositories so we don't have to reach out
to the internet:

```console
root@cobbler:~$ cobbler repo add \
  --arch=x86_64 \
  --breed=yum \
  --keep-updated=N \
  --mirror=https://archives.fedoraproject.org/pub/archive/fedora/linux/releases/35/Server/x86_64/os/ \
  --name=fedora35  
root@cobbler:~$ cobbler repo add \
  --arch=x86_64 \
  --breed=yum \
  --keep-updated=N \
  --mirror=https://archives.fedoraproject.org/pub/archive/fedora/linux/updates/35/Everything/x86_64/ \
  --name=fedora35-updates
```

Normally, one would need to execute `cobbler reposync`, but that is not needed because the repos are not updated (just
definitions for kickstart).

The `kickstart_start` & `kickstart_done` templates have been renamed to `autoinstall_start` & `autoinstall_done` and are
fully maintained in the upstream repo.

### Setting up the RPM Mirror

I have created a small Python script to download the Chef Open-Source Clients from their API. You can find the script in
this [GitHub Gist](https://gist.github.com/SchoolGuy/2fcd4452d347303ae892fadbdf1f8d3b).

First, download the script and make it executable:

```console
root@cobbler:~$ curl -o /usr/local/bin/chef-download https://gist.githubusercontent.com/SchoolGuy/2fcd4452d347303ae892fadbdf1f8d3b/raw/chef-download.py
root@cobbler:~$ chmod +x /usr/local/bin/chef-download
root@cobbler:~$ zypper in createrepo
```

Now, create the directories and download the RPMs. Replace the placeholders (like `LICENSE_ID`) with your actual values.

```console
root@cobbler:~$ mkdir -p /srv/www/rpms/rhel /srv/www/rpms/suse
root@cobbler:~$ chef-download --endpoint=download-nice --product=chef --platform=el --platform-version=8 --architecture=x86_64 --version=latest --license-id=free-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx-xxxx
root@cobbler:~$ createrepo /srv/www/rpms/suse/
root@cobbler:~$ createrepo /srv/www/rpms/rhel/
```

Now create the vhost to allow access to the RPMs:

```apache
<VirtualHost *:80>
    DocumentRoot "/srv/www/rpms"
    ServerName rpm.cobbler.local

    <Directory "/srv/www/rpms">
        Options Indexes MultiViews
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
```

Add a `ServerName cobbler.cobbler.local` directive to the Cobbler vhost.

### Chef Server Setup

Now it is time to set up the Chef-Server appliance and the Chef Workstation Application on your laptop:

On the Cobbler Server:

```console
root@cobbler:~$ cobbler distro add --name=fake --kernel=/var/lib/cobbler/kernel --initrd=/var/lib/cobbler/initrd
root@cobbler:~$ cobbler profile add --name=fake --distro=fake
root@cobbler:~$ cobbler system add --name="chef.cobbler.local" --profile=fake --interface=default --dns-name="chef.cobbler.local" --ip-address="192.168.100.10" --mac-address="52:54:00:f2:61:40"
root@cobbler:~$ cobbler sync
```

Now edit the Cobbler named template (`/etc/cobbler/named.template`) to allow queries from your libvirtd network and
listen on any interface, as this is only a test setup. If you are in production, please limit the number of networks
that can send DNS queries to your named server.

On the Chef VM (Rocky Linux 9), now execute the following commands:

```console
root@chef:~$ dnf install libnsl nginx
root@chef:~$ wget -O chef-server.rpm "https://chefdownload-community.chef.io/stable/chef-server/download?license_id=free-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx-xxxx&m=x86_64&p=sles&pv=15&v=latest"
root@chef:~$ dnf install chef-server.rpm
root@chef:~$ chef-server-ctl reconfigure
root@chef:~$ chef-server-ctl user-create USER_NAME FIRST_NAME LAST_NAME EMAIL 'PASSWORD' --filename FILE_NAME
root@chef:~$ chef-server-ctl org-create short_name 'full_organization_name' --association_user user_name --filename ORGANIZATION-validator.pem
root@chef:~$ firewall-cmd --permanent --zone=public --add-service=http
root@chef:~$ firewall-cmd --permanent --zone=public --add-service=https
root@chef:~$ firewall-cmd --reload
```

### Installing Chef Workstation

Installing Chef Workstation on openSUSE Leap 15.6:

```
root@chef-workstation:~$ wget -O chef-workstation.rpm https://packages.chef.io/files/stable/chef-workstation/0.4.2/el/6/chef-workstation-0.4.2-1.el6.x86_64.rpm?licenseId=free-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx-xxxx
root@chef-workstation:~$ zypper in chef-workstation.rpm
root@chef-workstation:~$ cd <projects directory>
root@chef-workstation:~$ knife configure init-config
root@chef-workstation:~$ cd ~/.chef
root@chef-workstation:~$ scp root@chef.cobbler.local:/root/admin.pem .
root@chef-workstation:~$ knife ssl fetch
root@chef-workstation:~$ knife client list
root@chef-workstation:~$ chef generate repo chef-repo
root@chef-workstation:~$ cd chef-repo
```

### Integrating Chef with Cobbler

Back on the Cobbler Server, the following fixups need to be done:

The default sample template found at `/var/lib/cobbler/templates/sample.ks` requires modification to work with this blog
post:

- Disable setting the specific authentication through commenting the `auth ...` command
  ```
  # System authorization information
  # The following line is not commented out in the template shipped by Cobbler. Comment it with a pound sign!
  # auth  --useshadow  --enablemd5
  ```
- Replace the deprecated and removed `install` directive with the new `url` directive
  ```
  # Install OS instead of upgrade
  url --url=$tree
  ```
- Add the Fedora Update repository and our custom chef repository before the `%pre` section with the help of the `repo` directive
  ```
  # System timezone
  timezone  America/New_York
  
  repo --name=updates
  repo --name=chef --baseurl="http://rpm.cobbler.local/rhel" --install
  ```
- Add the packages `libxcrypt-compat` and `chef` inside the `%packages` section
  ```
  %packages
  libxcrypt-compat
  chef
  %end
  ```

Edit `yumgen.py` from the Cobbler source code and edit the function `get_yum_config`. The part which needs to be
modified is the first line in the first for-loop.

```python
included = {}
for r in blended["source_repos"]:
    # The following line was edited!
    filename = pathlib.Path(self.settings.webdir).joinpath(*(r[0].split("/")[4:]))
    if filename not in included:
        input_files.append(filename)
    included[filename] = 1
```

Now, copy the Chef authentication certificate to the Cobbler Server:

```console
root@cobbler:~$ scp root@192.168.100.10:/root/cobbler-validator.pem /srv/www/cobbler/pub/
```

To ensure that the node can resolve the `cobbler.local` domain, `systemd-resolved` needs to be disabled both during and
after installation. To do so insert the following snippets into the `sample.ks` file:

```
%pre
# Disable systemd-resolved for installation
systemctl stop systemd-resolved 2>/dev/null || true
...

%post
# Disable systemd-resolved for post-installation
systemctl disable systemd-resolved
systemctl mask systemd-resolved
rm -f /etc/resolv.conf
cat <<EOF > /etc/resolv.conf
search cobbler.local
nameserver 192.168.100.2
EOF
...
```

Now that `systemd-resolved` is disabled we add to the same file the following snippet as the last step in the `%post`
section:

```bash
mkdir -p /etc/chef
cat <<EOF > /etc/chef/client.rb 
chef_server_url "https://chef.cobbler.local/organizations/cobbler"
validation_client_name "cobbler-validator"
validation_key "/etc/chef/cobbler-validator.pem"
log_level :info
node_name "$name"
EOF
curl -o /etc/chef/cobbler-validator.pem http://cobbler.cobbler.local/cobbler/pub/cobbler-validator.pem
knife ssl fetch -c /etc/chef/client.rb
chef-client -c /etc/chef/client.rb --override-runlist=""
```

### Testing the Setup

After this is done, a new system can finally be added to Cobbler:

```console
root@cobbler:~$ cobbler system add \
  --name=server01.cobbler.local \
  --profile=fedora-35-x86_64 \
  --mac=1a:2b:3c:4d:5e:6f \
  --ip-address=192.168.1.3 \
  --dns-name=server01.cobbler.local \
  --netboot-enabled=true
```

Now PXE-boot the node and follow the anamon logs on the Cobbler server. Repeat the last step for all of your hardware
and check that they are onboarded in Chef. To verify log into the VM with Chef-Workstation and execute the following
command:

```console
root@chef-workstation:~$ knife node list
server.01.cobbler.local
```

### Conclusion

The steps taken in this tutorial-style blog post showed that with a bit of effort a hands-free air-gapped bootstrap of
Chef clients is easily possible with Cobbler, even a dozen years after the original tutorial. While Chef didn't change
anything on the managed system yet, the role of Cobbler here is done, and it would be out of the scope of this tutorial
to go in-depth with Chef as a configuration management system.

[^1]: <https://web.archive.org/web/20140221232937/http://blog.milford.io/2012/03/getting-a-basic-cobbler-server-going-on-centos/>
