---
layout: post
title: Official community repositories
author: Enno
summary: OBS based community repositories for RPMs and DEBs
---

After a long time of not being able to provide community repositories that allow for seamless updates of Cobbler
versions, we can finally announce that they are back!

Here are the link for the different Cobbler versions[^1]:

- Cobbler 3.0.x: <https://software.opensuse.org/download/package?package=cobbler&project=systemsmanagement%3Acobbler%3Arelease30>
- Cobbler 3.1.x: <https://software.opensuse.org/download/package?package=cobbler&project=systemsmanagement%3Acobbler%3Arelease31>
- Cobbler 3.2.x: <https://software.opensuse.org/download/package?package=cobbler&project=systemsmanagement%3Acobbler%3Arelease32>
- Cobbler 3.3.x: <https://software.opensuse.org/download/package?package=cobbler&project=systemsmanagement%3Acobbler%3Arelease33>

These repositories (and future ones for newer version of Cobbler) can be also found on our Website:

- Cobbler 3: https://cobbler.github.io/downloads/2.x.x.html
- Cobbler 2: https://cobbler.github.io/downloads/3.x.x.html

In case you want to build the packages from source or locally for yourself you can find the instructions here:
https://cobbler.readthedocs.io/en/latest/installation-guide.html

### How to use the OBS repositories with the major package providers?

OBS repositories offer the benefit that it automatically rebuilds your package based on updates of transitive
dependencies. As such you can always be sure that your package is compatible with the installed software on your system. 

#### openSUSE

```shell
zypper addrepo https://download.opensuse.org/repositories/systemsmanagement:cobbler:<cobbler branch>/<os version>/systemsmanagement:cobbler:<cobbler branch>.repo
zypper refresh
zypper install cobbler
```

#### RedHat based distributions

```shell
cd /etc/yum.repos.d/
wget https://download.opensuse.org/repositories/systemsmanagement:cobbler:<cobbler branch>/<os version>/systemsmanagement:cobbler:<cobbler branch>.repo
yum install cobbler
```

#### Ubuntu

```shell
echo 'deb http://download.opensuse.org/repositories/systemsmanagement:/cobbler:/<cobbler branch>/<os version>/ /' | sudo tee /etc/apt/sources.list.d/systemsmanagement:cobbler:<cobbler branch>.list
curl -fsSL https://download.opensuse.org/repositories/systemsmanagement:cobbler:<cobbler branch>/<os version>/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/systemsmanagement_cobbler_<cobbler branch>.gpg > /dev/null
sudo apt update
sudo apt install cobbler
```

### Closing remarks

We do hope that those repositories find wider adoption for those people that either need a specific version of Cobbler
or don't have Cobbler submitted in their operating system. Please do request support for new operating systems as a
[GitHub Issue](https://github.com/cobbler/cobbler/issues/new?assignees=&labels=enhancement&projects=&template=02_feature_request.md&title=).

Please don't attempt to use the RPMs for operating systems that they are not built for. It will cause issues that are
hard to debug. We are attempting to progress a container based release for Cobbler that enables everyone to use it on
their operating system of choice.

### Footnotes

[^1]: These repositories are provided without any kind of warranty and "as is".
