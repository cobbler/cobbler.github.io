---
layout: post
title: Creating custom yum repos
author: Alastair Munro
summary: Creating custom yum repos
---

## First option
### Introduction

You may have some rpms that don't fit into any particular repo. For example proprietary software that you use. Thus you
may want to create a supplementary repo to put these in. I had a hunt around for documentation on this and could not
find anything, so I just experimented and worked it out.

Based on a centos/el cobbler!

### Steps

You may wish to do this from the command line but I found it easiest from cobbler web. Example is for yum/centos 6.

Click on Repos then New repo. Set arch to x86_64 and breed yum. Untick keep updated (not being synced from a remote
repo). Give it a name (we called it el6-misc-x86_64 since this will work for all el6 varients such as rhel, centos,
si-linux, etc, and we only use 64bit). Command line version of this:

    # cobbler repo add --name=el6-misc-x86_64 --keep-updated=N --arch=x86_64 --mirror-locally=Y --breed=yum

Now create a dir to install the rpms; these go under /var/www/cobbler/repo_mirror:

    # mkdir /var/www/cobbler/repo_mirror/el6-misc-x86_64 # same name as in the web page

Copy your rpms in there. Then run createrepo:

    # createrepo /var/www/cobbler/repo_mirror/el6-misc-x86_64

You need to do a reposync; either click on Reposync or:

    # cobbler reposync

You need to create a repo file, which will be copied over to /etc/yum.repos.d on your clients. It must be called
config.repo:

    # cat /var/www/cobbler/repo_mirror/el6-misc-x86_64/config.repo
    [el6-misc]
    name=el6 supplementary
    baseurl=http://@@http_server@@/cobbler/repo_mirror/el6-misc-x86_64
    enabled=1
    gpgcheck=0
    priority=$yum_distro_priority

Now you need to attach the repo to you profile. Eg click on cent6u5. Under repos select el6-misc-x86_64 and click on
the >>. Command line version:

    # cobbler profile edit --name=cent6u5 --repos='el6-misc-x86_64'

If you add or change the rpms in the repo, rerun the createrepo command.

This is how the repo looks from the command line:

    # cobbler repo report --name=el6-misc-x86_64
    Name                           : el6-misc-x86_64
    Apt Components (apt only)      : []
    Apt Dist Names (apt only)      : []
    Arch                           : x86_64
    Breed                          : yum
    Comment                        :
    Createrepo Flags               : <<inherit>>
    Environment Variables          : {}
    Keep Updated                   : False
    Mirror                         :
    Mirror locally                 : True
    Owners                         : ['admin']
    Priority                       : 99
    RPM List                       : []
    Yum Options                    : {}

## Second option
### Introduction

There is another approach for creating a local repository for use during installations.

I'm doing this using Cobbler 2.6.9 on a Scientific Linux 6x machine. (Should be the same as CentOS). I did this using
the command line because I found some difficulties using the GUI to do the same thing.

### Steps

Collect the RPMs into a staging area. It is from here that the reposync command will copy the files from:

    # mkdir $PWD/myrpmstagearea/
    # cp /my/private/rpms/* $PWD/myrpmstagearea/

Now create your repository entry in the cobbler system:

    # cobbler repo add \
          --arch x86_64 \
          --breed rsync \
          --comment "Local copy of my RPMs." \
          --keep-updated No \
          --name myrpms \
          --mirror-locally Yes \
          --mirror $PWD/myrpmstagearea

### Notes/Clarifications:

* The _arch_ you should set as you need.
* The _breed_ needs to be 'rsync' since this is how cobbler will copy over the files from your staging area to the
  internal storage.
* The use of _keep-updated No_ means that when a reposync is called without specifying this repo specifically Cobbler
  will not try to copy over the RPMs again.
* _mirror-locally Yes_ orders Cobbler to copy the files from the staging area to the internal storage.
* The _mirror_ designation is of where you'll be leaving the RPMs so that when reposync specifies this repo the files
  can be refreshed. If you remove a file/RPM from there it will be reflected in the internal Cobbler storage. N.B. You must use the full path to this location.
* The path of _/my/private/rpms/*_ could be the same as your staging area but I didn't want to do it that way.

The use of the _createrepo_ command won't need to be done manually since the reposync will do it for you and create all
necessary files for you including the config.repo file that is needed.