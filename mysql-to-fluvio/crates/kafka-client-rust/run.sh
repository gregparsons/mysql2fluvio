cd crates/kafka-client-rust

docker build -t rust-client .
docker run -it --rm \
--net cats_default \
--name kafkarust \
rust-client