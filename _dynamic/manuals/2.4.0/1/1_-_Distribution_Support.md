---
layout: manpage
title: Distribution Support
meta: 2.4.0
---

Cobbler currently supports importing a wide array of distributions from many vendors. However, since Cobbler has a history rooted in Red Hat based distributions, support for them is definitely the strongest. For others, the level of support varies from very good to requiring a lot of manual steps to get things working smoothly.

Here is the full list of supported distributions. 

Key:

<ul>
 <li><i class="icon-ok-sign text-success"></i> Fully supported</li>
 <li><i class="icon-wrench"></i> Some support, not 100%</li>
 <li><i class="icon-ban-circle text-error"></i> Not supported, or significant manual action required</li>
</ul>

<table class="table table-hover">
 <tr>
  <td class=""></td>
  <td class=""></td>
  <td class="center span1">Import</td>
  <td class="center span1">Import<br/>--available-as</td>
  <td class="center span1">PXE</td>
  <td class="center span1">Build ISO</td>
  <td class="center span1">Snippets</td>
 </tr>
 <tr>
  <td colspan="7">Red Hat</td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">Fedora 16</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">Fedora 17</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">Fedora 18 (beta)</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">RHEL/CentOS 4</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">RHEL/CentOS 5</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">RHEL/CentOS 6</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
 </tr>
 <tr>
  <td colspan="7">Ubuntu</td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">Oneiric</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">Precise</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">Quantal</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td colspan="7">Debian</td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">Squeeze</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td colspan="7">SuSE</td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">OpenSuSE 11.2</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">OpenSuSE 11.3</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">OpenSuSE 11.4</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">OpenSuSE 12.1</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">OpenSuSE 12.2</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td colspan="7">VMware</td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">ESX 4</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">ESXi 4</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">ESXi 5</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
 </tr>
 <tr>
  <td colspan="7">FreeBSD</td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">8.2</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">8.3</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
 </tr>
 <tr>
  <td class="span2"></td>
  <td class="span2">9.0</td>
  <td class="center span1"><i class="icon-ok-sign text-success"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-wrench"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
  <td class="center span1"><i class="icon-ban-circle text-error"></i></td>
 </tr>
</table>

<div class="alert alert-info alert-block"><b>Note:</b> This list does not include support for images, which can be just about any OS.</div>
