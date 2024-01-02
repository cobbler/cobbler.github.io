---
layout: post
title: Cobbler inside libvirt (2)
author: Enno
summary: Cobbler inside libvirt with a network bridge
---

> This blog article assumes you have read the previous part of this small series:
> [Cobbler inside libvirt (1)](./2023-07-07-cobbler-inside-libvirt-1.md)

This blog article will try to showcase how to setup a Cobbler VM that provides network booting to your network. This of 
course excludes the host that the VM we are setting up is running on.

To simplify this guide please ensure that your DHCP addresses are taken care of by an external source. This may be your
home router, another VM or you may also of course use static IPs if you feel like it. IPv6 support in Cobbler is mature
but for this guide, we will ignore it.

### Setup the libvirt bridge

Before we can get started with setting up the Cobbler VM, we need to ensure that our guest VM has access to the network
it should supply network booting capabilities to. Per default, libvirt uses a NAT network that limits all network
traffic to the libvirt guests that have a network interface that is inside this NAT network.

To enable our VM to have equal access to the network to our host we need to set up a bridge so our host and guest can
share a single physical network interface. To explain how to setup a bridge would be its own dedicated blog article. As
such please consult your OS vendor or community on how to achieve this, in the following are a few links to the most
common operating systems:

- SUSE: [openSUSE Documentation](https://doc.opensuse.org/documentation/leap/virtualization/html/book-virtualization/cha-libvirt-host.html#libvirt-host-network)
- RedHat:
  - [RedHat Documentation - Configuring a network bridge](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking)
  - [RedHat Documentation - Virtual networking using bridges](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/configuring_and_managing_virtualization/configuring-virtual-machine-network-connections_configuring-and-managing-virtualization#virtual-networking-bridged-mode_types-of-virtual-machine-network-connections)
  - [RedHat Sysadmin Blog](https://www.redhat.com/sysadmin/setup-network-bridge-VM)
- Debian: [Debian Wiki](https://wiki.debian.org/BridgeNetworkConnections#Libvirt_and_bridging)
- Vendor Neutral (the hard way): [Linuxconfig](https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm)

To read more about:

- **NAT**: please head over to [Wikipedia](https://en.wikipedia.org/wiki/Network_address_translation).
- **Network Briding**: please head over to [Wikipedia](https://en.wikipedia.org/wiki/Network_bridge)

### Setup Cobbler VM & install the guest OS

Download the openSUSE Tumbleweed ISO and move it to your desired libvirt storage pool (below I show the location of the 
default storage pool):

```shell
wget https://download.opensuse.org/tumbleweed/iso/openSUSE-Tumbleweed-NET-x86_64-Current.iso
mv openSUSE-Tumbleweed-NET-x86_64-Current.iso /var/lib/libvirt/images
```

Now we can start the setup of the guest. An example of a guide can be found
[in the openSUSE Documentation](https://doc.opensuse.org/documentation/leap/virtualization/html/book-virtualization/cha-kvm-inst.html#sec-libvirt-inst-vmm). 

During the setup two things need to be thought of:

1. Give the VM a little more storage for the ISOs, 50GB is recommended. If you forget this you may not be able to 
   download the ISO for the guest later on. Cobbler copies a lot from the ISO and as such be prepared that you need 
   double the storage that the ISO takes up.
2. Instead of the network `default` assign the network bridge so Cobbler receives and IP from your external DHCP server.

### Install Cobbler on the Guest

To make access to the host easier, you could copy SSH keys to your guest from your host with the following command:

```shell
ssh-copy-id -i ~/.ssh/id_rsa <user>@<guest ip>
```

Passwordless login should now be possible with the following command:

```shell
ssh -i ~/.ssh/id_rsa <user>@<guest ip>
```

To install Cobbler on openSUSE Tumbleweed, use the following command:

```shell
zypper in cobbler
```

You want to confirm the installation with `y` and then press enter.

### Configure Cobbler

Since your files are usually transferred via the TFTP protocol during the early boot stage, you must enable it with the
following command:

```shell
systemctl enable --now tftp.service
```

Now open the ports in the firewall:

```shell
firewall-cmd --zone=public --add-service=http
firewall-cmd --zone=public --add-service=https
firewall-cmd --zone=public --add-service=tftp
```

Edit Cobbler settings (`/etc/cobbler/settings.yaml`) to match the IP range of the network:

```yml
server: 10.17.3.2
next_server_v4: 10.17.3.2
```

You may safely ignore the rest of the settings. They are not relevant to us for now.

Finally, to make all these changes get recognized by Cobbler restart it with `systemctl restart cobblerd`.

### Import your first distribution

Download the openSUSE Leap image (or any other full DVD ISO) inside the Cobbler VM:

```shell
wget https://download.opensuse.org/distribution/leap/15.4/iso/openSUSE-Leap-15.4-DVD-x86_64-Media.iso
```

Mount the ISO to a sensible directory that cannot be accidentally modified or deleted (e.g.: add an entry to
`/etc/fstab`) in case you want to reboot the VM without 
problems:

```shell
mkdir -p /mnt/cobbler-isos/leap-15-4
mount -o loop /root/openSUSE-Leap-15.4-DVD-x86_64-Media.iso /mnt/cobbler-isos/leap-15-4
```

Use `cobbler import` to automate setting up a distro and profile:

```shell
cobbler import --name="openSUSE-Leap-15-4" --path="/mnt/cobbler-isos/leap-15-4/"
```

Due to [cobbler/cobbler#3417](https://github.com/cobbler/cobbler/issues/3417) you will need to apply a fix in case 
`install=` is missing from your kernel options:

```shell
cobbler distro edit --name="openSUSE-Leap-15-4-x86_64" --kernel-options="install=http://10.17.3.2/cblr/distro_mirror/openSUSE-Leap-15-4"
```

### Create an empty VM with a bridge network

In case you don't have a physical host (other than your libvirt host) to test that network booting is working you want
to setup an empty VM that is installed via PXE and GRUB.

The VM should have a disk size of 20GB and the network interface must again be the libvirt bridge to utilize the shared
host network device.

Independent if you use a secondary physical host or if you use a VM please take note of the MAC address of the network
interface used for network booting. Don't forget to move the network interface to the first place in the boot order.

### Add the VM to Cobbler

Add the system to Cobbler:

```shell
cobbler system add --name="testsystem" --profile="openSUSE-Leap-15-4-x86_64" --mac="<your mac here>" --ip-address=="<ip for the host>"
```

Generate the bootloaders and sync them into the TFTP Tree

```shell
cobbler mkloaders && cobbler sync
```

### Final thoughts

Now boot the secondary host and watch the installation automatically proceed until the reboot. Cobbler switched during
the installation an internal switch that boots your hard drive as a chainload in case the machine boots via the network
again. This is desired so you can remotely reinstall the machine again in case it gets inaccessible.

---

P.S.: In case you find typos and/or grammar mistakes just
[open an Issue](https://github.com/cobbler/cobbler.github.io/issues/new) or
[open a PR](https://github.com/cobbler/cobbler.github.io/compare).
