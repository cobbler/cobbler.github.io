---
layout: manpage
title: Settings File
meta: 2.2.3
---
# {{ page.title }} - /etc/cobbler/settings

The main settings file for cobbler is /etc/cobbler/settings. This file is YAML-formatted, so take care when hand-editing this file as an invalid formatting can render both the command-line utility and cobblerd inoperable.

Currently, if you make any changes to this file, you must restart cobblerd for them to take effect.
