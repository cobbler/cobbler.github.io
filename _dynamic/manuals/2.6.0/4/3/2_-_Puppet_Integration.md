---
layout: manpage
title: Puppet Integration
meta: 2.6.0
---

## Puppet support

This example is relatively advanced, involving Cobbler "mgmt-classes" to control different types of initial configuration.
But if instead you opt to put most of the initial configuration into the Puppet CMS rather than here, then things could be simpler.

### Keeping Class Mappings In Cobbler

First, we assign management classes to distro, profile, or system objects.

    cobbler distro edit --name=distro1 --mgmt-classes="distro1"
    cobbler profile add --name=webserver --distro=distro1 --mgmt-classes="webserver likes_llamas" --kickstart=/etc/cobbler/my.ks
    cobbler system edit --name=system --profile=webserver --mgmt-classes="orange" --dns-name=system.example.org

For Puppet, the --dns-name (shown above) must be set because this
is what puppet will be sending to cobbler and is how we find the
system. Puppet doesn't know about the name of the system object in
cobbler. To play it safe you probably want to use the FQDN here
(which is also what you want if you were using Cobbler to manage
your DNS, which you don't have to be doing).

### External Nodes

For more documentation on Puppet's external nodes feature, see docs.puppetlabs.com

Cobbler provides one, so configure puppet to use
`/usr/bin/cobbler-ext-nodes`:

    [main]
    external_nodes = /usr/bin/cobbler-ext-nodes

<div class="alert alert-info alert-block"><b>Note:</b> if you are using puppet 0.24 or later then you will want to</div>
also add the following to your configuration file

    node_terminus = exec

You may wonder what this does. This is just a very simple script
that grabs the data at the following URL, which is a URL that
always returns a YAML document in the way that Puppet expects it to
be returned. This file contains all the parameters and classes that
are to be assigned to the node in question. The magic URL being
visited is powered by Cobbler.

    http://cobbler/cblr/svc/op/puppet/hostname/foo


And this will return data such as:

    ---
    classes:
        - distro1
        - webserver
        - likes_llamas
        - orange
    parameters:
        tree: 'http://.../x86_64/tree'

Where do the parameters come from? Everything that cobbler tracks
in "--ks-meta" is also a parameter. This way you can easily add
parameters as easily as you can add classes, and keep things all
organized in one place.

What if you have global parameters or classes to add? No problem.
You can also add more classes by editing the following fields in
`/etc/cobbler/settings`:

    mgmt_classes: []
    mgmt_parameters:
       from_cobbler: 1

### Alternate External Nodes Script

Attached at puppet\_node.py is an alternate external node script
that fills in the nodes with items from a manifests repository (at
`/etc/puppet/manifests/`) and networking information from cobbler. It
is configured like the above from the puppet side, and then looks
for `/etc/puppet/external_node.yaml` for cobbler side configuration.
The configuration is as follows.

    base: /etc/puppet/manifests/nodes
    cobbler: <%= cobbler_host %>
    no_yaml: puppet::noyaml
    no_cobbler: network::nocobbler
    bad_yaml: puppet::badyaml
    unmanaged: network::unmanaged

The output for network information will be in the form of a pseudo
data structure that allows puppet to split it apart and create the
network interfaces on the node being managed.

