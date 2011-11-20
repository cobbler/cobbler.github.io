---
layout:default
title:Cobbler in plain English
----

Gluing your Linux infrastructure together
-----------------------------------------

Linux systems management is typically an assortment of apps that don't really talk to each other.  Cobbler is largely glue that makes all the tasks related to roling out systems substantially easier, by automating repeated tasks.  Cobbler is not like Puppet, Chef, and cfengine, but is complementary to those tools.  While configuration management deals with existing systems, Cobbler helps you create them.

Lightweight Automation
----------------------

Cobbler is a small and lightweight application (about 15k lines of Python code) containing a daemon (cobblerd), a command line client, and an optional web interface. It tries to be extremely simple to use both for very small and very large installations -- as well as easy to work on, extend, and hack. It avoids being "enterprisey" (as in complicated or overly resource consuming) whenever possible, but is highly useful in all sorts of enterprises by having a lot of advanced features and doing small things to save a large amount of time in repeated tasks.

Batteries Included
------------------

Cobbler can also optionally help with managing DHCP, DNS, and yum package mirroring infrastructure -- in this regard, it is a more generalized automation app, rather than just dealing specifically with installations. There is also a lightweight built-in configuration management system, as well as support for integrating with configuration management systems like Puppet or Chef.

DevOps friendly
---------------

Cobbler has a command line interface, a web interface (screenshot), and also several API access options. That may sound like a lot, but it's really pretty simple. New users may like to start with the web app after doing the initial setup steps on the command line (cobbler check; cobbler import) as it will give them a good idea of all of the features available. Advanced features don't have to be understood all at once, they can be incorporated over time as the need for them arises.

