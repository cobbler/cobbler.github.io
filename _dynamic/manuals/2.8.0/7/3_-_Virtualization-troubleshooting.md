---
layout: manpage
title: Cobbler Manual
meta: 2.8.0
---
# Frequently Asked Virtualization Trouble Shooting Questions

This section covers some questions that frequently come up in IRC,
some of which are problems, and some of which are things about
Cobbler that are not really problems, but are things folks just ask
questions about frequently... all related to virtualization.

See also [TroubleShooting](TroubleShooting) for
general items

## Why don't I see this Xen distribution in my PXE menu

There are two types of installer kernel/initrd pairs. There's a
normal one (for all physical installations) and a Xen paravirt one.
If you "cobbler import" an install tree (say from a DVD image) and
get some "xen" distributions, these distributions will then not
show up in your PXE menu -- just because Cobbler knows it's
impossible to PXE boot them on physical hardware.

If you want to install virtual guests, read "man koan" for details
and also
[Installing Virtual Guests](Installing Virtual Guests)

If you want to install a physical host, use the standard
distribution, the one without "xen" in the name. Instead, in the
"%packages" section of the kickstart, add the package named
"kernel-xen".

This only applies for Xen, of course, if you are using KVM, it's
simpler and there is only one installer kernel/initrd pair to worry
about -- the main one.

In recent versions of Fedora, the Xen kernels have merged again, so
this is not a problem.

## I'm having problems using Koan to install virtual guests

If you use virt-type xenpv, make sure the profile you are
installing uses a distro with "xen" in the name. These are the
paravirtualized versions of the installer kernel/initrd pair.

Make sure your host arch matches your guest arch

If installing Xen and using virsh console or xm console, if you
don't use --nogfx at one point the installer will appear to hang.
Most likely it did not, it switched over to using VNC which you can
view with virt-manager. If you would like to keep using the text
console, use --nogfx instead. This does not apply to other virt
types, only Xen.

There really aren't any KVM gotchas, other than making sure
/dev/kvm is present (you need the right kernel module installed on
the host) otherwise things will install with qemu and appear to be
very slow.

See also
[Installing Virtual Guests](Installing Virtual Guests)

## What Is This Strange Message From Xen?

    libvir: Xen error : Domain not found: xenUnifiedDomainLookupByUUID
    libvir: Xen error : Domain not found: xenUnifiedDomainLookupByName

If you see the above, it's not an error. These strange messages are
perfectly normal and are coming from Xen as it's looking for an
existing domain. It does not come from Cobbler/koan and your
installation will not be affected. We agree they are confusing but
they are not coming from Cobbler or Koan.

## VirtualBox version 4+ won't PXE boot, DHCP logs show up nothing

If you setup cobbler all correctly and you are trying to network book with PXE and you receive this error right after the VirtualBox POST:

    FATAL: No bootable medium found! System halted. 

Be sure to install to install the VirtualBox Extensions Pack to enable PXE boot support.
