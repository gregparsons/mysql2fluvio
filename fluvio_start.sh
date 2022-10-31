cd fluvio
# make clean
# make -C k8-util/helm clean
# export FLUVIO_BUILD_LLD=/usr/local/bin/lld
# make build_k8_image
# not needed with my hack to cli source
# cargo run --package fluvio-cli -- cluster delete
cargo run --package fluvio-cli -- cluster start --proxy-addr localhost --develop
cargo run --package fluvio-cli -- topic create catfact