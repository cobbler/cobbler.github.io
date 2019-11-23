---
layout: post
title: Adding extra repositories to buildiso standalone media
author: Michael Pelletier
summary: Adding Extra Repositories to "buildiso standalone" Media
---

By: [Michael V. Pelletier](https://github.com/mvpel)

The `cobbler buildiso --standalone` command will create an ISO image of a DVD which can be used to install the selected
distribution. However, it does not include any additional repositories which you might have defined in the profiles -
only the base distribution. This means that if you have an errata repository or additional packages from something like
Red Hat MRG, those RPMs won't make it into your installed system.

The $yum_repo_stanza is still expanded in the kickstart configuration file to list the applicable repositories with HTTP
addresses, which means that if the system you're installing has access to a web server hosting those repositories, then
the install will proceed normally - but then why would you want a standalone ISO if you can reach the Cobbler server?

If your extra repositories are small enough to fit on the remaining space on the DVD after the distribution is copied,
then with a few small changes you can create a DVD which includes both the distribution and the additional repositories,
making it possible to install a system which is completely disconnected from the network.

First, run a standard buildiso, capturing the output to a file:

* cobbler buildiso --standalone --distro=distribution_name --iso=/tmp/standalone.iso >/tmp/build.out 2>&1

The directory `/var/cache/cobbler/buildiso` holds the filesystem which is transferred to the ISO image, so we can
customize this and recreate the ISO. In `/var/cache/cobbler/buildiso/isolinux`, you will find a list of `.cfg` files
named after the profiles which are attached to the distribution you specified.

Edit each one, and look for the "repo" lines which define the extra repositories:

* repo --name=rhel-x86_64-server-6.3-errata --baseurl=http://cobbler-server/cobbler/repo_mirror/rhel-x86_64-server-6.3-errata
* repo --name=rhel-6-mrg-2.1-x86_64-errata --baseurl=http://cobbler-server/cobbler/repo_mirror/rhel-6-mrg-2.1-x86_64-errata
* repo --name=rhel-6-mrg-2.1-x86_64 --baseurl=http://cobbler-server/cobbler/repo_mirror/rhel-6-mrg-2.1-x86_64

First, change the "baseurl" to point to the install media, rather than a web server, by replacing the
"http://cobbler-server" with "file:///mnt/source," like so:

* repo --name=rhel-x86_64-server-6.3-errata --baseurl=file:///mnt/source/cobbler/repo_mirror/rhel-x86_64-server-6.3-errata
* repo --name=rhel-6-mrg-2.1-x86_64-errata --baseurl=file:///mnt/source/cobbler/repo_mirror/rhel-6-mrg-2.1-x86_64-errata
* repo --name=rhel-6-mrg-2.1-x86_64 --baseurl=file:///mnt/source/cobbler/repo_mirror/rhel-6-mrg-2.1-x86_64

The "/mnt/source" path is where the root directory of the install media is mounted during an Anaconda installation.
Also, be sure to delete or comment out all of the "source-_n_" repos, since they are being made available from the media
and will not be reachable via a URL during a standalone media-only install.

We then copy over the appropriate repositories to the buildiso directory:

* mkdir -p /var/cache/cobbler/buildiso/cobbler/repo_mirror
* cd /var/cache/cobbler/buildiso/cobbler/repo_mirror
* cp -rp /var/www/cobbler/repo_mirror/rhel-x86_64-server-6.3-errata .
* cp -rp /var/www/cobbler/repo_mirror/rhel-6-mrg-2.1-x86_64-errata .
* cp -rp /var/www/cobbler/repo_mirror/rhel-6-mrg-2.1-x86_64 .

Next, check that each of the repositories you have copied contains a "config.repo" file in its top-level directory. This
is used after the completion of the Cobbler installation to build a cobbler-config.repo file - the contents of each of
these files will be pasted together once the system is installed. If your system will eventually be network-connected,
you can use the web addresses of each of the repositories you're copying into the ISO, or otherwise change the base URLs
to suit the requirements of your environment. Perhaps you could copy an ISO image of the install DVD you're about to
create here to new system, and configure a loopback mount for it?

You will need to delete any checksum cache directories from the repositories if you're copying them out of a mirror, as
above, since otherwise the cache file names will overwhelm the Joliet file name conversion tables:

* rm -rf /var/cache/cobbler/buildiso/cobbler/repo_mirror/*/cache

Since the distribution itself will probably take up a majority of the space available on a 4.7GB DVD, you should be
selective as to which repositories you copy - only take the ones that are actually needed by the profiles listed in the
isolinux directory. Or, if your hardware supports it, you can use a dual-layer DVD or a BluRay, and go nuts.

Next, execute the exact same "mkisofs" command which was used to create the original ISO image, which can be found in
the `/tmp/build.out` file from your `cobbler buildiso` run. It will probably look like this:

* mkisofs -o /tmp/standalone.iso  -r -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -V Cobbler\ Install -R -J -T /var/cache/cobbler/buildiso

Once complete, you will have an ISO image which will install not only the distribution you selected, but also the
additional packages from the supplemental repositories, eliminating the need for a network connection or web server
during the installation - absolutely 100% standalone.

I grant that these instructions are Red Hat-centric since that's what I have to work with, but if there are adjustments
needed for Debian, Ubuntu, or other distributions, please feel free to update this page.

NOTE: As of October 2015, work is underway to incorporate this capability into Cobbler via a buildiso --airgapped option.