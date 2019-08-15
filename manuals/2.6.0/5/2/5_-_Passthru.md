
<!-- begin content -->

<div id="wrap" class="container">
 <div class="row">
  <div class="span8">
<ul class="breadcrumb"><li><a href="/manuals">manuals</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0">2.6.0</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/5_-_Web_Interface.html">5</a> <span class="divider">/</span></li><li><a href="/manuals/2.6.0/5/2_-_Web_Authentication.html">2</a> <span class="divider">/</span></li><li class="active">Passthru Authentication</li></ul>
   <h1>Passthru Authentication</h1>
<p>Passthru authentication has been added back to Cobbler Web as of version 2.6.0.  Passthru authentication allows you to setup your webserver to perform authentication and Cobbler Web will use the value of REMOTE_USER to determine authorization.  Using this authentication module disables the normal web form authentication which was added in Cobbler Web 2.2.0.  If you prefer to use web form authentication we recommend using PAM or one of the other authentication schemes.</p>

<p>A common reason you might want to use Passthru authentication is to provide support for single sign on authentication like Kerberos.  An example of setting this up can be found <a href="http://linux3.julienfamily.com/manuals/2.6.0/6/2/3_-_Kerberos.html">here.</a></p>
