---
layout: post
title: Importing Fedora 21
author: Greg Swift
summary: Importing Fedora 21
---

# Importing Fedora 21 Workstation as a distro

With the recent split into separate products the only Fedora 21 component that actually has a cobbler recognized distro
is the Server product.  The basic workflow I did to bootstrap workstations using this was:

1. Import Fedora 21 Server for a distro (download one of these
   [Fedora 21 Server x86_64 ISOs](http://dl.fedoraproject.org/pub/fedora/linux/releases/21/Server/x86_64/iso/))

2. Execute: `cobbler import --name=fedora21-x86_64 --path=/mnt/x --kickstart=/var/lib/cobbler/kickstarts/default.ks`
3. Sync the Fedora/21/Everything repository (use `--mirror-locally=False` if you can get away with it!): 
   `cobbler repo add --name=fedora21-everything-64 --breed=yum --arch=x86_64 --mirror=http://dl.fedoraproject.org/pub/fedora/linux/releases/21/Everything/x86_64/os/`
3. Now they have to be glued together. You need to copy the `.treeinfo` and images directories from the distro into
   everything repo: `cp -pr /var/www/cobbler/ks_mirror/fedora21/{.treeinfo,LiveOS,images}  /var/www/cobbler/repo_mirror/fedora21-everything-64/`
4. Then you need to edit the distro's tree path: `cobbler distro edit --name=fedora21-x86_64 --ksmeta=tree=http://@@http_server@@/cblr/repo_mirror/fedora21-everything-x86_64`

If you want to get clean with it you could probably manually perform the reposync of Everything, copy over the treeinfo
and images directories into Everything and then perform the import.

# list-harddrives fails now in my partitioning scriplets
By converting code for better python 3 support an unintended consequence in anaconda was an altering of the output of
the anaconda list-harddrives command. This only occurs when the code is run in python2 environments. 

The expected output of list-harddrives is something like: `vda 930193`. Instead we get `('vda', 930193)`.

You can read the [bug](https://github.com/rhinstaller/anaconda/issues/5). This should not be a problem in future
releases, and I guess if they re-rolled the Fedora 21 media for a 6th time it could go away.
