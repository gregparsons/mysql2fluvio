## cat-mysql

Continuously fill a MySQL database with cat facts (as insert events to, say, feed a Kafka stream). The idea is to 
simulate having a MySQL database that you want to monitor binlog events on. Debezium has already built a Kafka
connector that does the binlog part and publishes the events to Kafka. This piece just creates a neverending thread to
automate inserts so we can watch the events downstream. 

The docker-mysql directory contains a copy of the Debezium guidance on creating a MySQL database that the Debezium 
connector wants to see to read binlog events from. TODO: this can be removed. It has been moved to the compose package.

## Run (local, mysql docker container is open to localhost on 3306):
# run after having started the debezium docker compose
cargo run

Database provided per:
https://debezium.io/documentation/reference/2.0/tutorial.html

Or just for a standalone:
# docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A -d mysql:latest
# mysql -h127.0.0.1 -uroot -p

## Setup using the Rust sqlx crate: 
cargo install sqlx-cli --features mysql
# export DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}
export DATABASE_URL=mysql://mysqluser:vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A@localhost:3306/cat
sqlx database create
sqlx migrate add create_cat_table
# see migrations/create_cat_table.sql
sqlx migrate run
# > select * from cat.fact;

# note: permissions required by debezium; more in debezium's docker setup on github
# CREATE USER 'user_debezium'@'localhost' IDENTIFIED BY 'vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A';
# CREATE USER 'user_debezium'@'172.17.0.5' IDENTIFIED BY 'vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A';
# GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT, lock tables ON *.* TO 'user_debezium'@'172.17.0.5';
# FLUSH PRIVILEGES;

# datasource
https://catfact.ninja/fact


