FROM debian:bullseye

RUN mkdir -p /tmp/bootstrap
WORKDIR /tmp/bootstrap
COPY bootstrap.sh .
RUN ./bootstrap.sh

COPY chef chef
#TODO: Berksfile
RUN chef-solo --chef-license accept-silent
RUN chef-solo -o 'role[afs-bootstrap-dev]' -c chef/solo.rb -E development
RUN rm -rf /tmp/bootstrap
USER afs
WORKDIR /home/afs
