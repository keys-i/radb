#!/bin/bash

set -e

# Function to generate one node folder
generate_node_config() {
  local id="$1"
  local node_dir="radb${id}"
  local data_dir="${node_dir}/data"
  local config_file="${node_dir}/radb.yaml"
  local listen_sql="0.0.0.0:960${id}"
  local listen_raft="0.0.0.0:970${id}"

  # Generate peers list excluding self
  peers=""
  for peer_id in {1..5}; do
    if [[ $peer_id -ne $id ]]; then
      peers+="  \"$peer_id\": 127.0.0.1:970${peer_id}\n"
    fi
  done

  mkdir -p "$data_dir"
  cat > "$config_file" <<EOF
id: $id
data_dir: data
sync: false
listen_sql: $listen_sql
listen_raft: $listen_raft
peers:
$(echo -e "$peers")
EOF
}

# Loop to build each container individually
for id in {1..5}; do
  generate_node_config "$id"

  echo "🛠 Building radb${id} container..."
  docker build \
    --build-arg NODE_ID=$id \
    -t radb${id}:latest .

  rm -rf "radb${id}"
done

# Finally, run them with docker-compose
docker-compose up
