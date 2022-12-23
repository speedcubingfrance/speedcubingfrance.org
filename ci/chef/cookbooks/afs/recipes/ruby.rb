ruby_version = data_bag_item("common", "versions")["ruby"]
bash "install ruby-build globally" do
  code <<-EOF
    tmp=`mktemp -d`
    cd $tmp
    git clone https://github.com/rbenv/ruby-build.git
    PREFIX=/usr/local ./ruby-build/install.sh
    cd /
    rm -rf $tmp
  EOF
  not_if { ::File.exist?("/usr/local/bin/ruby-build") }
end

bash "install ruby globally" do
  code <<-EOF
    ruby-build #{ruby_version} /usr/local
  EOF
  not_if { ::File.exist?("/usr/local/bin/ruby") }
end

bundler_version = data_bag_item("common", "versions")["bundler"]
bash "install bundler" do
  code <<-EOF
    gem install bundler -v #{bundler_version}
  EOF
end
