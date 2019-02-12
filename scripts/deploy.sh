#!/usr/bin/env bash

pull_latest() {
  git pull
}

bootstrap_rails() {
  gem install bundler
  gem install pg -v '1.0.0'
  bundle install --path=vendor/bundle
  echo "SECRET_KEY_BASE=`bin/rails secret`" >> .env.production
  bin/rails db:setup
}

setup_env() {
  read -p "Please input the WCA_CLIENT_ID for the website: " client_id
  echo "WCA_CLIENT_ID=$client_id" >> .env.production
  read -p "Please input the WCA_CLIENT_SECRET for the website: " client_secret
  echo "WCA_CLIENT_SECRET=$client_secret" >> .env.production
  read -p "Please input the SENDGRID_API_KEY for the website: " sendgrid_key
  echo "SENDGRID_API_KEY=$sendgrid_key" >> .env.production
  echo "Bootstrap done, now please run rebuild_rails"
}

rebuild_rails() {
  bundle install
  bundle exec rake assets:clean assets:precompile
  restart_app
}

restart_app() {
  if ps -efw | grep "puma" | grep -v grep; then
    # Found a puma process, restart it gracefully
    pid=$(<"/tmp/puma.pid")
    kill -SIGUSR2 $pid
  else
    # We could not find a unicorn master process running, lets start one up!
    bundle exec puma &
  fi
}

scheduled_jobs() {
  if [ -z ${RAILS_ENV+x} ]; then
    source ~/.bashrc
  fi
  # This function is added as a daily cron in afs_bootstrap.sh
  bin/rails scheduler:get_wca_competitions
  bin/rails scheduler:send_subscription_reminders
  bin/rails scheduler:sync_groups
}


cd "$(dirname "$0")"/..

allowed_commands="pull_latest bootstrap_rails setup_env rebuild_rails restart_app scheduled_jobs"
source scripts/_parse_args.sh
