---
layout: manpage
title: Cobbler Manual - Developer Documentation
meta: 2.4.0
---
Learn how cobbler works internally, and how to contribute to it.   We're in the process of moving documentation to github, so if a page is blank, you may find it on fedorahosted.org/cobbler.   

## About

This is a page for various advanced topics about using Cobbler's API and integration with other applications, as well as information on Work In Progress (WIP) features.

Note that cobbler has its own development mailing list, which is:

   * https://fedorahosted.org/mailman/listinfo/cobbler-devel

## How To Contribute

Various information about how to get involved with the Cobbler project.

   * {% linkup title:"Patch Process" extrameta:2.4.0 %} -- How to contribute code/patches/docs
   * {% linkup title:"Development Environment Tips" exrtameta:2.4.0 %} -- How to get your development setup going

## First, Read The Source

We take pride in our user documentation, however the development documentation will largely point you at existing code files
and examples, so you're expected to be able to read Python.  That should be ok though, Cobbler has been the first Python program a lot of our best contributors have worked with, and we want to keep everything simple to minimize levels of complexity for future contributors.

## API

XMLRPC API is used to interact with cobbler via the cobblerd daemon.  In addition, cobbler can be extended via trigger modules (or scripts), as well as plugin modules.   If using Cobbler as service, start with the XMLRPC interface... accessing the Python code directly is not supported.
 
   * [XMLRPC](XMLRPC) -- main API walkthrough for end users
   * [Triggers](Triggers) -- triggers, do X when cobbler does Y
   * [Modules](Modules) -- extend Cobbler authentication, authorization, or serialization via plugins

## Debugging

   * [epdb](http://michaeldehaan.net/2011/07/08/better-remote-python-debugging/)

