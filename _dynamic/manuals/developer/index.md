---
layout: manpage
title: Developer Guide
meta: 2.6.0
---

## About

Note that cobbler has its own development mailing list, which is:

   * https://fedorahosted.org/mailman/listinfo/cobbler-devel

## How To Contribute

Various information about how to get involved with the Cobbler project.

   * [Patch Process](Patch Process) -- How to contribute code/patches/docs
   * [Development Environment](Development Environment Tips) -- How to get your development setup going

## First, Read The Source

We take pride in our user documentation, however the development documentation will largely point you at existing code files
and examples, so you're expected to be able to read Python.  That should be ok though, Cobbler has been the first Python program a lot of our best contributors have worked with, and we want to keep everything simple to minimize levels of complexity for future contributors.

## API

XMLRPC API is used to interact with cobbler via the cobblerd daemon.  In addition, cobbler can be extended via trigger modules (or scripts), as well as plugin modules.   If using Cobbler as service, start with the XMLRPC interface... accessing the Python code directly is not supported.
 
   * [XMLRPC](XMLRPC) -- main API walkthrough for end users
   * [Triggers](Triggers) -- triggers, do X when cobbler does Y
   * [Modules](Modules) -- extend Cobbler authentication, authorization, or serialization via plugins


