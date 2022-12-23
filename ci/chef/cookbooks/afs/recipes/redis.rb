apt_package "redis-server"
service "redis-server" do
  action :restart
end
