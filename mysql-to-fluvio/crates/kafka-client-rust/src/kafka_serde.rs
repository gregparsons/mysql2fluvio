///
/// Convert the Kafka message from json to a KafkaEvent w/ payload and database source information.
///
///
///
///

use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct KafkaEvent{
	schema:Value,
	payload:Payload,
}

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct Payload{
	op:String,
	before:Value,
	after:Value,
	source:Source,
	ts_ms:Value, 	// unix epoch ms when kafka connector processed the event
}

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct Source{
	db:String,
	table:String,
	file:String,
	// TODO: persist position number to resume unread events without starting over
	// pos:Number
}


pub fn get_json_value(s:&str) -> KafkaEvent {

	let json_value:Value = serde_json::from_str(&s).expect("[get_json_value] couldn't extract payload from json");

	// TODO: get the timestamp and put in PostgreSQL
	let payload_json = &json_value["payload"];

	// if let Some(client) = db_connect() {
	// 	run_sql(client);
	// } else {
	// 	println!("[get_json_value] db didn't connect")
	// }

	// payload.ts_ms is when debezium got the message
	// payload.source.ts_ms is when the database record was changed
	// https://debezium.io/documentation/reference/connectors/db2.html
	// Not sure that's really what's happening because the times are only like 1 nanosecond different, should be several weeks different
	let dtg = &json_value["payload"]["source"]["ts_ms"].as_f64().unwrap() / 1000.0;
	println!("\n[get_json_value] dtg(source): {}, dtg(debezium): {}, payload_json: {}", dtg, &json_value["payload"]["ts_ms"], &payload_json);


	// let payload_raw = &json_value["payload"].as_str().unwrap();
	// println!("[get_json_value] payload_raw: {}", payload_raw);

	let evt:KafkaEvent = serde_json::from_str(&s).expect("[get_json_value] json conversion failed");

	// https://debezium.io/documentation/reference/connectors/mysql.html#mysql-create-events

	// payload.op
		// Mandatory string that describes the type of operation that caused the connector to generate the event.
		// 	c = create
		// 	u = update
		// 	d = delete
		// 	r = read (applies to only snapshots)

	// payload.source
		// Mandatory field that describes the source metadata for the event. This field contains information that you can use to compare this event with other events, with regard to the origin of the events, the order in which the events occurred, and whether events were part of the same transaction. The source metadata includes:
		//     Debezium version
		//     Connector name
		//     binlog name where the event was recorded
		//     binlog position
		//     Row within the event
		//     If the event was part of a snapshot
		//     Name of the database and table that contain the new row
		//     ID of the MySQL thread that created the event (non-snapshot only)
		//     MySQL server ID (if available)
		//     Timestamp for when the change was made in the database
		// If the binlog_rows_query_log_events MySQL configuration option is enabled and the connector configuration include.query property is enabled, the source field also provides the query field, which contains the original SQL statement that caused the change event.

	evt
}

pub fn print_kafka_evt(evt:&KafkaEvent) {
	println!("[consume] \n\n****************");
	println!("[consume] payload.source: {}.{}, op: {}", evt.payload.source.db, evt.payload.source.table, evt.payload.op);
	println!("[consume] payload.before: {:?}", evt.payload.before);
	println!("[consume] payload.after: {:?}", evt.payload.after);
	// println!("[consume] raw payload: {:?}", evt.payload);
}

