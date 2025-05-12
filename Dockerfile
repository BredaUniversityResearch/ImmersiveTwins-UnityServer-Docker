# This Dockerfile is used to build a container image for a Unity game server.
# source: https://docs.unity.com/ugs/en-us/manual/game-server-hosting/manual/concepts/container-builds
# Use this console command to build:
#   docker build --no-cache -t unity-server-image .
# You need to create a local file in ./secrets/NEXUS_AUTHORIZATION_HEADERS with the following content:
#   Authorization: Basic ...
#   NX-ANTI-CSRF-TOKEN: ...
# And of course, replace the ... with the actual values.

# Create a container built with the base image
FROM unitymultiplay/linux-base-image:ubuntu-noble

# Switch to root user to install dependencies
USER root

# Install additional dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip

# Copy the local secrets folder to /app/secrets in the container
COPY secrets /app/secrets
# Copy secrets from the mounted directory on the API machine - if available
RUN (test -d /secrets && cp -r /secrets /app/secrets) || true

# Verify that the secrets are available
RUN test -f /app/secrets/NEXUS_AUTHORIZATION_HEADERS || (echo "Error: file ./secrets/NEXUS_AUTHORIZATION_HEADERS is not set!" && exit 1)

# Download the game server build from Nexus
RUN curl --fail-with-body -X "GET" -L "https://nexus.cradle.buas.nl/service/rest/v1/search/assets/download?sort=name&direction=desc&q=UnityServer/*&repository=MSP_ProceduralOceanViewUnity-Main" \
    -H "accept: application/json" \
    -H "X-Nexus-UI: true" \
    -H @/app/secrets/NEXUS_AUTHORIZATION_HEADERS \
    --output "build.zip" || (echo "Error: Failed to download build.zip!" && exit 1) && \
    rm -rf /app/secrets
RUN test -f build.zip || (echo "Error: file build.zip not found!" && exit 1)
RUN rm -rf build/ && unzip build.zip -d build/ && rm build.zip && \
    test -f ./build/ImmersiveTwins-Unity || (echo "Error: Binary file ./build/ImmersiveTwins-Unity not found!" && exit 1)

# Set the working directory to /build and set binary ownership and permissions
WORKDIR /build
COPY --chown=mpukgame . .
RUN chmod +x ImmersiveTwins-Unity

# Switch back to the default user (if necessary)
USER mpukgame

# Set binary as the entrypoint
ENTRYPOINT [ "/build/ImmersiveTwins-Unity" ]
