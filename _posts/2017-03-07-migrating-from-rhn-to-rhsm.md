---
layout: post
title: Migrating a RHEL6 cobbler server from RHN to RHSM
author: teridon
summary: 
---

If you're mirroring repositories using the `rhn://` protocol on an RHEL6 system, those mirrors will cease to work after
you migrate your server from RHN to RHSM.  Note that RHN is scheduled to be disabled in July 2017, so you must migrate
RHN systems to RHSM on or before that time if you want them to continue to mirror Red Hat repositories.

RHSM repositories use SSL client certificates for authentication, so you must have a RHSM-registered system to obtain
the certificates required.

Starting with https://github.com/cobbler/cobbler/pull/1763 you can use cobbler to mirror those repositories. If you're
working from an older release of cobbler, you can patch `action_reposync.py` (e.g.
`/usr/lib/python2.6/site-packages/cobbler/action_reposync.py`) to work, based on the changes made in #1763. Note: if you
patch `action_reposync.py`, you must restart cobblerd.

Below are the steps for migrating your system, and editing your repositories so that you can continue mirroring.

# Migrate server from RHN to RHSM

Simply follow the directions Red Hat provides here: [https://access.redhat.com/articles/1161543]

# Edit repositories

## Obtain certificate names

You'll need the filenames for your SSL client certificate and key.

    # grep sslclient /etc/yum.repos.d/redhat.repo | head -2
    sslclientcert = /etc/pki/entitlement/2129913280042545783.pem
    sslclientkey = /etc/pki/entitlement/2129913280042545783-key.pem

## Edit Repo

First, change the breed from "rhn" to "yum".

### Change the URL

Look in `/etc/yum.repos.d/redhat.repo` for the repository you want (based on "yum repolist"). E.g. the standard RHEL6
workstation URL for x64 is:

    https://cdn.redhat.com/content/dist/rhel/workstation/6/6Workstation/x86_64/os/

For supplementary:

    https://cdn.redhat.com/content/dist/rhel/workstation/6/6Workstation/x86_64/supplementary/os


Perhaps obviously, you can only sync repositories for which you have an entitlement.

### Add advanced yum options
Add these options to "yum options" (using the correct client cert filenames, of course.  the "sslcacert" is always the
same):

    sslclientcert=/etc/pki/entitlement/2129913280042545783.pem
    sslclientkey=/etc/pki/entitlement/2129913280042545783-key.pem
    sslcacert=/etc/rhsm/ca/redhat-uep.pem

## Duplicate downloads notice
It seems that for RHN repos, the directory name for RPMs is "getPackage", but for yum/RHSM it is "Packages". After you
migrate, when you do a reposync, it will consider all the packages missing and will attempt to download them again.

You can avoid this by renaming the "getPackage" directory in any previously-RHN repositories on your system.

## Test
You probably want to test using a smaller repository like the supplementary one:

    cobbler reposync --only=rhel-6-workstation-supplementary

# Debugging

cobbler uses the python library `urlgrabber` to download individual files from the repository. You can see problems with
your configuration by turning on debugging for `urlgrabber`. Edit/create /etc/sysconfig/cobblerd, and add:

    URLGRABBER_DEBUG=1
    export URLGRABBER_DEBUG

Then **restart cobblerd** and try your reposync again. Debug messages from urlgrabber will be written to stderr.

