# This Dockerfile is used to build a container image for a Unity game server.
# source: https://docs.unity.com/ugs/en-us/manual/game-server-hosting/manual/concepts/container-builds
# Use this console command to build:
#   docker build --no-cache -t docker-hub.mspchallenge.info/cradlewebmaster/auggis-unity-server:netcat .
# to run it use:
#   docker run -d -e MSPXRClientPort=45101 --network host  docker-hub.mspchallenge.info/cradlewebmaster/auggis-unity-server:netcat
# to test the connection, run (from WSL):
#   nc -u <server-ip> 45101

# Create a container built with the base image
FROM unitymultiplay/linux-base-image:ubuntu-noble

# Switch to root user to install dependencies
USER root

# Install additional dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    netcat-openbsd

# Switch back to the default user (if necessary)
USER mpukgame

# To use netcat for testing, uncomment the line below and comment the line above
# The -u flag explicitly specifies that the connection should use the UDP protocol.
ENTRYPOINT [ "sh", "-c", "nc -u -l -p ${MSPXRClientPort:-50123}" ]
