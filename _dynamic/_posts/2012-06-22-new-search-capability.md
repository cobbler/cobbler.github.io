---
layout: post
title: New Search Capability
author: James
---
I've added a new search function to the site, which will search the manual documentation. Since github uses jekyll for their page hosting, all site content has to be static, which really limits the search capability. Some third-party services exist to get around this issue, but I decided to go a different direction and wrote a jekyll plugin (using ferret to index the text) to generate a searchable JSON index. JQuery is used on the client side to grab that index and find the results based on a fuzzy matching algorithm.

Now, obviously this is no Google-class search, but it works well enough to find words and scores pages higher the more words you enter and it finds on a page. I've put the [code up on github](https://github.com/cobbler/jekyll-dynamic-search) if anyone's interested in seeing how this all works, and feel free to improve on it.

You may notice that right now a lot of the results appear to be the same - that's because the plugin uses the title associated with the page it finds, and a lot (really most) of them have a generic title. That will be fixed as I continue updating the manual documentation. Beyond that, let me know if you run into issues with the search behaving oddly.
