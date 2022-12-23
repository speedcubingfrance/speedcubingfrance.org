apt_repository 'stretch-backport' do
  uri "http://ftp.debian.org/debian"
  distribution "stretch-backports"
  components ["main"]
end

apt_package %w(nginx cron)

apt_package "python-certbot-nginx" do
  options "-t stretch-backports"
end

## Regular nginx config
main_conf = "/etc/nginx/conf.d/afs.conf"
template main_conf do
  source "nginx.erb"
end

cert_file = "/etc/letsencrypt/live/#{node[:domain_name]}/privkey.pem"
fullchain_file = "/etc/letsencrypt/live/#{node[:domain_name]}/fullchain.pem"

unless ::File.exist?(cert_file)
  template "/etc/nginx/conf.d/pre_certif.conf" do
    source "pre_certif.conf.erb"
  end

  bash "touch empty confs if not ssl cert" do
    code <<-EOF
    echo '' > /etc/nginx/certif.conf
    echo '' > /etc/nginx/use_https.conf
    EOF
  end

  service "nginx" do
    action :restart
  end
  certbot_common_args = %w(
    certonly
    -n
    --agree-tos
    --email admin@speedcubingfrance.org
    --webroot
  ).join(" ")

  bash "get SSL certificate if needed" do
    code <<-EOF
    set -e
    certbot #{certbot_common_args} -w #{node[:repo_home]}/public -d #{node[:domain_name]}
    rm -rf /etc/nginx/conf.d/pre_certif.conf
    EOF
  end
end

## We need to use only_if here, as we want the condition evaluated when chef
## executes.
template "/etc/nginx/use_https.conf" do
  source "use_https.conf"
  only_if { ::File.exist?(cert_file) }
end

template "/etc/nginx/conf.d/post_certif.conf" do
  source "post_certif.conf.erb"
  only_if { ::File.exist?(cert_file) }
end

template "/etc/nginx/certif.conf" do
  source "certif.conf.erb"
  variables(cert: cert_file, fullchain: fullchain_file)
  only_if { ::File.exist?(cert_file) }
end

template "/etc/cron.weekly/renew_certbot" do
  source "renew_certbot"
  mode 755
end

service "nginx" do
  action :restart
end
