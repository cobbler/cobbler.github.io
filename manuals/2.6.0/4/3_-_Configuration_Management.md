
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/4_-_Advanced_Topics.html">4</a> <span class="divider">/</span></li><li class="active">Configuration Management</li></ul>
   <h1>Configuration Management</h1>
<p>The initial provisioning of client systems with cobbler is just one component of their management. We also need to consider how to continue to manage them using a configuration management system (CMS). Cobbler can help you provision and introduce a CMS onto your client systems.</p>

<p>One option is cobbler's own lightweight CMS.  For that, see the document <a href="Built%20in%20configuration%20management">Built in configuration management</a>.</p>

<p>Here we discuss the other option: deploying a CMS such as puppet, cfengine, bcfg2, Chef, etc.</p>

<p>Cobbler doesn't force you to chose a particular CMS (or to use one at all), though it helps if you do some things to link cobbler's profiles with the "profiles" of the CMS. This, in general, makes management of both a lot easier.</p>

<p>Note that there are two independent "variables" here: the possible client operating systems and the possible CMSes.  We don't attempt to cover all details of all combinations; rather we illustrate the principles and give a small number of illustrative examples of particular OS/CMS combinations. Currently cobbler has better support for Redhat-based OSes and for Puppet so the current examples tend to deal with this combination.</p>

<h2>Background considerations</h2>

<h3>Machine lifecyle</h3>

<p>A typical computer has a lifecycle something like:</p>

<ul>
<li>installation</li>
<li>initial configuration</li>
<li>ongoing configuration and maintenance</li>
<li>decommissioning</li>
</ul>


<p>Typically installation happens once.  Likewise, the initial configuration happens once, usually shortly after installation.  By contrast ongoing configuration evolves over an extended period, perhaps of several years.  Sometimes part of that ongoing configuration may involve re-installing an OS from scratch.  We can regard this as repeating the earlier phase.</p>

<p>We need not consider decommissioning here.</p>

<p>Installation clearly belongs (in our context) to Cobbler.  In a complementary manner, ongoing configuration clearly belongs to the CMS.  But what about initial configuration?</p>

<p>Some sites consider their initial configuration as the final phase of installation: in our context, that would put it at the back end of Cobbler, and potentially add significant configuration-based complication to the installation-based Cobbler set-up.</p>

<p>But it is worth considering initial configuration as the first step of ongoing configuration: in our context that would put it as part of the CMS, and keep the Cobbler set-up simple and uncluttered.</p>

<h3>Local package repositories</h3>

<p>Give consideration to:</p>

<ul>
<li>local mirrors of OS repositories</li>
<li>local repository of local packages</li>
<li>local repository of pick-and-choose external packages</li>
</ul>


<p>In particular consider having the packages for your chosen CMS in one of the latter.</p>

<h3>Package management</h3>

<p>Some sites set up Cobbler always to deploy just a minimal subset of packages, then use the CMS to install many others in a large-scale fashion.  Other sites may set up Cobbler to deploy tailored sets of packages to different types of machines, then use the CMS to do relatively small-scale fine-tuning of that.</p>

<h2>General scheme</h2>

<p>We need to consider getting Cobbler to install and automatically invoke the CMS software.</p>

<p>Set up Cobbler to include a package repository that contains your chosen CMS:</p>

<pre><code>cobbler repo add ...
</code></pre>

<p>Then (illustrating a Redhat/Puppet combination) set up the kickstart file to say something like:</p>

<pre><code>%packages
puppet

%post
/sbin/chkconfig --add puppet
</code></pre>

<p>The detail may need to be more substantial, requiring some other associated local packages, files and configuration.  You may wish to manage this through <a href="Kickstart%20Snippets">Kickstart snippets</a>.</p>

<h2>Conclusion</h2>

<p>Hopefully this should get you started in linking up your
provisioning configuration with your CMS
implementation. The examples provided are for Puppet, but we can
(in the future) presumably extend --mgmt-classes to work with other
tools ... just let us know what you are interested in, or perhaps
take a shot at creating a patch for it.</p>
