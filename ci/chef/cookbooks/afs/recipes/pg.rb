# This is used only on a server, because for docker-compose we start a dedicated
# service.
postgresql_install 'postgresql-install' do
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

cron 'backup db' do
  command "#{node[:repo_home]}/scripts/backup_db.sh"
  user node[:user]
  time :weekly
end
