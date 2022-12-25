apt-get update

export DEBIAN_FRONTEND=noninteractive
export PATH=/opt/chef/embedded/bin:$PATH

apt-get install -yq --no-install-recommends \
  apt-transport-https curl sudo wget ca-certificates lsb-release

curl -L https://omnitruck.chef.io/install.sh | bash -s -- -v 18.0.185
mkdir -p /opt/vendor_cookbooks
gem install berkshelf -v "7.2.2"
berks install
berks vendor /opt/vendor_cookbooks

chef-solo --chef-license accept-silent

chef-solo -o 'role[afs-bootstrap-dev]' -c solo.rb -E development

# FIXME: run chef bootstrap, -E something, and make afs-bootsrap dynamically add
# environment-specific recipes
# TODO: example chef-solo with -j.
