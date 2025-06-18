# This Dockerfile is used to build a container image for a Unity game server.
# source: https://docs.unity.com/ugs/en-us/manual/game-server-hosting/manual/concepts/container-builds
# Use this console command to build:
#   docker build --no-cache --secret id=headers,src=./secrets/nexus.txt -t docker-hub.mspchallenge.info/cradlewebmaster/auggis-unity-server:latest .
# You need to create a local file in ./secrets/ or environmental variable called nexus.txt with the following content:
#   Authorization: Basic ...
# And of course, replace the ... with the actual values.
# to run it use:
#   docker run -d -e MSPXRClientPort=45101 --network host docker-hub.mspchallenge.info/cradlewebmaster/auggis-unity-server:latest

# Create a container built with the base image
FROM unitymultiplay/linux-base-image:ubuntu-noble

# Switch to root user to install dependencies
USER root

# Install additional dependencies & download the game server build from Nexus
RUN --mount=type=secret,id=headers \
    (test -f /run/secrets/headers || (echo "Error: secret "headers" is not set!" && exit 1)) && \
    apt-get update && \
	apt-get install -y --no-install-recommends curl unzip && \
    curl --fail-with-body -X "GET" -L "https://nexus.cradle.buas.nl/service/rest/v1/search/assets/download?sort=name&direction=desc&q=UnityServer/*&repository=MSP_ProceduralOceanViewUnity-Main" \
        -H "accept: application/json" \
        -H @/run/secrets/headers \
        -H "X-Nexus-UI: true" \
        --output "build.zip" && \
    (test -f build.zip || (echo "Error: file build.zip not found!" && exit 1)) && \
    rm -rf /app && unzip build.zip -d /app && rm build.zip && \
    (test -f /app/ImmersiveTwins-Unity || (echo "Error: Binary file /app/ImmersiveTwins-Unity not found!" && exit 1))

# Set the working directory to /app and set binary ownership and permissions
WORKDIR /app
COPY --chown=mpukgame . .
RUN chmod +x /app/ImmersiveTwins-Unity

# Switch back to the default user (if necessary)
USER mpukgame

# Set binary as the entrypoint
ENTRYPOINT [ "/app/ImmersiveTwins-Unity" ]
