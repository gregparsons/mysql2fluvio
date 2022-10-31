
fluvio-start:
	./fluvio_start.sh

kafka-start:
	./mysql-to-fluvio/crates/mysql-to-kafka/run.sh

kafka-subscribe:
	./mysql-to-fluvio/crates/mysql-to-kafka/start_connector.sh

# continuous insert events
start-fake-events:
	cargo run --manifest-path ./mysql-to-fluvio/Cargo.toml --package cat-mysql

# start this
kafka-watch:
	./mysql-to-fluvio/crates/mysql-to-kafka/watch.sh

# my super simple kafka client
kafka-rust:
	./mysql-to-fluvio/crates/kafka-client-rust/run.sh

# doesn't work
fluvio-kafka-connector:
	# run in docker
	./fluvio_connector_start.sh
	# neither works
	# cargo run --bin kafka-source --package kafka-source -- --kafka-url cats-kafka-1:9092 --kafka-topic catserver01.cat.facts --fluvio-topic catfact




