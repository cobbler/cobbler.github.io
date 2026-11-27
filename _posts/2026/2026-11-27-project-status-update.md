---
layout: post
title: Project status update
author: Enno
summary: Why Cobbler 4.0.0 took so long and what's next
---

> TLDR: Cobbler 4.0.0 is out ([announcement]({% post_url /2026/2026-11-27-cobbler_4.0.0_released %})). This post
> compares our last roadmap with what actually shipped, explains why it took more than four and a half years, and
> describes what comes next: bugfixes and ISO automation for 4.x, and in the long run a rewrite of the server in Go
> with a REST API, a real database and Kubernetes in mind.

## Where we left off

The `release33` branch was split off from the main branch on March 11th, 2022, right at the commit that became 3.3.2.
On the same day, the main branch was bumped to 3.4.0. In the
[roadmap update from November 2022]({% post_url /2022/2022-11-15-roadmap-update %}) I had to admit that the planned
release date of July 31st, 2022 was gone and named "around new year 2023" as the new target. The
[update from February 2023]({% post_url /2023/2023-02-15-roadmap-update %}) then listed 16 open issues, a roadblock with
inheritance in the Go client and a web interface without a maintainer. Internally, the plan was to have the release out
by late 2023 at the latest.

That is not what happened. In June 2026, after more than four years of development, the 3.4.0 development line was
renamed to 4.0.0, because the number of breaking changes (UIDs as primary keys, handle-based XML-RPC calls, the removal
of the bundled CLI, and more) no longer fit a minor version. Today 4.0.0 is finally out, so it is time to look back and
explain what happened.

