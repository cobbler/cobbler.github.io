#!/bin/sh

cp -a {_plugins,_includes,_layouts} _dynamic/
cd _dynamic
jekyll
cd ..
rsync -a --delete _dynamic/_site/manuals/ manuals/
rm -rf _dynamic/{_plugins,_includes,_layouts}
