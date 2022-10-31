## kafka-client-rust

Simple Rust client to subscribe to a Kafka stream published via the Debezium MySQL connector. Expands on the 
Debezium tutorial by extracting the MySQL CDC with a Rust client.

## Run
docker build -t kafka-client-rust .
docker run --net cats_default kafka-client-rust