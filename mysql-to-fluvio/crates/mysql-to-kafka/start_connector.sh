cd mysql-to-fluvio/crates/mysql-to-kafka

curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ \
-d '{ "name": "cat-facts-connector",
        "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "tasks.max": "1",
        "database.hostname": "cats-mysql-1",
        "database.port": "3306",
        "database.user": "debezium",
        "database.password": "vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A",
        "database.server.id": "99999999",
        "topic.prefix": "catserver01",
        "database.include.list": "cat",
        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
        "schema.history.internal.kafka.topic": "schema-changes-cat-fact",
        "database.allowPublicKeyRetrieval":"true"}
}'