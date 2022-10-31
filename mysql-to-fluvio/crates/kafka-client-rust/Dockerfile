FROM rust:latest
RUN /bin/bash -c 'apt-get update'
RUN /bin/bash -c 'apt-get -y upgrade'
COPY . .
CMD cargo run