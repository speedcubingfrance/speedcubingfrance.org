#!/usr/bin/env bash

source /etc/profile.d/afs.sh

pull_latest() {
  git pull
}

rebuild_rails() {
  bundle install
  bundle exec rake assets:clean assets:precompile
  restart_app
}

restart_app() {
  sudo systemctl restart puma.service
}

scheduled_jobs() {
  # This function is added as a daily cron in afs_bootstrap.sh
  bin/rails scheduler:get_wca_competitions
  bin/rails scheduler:send_subscription_reminders
  bin/rails scheduler:sync_groups
}


cd "$(dirname "$0")"/..

allowed_commands="pull_latest rebuild_rails restart_app scheduled_jobs"
source scripts/_parse_args.sh
