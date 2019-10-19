---
layout: manpage
title: Reposync
meta: 2.6.0
nav: 5 - Reposync
navversion: nav26
---

Yum repository management is an optional feature, and is not required to provision through cobbler. However, if cobbler
is configured to mirror certain repositories, it can then be used to associate profiles with those repositories. Systems
installed under those profiles will then be autoconfigured to use these repository mirrors in
<code>/etc/yum.repos.d</code>, and if supported (Fedora Core 6 and later) these repositories can be leveraged even
within Anaconda. This can be useful if (A) you have a large install base, (B) you want fast installation and upgrades
for your systems, or (C) have some extra software not in a standard repository but want provisioned systems to know
about that repository.

Make sure there is plenty of space in cobbler’s webdir, which defaults to `/var/www/cobbler`.

`$ cobbler reposync [--tries=N] [--no-fail]`

Cobbler reposync is the command to use to update repos as configured with `cobbler repo add`. Mirroring can take a long
time, and usage of `cobbler reposync` prior to usage is needed to ensure provisioned systems have the files they need to
actually use the mirrored repositories. If you just add repos and never run `cobbler reposync`, the repos will never be
mirrored. This is probably a command you would want to put on a crontab, though the frequency of that crontab and where
the output goes is left up to the systems administrator.

For those familiar with yum’s reposync, cobbler’s reposync is (in most uses) a wrapper around the yum command. Please
use `cobbler reposync` to update cobbler mirrors, as yum’s reposync does not perform all required steps. Also cobbler
adds support for rsync and SSH locations, where as yum’s reposync only supports what yum supports (http/ftp).

If you ever want to update a certain repository you can run: `$ cobbler reposync --only="reponame1" ...`

When updating repos by name, a repo will be updated even if it is set to be not updated during a regular reposync
operation (ex: cobbler repo edit --name=reponame1 --keep-updated=0).

Note that if a cobbler import provides enough information to use the boot server as a yum mirror for core packages,
cobbler can set up kickstarts to use the cobbler server as a mirror instead of the outside world. If this feature is
desirable, it can be turned on by setting `yum_post_install_mirror` to 1 in `/etc/cobbler/settings` (and running
`cobbler sync`). You should not use this feature if machines are provisioned on a different VLAN/network than
production, or if you are provisioning laptops that will want to acquire updates on multiple networks.

The flags `--tries=N` (for example, `--tries=3`) and `--no-fail` should likely be used when putting reposync on a
crontab. They ensure network glitches in one repo can be retried and also that a failure to synchronize one repo does
not stop other repositories from being synchronized.
