---
layout: post
title: Cobbler Roadmap Update
author: Enno
summary: Status of the current roadmap
---

> TLDR: The current roadmap can be found [here](https://github.com/cobbler/cobbler/wiki/Roadmap)

A new year requires a new Roadmap update. This time there are no changes in the roadmap itself, just in the date of
delivery.

## Server

### 3.4.0

Due to the extensive performance problems, the project teams wants to reintroduce the internal Cache of Cobbler, to
speed things up from an end-user perspective. This cache however is not trivial to implement and thus the release 3.4.0
is still in development. We are getting there but at the time of writing there are still
[16 open issues](https://github.com/orgs/cobbler/projects/2/views/4) for the milestone.

Please be aware that after all issues are done we will not tag the release but we will instead implement the WebUI and
Golang CLI (with its client). After that, we will test the integration of all components and only if the quality is
satisfactory, we will tag 3.4.0.

### 3.3.4

Although in the [GH project](https://github.com/orgs/cobbler/projects/2/views/8) no progress is visible, the
[SUSE Manager](https://www.suse.com/de-de/solutions/manager/) development team is currently working to stabilise the
release and afterwards provide 3.3.4 for the community. However atm this stabilisation phase is not finished and thus it
will take a while. No exact dates have been confirmed for this release yet.

### 3.2.3

After the current two open PRs are merged we can release the version and hopefully close the chapter of 3.2.x for
good.

Progress can be monitored [here](https://github.com/orgs/cobbler/projects/2/views/3).

## cobblerclient

Here we have hit a temporary roadblock sadly due to
[a problem with implementing inheritance](https://github.com/cobbler/cobblerclient/issues/4#issuecomment-1402503157).
The problem will get solved after there is no more work done on the Cobbler server part.

## Golang CLI

This is purely dependent on the cobblerclient and thus no progress has been made in the last months sadly.

## Web Interface

The Web UI is still lacking a dedicated maintainer and thus no work could be done on the repository. Thus it needs to
wait until the server-side work for 3.4.0 is completed. After that, the project team will work on finishing up the
implementation of the XML-RPC Typescript API Client for the Angular web interface. After that, the user's noticeable
changes will start to slowly appear.

---

P.S.: In case your find typos and/or grammar mistakes just
[open an Issue](https://github.com/cobbler/cobbler.github.io/issues/new) or
[open a PR](https://github.com/cobbler/cobbler.github.io/compare).
