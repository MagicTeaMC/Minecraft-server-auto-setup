@echo off
title SpigotBuilder
if exist BuildTools.jar (
    del BuildTools.jar
)
curl -O https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
cls
set /p Input=Minecraft version (e.g. 1.18.2 or latest): || set Input=latest
java -jar BuildTools.jar --rev %Input%
cls
echo Spigot %Input% has been built
pause