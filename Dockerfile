FROM openjdk:8-jre-alpine AS buildStage

ARG FORGE_INSTALLER_URL=https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2855/forge-1.12.2-14.23.5.2855-installer.jar
ARG PIXELMON_SERVER_URL=https://download.nodecdn.net/containers/reforged/server/release/8.2.0/a/Pixelmon-1.12.2-8.2.0-server.jar

WORKDIR /opt/minecraft

# Download forge and pixelmon
ADD ${FORGE_INSTALLER_URL} installer-forge.jar
ADD ${PIXELMON_SERVER_URL} mods/pixelmon-server.jar

COPY docker_entrypoint.sh /opt/minecraft/docker_entrypoint.sh

# Build forge
RUN chmod go+rx /opt/minecraft/docker_entrypoint.sh && \
  chmod go+r /opt/minecraft -R && \
  java -jar /opt/minecraft/installer-forge.jar --installServer; exit 0

# Copy built jar
RUN echo eula=true >eula.txt && \
  mv /opt/minecraft/forge-*.jar forge.jar && \
  rm /opt/minecraft/installer-forge.jar

FROM openjdk:8-jre-alpine AS finalStage
COPY --from=buildStage /opt/minecraft /opt/minecraft/

# Working directory
# Worlds, logs, config and plugins will be here
VOLUME /data
WORKDIR /data
EXPOSE 25565

# Entrypoint
ENTRYPOINT ["/opt/minecraft/docker_entrypoint.sh"]
