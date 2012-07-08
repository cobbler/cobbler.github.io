#!/bin/sh

cp -a {_plugins,_includes,_layouts} _dynamic/
cd _dynamic
rm -rf test.idx
jekyll
cd ..
rsync -a --delete _dynamic/_site/manuals/ manuals/
cp _dynamic/_site/search.json .
rm -rf _dynamic/{_plugins,_includes,_layouts,test.idx}
# cleanup generated html pages that no longer exist
for i in $(git status | grep deleted | tr -s " " | cut -f2 -d " " | grep ^manuals); do git rm $i; done

echo "Checking for undefined reference links..."
grep -r "UNDEFINED REFERENCE" manuals/*
