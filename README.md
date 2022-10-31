
## Stream MySQL Change Data Capture (CDC) Events to Fluvio via Kafka

## Overview
1. Set up a MySQL database
2. Simulate events occurring on it
3. Public binlog changes to Kafka
4. Monitor the Kafka stream with a simple Rust client
5. Extend this simple example to a Fluvio connector

## Run
1. [start Rancher]
2. make fluvio-start (topic create catfact)
3. make kafka-start (start MySQL, Kafka, Debezium)
4. make kafka-subscribe
5. make start-fake-events (fake loop to insert cat facts into the database as simulated events)
6. make kafka-watch (Debezium script to make sure the connector is working)
7. make kafka-rust (my rust client to watch the Kafka stream)
8. *make fluvio-kafka-connector (doesn't work, same logic as #6, I just can't yet get the Docker/Compose/Debezium/Fluvio pieces talking)


Result of #8
```
Successfully tagged fluvio-connectors-kafka-source:latest
2022-10-31T22:38:26.618508Z  INFO kafka_source: Starting Kafka source connector connector_version="0.3.1" git_hash="161301ff696721dbe603ef9f318349b83eb79019"
2022-10-31T22:38:26.639575Z  INFO fluvio::fluvio: Connecting to Fluvio cluster fluvio_crate_version="0.15.0" fluvio_git_hash="df561cd66c7d72824ba0290c189a0b0382b4a6c9"
Error: Socket error: socket 

Caused by:
    0: socket 
    1: Cannot assign requested address (os error 99)
make: *** [fluvio-kafka-connector] Error 1


```