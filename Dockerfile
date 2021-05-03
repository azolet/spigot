# Spigot 1.16.5 Dockerfile - Example with notes

# Use the offical Debian Docker image with a specified version tag, Stretch, so not all
# versions of Debian images are downloaded.
FROM debian:stretch

# Version of minecraft to download
ENV MINECRAFT_VERSION 1.16.5
ENV PORT 25565

# Use APT (Advanced Packaging Tool) built in the Linux distro to download Java, a dependency
# to run Minecraft.
# First, we need to ensure the right repo is available for JRE 8
# Then we update apt
# Then we pull in all of our dependencies, 
# Finally, we download the correct .jar file using wget
# .jar file fetched from the https://cdn.getbukkit.org/spigot/spigot-1.16.5.jar
RUN apt update; \
    apt install -y default-jre ca-certificates-java curl; \
    echo "eula=true" > /data/eula.txt; \
    echo "java -jar server.jar" > /data/start.sh; \
    chmod +x /data/start.sh; \
    curl -sL https://cdn.getbukkit.org/spigot/spigot-${MINECRAFT_VERSION}.jar -o server.jar;
# We do the above in a single line to reduce the number of layers in our container

# Sets working directory for the CMD instruction (also works for RUN, ENTRYPOINT commands)
# Create mount point, and mark it as holding externally mounted volume
WORKDIR /data
VOLUME /data

# Expose the container's network port: 25565 during runtime.
EXPOSE ${PORT}

# Automatically accept Minecraft EULA, and start Minecraft server
CMD /data/start.sh
