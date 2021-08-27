FROM openjdk:8-jre-alpine AS buildStage

ARG FORGE_INSTALLER_URL=https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2855/forge-1.12.2-14.23.5.2855-installer.jar
ARG PIXELMON_SERVER_URL=https://download.nodecdn.net/containers/reforged/server/release/8.2.0/a/Pixelmon-1.12.2-8.2.0-server.jar

WORKDIR /opt/minecraft

# Download forge and pixelmon
ADD ${FORGE_INSTALLER_URL} installer-forge.jar
ADD ${PIXELMON_SERVER_URL} mods/pixelmon-server.jar

# Build forge
RUN chmod go+r /opt/minecraft -R && java -jar /opt/minecraft/installer-forge.jar --installServer; exit 0

# Copy built jar
RUN mv /opt/minecraft/forge-*.jar forge.jar && rm /opt/minecraft/installer-forge.jar

FROM openjdk:8-jre-alpine AS finalStage
COPY --from=buildStage /opt/minecraft /opt/minecraft/

# Working directory
# Worlds, logs, config and plugins will be here
VOLUME /data
WORKDIR /data
EXPOSE 25565

# Entrypoint
ENTRYPOINT exec java -jar -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled $JAVA_OPTS -Dcom.mojang.eula.agree=true /opt/minecraft/forge.jar
