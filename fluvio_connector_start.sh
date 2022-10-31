cd fluvio-connectors

docker build -t fluvio-connectors-kafka-source .

docker run -it --rm \
    --net cats_default \
    --link kafka \
    -v $HOME/.fluvio:/root/.fluvio \
    fluvio-connectors-kafka-source \
    --kafka-url cats-kafka-1:9092 \
    --kafka-topic catserver01.cat.facts \
    --fluvio-topic catfact