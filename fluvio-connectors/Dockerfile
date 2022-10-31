FROM lukemathwalker/cargo-chef:latest-rust-1.64.0 as chef
WORKDIR /app
RUN apt-get update && apt-get -y upgrade

FROM chef as planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef as builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --package kafka-source --recipe-path recipe.json
COPY . .
RUN cargo build --bin kafka-source --package kafka-source

FROM rust:latest as runtime
WORKDIR /app
RUN apt-get update && apt-get -y upgrade
COPY --from=builder /app/target/debug/kafka-source kafka-source
# COPY $HOME/.profile /root/.profile

ENTRYPOINT ["./kafka-source"]

# FROM rust:latest as builder
#WORKDIR /app
#RUN /bin/bash -c 'apt-get update && apt-get upgrade'
#RUN /bin/bash -c 'apt-get -y upgrade'
#COPY . .
#RUN cargo build --bin kafka-source --package kafka-source
#
#FROM rust:latest as RUNTIME
#WORKDIR /app
#COPY --from=builder /app/target/debug/kafka-source kafka-source
#COPY $HOME/.profile /root/.profile
## CMD cargo run --bin kafka-source --package kafka-source -- --kafka-url cats-kafka-1:9092 --kafka-topic catserver01.cat.facts --fluvio-topic catfact
#ENTRYPOINT ["./kafka-source"]
