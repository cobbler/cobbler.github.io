#!/bin/sh

cp -a {_includes,_layouts} _dynamic/
mkdir _dynamic/posts
cp -a _rawposts/* _dynamic/posts/
cd _dynamic
rm -rf test.idx
mkdir _site
jekyll build
rm -rf posts/_posts
cd ..
rsync -a --delete _dynamic/_site/manuals/ manuals/
rsync -a --delete _dynamic/_site/posts/ posts/
rsync -a --delete _dynamic/_site/downloads/ downloads/
rsync -a --delete _dynamic/_site/loaders/ loaders/
cp -a _dynamic/_site/*.html ./
# cp _dynamic/_site/search.json .
rm -rf _dynamic/{_includes,_layouts,_site,posts,test.idx}
# cleanup generated html pages that no longer exist
for i in $(git status | grep deleted | tr -s " " | cut -f2 -d " " | grep ^manuals); do git rm $i &>/dev/null; done

echo "Checking for undefined reference links..."
grep -r "UNDEFINED REFERENCE" manuals/*
