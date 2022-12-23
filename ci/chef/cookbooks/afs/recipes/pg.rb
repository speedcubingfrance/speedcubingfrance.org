# NEVER create a production docker image including this recipe, as this leaves the user password in the image
service "postgresql" do
  action :restart
end

production = node.chef_environment == "production"
password = production ? `openssl rand -base64 16`.chomp : "btest"

user_exists=`sudo -u postgres psql -tAc "select 1 from pg_catalog.pg_roles where rolname='btest';"`.chomp

bash "create pg user 'btest'" do
  code <<-EOF
    sudo -u postgres psql -c "create role btest login password '#{password}' createdb;"
  EOF
  not_if { user_exists == "1" }
  sensitive true
end

template "/home/btest/btest/server/.env.local" do
  source "dotenv-local.erb"
  not_if { user_exists == "1" || !production }
  variables ({ password: password })
  sensitive true
end
