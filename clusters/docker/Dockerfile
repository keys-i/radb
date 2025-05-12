# Dockerfile
FROM debian:bookworm-slim

ARG NODE_ID
WORKDIR /app

COPY ../radb /usr/local/bin/radb

# Copy only the relevant config folder
COPY radb${NODE_ID} ./radb${NODE_ID}

RUN chmod +x /usr/local/bin/radb

CMD [ "sh", "-c", "/usr/local/bin/radb -c radb$NODE_ID/radb.yaml 2>&1 | sed -e 's/\\(.*\\)/radb$NODE_ID \\1/g'" ]
