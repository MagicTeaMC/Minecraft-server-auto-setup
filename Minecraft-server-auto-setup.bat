@echo off
color B
echo       歡迎使用  Minecraft server auto setup tool
echo       請先選擇一個核心
echo       一般伺服器核心
echo       1 為 Spigot(建議)
echo       2 為 CraftBukkit
echo       3 為 Paper
echo       4 為 Purpur
echo:
echo       分流系統核心
echo                  5 為 BungeeCord(建議)
echo                  6 為 Waterfall
set choice=
set /p choice=請選擇一個：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto dspigot
if '%choice%'=='2' goto dcraftbukkit
if '%choice%'=='3' goto dpaper
if '%choice%'=='4' goto dpurpur
if '%choice%'=='5' goto dbungeecord
if '%choice%'=='6' goto dwaterfall
echo 輸入錯誤，請再試一次                          
cd %~dp0
goto start
:dpaper
echo:
echo:
echo:
echo       開始下載 server.jar(Paper) (MC version 1.19.3)
curl -O https://api.papermc.io/v2/projects/paper/versions/1.19.3/builds/413/downloads/paper-1.19.3-413.jar
ren paper-1.19.3-413.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(Paper) (MC version 1.19.3) 下載成功

:dpurpur
echo:
echo:
echo:
echo       開始下載 server.jar(Purpur) (MC version 1.19.3)
curl -O https://api.purpurmc.org/v2/purpur/1.19.3/latest/download
ren download server.jar
cls
echo:
echo:
echo:
echo       server.jar(Purpur) (MC version 1.19.3) 下載成功

:dcraftbukkit
echo:
echo:
echo:
echo       開始下載 server.jar(CraftBukkit) (MC version 1.19.3)
curl -O https://download.getbukkit.org/craftbukkit/craftbukkit-1.19.3.jar
ren craftbukkit-1.19.3.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(CraftBukkit) (MC version 1.19.3) 下載成功

:dspigot
echo:
echo:
echo:
echo       開始下載 server.jar(Spigot) (MC version 1.19.3)
curl -O https://download.getbukkit.org/spigot/spigot-1.19.3.jar
ren spigot-1.19.3.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(Spigot) (MC version 1.19.3) 下載成功

:dbungeecord
echo:
echo:
echo:
echo       開始下載 server.jar(BungeeCord) (MC version 1.19.X)
curl -O https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
ren BungeeCord.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(BungeeCord) (MC version 1.19.X) 下載成功

:dwaterfall
echo:
echo:
echo:
echo       開始下載 server.jar(Waterfall) (MC version 1.19.X)
curl -O https://api.papermc.io/v2/projects/waterfall/versions/1.19/builds/511/downloads/waterfall-1.19-511.jar
ren waterfall-1.19-511.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(Waterfall) (MC version 1.19.X) 下載成功

:labe51
@echo off
title=Minecraft server auto setup tool
mode con cols=70 lines=30
color B                
cls
@echo off
echo:
echo:
echo:
echo       正在設定檔案......
if not exist StartServer.bat goto label4
if exist 伺服器架設中.bat goto label3
:label3
if not exist usercache.json goto label5
if exist usercache.json goto label6
:label4
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
echo:
:label5
call StartServer.bat
echo:
@echo off
echo:
echo:
echo:
echo:
echo       設定完成！
cls
@echo off
echo:
echo 伺服器即將開始運行......
ping -n 6 127.0.0.1 >NUL
@echo off
cls
color B
echo:
echo:
echo:
echo       請詳細閱讀 Minecraft EULA
echo:                                                                  
echo:                              
echo       https://account.mojang.com/documents/minecraft_eula                                                                      
@echo off
echo:
echo:
set eulayn=
set /p eulayn=請輸入"1"同意 Minecraft EULA：
if not '%eulayn%'=='' set choice=%choice:~0,1%
if '%eulayn%'=='1' goto label6
echo 輸入錯誤，請再試一次 
:label6
@echo off&setlocal enabledelayedexpansion
for /f "eol=* tokens=*" %%i in (eula.txt) do (
set a=%%i
set "a=!a:false=true!"
echo !a!>>$)
move $ eula.txt
cls
echo:                                                                
echo       伺服器設定成功！  
cls                                                                               
echo       即將啟動伺服器...                
@echo off
start StartServer.bat
