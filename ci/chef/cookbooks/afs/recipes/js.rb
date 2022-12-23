apt_repository 'yarn' do
  key "https://dl.yarnpkg.com/debian/pubkey.gpg"
  uri "https://dl.yarnpkg.com/debian/"
  distribution "stable"
  components ["main"]
end

nodejs_version = data_bag_item("common", "versions")["nodejs"]
bash "setup apt for nodejs #{nodejs_version}" do
  code <<-EOF
    curl -sL https://deb.nodesource.com/setup_#{nodejs_version}.x | bash -
  EOF
  not_if { ::File.exist?("/usr/bin/nodejs") }
end

apt_package %w(nodejs yarn)

