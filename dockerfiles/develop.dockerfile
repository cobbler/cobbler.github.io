FROM jekyll/jekyll:latest
RUN gem install webrick
VOLUME ["/srv/jekyll"]
EXPOSE 4000/tcp
ENTRYPOINT jekyll serve --watch --drafts
