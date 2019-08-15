---
layout: manpage
title: File System ACLs
meta: 2.6.0
---

<p>Cobbler contains an "aclsetup" command for automation of setting up file system acls (i.e. setfacl) on directories that cobbler needs to read and write to.</p>

<h2>Using File System ACLs</h2>

<p>Usage of this command allows the administrator to grant access to other users without granting them the ability to run cobbler as root.</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler aclsetup --help
Usage: cobbler aclsetup  [ARGS]</p>

<p>Options:
  -h, --help            show this help message and exit
  --adduser=ADDUSER     give acls to this user
  --addgroup=ADDGROUP   give acls to this group
  --removeuser=REMOVEUSER
                        remove acls from this user
  --removegroup=REMOVEGROUP
                        remove acls from this group</code></pre></figure></p>

<p>Example:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler aclsetup --adduser=timmy</code></pre></figure></p>

<p>The above example gives timmy access to run cobbler commands.</p>

<p>Note that aclsetup does grant access to configure all of <code>/etc/cobbler</code>, <code>/var/www/cobbler</code>, and <code>/var/lib/cobbler</code>, so it is still rather powerful in terms of the access it grants (though somewhat less so than providing root).</p>

<p>A user with acls can, for instance, edit cobbler triggers which are later run by cobblerd (as root). In this event, cobbler access (either sudo or aclsetup) should not be granted to users you do not trust completely. This should not be a major problem as in giving them access to configure future aspects of your network (via the provisioning server) they are already being granted fairly broad rights.</p>

<p>It is at least nicer than running "sudo" all of the time if you were going to grant a user "no password" sudo access to cobbler.</p>
