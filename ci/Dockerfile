FROM debian:bullseye

RUN mkdir -p /tmp/bootstrap
WORKDIR /tmp/bootstrap
COPY bootstrap.sh .
RUN ./bootstrap.sh

COPY chef chef
WORKDIR chef
RUN chef-solo --chef-license accept-silent

# TODO: move this too bootstrap!
RUN /opt/chef/embedded/bin/gem install berkshelf -v "7.2.2"
RUN /opt/chef/embedded/bin/berks install
RUN /opt/chef/embedded/bin/berks vendor vendor_cookbooks

RUN chef-solo -o 'role[afs-bootstrap-dev]' -c solo.rb -E development
RUN rm -rf /tmp/bootstrap
USER afs
WORKDIR /home/afs
