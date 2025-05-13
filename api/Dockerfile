FROM alpine

# Add your customizations here
RUN apk add --no-cache socat

# Set the default command
CMD ["sh", "-c", "socat -v TCP-LISTEN:2375,reuseaddr,fork UNIX-CLIENT:/var/run/docker.sock"]
