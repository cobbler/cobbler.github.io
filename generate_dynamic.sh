#!/bin/sh

cp -a {_plugins,_includes,_layouts} _dynamic/
jekyll _dynamic/ _dynamic/_site/
rsync -a --delete _dynamic/_site/manuals/ manuals/
rm -rf _dynamic/{_plugins,_includes,_layouts}
