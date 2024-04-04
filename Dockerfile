# Use an official Rust runtime as a parent image
FROM rust:latest

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the entire source code to the working directory
COPY . .

# Build the application inside the container
RUN cargo build --release --bin radb

# Expose the port on which your application will listen
EXPOSE 9700

# Run the application when the container starts
CMD ["target/release/radb", "-c", "/usr/src/app/clusters/docker/clusters/docker/radb${ID}/radb.yaml"]
