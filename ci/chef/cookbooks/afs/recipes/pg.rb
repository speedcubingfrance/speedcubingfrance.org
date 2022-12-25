postgresql_install 'postgresql' do
  version node["postgres"]["version"]
  action %w(install init_server)
end

postgresql_service "postgresql" do
  action %w(enable start)
end

postgresql_role node["postgres"]["user"] do
  unencrypted_password data_bag_item("variables", node.environment)["DATABASE_PASSWORD"]
  createdb true
  login true
end
