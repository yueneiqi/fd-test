#!/bin/sh

prefix=/home/runner/work/buckal_workspace/buckal_workspace/test/3rd/fd/buck-out/v2/gen/root/fecc77911dff3f64/third-party/rust/crates/tikv-jemalloc-sys/0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7/__tikv-jemalloc-sys-build-script-run__/OUT_DIR
exec_prefix=/home/runner/work/buckal_workspace/buckal_workspace/test/3rd/fd/buck-out/v2/gen/root/fecc77911dff3f64/third-party/rust/crates/tikv-jemalloc-sys/0.6.0+5.3.0-1-ge13ca993e8ccb9ba9847cc330696e02839f328f7/__tikv-jemalloc-sys-build-script-run__/OUT_DIR
libdir=${exec_prefix}/lib

LD_PRELOAD=${libdir}/libjemalloc.so.2
export LD_PRELOAD
exec "$@"
