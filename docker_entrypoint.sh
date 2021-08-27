#!/bin/sh
mkdir -p /data/mods && \
rm -f /data/mods/*.jar && \
cp /opt/minecraft/mods/*.jar /data/mods/ && \
exec java -jar -XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=100 -XX:+DisableExplicitGC -XX:TargetSurvivorRatio=90 -XX:G1NewSizePercent=50 -XX:G1MaxNewSizePercent=80 -XX:G1MixedGCLiveThresholdPercent=35 -XX:+AlwaysPreTouch -XX:+ParallelRefProcEnabled $JAVA_OPTS -Dcom.mojang.eula.agree=true /opt/minecraft/forge.jar