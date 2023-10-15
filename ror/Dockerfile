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

COPY --chmod=0755 docker-entrypoint.sh /usr/bin/entrypoint.sh
# RUN chmod +x /usr/bin/entrypoint.sh

STOPSIGNAL SIGQUIT

CMD sh /usr/bin/entrypoint.sh
