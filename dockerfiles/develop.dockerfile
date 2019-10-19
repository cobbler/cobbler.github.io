FROM jekyll/jekyll:latest
VOLUME ["/srv/jekyll"]
EXPOSE 4000/tcp
ENTRYPOINT jekyll serve --watch --drafts
