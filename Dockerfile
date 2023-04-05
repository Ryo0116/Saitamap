FROM ruby:3.0.2

RUN apt-get update && \
  apt-get install -y build-essential libpq-dev nodejs libxml2-dev libxslt-dev && \
  gem install bundler

RUN mkdir /Saitmap
WORKDIR /Saitmap
ADD Gemfile /Saitmap/Gemfile
ADD Gemfile.lock /Saitmap/Gemfile.lock
RUN bundle install
ADD . /Saitmap

RUN gem install sprockets-rails
