FROM heroku/ruby
WORKDIR /app/user
CMD bundle exec puma -C config/puma.rb
