---
layout: manpage
title: Cobbler Check
meta: 2.8.0
nav: 1 - Check
navversion: nav28
---

The check command is used to provide information to the user regarding possible issues with their installation. Many of
these checks are feature-based, and may not show up depending on the features you have enabled in Cobbler.

One of the more important things to remember about the check command is that the output contains suggestions, and not
absolutes. That is, the check output may always show up (for example, the SELinux check when it is enabled on the
system), or the suggested remedy is not required to make Cobbler function properly (for example, the firewall checks).
It is very important to evaluate each item in the listed output individually, and not be concerned with them unless you
are having definite problems with functionality.

**Example:**

{% highlight bash %}
$ cobbler check
The following are potential configuration items that you may want to fix:

1 : SELinux is enabled. Please review the following wiki page for details on ensuring cobbler works correctly in your SELinux environment:
    https://github.com/cobbler/cobbler/wiki/Selinux
2 : comment 'dists' on /etc/debmirror.conf for proper debian support
3 : comment 'arches' on /etc/debmirror.conf for proper debian support
4 : Dynamic settings changes are enabled, be sure you run "sed -i 's/^[[:space:]]\+/ /' /etc/cobbler/settings" to ensure the settings file is properly indented

Restart cobblerd and then run 'cobbler sync' to apply changes.
{% endhighlight %}
