# This Dockerfile is used to build a container image for a Unity game server.
# source: https://docs.unity.com/ugs/en-us/manual/game-server-hosting/manual/concepts/container-builds
# Use this console command to build:
#   docker build --no-cache -t docker-hub.mspchallenge.info/cradlewebmaster/auggis-unity-server:netcat .
# to run it use:
#   docker run -it -p 45101:50123/udp docker-hub.mspchallenge.info/cradlewebmaster/auggis-unity-server:netcat

# Create a container built with the base image
FROM unitymultiplay/linux-base-image:ubuntu-noble

# Switch to root user to install dependencies
USER root

# Install additional dependencies
# netcat is only used for testing UDP network connectivity, with these commands:
#   * server: nc -u -l -p 50123
#   * client: nc -u <server-ip> 50123 (from WSL)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    netcat-openbsd

# Switch back to the default user (if necessary)
USER mpukgame

# Set binary as the entrypoint
# ENTRYPOINT [ "/app/ImmersiveTwins-Unity" ]
# To use netcat for testing, uncomment the line below and comment the line above
ENTRYPOINT [ "nc", "-u", "-l", "-p", "50123" ]
