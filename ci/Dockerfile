FROM debian:bullseye

RUN mkdir -p /tmp/bootstrap
WORKDIR /tmp/bootstrap
COPY . .
WORKDIR chef
RUN ./bootstrap.sh docker
RUN rm -rf /tmp/bootstrap
USER afs
WORKDIR /home/afs
