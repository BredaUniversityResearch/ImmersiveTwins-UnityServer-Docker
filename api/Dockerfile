# build a local image using the following command:
#   docker build -t cradlewebmaster/docker-api:latest -f Dockerfile .
# to run:
#   docker run -d -p 2375:2375 -v /var/run/docker.sock:/var/run/docker.sock cradlewebmaster/docker-api:latest

FROM alpine

# Add your customizations here
RUN apk add --no-cache socat

# Set the default command
CMD ["sh", "-c", "socat -v TCP-LISTEN:2375,reuseaddr,fork UNIX-CLIENT:/var/run/docker.sock"]
