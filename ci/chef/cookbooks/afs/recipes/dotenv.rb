envfile = "#{node[:repo_home]}/.env"
template envfile do
  source "dotenv.erb"
  sensitive true
  # We want to generate it just once!
  not_if { ::File.exist?(envfile) }
  variables(variables: data_bag_item("variables", node.environment))
  owner node[:user]
  group node[:user]
end
