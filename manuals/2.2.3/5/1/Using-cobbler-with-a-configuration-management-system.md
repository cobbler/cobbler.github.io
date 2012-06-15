The initial provisioning of client systems with cobbler is just one component of their management. We also need to consider how to continue to manage them using a configuration management system (CMS). Cobbler can help you provision and introduce a CMS onto your client systems.

One option is cobbler's own lightweight CMS.  For that, see the document [Built in configuration management](Built in configuration management).

Here we discuss the other option: deploying a CMS such as puppet, cfengine, bcfg2, Chef, etc. 

Cobbler doesn't force you to chose a particular CMS (or to use one at all), though it helps if you do some things to link cobbler's profiles with the "profiles" of the CMS. This, in general, makes management of both a lot easier.

Note that there are two independent "variables" here: the possible client operating systems and the possible CMSes.  We don't attempt to cover all details of all combinations; rather we illustrate the principles and give a small number of illustrative examples of particular OS/CMS combinations. Currently cobbler has better support for Redhat-based OSes and for Puppet so the current examples tend to deal with this combination.

## Background considerations

### Machine lifecyle

A typical computer has a lifecycle something like:

* installation
* initial configuration
* ongoing configuration and maintenance
* decommissioning

Typically installation happens once.  Likewise, the initial configuration happens once, usually shortly after installation.  By contrast ongoing configuration evolves over an extended period, perhaps of several years.  Sometimes part of that ongoing configuration may involve re-installing an OS from scratch.  We can regard this as repeating the earlier phase.

We need not consider decommissioning here.

Installation clearly belongs (in our context) to Cobbler.  In a complementary manner, ongoing configuration clearly belongs to the CMS.  But what about initial configuration?

Some sites consider their initial configuration as the final phase of installation: in our context, that would put it at the back end of Cobbler, and potentially add significant configuration-based complication to the installation-based Cobbler set-up. 

But it is worth considering initial configuration as the first step of ongoing configuration: in our context that would put it as part of the CMS, and keep the Cobbler set-up simple and uncluttered.

### Local package repositories

Give consideration to:

* local mirrors of OS repositories
* local repository of local packages
* local repository of pick-and-choose external packages

In particular consider having the packages for your chosen CMS in one of the latter.

### Package management

Some sites set up Cobbler always to deploy just a minimal subset of packages, then use the CMS to install many others in a large-scale fashion.  Other sites may set up Cobbler to deploy tailored sets of packages to different types of machines, then use the CMS to do relatively small-scale fine-tuning of that.

## General scheme

We need to consider getting Cobbler to install and automatically invoke the CMS software.

Set up Cobbler to include a package repository that contains your chosen CMS:

    cobbler repo add ...

Then (illustrating a Redhat/Puppet combination) set up the kickstart file to say something like:

    %packages
    puppet

    %post
    /sbin/chkconfig --add puppet
    
The detail may need to be more substantial, requiring some other associated local packages, files and configuration.  You may wish to manage this through [Kickstart snippets](Kickstart Snippets).

David Lutterkort has a [walkthrough for kickstart] (http://watzmann.net/blog/2006/12/kickstarting-into-puppet.html).
While his example is written for Redhat (Fedora) and Puppet, the principles are useful for other OS/CMS combinations.

## Puppet support

This example is relatively advanced, involving Cobbler "mgmt-classes" to control different types of initial configuration. But if instead you opt to put most of the initial configuration into the Puppet CMS rather than here, then things could be simpler.

### Keeping Class Mappings In Cobbler

First, we assign management classes to distro, profile, or system
objects.

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
/usr/bin/cobbler-ext-nodes:

    [main]
    external_nodes = /usr/bin/cobbler-ext-nodes

Note: if you are using puppet 0.24 or later then you will want to
also add the following to your configuration file

    node_terminus = exec

You may wonder what this does. This is just a very simple script
that grabs the data at the following URL, which is a URL that
always returns a YAML document in the way that Puppet expects it to
be returned. This file contains all the parameters and classes that
are to be assigned to the node in question. The magic URL being
visited is powered by Cobbler.

    http://cobbler/cblr/svc/op/puppet/hostname/foo

(for developer information about this magic URL, visit
[https://fedorahosted.org/cobbler/wiki/ModPythonDetails](https://fedorahosted.org/cobbler/wiki/ModPythonDetails)
)

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
/etc/cobbler/settings:

    
    # cobbler has a feature that allows for integration with config management
    # systems such as Puppet.  The following parameters work in conjunction with 
    
    # --mgmt-classes  and are described in furhter detail at:
    # https://fedorahosted.org/cobbler/wiki/UsingCobblerWithConfigManagementSystem
    mgmt_classes: []
    mgmt_parameters:
       from_cobbler: 1

### Alternate External Nodes Script

Attached at puppet\_node.py is an alternate external node script
that fills in the nodes with items from a manifests repository (at
/etc/puppet/manifests/) and networking information from cobbler. It
is configured like the above from the puppet side, and then looks
for /etc/puppet/external\_node.yaml for cobbler side configuration.
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

## Chef support

Documentation to be added

## cfengine support

Documentation to be added

## bcfg2 support

Documentation to be added

## Conclusion

Hopefully this should get you started in linking up your
provisioning configuration with your CMS
implementation. The examples provided are for Puppet, but we can
(in the future) presumably extend --mgmt-classes to work with other
tools ... just let us know what you are interested in, or perhaps
take a shot at creating a patch for it.

### Attachments

-   [puppet\_node.py](/cobbler/attachment/wiki/UsingCobblerWithConfigManagementSystem/puppet_node.py)
    (2.5 kB) -Alternate External Nodes Script, added by shenson on
    12/09/10 20:33:36.

