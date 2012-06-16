---
layout: manpage
title: Cobbler Manual - Settings
---
allow_duplicate_hostnames               : 0
allow_duplicate_ips                     : 0
allow_duplicate_macs                    : 0
allow_dynamic_settings                  : 0
anamon_enabled                          : 0
bind_chroot_path                        : /
bind_master                             : 127.0.0.1
build_reporting_email                   : ['root@localhost']
build_reporting_enabled                 : 0
build_reporting_sender                  :
build_reporting_smtp_server             : localhost
build_reporting_subject                 :
build_reporting_to_address              :
buildisodir                             : /var/cache/cobbler/buildiso
cheetah_import_whitelist                : ['random', 're', 'time']
client_use_localhost                    :
cobbler_master                          :
consoles                                : /var/consoles
createrepo_flags                        : -c cache -s sha --update
default_deployment_method               : ssh
default_kickstart                       : /var/lib/cobbler/kickstarts/default.ks
default_name_servers                    : []
default_name_servers_search             : []
default_ownership                       : ['admin']
default_password_crypted                : $1$wrWZXfa7$Ts7jMmpdZkTlu0lSx1A/I/
default_template_type                   : cheetah
default_virt_bridge                     : xenbr0
default_virt_disk_driver                : raw
default_virt_file_size                  : 5
default_virt_ram                        : 512
default_virt_type                       : xenpv
enable_gpxe                             : 0
enable_menu                             : 1
func_auto_setup                         : 0
func_master                             : overlord.example.org
http_port                               : 80
isc_set_host_name                       : 0
iso_template_dir                        : /etc/cobbler/iso
kerberos_realm                          : EXAMPLE.COM
kernel_options                          : {'ksdevice': 'bootif', 'lang': ' ', 'text': '~'}
kernel_options_s390x                    : {'vnc': '~', 'ip': False, 'RUNKS': 1, 'ramdisk_size': 40000, 'ro': '~', 'root': '/dev/ram0'}
ldap_anonymous_bind                     : 1
ldap_base_dn                            : DC=example,DC=com
ldap_management_default_type            : authconfig
ldap_port                               : 389
ldap_search_bind_dn                     :
ldap_search_passwd                      :
ldap_search_prefix                      : uid=
ldap_server                             : ldap.example.com
ldap_tls                                : 1
manage_dhcp                             : 1
manage_dns                              : 0
manage_forward_zones                    : []
manage_reverse_zones                    : []
manage_rsync                            : 0
manage_tftp                             : 1
manage_tftpd                            : 1
mgmt_classes                            : []
mgmt_parameters                         : {'from_cobbler': 1}
next_server                             : 1.1.1.1
power_management_default_type           : ipmitool
power_template_dir                      : /etc/cobbler/power
puppet_auto_setup                       : 1
puppetca_path                           : /usr/sbin/puppetca
pxe_just_once                           : 0
pxe_template_dir                        : /etc/cobbler/pxe
redhat_management_key                   :
redhat_management_permissive            : 0
redhat_management_server                : xmlrpc.rhn.redhat.com
redhat_management_type                  : off
register_new_installs                   : 0
remove_old_puppet_certs_automatically   : 1
replicate_rsync_options                 : -avzH
reposync_flags                          : -l -m -d
restart_dhcp                            : 1
restart_dns                             : 1
restart_xinetd                          : 1
run_install_triggers                    : 1
scm_track_enabled                       : 0
scm_track_mode                          : git
serializer_pretty_json                  : 0
server                                  : 1.1.1.1
sign_puppet_certs_automatically         : 0
snippetsdir                             : /var/lib/cobbler/snippets
template_remote_kickstarts              : 0
virt_auto_boot                          : 1
webdir                                  : /var/www/cobbler
xmlrpc_port                             : 25151
yum_distro_priority                     : 1
yum_post_install_mirror                 : 1
yumdownloader_flags                     : --resolve
