---
layout: manpage
title: Patch Process
meta: 2.8.0
---

You'd like to contribute features or fixes to Cobbler? Great! We'd
love to have them.

It is highly recommended that you have a github.com account if you would
like to contribute code.   Create an account, log in, and then go
to github.com/cobbler/cobbler to "fork" the project.

Create a new branch named after the feature you are working on.

Do the work on your local machine, please make sure your work passes Cobbler's
coding standards by using 'make qa'. Only then push to your personal github
branch (e.g. github.com/yourname/cobbler)

Then use the "submit pull request" feature of github to request that
the official repo pull in your changes.  Be sure to include a full
description of what your change does in the comments, including
what you have tested (and other things that you may have not been
able to test well and need help with).

If the patch needs more work, we'll let you know in the comments.

Do not mix work on different features in different pull requests/branches if at
all possible as this makes it difficult to take only some of the work at
one time, and to quickly slurp in some changes why others get hammered out.

Once we merge in your pull request, you can remove the branch from your repo if you
like.

If not already there, please add yourself to the AUTHORS file in the root of the checkout.

## Branches

Cobbler has a development branch called "master" (where the action is),
and a branch for each release that are in maintaince mode.

All work on new features should be done against the master branch.
If you want to address bugs then please target the latest release branch,
the maintainers will then cherry-pick those changes into the master branch.

## Standards

We're not overly picky, but please follow the usual python PEP8 standards
within reason.

-   always use under\_scores, not camelCase
-   always four (4) spaces, not tabs
-   avoid one line if statements
-   validate your code by using 'make qa'
-   keep things simple -- make sure everyone can read and     understand your code -- avoid "magic" such as very
    complex list comprehensions.   The audience for Cobbler     includes folks with a wide range of programming skills and
    this is not the place to show off
-   use modules that are available in EPEL or the base OS, otherwise they have to be packaged with the app, which usually runs afoul of distribution packaging guidelines
-   at least for now we have to support Python 2.6 for Cobbler and
    Python 2.2 for koan, so stay away from metaclasses and fancy stuff
    :).

You're also welcome to hang out in \#cobbler and
\#cobbler-devel on irc.freenode.net, as there are folks around to
answer questions, etc.

## Contributing to the website: https://cobbler.github.io/

The github-based git repository for the Cobbler website itself is at [ https://github.com/cobbler/cobbler.github.com ]( https://github.com/cobbler/cobbler.github.com ).

If you want to contribute changes to the website, you will need [jekyll](http://jekyllrb.com).

You will probably want to:

-   edit the files in _dynamic
-   run the generate_dynamic.sh script
-   add both the .md and resulting .html files in your git commit

## Mailing List

We have a development mailing list at [https://fedorahosted.org/mailman/listinfo/cobbler-devel](https://fedorahosted.org/mailman/listinfo/cobbler-devel).  Discuss development related questions,
roadmap, and other things there, rather than on the general user list.

It is a very good idea to mention your pull request (copy/paste, etc) to the development mailing
list for discussion.

## The End

Thanks for the interest and happy patching!
