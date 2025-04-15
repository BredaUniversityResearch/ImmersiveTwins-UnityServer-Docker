# This Dockerfile is used to build a container image for a Unity game server.
# source: https://docs.unity.com/ugs/en-us/manual/game-server-hosting/manual/concepts/container-builds

# Create a container built with the base image
FROM unitymultiplay/linux-base-image:ubuntu-noble

# copy game files here
# for example:
WORKDIR /Build
COPY --chown=mpukgame . .

# set your game binary as the entrypoint
ENTRYPOINT [ "./Build/ImmersiveTwins-UnityServer.x86_64" ]

## Create a container build from scratch
## ======================================================== #
##                  Unity base image stuff                  #
## ======================================================== #
#
#FROM ubuntu:noble AS mpuk
#
#RUN addgroup --gid 2000 mpukgame && \
#    useradd -g 2000 -u 2000 -ms /bin/sh mpukgame && \
#    mkdir /game && \
#    chown mpukgame:mpukgame /game && \
#    apt update && \
#    apt upgrade && \
#    apt install -y ca-certificates
#USER mpukgame
#
## ======================================================== #
##                    Custom game stuff                     #
## ======================================================== #
#
#FROM mpuk AS game
#
## copy game files here
## for example:
#WORKDIR /Build
#COPY --chown=mpukgame . .
#
## set your game binary as the entrypoint
# ENTRYPOINT [ "./Build/ImmersiveTwins-UnityServer.x86_64" ]
