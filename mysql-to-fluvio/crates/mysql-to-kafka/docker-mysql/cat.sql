# In production you would almost certainly limit the replication user must be on the follower (slave) machine,
# to prevent other clients accessing the log from other machines. For example, 'replicator'@'follower.acme.com'.
#
# However, this grant is equivalent to specifying *any* hosts, which makes this easier since the docker host
# is not easily known to the Docker container. But don't do this in production.
#
CREATE USER 'replicator' IDENTIFIED BY 'replpass';
CREATE USER 'debezium' IDENTIFIED BY 'vg4Vax5biF1u62nbiNsmzZ34Ww3gsIsAiovTow3A';
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'replicator';
GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT  ON *.* TO 'debezium';

# Create the database that we'll use to populate data and watch the effect in the binlog
CREATE DATABASE cat;
GRANT ALL PRIVILEGES ON cat.* TO 'mysqluser'@'%';

# Switch to this database
USE cat;

# Create and populate our products using a single insert with many rows
CREATE TABLE facts (
    id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fact VARCHAR(512) NOT NULL,
    dt datetime
);
ALTER TABLE facts AUTO_INCREMENT = 101;

# INSERT INTO products
# VALUES (default,"scooter","Small 2-wheel scooter",3.14),
#        (default,"car battery","12V car battery",8.1),
#        (default,"12-pack drill bits","12-pack of drill bits with sizes ranging from #40 to #3",0.8),
#        (default,"hammer","12oz carpenter's hammer",0.75),
#        (default,"hammer","14oz carpenter's hammer",0.875),
#        (default,"hammer","16oz carpenter's hammer",1.0),
#        (default,"rocks","box of assorted rocks",5.3),
#        (default,"jacket","water resistent black wind breaker",0.1),
#        (default,"spare tire","24 inch spare tire",22.2);

