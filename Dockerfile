# This Dockerfile is used to build a container image for a Unity game server.
# source: https://docs.unity.com/ugs/en-us/manual/game-server-hosting/manual/concepts/container-builds
# Use this console command to build:
#   docker build --no-cache --secret id=headers,src=NEXUS_AUTHORIZATION_HEADERS -t unity-server-image .
# You need to create a local file called NEXUS_AUTHORIZATION_HEADERS with the following content:
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

# Download the game server build from Nexus
RUN --mount=type=secret,id=headers \
    test -f /run/secrets/headers || (echo "Error: secret "headers" is not set!" && exit 1)
RUN --mount=type=secret,id=headers \
    curl --fail-with-body -X "GET" -L "https://nexus.cradle.buas.nl/service/rest/v1/search/assets/download?sort=name&direction=desc&q=UnityServer/*&repository=MSP_ProceduralOceanViewUnity-Main" \
    -H "accept: application/json" \
    -H "X-Nexus-UI: true" \
    -H @/run/secrets/headers \
    --output "build.zip" || (echo "Error: Failed to download build.zip!" && exit 1)
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
ENTRYPOINT [ "ImmersiveTwins-Unity" ]
