rbenv_user_install node[:user]

rbenv_ruby node['ruby']['version'] do
  user node[:user]
end

rbenv_gem 'bundler' do
  version node['ruby']['bundler']
  rbenv_version node['ruby']['version']
  user node[:user]
end
