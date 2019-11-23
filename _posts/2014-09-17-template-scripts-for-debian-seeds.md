---
layout: post
title: Using template scripts for Debian and Ubuntu seeds
author: Alastair Munro
summary: Using template scripts for Debian and Ubuntu seeds
---

# Introduction

Debian/ubuntu server building uses a totally different method to fedora/redhat/centos. It uses debian installer (google
for docs). If you look at the sample.seed kickstart in cobbler, you will see all lines begin with d-i (means debian
installer). 

The difference with debian installer is the pre and post phases of the build do not have blocks where you can include
code; instead you just have one line to specify commands. This is where you can use cobbler template scripts.

With ubuntu 14.04 you can now use Anaconda kickstarts; see the install documentation for this release. The docs say its
not as fully functional as the fedora kickstart, but it should be good enough to allow working around any issues. I
suspect seeds are probably the way to go until this becomes more mature.

For ubuntu, to install via debian installer, you must use the alternative iso images.

Personally, I think the cobbler_web should have a left hand menu for template scripts like it has for snippets and
kickstarts. If you want them to show up in the snippets page, you can hard link them into the snippets dir, which is
what I did. Also it should be better documented in the official docs. Anyhow I kind of worked out how to use them.

# Using template scripts to include pre/post functionality

With the d-i lines you do have a couple of pre and post lines:

    d-i preseed/early_command string wget -O- \
       http://$http_server/cblr/svc/op/script/$what/$name/?script=preseed_early_default | \
       /bin/sh -s

    d-i preseed/late_command string wget -O- \
        http://$http_server/cblr/svc/op/script/$what/$name/?script=preseed_late_default | \
        chroot /target /bin/sh -s

These scripts actually live in /var/lib/cobbler/scripts and you can make copies of them and then adapt them to your
requirements, including embedding snippets in them which will get interpreted by the cheetah template engine. Thus you
can do exactly the same as the %pre and %post in kickstart, but they are outside the main seed file. You could have the
same snippets for fedora and debian, but they are just called differently within the kickstart or seed.

    # cd /var/lib/cobbler/scripts
    # cp preseed_late_default preseed_late_ub1404
    # vi preseed_late_ub1404 # customise as required, including adding snippets

Then you can call it in the seed as follows:

    d-i preseed/late_command string wget -O- \
       http://$http_server/cblr/svc/op/script/$what/$name/?script=preseed_late_ub1404 | \
       chroot /target /bin/sh -s

You can also use in-target rather than piping into chroot:

    d-i preseed/late_command string in-target wget http://$http_server/cblr/svc/op/script/$what/$name/ script=preseed_late_ub1404 -O /tmp/postinst.sh; \
        in-target /bin/chmod 755 /tmp/postinst.sh; \
        in-target /tmp/postinst.sh;

Here is the copied preseed late script. It includes a ubuntu 14.04 work around where the /etc/network/interfaces gets
clobbered by ubuntu post install scripts:
 
    # Start preseed_late_ub1404
    # This script runs in the chroot /target by default
    #
    # Issue with /e/i/n getting clobbered.
    # See this: http://comments.gmane.org/gmane.linux.installation.cobbler/9613. Work around:
    rm -f /usr/lib/finish-install.d/55netcfg-copy-config /usr/lib/finish-install.d/50config-target-network 
    #
    # The standard stuff from the copied script:
    $SNIPPET('post_install_network_config_deb')
    $SNIPPET('late_apt_repo_config')
    $SNIPPET('post_run_deb')
    $SNIPPET('download_config_files')
    #
    $SNIPPET('my_snippet1')
    $SNIPPET('my_snippet2')
    $SNIPPET('my_snippet3')
    #
    $SNIPPET('kickstart_done')
    # End preseed_late_default
