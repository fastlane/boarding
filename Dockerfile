FROM ruby:2.3.1
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential nodejs libpq-dev
      WORKDIR /app
COPY Gemfile Gemfile.lock /app/

ARG rails_env

ENV RAILS_ENV="${rails_env:-production}"
RUN bundle install

COPY . /app/
RUN bundle install
EXPOSE 3001
CMD ["./docker-scripts/cmd.sh"]