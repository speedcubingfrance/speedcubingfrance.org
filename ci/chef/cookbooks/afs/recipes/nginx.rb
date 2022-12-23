apt_repository 'stretch-backport' do
  uri "http://ftp.debian.org/debian"
  distribution "stretch-backports"
  components ["main"]
end

apt_package %w(nginx cron)

apt_package "python-certbot-nginx" do
  options "-t stretch-backports"
end

# Regular nginx config
main_conf = "/etc/nginx/conf.d/btest.conf"
template main_conf do
  source "nginx.erb"
end

certificate_file = "/etc/letsencrypt/live/www.f2l.org/privkey.pem"

unless ::File.exist?(certificate_file)
  template "/etc/nginx/conf.d/pre_certif.conf" do
    source "pre_certif.conf"
  end

  bash "touch empty confs if not ssl cert" do
    code <<-EOF
    echo '' > /etc/nginx/certif_api.conf
    echo '' > /etc/nginx/certif_client.conf
    echo '' > /etc/nginx/use_https.conf
    EOF
  end

  service "nginx" do
    action :restart
  end
  # FIXME: somehow move the specific logic to data_bag/environment
  certbot_common_args = %w(
    certonly
    -n
    --agree-tos
    --email philippe.44@gmail.com
    --webroot
  ).join(" ")

  bash "get SSL certificate if needed" do
    code <<-EOF
    set -e
    certbot #{certbot_common_args} -w /home/btest/btest/server/public -d api.f2l.org
    certbot #{certbot_common_args} -w /home/btest/btest/client/build -d www.f2l.org
    rm -rf /etc/nginx/conf.d/pre_certif.conf
    EOF
  end
end

# We need to use only_if here, as we want the condition evaluated when chef
# executes.
template "/etc/nginx/use_https.conf" do
  source "use_https.conf"
  only_if { ::File.exist?(certificate_file) }
end

template "/etc/nginx/conf.d/post_certif.conf" do
  source "post_certif.conf"
  only_if { ::File.exist?(certificate_file) }
end

template "/etc/nginx/certif_api.conf" do
  source "certif_api.conf"
  only_if { ::File.exist?(certificate_file) }
end

template "/etc/nginx/certif_client.conf" do
  source "certif_client.conf"
  only_if { ::File.exist?(certificate_file) }
end

template "/etc/cron.weekly/renew_certbot" do
  source "renew_certbot"
  mode 755
end

service "nginx" do
  action :restart
end
