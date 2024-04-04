#!/usr/bin/env bash

set -euo pipefail

# Build the radb binary
cargo build --release --bin radb

# Start Dockerized containers for radb
for ID in 1 2 3 4 5; do
    # Build Docker container for radb$ID
    docker build --build-arg ID=$ID -t radb-image$ID .

    # Run Docker container
    docker run -d -p 970$ID:9700 radb-image$ID
    echo "radb$ID Docker container is running on port 970$ID"
done

echo "All radb Docker containers are running"

# Function to stop Docker containers gracefully on script exit
cleanup() {
    for ID in 1 2 3 4 5; do
        docker stop radb-image$ID >/dev/null
        docker rm radb-image$ID >/dev/null
    done
    echo "Stopped all radb Docker containers"
}

# Trap to call cleanup function on script exit
trap cleanup EXIT

# Keep script running until interrupted
while true; do
    sleep 1
done
