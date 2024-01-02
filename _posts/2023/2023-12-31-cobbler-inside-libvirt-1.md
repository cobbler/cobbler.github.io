---
layout: post
title: Cobbler inside libvirt (1)
author: Enno
summary: Cobbler inside libvirt with a private libvirt network
---

The last blog post that was neither a roadmap update nor a release announcement was in December 2020. Thus it is time
to give you guys a new guide!

This time we will together explore how to use Cobbler to enable a libvirt internal network to boot over the network.
The guide will assume you have a running host OS and libvirt installed and running already. As a guest OS I will use
openSUSE Tumbleweed but any other guest OS should work equally well.

In case you have libvirt not installed please consult your OS vendors resources to do so. A few examples:

- [openSUSE](https://doc.opensuse.org/documentation/leap/virtualization/html/book-virtualization/part-virt-libvirt.html)
- [Fedora](https://developer.fedoraproject.org/tools/virtualization/installing-libvirt-and-virt-install-on-fedora-linux.html)
- [Ubuntu](https://ubuntu.com/server/docs/virtualization-libvirt)

Note:

> There will be a second part of this guide where we will utilize a network bridge to also boot real hardware with our
> VM based Cobbler setup.

Information:

> Depending on your setup you may need to prefix the `virsh` and other commands with `sudo`.

### Prepare the host environment

To limit the impact of this guide to the rest of your current host we will create a dedicated libvirt network for
Cobbler (don't modify the network `default` that libvirt provides out of the box).

There are multiple options to create a virtual network (XML for `virsh` can be found below):

- Create one with `virsh` persistently: [`virsh net-define`](https://download.libvirt.org/virshcmdref/html/sect-net-define.html)
- Create one with `virsh` temporarily: [`virsh net-create`](https://download.libvirt.org/virshcmdref/html/sect-net-create.html)
- Create one with `virt-manager` persistently: [virt-manager](https://wiki.libvirt.org/TaskNATSetupVirtManager.html)

```xml
<network>
    <name>cobbler</name>
    <uuid>6b7f4f36-7895-4b74-8be6-dfa4b2b84500</uuid>
    <forward mode='nat'/>
    <bridge name='virbr2' stp='on' delay='0'/>
    <mac address='52:54:00:fb:72:57'/>
    <domain name='cobbler.local'/>
    <dns enable='no'/>
    <ip family='ipv4' address='10.17.3.1' prefix='24'>
    </ip>
</network>
```

After the network is successfully created we can switch over to choosing the guest OS that Cobbler will be installed 
on. This guide will use openSUSE Tumbleweed since this is what Cobbler is tested on primarily. To get started download 
the ISO and move it to your desired libvirt storage pool (below I show the default location):

```
wget https://download.opensuse.org/tumbleweed/iso/openSUSE-Tumbleweed-NET-x86_64-Current.iso
mv openSUSE-Tumbleweed-NET-x86_64-Current.iso /var/lib/libvirt/images
```

### Create and prepare the Cobbler VM

Since now we have the host configured and have the ISO for installing the guest available, we can start setting it up. 
An example guide can be found [in the openSUSE Documentation](https://doc.opensuse.org/documentation/leap/virtualization/html/book-virtualization/cha-kvm-inst.html#sec-libvirt-inst-vmm). For this guide to work as intended give the virtual machine a little more 
storage for the ISOs, 50GB is recommended at the moment to be on the safe side.

After the guest was successfully set up and installed I highly recommend adding your SSH keys to it. This can be done
with the following command:

```shell
ssh-copy-id -i ~/.ssh/id_rsa <user>@192.168.122.xxx
```

> Please replace the `<user>` with the username you chose during setup and `xxx` with the last three digits of the 
> guest IP.

Now you should be able to login passwordless into the guest with the following command from the host:

```shell
ssh root@192.168.122.xxx
```

Before we start configuring the guest we need to shut it down from the host with::

```shell
virsh shutdown "<vm name>"
```

or if you are logged into the guest via SSH use

```shell
systemctl poweroff
```

to power it off. Now add the second network interface to the guest. Use the network defined above named "cobbler". If 
`virt-manager` asks you if you want to start it please confirm this with "Yes".

Start the VM again with the UI of `virt-manager` or use the following command to boot it:

```shell
virsh start "<vm name>"
```

Once you are logged in (preferably via SSH) you can switch to the root user with the `su` command. Once you are `root` 
we can actually start the configuration of the VM.

The first step is to install the DHCP server with the following command:

```shell
zypper in dhcp-server
```

In SUSE-based distributions, the DHCP server refuses operation per default because normally you don't want it operating 
on all interfaces. This is also the case for us. We want to operate the DHCP server only on our secondary interface 
which is in the "cobbler" network. To achieve this, edit the file `/etc/sysconfig/dhcpd` and change `DHCPD_INTERFACE=""` 
to the name of your secondary interface. The entry should look similar to this afterwards:

```shell
DHCPD_INTERFACE="enp7s0"
```

Another thing that is missing for our secondary interface is its static configuration. Since we are hosting the DHCP 
server, there is nothing assigning our interface its IP, gateway, and DNS server. As such we need to configure this 
statically. openSUSE Tumbleweed uses NetworkManager per default to configure its networks.

```shell
nmcli con mod "Wired connection 1" ipv4.addresses "10.17.3.2/24"
nmcli con mod "Wired connection 1" ipv4.gateway "10.17.3.1"
nmcli con mod "Wired connection 1" ipv4.dns "8.8.8.8"
nmcli con mod "Wired connection 1" ipv4.method "manual"
nmcli c up "Wired connection 1"
```

> You will need to adjust the name of the interface `Wired Connection 1` to the interface that isn't online. This will
> be the interface written in white normally. The other two interfaces should have a green tone.

### Install & Configure Cobbler

At the time of writing this guide, the current version of Cobbler in openSUSE Tumbleweed is 3.3.3. This can be 
installed with:

```shell
zypper in cobbler
```

Confirm the installation with `y` when prompted and confirm by hitting the enter key. This will also install the TFTP 
server along with several other required dependencies.

In a default openSUSE Tumbleweed installation `firewalld` is configured and active. To open the required ports we 
execute the following commands:

```shell
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --permanent --zone=public --add-service=tftp
firewall-cmd --permanent --zone=public --add-service=dhcp
firewall-cmd --permanent --zone=public --add-service=dhcpv6
```

> Be sure that this is executed on the guest. Opening these ports on the host may have unexpected consequences.

Since clients can access the desired services now, we should start them up.

- Enable the TFTP service with: `systemctl enable --now tftp.service`
- Enable the webserver with: `systemctl enable --now apache2.service`
- Enable the DHCP service with: `systemctl enable --now dhcpd.service` - this will fail but this is expected at this 
  point

Now we can finally start configuring Cobbler itself. To do so edit the central configuration file at 
`/etc/cobbler/settings.yaml` and make it match the IP on the guest (ignore the rest of the settings file for now):

```yml
server: 10.17.3.2
next_server_v4: 10.17.3.2
manage_dhcp: true
manage_dhcp_v4: true
```

For this to take effect restart Cobbler:

```shell
systemctl restart cobblerd
```

Now that Cobbler knows its own IP address, we can modify the DHCP template that Cobbler ships to match our requirements.
To do so adjust the file `/etc/cobbler/dhcp.template`. The important part of the file should look like this after 
modifications:

```
subnet 10.17.3.0 netmask 255.255.255.0 {
        option routers             10.17.3.1;
        option domain-name-servers 8.8.8.8;
        option subnet-mask         255.255.255.0;
        range dynamic-bootp        10.17.3.100 10.17.3.254;
```

The rest of the template can be left as is. Cobbler per-default uses [Cheetah](https://cheetahtemplate.org/) as a 
template language. It supports [Jinja](https://jinja.palletsprojects.com/en/3.1.x/) via a shebang as well.

## Importing your first distribution to Cobbler

Now, at this point Cobbler doesn't do much. It doesn't hand out DHCP addresses since we haven't defined a DHCP pool, the 
TFTP tree at `/srv/tftpboot` is empty and Cobbler itself doesn't contain any records that the API could return.

To change this we will import our first distribution. For the sake of this guide, we will use openSUSE Leap. Get started
with downloading the openSUSE Leap image inside the Cobbler VM:

```shell
wget https://download.opensuse.org/distribution/leap/15.4/iso/openSUSE-Leap-15.4-DVD-x86_64-Media.iso
```

Mount the downloaded ISO to a sensible directory that cannot be accidentally modified or deleted. It is recommended to 
add an entry to `/etc/fstab` in case you want to reboot the VM without problems:

```shell
mkdir -p /mnt/cobbler-isos/leap-15-4
mount -o loop /root/openSUSE-Leap-15.4-DVD-x86_64-Media.iso /mnt/cobbler-isos/leap-15-4
```

Here is the entry in case you want to permanently mount the ISO:

```
# <device>                                    <dir>                       <type>  <options> <dump> <fsck>
/root/openSUSE-Leap-15.4-DVD-x86_64-Media.iso /mnt/cobbler-isos/leap-15-4 iso9660 loop      0      0
```

Now we are ready to populate Cobbler with its first entry. For this we will be using `cobbler import` to automate 
setting up a distro and profile:

```shell
cobbler import --name="openSUSE-Leap-15-4" --path="/mnt/cobbler-isos/leap-15-4/"
```

Due to the bug [cobbler/cobbler#3417](https://github.com/cobbler/cobbler/issues/3417) you will need to apply a fix in
case the `install=` kernel option is missing.

To check this report the desired distribution:

```shell
cobbler distro report --name="openSUSE-Leap-15-4-x86_64"
```

In case under `Kernel Options:` you can't read something that contains `install` you may use the following fixup 
command for this:

```shell
cobbler distro edit --name="openSUSE-Leap-15-4-x86_64" --kernel-options="install=http://10.17.3.2/cblr/distro_mirror/openSUSE-Leap-15-4"
```

### Auto-Install your first VM with Cobbler

Now to do our first fully automated installation of a VM we will need to setup an empty VM that uses the `cobbler` 
libvirt network - no installation media required. Make note of the MAC address of the VM. Change the boot order so that 
the network interface is the first boot option.

We now add the system to Cobbler:

```shell
cobbler system add --name="testsystem" --profile="openSUSE-Leap-15-4-x86_64" --mac="<your mac here>" --ip-address=="10.17.3.20"
```

Then we generate the bootloaders and sync them into the TFTP Tree:

```shell
cobbler mkloaders && cobbler sync
```

To utilize the empty VM we created earlier, boot it via the network with `virt-manager` or `virsh`. To achieve this
please take a look at the [libvirt domain XML specification](https://libvirt.org/formatdomain.html#bios-bootloader) or
take a look at [the RedHat Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/configuring-virtual-machine-network-connections_configuring-and-managing-virtualization#proc_booting-virtual-machines-using-pxe-and-a-virtual-network_assembly_booting-virtual-machines-from-a-pxe-server)
that also covers this topic.

> Sadly the default autoyast template for Cobbler 3.3.3 is broken as such a hands-free installation is not possible at 
> the moment.

### Final thoughts

By now you should have a rough understanding of the workflow that Cobbler automates and how easy it should be to setup
new VM guests. We hope you had fun following this guide. If there are any questions feel free to open a 
[GitHub Discussion](https://github.com/cobbler/cobbler/discussions/new/choose).

To clean up after your experiments there are only a couple of commands needed:

```shell
virsh destroy <vm name> && virsh destroy <second vm name> && virsh net-destroy cobbler
```

Further topics that we will cover in future blog posts:

- Write autoinstall snippets for your setups
- Setup Windows Guests

---

P.S.: In case you find typos and/or grammar mistakes just
[open an Issue](https://github.com/cobbler/cobbler.github.io/issues/new) or
[open a PR](https://github.com/cobbler/cobbler.github.io/compare).
