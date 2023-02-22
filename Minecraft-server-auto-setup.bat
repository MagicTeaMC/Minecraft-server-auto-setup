color B
@echo off
echo       歡迎使用  Minecraft server auto setup tool
echo       請先選擇一個核心版本
echo       1 為 Spigot(建議)
echo       2 為 CraftBukkit
echo       2 為 Paper
echo       3 為 Purpur
set choice=
set /p choice=請選擇一個：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto dspigot
if '%choice%'=='2' goto dcraftbukkit
if '%choice%'=='3' goto dpaper
if '%choice%'=='4' goto dpurpur
echo "%choice%" 輸入錯誤，請再試一次
echo.
echo:
echo:
echo:
echo       開始下載 server.jar (MC version 1.19.3)                   
echo:  
echo:
echo:                           
cd %~dp0
goto start
:dpaper
curl -O https://api.papermc.io/v2/projects/paper/versions/1.19.3/builds/413/downloads/paper-1.19.3-413.jar
ren paper-1.19.3-413.jar server.jar
goto end
:dpurpur
curl -O https://api.purpurmc.org/v2/purpur/1.19.3/latest/download
ren download server.jar
goto end
:dcraftbukkit
curl -O https://download.getbukkit.org/craftbukkit/craftbukkit-1.19.3.jar
ren craftbukkit-1.19.3.jar server.jar
goto end
:dspigot
curl -O https://download.getbukkit.org/spigot/spigot-1.19.3.jar
ren spigot-1.19.3.jar server.jar
goto end
:labe51
@echo off
rem setting title
title=Minecraft server auto setup tool
mode con cols=70 lines=30
color B                
echo       server.jar(MC version:1.19.3) 下載成功
pause
cls
@echo off
echo:
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
echo:   
ping -n 3 127.0.0.1 >NUL
@echo off
echo:
echo:
pause
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
