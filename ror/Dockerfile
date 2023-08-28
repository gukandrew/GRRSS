FROM ruby:3.2.2-alpine as base

RUN apk --update add build-base nodejs tzdata \
    postgresql-dev postgresql-client libxslt-dev \
    libxml2-dev yarn ruby-nokogiri xz \
    # for nokogiri
    gcompat

WORKDIR /docker/app

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

ADD . /docker/app

ARG DEFAULT_PORT 3000

EXPOSE ${DEFAULT_PORT}

CMD bin/rails db:prepare; \
  bin/bundle exec whenever --update-crontab -s environment=development; \
  # rails assets:precompile; \
  bin/rails runner "RssConsumer.new.start" & \
  bin/bundle exec rails server -p 3000 -b 0.0.0.0 -e development
