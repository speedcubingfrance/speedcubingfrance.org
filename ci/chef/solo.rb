current_script_dir = File.expand_path(File.dirname(__FILE__))
role_path "#{current_script_dir}/roles"
cookbook_path "#{current_script_dir}/cookbooks"
data_bag_path "#{current_script_dir}/data_bags"
environment_path "#{current_script_dir}/environments"
current_user = `whoami`.chomp
file_cache_path "/tmp/chef-cache-#{current_user}"
