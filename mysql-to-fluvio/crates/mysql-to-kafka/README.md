# kafka-mysql-streamer

1. run run.sh to start the debezium/kafka/mysql/java mess
2. run watch.sh to start start the connector watching the mysql binlog (keep open to see mysql changes published to kafka)
3. run cat-mysql to dump fake data into the database
4. read kafka changes as fluvio source




# Debezium setup
# adapted from:
# https://debezium.io/documentation/reference/2.0/tutorial.html

docker build -t mysql-kafka-gp-no-composer -f ./docker-mysql/Dockerfile ./docker-mysql

docker run -it \
    --name mysql-kafka-gp-no-composer \
    --net cats-net \
    -p 0.0.0.0:3307:3306 \
     -e MYSQL_ROOT_PASSWORD=vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A \
     -e MYSQL_USER=mysqluser \
     -e MYSQL_PASSWORD=vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A \
     mysql-kafka-gp-no-composer

# confirm outside compose
# mysql -hlocalhost -P3307 -umysqluser -p

docker run -it --rm --name zookeeper -p 2181:2181 -p 2888:2888 -p 3888:3888 quay.io/debezium/zookeeper:2.0

    # -e KAFKA_ADVERTISED_LISTENERS:INTERNAL://kafka:9092,OUTSIDE://127.0.0.1:9092 \
    #    -e ADVERTISED_HOST_NAME=localhost \
docker run -it --rm \
    --name kafka \
    -p 0.0.0.0:9092:9092 \
    --link zookeeper:zookeeper \
quay.io/debezium/kafka:2.0


#test
# https://serverfault.com/questions/1039393/the-debezium-kafka-based-kafka-advertised-listeners-property-setting-is-ignored
    -e KAFKA_ALLOW_PLAINTEXT_LISTENER="yes" \
    -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,FROM_DOCKER_NETWORK:PLAINTEXT,FROM_HOST:PLAINTEXT \
    -e KAFKA_LISTENERS="FROM_DOCKER_NETWORK://0.0.0.0:9092,FROM_HOST://0.0.0.0:9096" \
    -e KAFKA_ADVERTISED_LISTENERS="FROM_DOCKER_NETWORK://kafka:9092,FROM_HOST://localhost:9096" \
    -e KAFKA_INTER_BROKER_LISTENER_NAME=FROM_DOCKER_NETWORK \
    -e KAFKA_AUTO_CREATE_TOPICS_ENABLE="false" \

    
docker run -it --rm \
    --name kafka \
    --link zookeeper:zookeeper \
    -p 9092:9092 \
    -p 9096:9096 \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e KAFKA_LISTENERS=FROM_DOCKER_NETWORK://0.0.0.0:9092,FROM_HOST://localhost:9096 \
    -e KAFKA_ADVERTISED_LISTENERS=FROM_DOCKER_NETWORK://kafka:9092,FROM_HOST://localhost:9096 \
    -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,FROM_DOCKER_NETWORK:PLAINTEXT,FROM_HOST:PLAINTEXT \
    -e KAFKA_INTER_BROKER_LISTENER_NAME=FROM_DOCKER_NETWORK \
    quay.io/debezium/kafka:2.0







docker run -it --rm \
    --name connect \
    -p 8083:8083 \
    -e GROUP_ID=1 \
    -e CONFIG_STORAGE_TOPIC=my_connect_configs \
    -e OFFSET_STORAGE_TOPIC=my_connect_offsets \
    -e STATUS_STORAGE_TOPIC=my_connect_statuses \
    --link kafka:kafka \
    --link mysql-kafka-gp-no-composer:mysql-kafka-gp-no-composer \
    quay.io/debezium/connect:2.0








If database run outside composer: 
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" 127.0.0.1:8083/connectors/ \
-d '{ 
    "name": "cat-facts-connector-no-compose", 
    "config": { 
         "connector.class": "io.debezium.connector.mysql.MySqlConnector", 
         "tasks.max": "1", 
         "database.hostname": "mysql-kafka-gp-no-composer", 
         "database.port": "3306", 
         "database.user": "debezium", 
         "database.password": "vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A", 
         "database.server.id": "99999999", 
         "topic.prefix": "catserver01", 
         "database.include.list": "cat", 
         "schema.history.internal.kafka.bootstrap.servers": "kafka:9092", 
         "schema.history.internal.kafka.topic": "schema-changes-cat-fact"
    } 
}'






If run in composer:
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

# optional
curl -H "Accept:application/json" localhost:8083/connectors/
curl -i -X GET -H "Accept:application/json" localhost:8083/connectors/cat-fact-connector

# watch the kafka stream
docker run -it --rm --name watcher2 --link zookeeper:zookeeper --link kafka:kafka quay.io/debezium/kafka:2.0 watch-topic -a -k catserver01.cat.facts

# SQL
# insert into cat.facts (fact, dt) values ('test', '2022-10-01');


# ** Watch **********
#  works with mysql outside of composer
docker run -it --rm --name watcher --link zookeeper:zookeeper --link kafka:kafka quay.io/debezium/kafka:2.0 watch-topic -a -k catserver01.cat.facts


# works with composer
docker run -it --rm --name watcher \
    --net cats_default \
    quay.io/debezium/kafka:2.0 \
    bin/kafka-console-consumer.sh \
    --bootstrap-server cats-kafka-1:9092 \
    --topic catserver01.cat.facts \
    --from-beginning




