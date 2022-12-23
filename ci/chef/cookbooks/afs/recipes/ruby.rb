rbenv_user_install node[:user]

rbenv_ruby node['ruby']['version'] do
  user node[:user]
end

rbenv_gem 'bundler' do
  version node['ruby']['bundler']
  rbenv_version node['ruby']['version']
  user node[:user]
end

cron "daily jobs" do
  command "#{node[:repo_home]}/scripts/deploy.sh scheduled_jobs"
  user node[:user]
  time :daily
  # A bit dirty, but prevent registering this cron on "semi-prod" environment
  # like us testing on dev.afs.
  only_if { node[:domain_name] == "www.speedcubingfrance.org" }
end

template "/etc/systemd/system/puma.service" do
  source "puma.service.erb"
  only_if { node.environment == "production" }
end
