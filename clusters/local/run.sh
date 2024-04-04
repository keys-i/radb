#!/usr/bin/env bash

set -euo pipefail

cargo build --release --bin radb

for ID in 1 2 3 4 5; do
    (cargo run -q --release -- -c radb$ID/radb.yaml 2>&1 | sed -e "s/\\(.*\\)/radb$ID \\1/g") &
done

trap 'kill $(jobs -p)' EXIT
wait < <(jobs -p)