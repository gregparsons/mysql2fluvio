cd mysql-to-fluvio/crates/mysql-to-kafka

# works with mysql outside of composer
# docker run -it --rm --name watcher --link zookeeper:zookeeper --link kafka:kafka quay.io/debezium/kafka:2.0 watch-topic -a -k catserver01.cat.facts

#curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ \
#-d '{ "name": "cat-facts-connector",
#        "config": {
#        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
#        "tasks.max": "1",
#        "database.hostname": "cats-mysql-1",
#        "database.port": "3306",
#        "database.user": "debezium",
#        "database.password": "vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A",
#        "database.server.id": "99999999",
#        "topic.prefix": "catserver01",
#        "database.include.list": "cat",
#        "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
#        "schema.history.internal.kafka.topic": "schema-changes-cat-fact",
#        "database.allowPublicKeyRetrieval":"true"}
#}'

# works with composer
docker run -it --rm --name watcher \
    --net cats_default \
    quay.io/debezium/kafka:2.0 \
    bin/kafka-console-consumer.sh \
    --bootstrap-server cats-kafka-1:9092 \
    --topic catserver01.cat.facts \
    --from-beginning