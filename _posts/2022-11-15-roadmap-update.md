---
layout: post
title: Cobbler Roadmap Update
author: Enno
summary: Status of the current roadmap
---

> TLDR: The current roadmap can be found [here](https://github.com/cobbler/cobbler/wiki/Roadmap)

Now a summary of things that has happened in the last months and what is about to come for those of you with more time
to read.

## Cobbler 3.3.x

For 3.3.4 there is no due date, but we require it definitely. I will thus include more bugfixes if they are provided by
the community or required by SUSE Manager. Latest point when I will tag 3.3.4 will be directly after 3.4.0. More
releases in the series will be created as needed. The more
[Backport requests](https://github.com/cobbler/cobbler/issues/new?assignees=&labels=backport&template=03_backport_request.md&title=%5BBackport%5D+Your+title)
are correctly created and then directly contributed as a PR or made by me, the better support the series will get.

However, please keep in mind I will refuse to merge features or backport them myself since with 3.4.0 the codebase
is very different due to the introduction of the Black code-formatter.

## Cobbler 3.4.0

The planned release for 3.4.0 was the 31.07.2022 (DD-MM-YYYY). Sadly due to many private interruptions and unplanned
work re-prioritisation it was not possible to hold this. A big factor is also that this is the biggest release I am
creating and me being a junior developer means sometimes I see things a little too optimistic.

The current GitHub projects view can be found [here](https://github.com/orgs/cobbler/projects/2/views/4). 

At the moment we have eight tickets open and seven are in progress. In progress means that there is a PR linked to it or
someone started drafting a PoC in the issue how this will be achieved with a PR in the near future.

At the moment for those tickets we have 12 PRs open. However, many of those are inactive. This means I need to rebase
them, improve them to match our quality standards and then find someone from work (I am working at SUSE) to review them. 

The new tentative date should be around new year 2023. Hopefully... Updates follow soon (TM).

### New features

The new release is very exiting for me since it as a few groundbreaking new feature additions that were not easy to
achieve.

- We will have **cloud-init support**. This will bring the desperately needed Ubuntu support.
- A **new webui** which is completely separated from the server and runs natively in a container (or on the host). It is
  Angular based and will provide a Material based UI that will hopefully provide a modern look and feel for admins that
  prefer UI based workflows.
- Support for a **wider range of web servers** is a big step towards the containerization of the server. You can now for
  example use Nginx as a webserver since Cobbler runs as a Gunicorn application (plus the XML-RPC server) that can be
  proxied via virtually every modern webserver. 
- We will complete the **golang client**, so third party applications can interface easier with Cobbler.
- A **new CLI** will be created in golang with the above-mentioned library to decouple the CLI from the server. You just
  need access to the XML-RPC API and you can fully manage your server from anywhere.
- A new library called **libcobblersignatures** was born and will be integrated into the server. Its purpose is the
  management of the `signatures.json` file for the reference here on [cobbler.github.io](https://cobbler.github.io) and
  locally. We hope it makes it easier to maintain your own versions of the file and still benefit from upstream updates.

## Cobbler after 3.4.0

Cobbler is not the hottest kid on the block, but I hope to make it more appealing for its users with the following
ideas.

### Features

I am planning after 3.4.0 to achieve the following things either with a 3.4.x release or 3.5.0:

- **Performance**: At the moment Cobbler suffers from some performance bottlenecks that can hopefully be solved
  properly to scale into the thousand systems again. Our integration testsuite will monitor this in the future.
- Many users asked for it, and I am also a big promoter for it: **Cobbler inside container(s)**
- **Support for web based ISO media** is also a long outstanding problem that I want to tackle. Most times a full ISO
  is not needed as configuration management systems configure the system later on anyway.
- **Koan**: This trustworthy tool should get some love. At the moment many tests are missing, and we just hope it works
  with new releases.
- **Backward compatibility for terraform provider**: The Terraform provider was a little neglected and should receive
  backwards compatibility with 3.3.x & 3.4.x. Hopefully this helps with the adoption of Cobbler into more environments. 
- **Backward compatibility for Web-UI** with 3.3.x: Since the old Web-UI was removed for 3.3.x and wasn't delivered in
  time.
- **API specification**: I aim to create an openAPI specification. The big problem is XML-RPC since openAPI only allows
  a single URL to have a single answer/functionality. This is not how XML-RPC works sadly. This can be overcome though
  with much effort. The creation of this API specification should allow for auto-generated API clients in many languages
  in the long-term future and much easier exploration of the Cobbler API.
- **More automated documentation updates**: At the moment we have a lot of documentation. I hope to move this closer to
  the actual code pieces to enable our docs to be more up to date so the efforts is lowered to maintain them. 

### Zero-Bug strategy

I am personally very impressed by the zero bug strategy used by [Photoprism](https://github.com/photoprism/photoprism).
In my eyes a project like Cobbler that has a lot more interfacing components will not be able to achieve this very
interesting goal, however it is my personal belief that the community and project should aim to get as close to there as
possible.

I personally am planning to achieve that with my contributions through the following things:

- Move test coverage over to Codacy. I hope to get rid of the additional tool Codecov (which is great, don't get me
  wrong).
- More test coverage in terms of unit-testing. Hopefully I can add contributions that enable us to enter the 90
  percentile area.
- Independent integration test-suite that enables us to test all components of the ecosystem at the same time in a
  specified version.

## Long term plans

Noting concrete here but a list of things that come into my mind and partly already have tickets:

- Transition away from XML-RPC
- Introduce Rust or golang server side
- Easier integration with configuration management systems
- More integration testing
- YouTube videos
- Asciinema videos
- Regular community hours
- Implement the k8s cluster API

## Conclusions

I want to keep the conclusion short so here is a bullet list again:

- There is much to do, but I am having great fun renovating the project to its former strength
- Contributors are desperately needed since maintaining this is taking a lot of my private and work time.
- Maintainers are needed long term for the following components to keep them alive and bug free:
  - WebUI
  - Terraform Provider
  - The Golang based CLI

In case you stayed with me for the whole post thanks for reading it. Comments and feedback are always appreciated.

---

P.S.: In case your find typos and or grammar mistakes just
[open an Issue](https://github.com/cobbler/cobbler.github.io/issues/new) or
[open a PR](https://github.com/cobbler/cobbler.github.io/compare).
