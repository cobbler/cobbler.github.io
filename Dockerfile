FROM jekyll/jekyll as build
COPY . /srv/jekyll
RUN bundle install
RUN bundle exec jekyll doctor
RUN bundle exec jekyll build --safe -V

FROM httpd:alpine as production
COPY --from=build /srv/jekyll/_site ./public-html/
EXPOSE 80/tcp
