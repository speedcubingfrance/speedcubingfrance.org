name "development"
description "Environment used in development"
# FIXME: this assumes we run in docker, we should make sure that general purpose
# recipes do not use these.
default_attributes ({
  'user' => 'afs',
  'authorized_users' => %w(viroulep zeecho),
  'home' => '/home/afs',
  'repo_home' => '/home/afs/speedcubingfrance.org'
})
