template "/home/btest/btest/server/.bundle/config" do
  source "bundle.erb"
  owner "btest"
  group "btest"
end

# FIXME: it would be nice to check the consistency of chef environment vs
# the one present in /etc/environment, and abort if inconsistent!
# env here instead of sourcing profile?!
# FIXME: to helper
rails_env = case node.chef_environment
            when "production"
              "production"
            when "test"
              "test"
            else
              "development"
            end

bash "run the server actions" do
  cwd "/home/btest/btest/server"
  code <<-EOF
    bundle install
    bin/rails db:create
    bin/rails db:migrate
  EOF
  environment ({
    "HOME": "/home/btest",
    "RAILS_ENV": rails_env,
    "RACK_ENV": rails_env,
  })
  user "btest"
end
