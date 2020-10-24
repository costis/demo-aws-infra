FROM ruby:2.7

LABEL maintainer="costisp@gmail.com"

# Allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https

# install node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# add yarn deb repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json .
RUN yarn install --check-files

COPY . .

RUN rake assets:precompile

EXPOSE 3000

ENV RAILS_LOG_TO_STDOUT=true

CMD ["rails", "server", "-b", "0.0.0.0"]
