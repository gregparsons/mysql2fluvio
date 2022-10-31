//!
//! Read a Kafka stream, extract the json to a Debezium/Mysql payload object
//! Reference: https://github.com/kafka-rust/kafka-rust/blob/master/examples/example-consume.rs
//!
//!
//!
mod kafka_serde;

use kafka::consumer::{Consumer, FetchOffset, GroupOffsetStorage};
use kafka::error::Error as KafkaError;
use crate::kafka_serde::{print_kafka_evt};


fn kafka_settings() ->Option<(String, Vec<String>, String)> {

	// inside docker
	let broker = "cats-kafka-1:9092".to_string();
	// let broker = "localhost:9094".to_string();
	let topics = vec!("catserver01.cat.facts".to_string());
	let group = "".to_string();
	Some((broker, topics, group))

}

fn consume(broker: String, topics: Vec<String>, group: String) -> Result<(), KafkaError> {

	let mut builder = Consumer::from_hosts(vec![broker])
		.with_group(group)
		.with_fallback_offset(FetchOffset::Earliest)
		.with_offset_storage(GroupOffsetStorage::Kafka);

	for topic in topics {
		builder = builder.with_topic(topic);
	}

	// let mut con = builder.create()?;
	let mut con = match builder.create() {
		Err(e) => {
			println!("[main] error building kafka connection: {:?}", &e);
			return Err(e)
		},
		Ok(connection) => {
			connection
		}

	};

	loop {
	// for _n in 1..2 {

		/*let message_sets = */match con.poll() {
			Err(e) => return Err(e),
			Ok(message_sets) => {

				for msg_set in message_sets.iter() {
					for msg_bytes in msg_set.messages() {
						match std::str::from_utf8(msg_bytes.value) {
							Err(_e) => {},
							Ok(kafka_string) => {
								parse_evt(kafka_string);
							}
						};
					}
					let _ = con.consume_messageset(msg_set);
				}
				con.commit_consumed()?;

			}
		};

		// never stop

		// if message_sets.is_empty() {
		// 	println!("[consume_messages] no messages available");
		// 	return Ok(());
		// }


	};
	Ok(())
}


fn parse_evt(kafka_string:&str) {

	print_kafka_evt(&kafka_serde::get_json_value(kafka_string))

}

fn main() {

	match kafka_settings() {
		Some((b, t, g)) => {
			if let Err(e) = consume(b, t, g) {
				println!("[main] Failed consuming messages: {}", e);
			}
		},
		None => {
			println!("[main] couldn't load all the necessary environment vars");
			return;
		},
	};
}