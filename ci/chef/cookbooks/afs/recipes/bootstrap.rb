node.default['apt']['confd']['install_recommends'] = false
include_recipe "apt"

apt_package %w(git
               vim
               htop
               autoconf
               bison
               build-essential
               libssl-dev
               libyaml-dev
               libreadline6-dev
               zlib1g-dev
               libncurses5-dev
               libffi-dev
               libpq-dev
               lsb-release
               gcc
               g++
               make
               postgresql
               screen
               rsync
               openssh-client
               man-db
               )

user node[:user] do
  comment "basic user"
  home node[:home]
  manage_home true
  shell "/bin/bash"
end

sudo "setup-admin" do
  user node[:user]
  nopasswd true
end

template "#{node[:home]}/.bashrc" do
  source 'bashrc.erb'
  owner node[:user]
  group node[:user]
end
