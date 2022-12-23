apt_package "openssh-server"

# This also installs the CI pubkey
bash "install authorized_keys" do
  cwd node[:home]
  user node[:user]
  code <<-EOF
    tmp_authorized_keys_path="/tmp/authorized_keys"
    for user in #{node[:authorized_users].join(' ')}; do
      public_keys_url="https://github.com/$user.keys"
      echo "" >> $tmp_authorized_keys_path
      echo "# Keys for $user" >> $tmp_authorized_keys_path
      curl -s $public_keys_url >> $tmp_authorized_keys_path
    done
    mkdir -p .ssh
    mv $tmp_authorized_keys_path .ssh/
  EOF
end

service "ssh" do
  action :restart
end
