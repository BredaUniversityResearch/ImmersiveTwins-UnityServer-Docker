# This Dockerfile is used to build a container image for a Unity game server.
# source: https://docs.unity.com/ugs/en-us/manual/game-server-hosting/manual/concepts/container-builds

# Create a container built with the base image
FROM unitymultiplay/linux-base-image:ubuntu-noble

# Install additional dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip

# Download the game server build from Nexus
ARG NEXUS_CREDENTIALS
RUN test -n "$NEXUS_CREDENTIALS" || (echo "Error: environmental variable NEXUS_CREDENTIALS is not set!" && exit 1)
RUN curl -X "GET" -L "https://nexus.cradle.buas.nl/service/rest/v1/search/assets/download?sort=name&direction=desc&q=UnityServer/*&repository=MSP_ProceduralOceanViewUnity-Main" \
    -H "accept: application/json" \
    -H "Authorization: Basic ${NEXUS_CREDENTIALS}" \
    -H "NX-ANTI-CSRF-TOKEN: 0.30681511151995955" \
    -H "X-Nexus-UI: true" \
    --output "build.zip"
RUN rm -rf build/ && unzip build.zip -d build/ && rm build.zip && \
    test -f ./build/ImmersiveTwins-Unity || (echo "Error: Binary file ./build/ImmersiveTwins-Unity not found!" && exit 1)

# Set the working directory to /build and set binary ownership and permissions
WORKDIR /build
COPY --chown=mpukgame . .
RUN chmod +x ./build/ImmersiveTwins-Unity;

# Set binary as the entrypoint
ENTRYPOINT [ "./build/ImmersiveTwins-Unity" ]
