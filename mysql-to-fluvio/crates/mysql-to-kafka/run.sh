cd mysql-to-fluvio/crates/mysql-to-kafka

export DEBEZIUM_VERSION=2.0
export COMPOSE_PROJECT_NAME=cats
docker-compose -f docker-compose-dev.yaml up

# non-composer version

#docker build -t mysql-kafka-gp .
#
#docker run -it --name mysql-kafka-gp -p 3306:3306 \
# -e MYSQL_ROOT_PASSWORD=vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A \
# -e MYSQL_USER=mysqluser \
# -e MYSQL_PASSWORD=vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A \
# mysql-kafka-gp
#
#docker run -it --rm --name zookeeper -p 2181:2181 -p 2888:2888 -p 3888:3888 quay.io/debezium/zookeeper:2.0
#docker run -it --rm --name kafka -p 9092:9092 --link zookeeper:zookeeper quay.io/debezium/kafka:2.0
#docker run -it --rm --name connect -p 8083:8083 \
#-e GROUP_ID=1 \
#-e CONFIG_STORAGE_TOPIC=my_connect_configs \
#-e OFFSET_STORAGE_TOPIC=my_connect_offsets \
#-e STATUS_STORAGE_TOPIC=my_connect_statuses \
#--link kafka:kafka \
#--link mysql-kafka-gp:mysql-kafka-gp \
#quay.io/debezium/connect:2.0
#
#curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ \
#-d '{ "name": "cat-facts-connector",
#"config": {
# "connector.class": "io.debezium.connector.mysql.MySqlConnector",
# "tasks.max": "1",
# "database.hostname": "mysql-kafka-gp",
# "database.port": "3306",
# "database.user": "debezium",
# "database.password": "vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A",
# "database.server.id": "99999999",
# "topic.prefix": "catserver01",
# "database.include.list": "cat",
# "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
# "schema.history.internal.kafka.topic": "schema-changes-cat-fact",
# "database.allowPublicKeyRetrieval":"true"}
#}'


# https://github.com/debezium/debezium-examples/blob/master/tutorial/README.md

