FROM jekyll/jekyll
VOLUME ["/srv/jekyll"]
EXPOSE 4000/tcp
ENTRYPOINT jekyll serve --watch --drafts