For reference, this was the last roadmap from the [GitHub wiki](https://github.com/cobbler/cobbler/wiki/Roadmap):

- **3.4.0:** The new web interface, a tool to read, modify and generate the `signatures.json` file
  (libcobblersignatures), new and improved `cobbler check` checks, fixed documentation and more tests.
- **3.5.0:** Code cleanup and some love for Koan.
- **4.0.0:** Remove all 2.x compatibility code, a RESTful JSON API with the same functionality as XML-RPC, possibly
  remove XML-RPC (to be discussed with SUSE Manager), a separate Angular web interface on top of the new API and a CLI
  that is independent of the server.
- **Future:** Consider a rewrite in Go or Rust, define the officially supported distributions, a prebuilt container, a
  migration script for upgrades and a Pulp integration.

## Why did 4.0.0 take so long?

The short answer: for most of these years, Cobbler was not where my time went.

The long answer needs a bit of background. Most of Cobbler's development happens at SUSE, and about three quarters of
the commits since 2022 are mine. When my time goes elsewhere, Cobbler stands still. For a long time, it did go
elsewhere, mostly to [Orthos 2](https://github.com/openSUSE/orthos2), the machine administration tool of SUSE's
development network. Orthos 2 itself uses Cobbler to manage DHCP and installations, so the work wasn't unrelated, but
every hour spent there was an hour not spent on Cobbler 4.0.0. I had no commits in Orthos 2 before spring 2023. Today I
am its main contributor with about 460 commits.

The commit history (merges not counted) shows quite clearly where the time went:

| Period | My commits to Orthos 2 | My commits to Cobbler | All commits to Cobbler |
|---|---:|---:|---:|
| 2022 | 0 | ~420 | ~540 |
| Q2–Q3 2023 | 30 | 27 | 65 |
| 2024 | 58 | 90 | 161 |
| February–September 2025 | ~160 | 55 | 76 |
| Q4 2025–Q1 2026 | 0 | 76 | 83 |
| Q2–Q3 2026 | 200 | 165 | 200 |
| Q4 2026 (so far) | 8 | 225 | 244 |

### 2022: A good start

2022 was a productive year. The switch to Gunicorn, the move of `modules.conf` into `settings.yaml` and the
integration of the 2.x migration all landed on the main branch, and the pull request for cloud-init was opened.
Orthos 2 wasn't on my plate yet.

### 2023: The data-center move

In 2023, SUSE moved data centers, and that pulled me onto Orthos 2: a development container, a working CI, proper
Django migrations and packaging. On top of that, a small accident kept me out for two months. In the third quarter of
2023, Cobbler received 16 commits, and two of them were mine.

### 2024: Infrastructure and priorities

The infrastructure work didn't stop after the move. In Orthos 2, I upgraded Django to 4.2 and later 5, replaced the
SSH-based Cobbler integration with XML-RPC calls and added integration tests. Cobbler simply wasn't a high priority at
SUSE at that time. The 3.3.x series still got four releases (3.3.4 to 3.3.7), but the main branch progressed slowly.
From November 2024 to January 2025, I was on sick leave for three months.

### 2025: The low point

After my return, Orthos 2 had priority again: integrating it with NetBox (importing machines and network interfaces and
comparing the data) and improving its Cobbler integration. Between February and September 2025, I made about 160
commits to Orthos 2 and 55 to Cobbler. The first quarter of 2025 was the low point of Cobbler's history since the split,
with five commits in total.

### Agama: SUSE-internal re-prioritisation for Cobbler

What changed things was SUSE adopting [Agama](https://agama-project.github.io), the new installer of SLES 16 and
openSUSE Leap 16. Network installations with Agama need a provisioning server that speaks Agama, and suddenly Cobbler
was relevant inside SUSE again. That gave me the room to focus: between October 2025 and March 2026 I didn't make a
single commit to Orthos 2, but 76 to Cobbler. Agama support was merged in December 2025, and the first alpha of 4.0.0
followed on June 30th, 2026.

### Claude Code: My virtual second developer

The other big help since June 2026 was AI, I have been working with Claude, Anthropic's AI coding assistant. About
270 Cobbler commits carry a `Co-Authored-By: Claude` trailer, which is roughly two thirds of the commits since June.
Most of that help went into the less glamorous work that had piled up: tests, documentation and refactorings.

The effect is visible in both projects. In the second and third quarter of 2026, Orthos 2 received 200 commits from me
(about 85 of them co-authored by Claude) and 17 releases between May and November, while Cobbler received 165. For the
first time, both projects moved forward at once instead of one at the expense of the other. Cobbler went through 9
alphas and 11 betas in under five months, and 2026 became its most active year since the split.

### The big-ticket items

Apart from time, three topics were simply a lot of work:

- **Performance:** Cobbler had serious scaling problems, which we tackled step by step: an item cache and lazy loading
  of collections in 2023, an SQLite serializer and in-memory indexes in 2024, a benchmark CI (on self-hosted runners
  since 2025), a large round of optimizations in August 2026 and serving TFTP and HTTP files directly instead of copying
  them. Some of this was backported to 3.3.5.
- **Angular:** The web interface had no maintainer in 2023. Getting it to 1.0.0 meant an upgrade from Angular 17 to 21
  and end-to-end tests against a real Cobbler server, and 4.0.0 required a second major release on top.
- **Go:** The inheritance roadblock in cobblerclient from the 2023 post was solved in 2024 with a generic value type
  that knows whether a value is inherited. The 1.0.0 releases then made a clean break (UIDs, transactions) and brought
  cobbler-cli to feature parity with the old Python CLI.

## Planned vs. delivered

Long story short: 3.4.0 became 4.0.0, and most of what was planned for 3.5.0 was pulled into it as well. Some promises
were kept, some moved and a few were dropped.

| Roadmap item | Status | What happened |
|---|---|---|
| New web interface | Done | [cobbler-web](https://github.com/cobbler/cobbler-web) is a standalone Angular 21 app using Angular Material. 1.0.0 was released in July 2026, and 2.0.0 adds support for Cobbler 4.0.0. It ships as a container image and has a Helm chart. It talks XML-RPC, since there is no new API (yet). |
| libcobblersignatures | Done | Cobbler 4.0.0 depends on [libcobblersignatures](https://github.com/cobbler/libcobblersignatures) 0.5.1 and no longer bundles its own signature file. The library saw eight releases in 2026 and comes with the `cobbler-manage-signatures` command. |
| Improved `cobbler check` | Partly | A few new checks (collection load errors, service state via `systemctl is-active`, pefile), but no overhaul. |
| Fix the documentation | Done, ongoing | The documentation on [ReadTheDocs](https://cobbler.readthedocs.io) was overhauled shortly before the release, including a migration matrix and guides for Agama and container deployments. This website gained deployment guides for Debian, openSUSE, Ubuntu and Windows. |
| More tests | Done | The Python test code tripled from about 19,700 lines in 3.3.x to about 60,000 lines. A benchmark CI was added as well. |
| Code cleanup (3.5.0) | Pulled into 4.0.0 | UIDs as primary keys, dedicated network interface and template items, a refactored item base class, split autoinstall generators and a refactored kernel command line. |
| Koan | Done | [Koan](https://github.com/cobbler/koan) received its first releases in five years, its test code grew from about 400 to about 5,000 lines, and it got a modernized CLI and Debian packaging. The new release requires Cobbler 4.0.0. |
| Remove 2.x compatibility code | Not done | A 2.x installation can still be migrated straight to 4.0.0. Given how many long-time users we have, I don't consider this a loss. |
| REST API | Moved | Moved to 5.0.0, see [What's next](#whats-next). |
| Remove XML-RPC | Not in 4.x | XML-RPC is still the API of 4.0.0 and even gained transactions. |
| Independent CLI | Done | The bundled Python CLI was removed in August 2025. The Go-based [cobbler-cli](https://github.com/cobbler/cli) 1.0.0, built on [cobblerclient](https://github.com/cobbler/cobblerclient) 1.0.0, covers all the old commands and adds new ones like `template`, `interface` and `event`. |
| Go or Rust? | Decided | Go. |
| Officially supported distributions | Partly | We build and test packages for openSUSE Tumbleweed, openSUSE Leap 16, Fedora 43, Rocky Linux 10 and Debian 13. |
| Prebuilt container | Done | A compose stack, images on the GitHub Container Registry and [Helm charts](https://github.com/cobbler/charts). |
| Migration script | Done | Settings are migrated automatically or with `cobbler-settings migrate`. |
| Pulp integration | Not done | Still open. |

## What else is new in 4.0.0

Besides the roadmap items, 4.0.0 brings a lot of other changes. The full list is in the
[release notes](https://github.com/cobbler/cobbler/releases/tag/v4.0.0). These are the ones that matter most when
upgrading:

- **Python 3.11 is the minimum:** The 3.3.x series still ran on the Python 3.6 that ships with openSUSE Leap 15.
- **`modules.conf` is gone:** Its content now lives in the `modules` section of `settings.yaml`, and the migration
  happens automatically.
- **The built-in configuration management was removed:** The `mgmtclass`, `package` and `file` items are gone. Please
  use a dedicated configuration management tool once your systems are installed.
- **Agama:** Cobbler 4.0.0 can install SLES 16 and openSUSE Leap 16 with the new Agama installer. 3.3.8 already learned
  to install Leap 16 with Agama.
- **Ubuntu with cloud-init:** Current Ubuntu releases can be installed via cloud-init and Subiquity. That pull request
  was opened in November 2022 and merged in January 2026.
- **Gunicorn instead of Apache mod_wsgi:** Cobbler's web services can now run behind the web server of your choice.
  There are ready-made `cobbler-apache2` and `cobbler-nginx` subpackages, and Kerberos SSO is supported natively.
- **Containers:** A compose stack with Traefik in front, and images on the GitHub Container Registry. The new
  `dynamic_tftp` and `dynamic_httpd` managers serve files without copying them first, and the optional stateless TFTP
  server [cobbler-tftp](https://github.com/cobbler/cobbler-tftp) is available as an alpha.
- **Companion releases:** Released together with 4.0.0 are cobbler-web 2.0.0, cobbler-cli 1.0.0, cobblerclient 1.0.0,
  [terraform-provider-cobbler](https://github.com/cobbler/terraform-provider-cobbler) 6.0.0, a new Koan release and
  libcobblersignatures 0.5.1.

Since the split, about 50 people contributed roughly 1,360 commits (not counting merges) to the server, and its Python
code grew from about 37,500 to about 53,300 lines.

## Maintenance releases

The 3.3.x series is not forgotten. 3.3.10 was released in September 2026, and 3.3.11 is planned. Its fixes are
already on the `release33` branch, among them a fix for duplicated owners, a CLI hang when following a task during log
rotation, a fix for the generated Agama JSON and a corrected undionly file name. In addition, 3.2.4 is planned as the
last release of the 3.2.x series to close that chapter for good.

## What's next

### Cobbler 4.x

4.x will mainly receive bugfixes. The one larger topic is automation around ISO images
([cobbler/cobbler#2789](https://github.com/cobbler/cobbler/issues/2789)). Today, the ISOs Cobbler imports need to stay
mounted, and if they are not in `/etc/fstab`, `cobblerd` fails to start after a reboot. Over the years I have seen
numerous people stumble over exactly this. The plan is a well-known (and configurable) directory for ISOs, a second
one for their mount points and automatic mounting with `grub2-mount`, which works without elevated privileges.

### The long run: Go

The "Go or Rust?" question from the old roadmap has been answered: the future of Cobbler is a rewrite of the server in
Go. There are three main reasons:

- **A REST API:** The REST API that was once planned for 4.0.0 will come with the next major version, 5.0.0.
- **A real database:** 4.0.0 can already store its data in SQLite or MongoDB instead of JSON files, but these backends
  still store JSON documents. The goal is a proper relational schema.
- **Kubernetes:** There are already [Helm charts](https://github.com/cobbler/charts), but the `cobblerd` chart is a
  preview limited to a single replica, because Cobbler keeps its state in files. A database is the foundation for
  running Cobbler properly in Kubernetes.

I won't promise any dates this time. I have learned my lesson.

## Thank you

Thank you to the roughly 50 people who contributed to the server since 2022, to everyone who worked on the web
interface, the CLI, the client library, Koan, the Terraform provider and the signatures, to SUSE for giving Cobbler a
home, and to all of you for your patience. Please give 4.0.0 a try (see the [downloads page](/downloads/4.x.x.html))
and [open an issue](https://github.com/cobbler/cobbler/issues/new/choose) if something doesn't work. If you need a
fix in 3.3.x, a backport request is the way to go.

---

P.S.: In case you find typos and/or grammar mistakes just
[open an Issue](https://github.com/cobbler/cobbler.github.io/issues/new) or
[open a PR](https://github.com/cobbler/cobbler.github.io/compare).
