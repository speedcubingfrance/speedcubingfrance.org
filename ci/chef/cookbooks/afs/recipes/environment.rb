template "/etc/profile.d/afs.sh" do
  source "environment.erb"
  sensitive true
  variables(variables: data_bag_item("variables", node.environment))
end
