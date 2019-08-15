---
layout: manpage
title: Dynamic Settings CLI Command
meta: 2.6.0
---

<p>The CLI command for dynamic settings has two sub-commands:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler setting --help</p>

<h1>usage</h1>

<p>cobbler setting edit
cobbler setting report</code></pre></figure></p>

<h3>cobbler setting edit</h3>

<p>This command allows you to modify a setting on the fly. It takes affect immediately, however depending on the setting you change, a "cobbler sync" may be required afterwards in order for the change to be fully applied.</p>

<p>This syntax of this command is as follows:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler setting edit --name=option --value=value</code></pre></figure></p>

<p>As with other cobbler primitives, settings that are array-based should be space-separated while hashes should be a space-separated list of key=value pairs.</p>

<h3>cobbler setting report</h3>

<p>This command prints a report of the current settings. The syntax of this command is as follows:</p>

<p><figure class="highlight"><pre><code class="language-bash" data-lang="bash">$ cobbler setting report [--name=option]</code></pre></figure></p>

<p>The list of settings can be limited to a single setting by specifying the --name option.</p>
