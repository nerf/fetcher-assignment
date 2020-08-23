FROM ruby:2.6.6-alpine
RUN apk add --update bash && rm -rf /var/cache/apk/*

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY . ./

RUN gem install bundler --no-document
RUN bundle install --deployment --path /opt/bundler-cache --jobs 20 --retry 5 --without development test

ENV RACK_ENV production

CMD bundle exec rackup
