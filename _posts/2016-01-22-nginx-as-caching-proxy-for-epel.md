---
layout: post
title: Using nginx as a caching proxy for EPEL
author: Han Boetes
summary: Using nginx as a caching proxy instead of cloning the whole epel repo
---

There are a lot of useful repositories which I'd gladly mirror. Some are also very very big and you'll only need a few
packages from it. Instead of cloning the whole repository you can also set up a caching proxy. I chose to do it with
nginx. I run nginx on port 81 since 80 is already in use by apache.

First I remove the `server{}` block from the `/etc/nginx/nginx.conf`

    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log;
    pid /run/nginx.pid;
    events {
        worker_connections 1024;
    }
    http {
      log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
      '$status $body_bytes_sent "$http_referer" '
      '"$http_user_agent" "$http_x_forwarded_for"';
      access_log  /var/log/nginx/access.log  main;
      sendfile            on;
      tcp_nopush          on;
      tcp_nodelay         on;
      keepalive_timeout   65;
      types_hash_max_size 2048;
      include             /etc/nginx/mime.types;
      default_type        application/octet-stream;
      include /etc/nginx/conf.d/*.conf;
    }

And created the following code as `/etc/nginx/proxy.conf`

    proxy_redirect          off; 
    proxy_set_header        Host            $host; 
    proxy_set_header        X-Real-IP       $remote_addr; 
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for; 
    client_max_body_size    100m; 
    client_body_buffer_size 1m; 
    proxy_connect_timeout   900; 
    proxy_send_timeout      900; 
    proxy_read_timeout      900; 
    proxy_buffers           32 4k; 
    proxy_cache            STATIC; 
    proxy_cache_valid      365d; 
    proxy_ignore_headers X-Accel-Expires Expires Cache-Control;

And add the following code as `/etc/nginx/conf.d/cacher.conf`

    proxy_cache_path  /var/nginx/cache levels=1 keys_zone=STATIC:50m inactive=200d max_size=12g;
    server {
        listen   81;
        server_name  epel.local ;
        location ~ .rpm$ {
                proxy_pass      http://ftp.nluug.nl;
                include         /etc/nginx/proxy.conf;
        }
        location / {
                proxy_pass      http://ftp.nluug.nl;
        }
    }
    # server {
    #        Same as above, different hosts, etc
    # }

And added a yum repo with this URL:

    http://${http_server}:81/pub/os/Linux/distr/fedora-epel/7/x86_64/

Fired up `nginx`, ran `cobbler reposync --only=epel` and `cobbler sync` and there you have it.

[Credit, where credit is due.](http://sysops.pblogs.gr/2012/06/rpm-caching-proxy-for-yum-zypper-kiwi-similar-to-apt-cacher-usin.html)