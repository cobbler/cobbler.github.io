---
layout: manpage
title: Digest Authentication
meta: 2.4.0
---


As of Cobbler 2.2.0, digest authentication with Apache is no longer supported due to the fact that we have moved to a session/token based authentication and form-based login scheme with the new Web UI. Unfortunately, digest authentication does not work with this method, so we now recommend using PAM or one of the other authentication schemes.
