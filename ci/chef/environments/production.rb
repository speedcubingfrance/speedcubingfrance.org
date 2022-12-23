name "production"
description "Environment used in production"
default_attributes ({
  'user' => 'afs',
  'authorized_users' => %w(viroulep zeecho),
  'home' => '/home/afs',
  'repo_home' => '/home/afs/speedcubingfrance.org'
})
