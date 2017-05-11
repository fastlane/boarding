#!/bin/bash
# start app and keep container aliv
mkdir -p /app/tmp/pids
touch /app/tmp/pids/puma.pid
if [ $RAILS_ENV == "staging" ] || [ $RAILS_ENV == "production" ]; then rake RAILS_ENV=$RAILS_ENV assets:precompile; fi
if [ $RAILS_ENV == "staging" ] || [ $RAILS_ENV == "production" ] ; then bundle exec passenger start --ssl --ssl-certificate /app/secret-files/cert.pem --ssl-certificate-key /app/secret-files/key.pem --ssl-port $PORT --nginx-config-template nginx.conf.erb; else bundle exec puma -b tcp://0.0.0.0 -p $PORT -e ${RAILS_ENV:-production} --prune-bundler --pidfile "/app/tmp/pids/puma.pid"; fi
