---
layout: post
title: Creating custom apt repositories in centos or el based cobbler
author: Alastair Munro
summary: Creating custom apt repositories in centos or el based cobbler
---

# Introduction

I setup a build for ubuntu 12.04 and found that the standard alt/server iso's were missing some basic packages like ntp
and autofs. Seems like Canonical were not serious about ubuntu as a server OS at this time, but 14.04 does have these
important packages. 

Also we have a policy of not installing from internet apt repos and most servers don't have internet access, so I had to
work out how to create custom apt repos that we could drop .deb packages into. Once you have a custom apt repo, you can
then drop deb packages into it and rebuild it, as required. For example you may have proprietary software that should be
in a repo.

I could have rebuild the 12.04 distro and added the missing packages, however that makes it non standard and ubuntu do
release updates from time to time (we are currently up to 12.04.5). Thus I decided to create a custom repo.

Note that you need to use the alt/server iso's for cobbler as these are the ones that support the debian installer, as
apposed to the desktop iso's that use the ubuntu installer called Ubiquity.

Ideally you should create a custom apt tied to a particular OS release. Thus create one for ubuntu 12.04 and one for
14.04, etc.

ubuntu 14.04 now supports kickstarting; check the install guide for details on this.

Its probably wise to stick with the ubuntu Long Term Support (LTS) releases. A new release of Ubuntu comes out every 6
months and the LTS releases come out every 2 years and are supported for 5 years.

This is how to setup a apt repo on a centos/el based cobbler. That is the os does not natively know how to deal with deb
packages or apt repos. Also this is tested with ubuntu; it would probably work with debian.

I mainly followed this guide:
[](http://troubleshootingrange.blogspot.co.uk/2012/09/hosting-simple-apt-repository-on-centos.html).
Credit to that author :)

# Setup el for debian packages

This is what I had to do on centos 6.5:

Add the epel repo (download the epel rpm for setting this up), then add these deb compat packages:

    # yum install dpkg dpkg-devel gnupg2 perl-TimeDate

For Centos 6.9 at least, the following package also needed to be installed in order to give me dpkg-scanpackages:

  #yum install dpkg-dev

# Add a apt repo to cobbler

Go to the cobbler web page click on Repos then New repo:
* Set arch to x86_64.
* breed apt.
* Untick keep updated (not being synced from a remote repo).
* Give it a name (I called it my-ub1204-x86_64). Apt supports multiple archs in a repo, but cobbler restricts to a
  single architecture.
* Set Apt Components: main
* Set Apt Dist: stable

If you are using the command line, the repo will look like this:

    # cobbler repo report --name=my-ub1204-x86_64
      Name                           : my-ub1204-x86_64
      Apt Components (apt only)      : ['main']
      Apt Dist Names (apt only)      : ['stable']
      Arch                           : x86_64
      Breed                          : apt
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

Now create a dir for the new repo; these go under /var/www/cobbler/repo_mirror:

     # mkdir /var/www/cobbler/repo_mirror/my-ub1204-x86_64

Additional dirs are needed under there:

     # cd /var/www/cobbler/repo_mirror/my-ub1204-x86_64
     # mkdir -p pool/main dists/stable/main/binary-i386 dists/stable/main/binary-amd64

Copy your custom .deb packages into the pool/main dir.

# Generate pgp keys for the repo

We need to generate a pgp key as apt uses keys, unless you wish to confirm every install? There is this seed setting
that allows you to do unauthenticated installs, but you will probably get issues when you boot your target OS:

     d-i debian-installer/allow_unauthenticated boolean true

