# This Dockerfile is used to build a container image for a Unity game server.
# source: https://docs.unity.com/ugs/en-us/manual/game-server-hosting/manual/concepts/container-builds
# Use this console command to build:
#   docker build --no-cache --build-arg NEXUS_CREDENTIALS="$NEXUS_CREDENTIALS" --build-arg NEXUS_ANTI_CSRF_TOKEN="$NEXUS_ANTI_CSRF_TOKEN" -t unity-server-image .
# to run it use:
#   docker run -it -p 45101:50123/udp unity-server-image
#   docker run -it -e MSPXRClientPort=45101 -p 45101:45101/udp unity-server-image

# Create a container built with the base image
FROM unitymultiplay/linux-base-image:ubuntu-noble

# Switch to root user to install dependencies
USER root

ARG NEXUS_CREDENTIALS
ARG NEXUS_ANTI_CSRF_TOKEN

# Install additional dependencies & download the game server build from Nexus
RUN test -n "$NEXUS_CREDENTIALS" || (echo "Error: build argument NEXUS_CREDENTIALS is not set!" && exit 1) && \
    test -n "$NEXUS_ANTI_CSRF_TOKEN" || (echo "Error: build argument $NEXUS_ANTI_CSRF_TOKEN is not set!" && exit 1) && \
	apt-get update && \
	apt-get install -y --no-install-recommends curl unzip && \
    curl -X "GET" -L "https://nexus.cradle.buas.nl/service/rest/v1/search/assets/download?sort=name&direction=desc&q=UnityServer/*&repository=MSP_ProceduralOceanViewUnity-Main" \
        -H "accept: application/json" \
        -H "Authorization: Basic ${NEXUS_CREDENTIALS}" \
        -H "NX-ANTI-CSRF-TOKEN: ${NEXUS_ANTI_CSRF_TOKEN}" \
        -H "X-Nexus-UI: true" \
        --output "build.zip" && \
    rm -rf /app && unzip build.zip -d /app && rm build.zip && \
    test -f /app/ImmersiveTwins-Unity || (echo "Error: Binary file /app/ImmersiveTwins-Unity not found!" && exit 1)

# Set the working directory to /app and set binary ownership and permissions
WORKDIR /app
COPY --chown=mpukgame . .
RUN chmod +x /app/ImmersiveTwins-Unity

# Switch back to the default user (if necessary)
USER mpukgame

# Set binary as the entrypoint
ENTRYPOINT [ "/app/ImmersiveTwins-Unity" ]