Thus it's best to set up a key:

     # gpg --gen-key
      gpg (GnuPG) 2.0.14; Copyright (C) 2009 Free Software Foundation, Inc.
      This is free software: you are free to change and redistribute it.
      There is NO WARRANTY, to the extent permitted by law.

      gpg: directory `/root/.gnupg' created
      gpg: new configuration file `/root/.gnupg/gpg.conf' created
      gpg: WARNING: options in `/root/.gnupg/gpg.conf' are not yet active during this run
      gpg: keyring `/root/.gnupg/secring.gpg' created
      gpg: keyring `/root/.gnupg/pubring.gpg' created
     Please select what kind of key you want:
        (1) RSA and RSA (default)
        (2) DSA and Elgamal
        (3) DSA (sign only)
        (4) RSA (sign only)
     Your selection? 1
     RSA keys may be between 1024 and 4096 bits long.
     What keysize do you want? (2048)
     Requested keysize is 2048 bits
     Please specify how long the key should be valid.
              0 = key does not expire
           <n>  = key expires in n days
           <n>w = key expires in n weeks
           <n>m = key expires in n months
           <n>y = key expires in n years
     Key is valid for? (0)
     Key does not expire at all
     Is this correct? (y/N) y

I did not add a passphrase. It can take a while to generate!

List your keys, and then pick the key you generated:

     # gpg --list-keys
     /root/.gnupg/pubring.gpg
     ------------------------
     pub   2048R/297776F1 2014-09-19
     uid                  myuser <myuser@somewhere.com>
     sub   2048R/37C7C29C 2014-09-19

Export the public key and put it somewhere on the repo:

     # gpg --export -a 297776F1 > ~/junk.key
     # gpg --no-default-keyring --keyring /var/www/cobbler/repo_mirror/my-ub1204-x86_64/public.pgp --import ~/junk.key
     # rm -f ~/junk.key
     # chmod a+r /var/www/cobbler/repo_mirror/my-ub1204-x86_64/public.pgp

# Create and run script to generate apt required bits

Create a reindex_apt.sh script (see at the end of this mail); adapt/edit to include the correct GPG_NAME, version and
details in the release file. Then run it to create all the things needed for the apt repo:

     # cd /var/www/cobbler/repo_mirror/my-ub1204-x86_64
     # chmod u+x ./reindex_apt.sh
     # ./reindex_apt.sh

Now you need to attach the repo to you profile. Eg click on ub12045-alt or whatever your main profile for ubuntu 12.04
is (or the profile created when you imported the repo). Under repos select my-ub1204-x86_64 and click on the >> to
add it.

The snippet preseed_apt_repo_config adds the additional repos but does not add the pub pgp key. I am not sure what the
proper process is for this. I copied this snippet to preseed_apt_repo_config_pgpkeys, adapt the copy and then call it
in the seed file. See the adapted snippet at the end of this.

If you add or change the .deb's in the repo, rerun the script you created earlier.

# reindex_apt.sh

This script lives in the apt repo dir (eg /var/www/cobbler/repo_mirror/my-ub1204-x86_64) and is used for creating apt
structures and recreating them when you add/remove .deb package (run it again). Don't forget to customize with the
correct key, version, label, origin, etc:

     #!/bin/bash

     GPG_NAME=297776F1
     REPONAME=stable
     VERSION=1.0

     for bindir in `find dists/${REPONAME} -type d -name "binary*"`; do
         arch=`echo $bindir|cut -d"-" -f 2`
         echo "Processing ${bindir} with arch ${arch}"

         overrides_file=/tmp/overrides
         package_file=$bindir/Packages
         release_file=$bindir/Release

         # Create simple overrides file to stop warnings
         cat /dev/null > $overrides_file
         for pkg in `ls pool/main/ | grep -E "(all|${arch})\.deb"`; do
             pkg_name=`/usr/bin/dpkg-deb -f pool/main/${pkg} Package`
             echo "${pkg_name} Priority extra" >> $overrides_file
         done

         # Index of packages is written to Packages which is also zipped
         dpkg-scanpackages -a ${arch} pool/main $overrides_file > $package_file
         # The line above is also commonly written as:
         # dpkg-scanpackages -a ${arch} pool/main /dev/null > $package_file
         gzip -9c $package_file > ${package_file}.gz
         bzip2 -c $package_file > ${package_file}.bz2

         # Cleanup
         rm $overrides_file
     done

     # Release info goes into Release & Release.gpg which includes an md5 & sha256 hash of Packages.*
     # Generate & sign release file
     cd dists/${REPONAME}
     cat > Release <<ENDRELEASE
     Suite: ${REPONAME}
     Version: ${VERSION}
     Component: main
     Origin: somewhere
     Label: my-ub1204-x86_64
     Architecture: i386 amd64
     Date: `date -R -u`
     ENDRELEASE

     # Generate hashes
     echo "MD5Sum:" >> Release
     for hashme in `find main -type f`; do
         md5=`openssl dgst -md5 ${hashme}|cut -d" " -f 2`
         size=`stat -c %s ${hashme}`
         echo " ${md5} ${size} ${hashme}" >> Release
     done
     echo "SHA256:" >> Release
     for hashme in `find main -type f`; do
         sha256=`openssl dgst -sha256 ${hashme}|cut -d" " -f 2`
         size=`stat -c %s ${hashme}`
         echo " ${sha256} ${size} ${hashme}" >> Release
     done

     # Sign!
     gpg --yes -u $GPG_NAME --digest-algo SHA256 --sign -bao Release.gpg Release
     cd -

# Apt repo preseed snippet

Copy snippet preseed_apt_repo_config to preseed_apt_repo_config_pgpkey, and then adapt the copy. Seed file now calls
preseed_apt_repo_config_pgpkey.

     ## A Munro: 19 Sep 2014: Add pgp keys in as well
     ## A Munro: 15 Oct 2014: 1404 has a different format for sources.list
     # Additional repositories, local[0-9] available
     #set $os_v = $getVar('os_version','')
     ##
     #if $os_v and $os_v.lower()[0] >= 't'
     #set $deb="deb"
     #else
     #set $deb=""
     #end if
     ##
     #set $cur=0
     #set $repo_data = $getVar("repo_data",[])
     #for $repo in $repo_data
     #for $dist in $repo.apt_dists
     #set $comps = " ".join($repo.apt_components)
     d-i apt-setup/local${cur}/repository string \
     #if $repo.mirror_locally
           $deb http://$http_server/cblr/repo_mirror/${repo.name} $dist $comps
     #else
           $deb ${repo.mirror} $dist $comps
     #end if
     #if $repo.comment != ""
     d-i apt-setup/local${cur}/comment string ${repo.comment}
     #end if
     #if $repo.breed == "src"
     # Enable deb-src lines
     d-i apt-setup/local${cur}/source boolean false
     #end if
     # Add repo pgp pub key
     d-i apt-setup/local${cur}/key string \
           http://$http_server/cblr/repo_mirror/${repo.name}/public.pgp
     #set $cur=$cur+1
     #end for