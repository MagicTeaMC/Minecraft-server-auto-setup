@echo off
if exist StartServer.bat goto bungeecordskip
color B
echo       歡迎使用  Minecraft server auto setup tool (v1.2.0)
echo       GitHub： https://github.com/MagicTeaMC/Minecraft-server-auto-setup
echo:
echo       請先選擇一個核心
echo:
echo       插件伺服器核心
echo       1 為 Spigot
echo       2 為 CraftBukkit
echo       3 為 Paper(建議)
echo       4 為 Purpur
echo:
echo       分流伺服器核心
echo       5 為 BungeeCord
echo       6 為 Waterfall
echo       7 為 Velocity
echo:
echo       模組伺服器核心
echo       8 為 Fabric
echo       9 為 Forge
echo:
echo       其他類型核心
echo       10 為 CatServer 1.18.2
echo       11 為 CatServer 1.12.2
echo       12 為 Mohist 1.12.2
echo       13 為 Mohist 1.16.5
echo       14 為 Mohist 1.18.2
echo       15 為 Folia
set choice=
set /p choice=請選擇一個：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto dspigot
if '%choice%'=='2' goto dcraftbukkit
if '%choice%'=='3' goto dpaper
if '%choice%'=='4' goto dpurpur
if '%choice%'=='5' goto dbungeecord
if '%choice%'=='6' goto dwaterfall
if '%choice%'=='7' goto dvelocity
if '%choice%'=='8' goto dfabric
if '%choice%'=='9' goto dforge
if '%choice%'=='10' goto dcatserver1182
if '%choice%'=='11' goto dcatserver1122
if '%choice%'=='12' goto dmohist1122
if '%choice%'=='13' goto dmohist1165
if '%choice%'=='14' goto dmohist1182
if '%choice%'=='15' goto dfolia
echo 輸入錯誤，請再試一次                          
cd %~dp0
goto start
:dpaper
echo:
echo:
echo:
echo       開始下載 server.jar(Paper) (MC version 1.19.4)
curl -O https://api.papermc.io/v2/projects/paper/versions/1.19.4/builds/538/downloads/paper-1.19.4-538.jar
ren paper-1.19.4-538.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(Paper) (MC version 1.19.4) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:dpurpur
echo:
echo:
echo:
echo       開始下載 server.jar(Purpur) (MC version 1.19.4)
curl -O https://api.purpurmc.org/v2/purpur/1.19.4/latest/download
ren download server.jar
cls
echo:
echo:
echo:
echo       server.jar(Purpur) (MC version 1.19.4) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:dcraftbukkit
echo:
echo:
echo:
echo       開始下載 server.jar(CraftBukkit) (MC version 1.19.4)
curl -O https://download.getbukkit.org/craftbukkit/craftbukkit-1.19.4.jar
ren craftbukkit-1.19.4.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(CraftBukkit) (MC version 1.19.4) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:dspigot
echo:
echo:
echo:
echo       開始下載 server.jar(Spigot) (MC version 1.19.4)
curl -O https://download.getbukkit.org/spigot/spigot-1.19.4.jar
ren spigot-1.19.4.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(Spigot) (MC version 1.19.4) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

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
echo       server.jar(BungeeCord) (MC version 1.19.X) 下載完成
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
goto bungeengrok

:dwaterfall
echo:
echo:
echo:
echo       開始下載 server.jar(Waterfall) (MC version 1.19.X)
curl -O https://api.papermc.io/v2/projects/waterfall/versions/1.19/builds/526/downloads/waterfall-1.19-526.jar
ren waterfall-1.19-526.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(Waterfall) (MC version 1.19.X) 下載完成
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
goto bungeengrok

:dvelocity
echo:
echo:
echo:
echo       開始下載 server.jar(velocity) (MC version 1.19.X)
curl -O https://api.papermc.io/v2/projects/velocity/versions/3.2.0-SNAPSHOT/builds/256/downloads/velocity-3.2.0-SNAPSHOT-256.jar
ren velocity-3.2.0-SNAPSHOT-256.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(Waterfall) (MC version 1.19.X) 下載完成
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
goto bungeengrok

:dcatserver1182
echo:
echo:
echo:
echo       開始下載 server.jar(CatServer) (MC version 1.18.2)
curl -O https://github.com/Luohuayu/CatServer/releases/download/23.05.11-1/CatServer-1.18.2-a59ef063-server.jar
ren CatServer-1.18.2-a59ef063-server.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(CatServer) (MC version 1.18.2) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:dcatserver1165
echo:
echo:
echo:
echo       開始下載 server.jar(CatServer) (MC version 1.16.5)
curl -O https://github.com/Luohuayu/CatServer/releases/download/23.05.14/CatServer-1.16.5-838c8dcc-server.jar
ren CatServer-1.16.5-838c8dcc-server.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(CatServer) (MC version 1.16.5) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:dcatserver1122
echo:
echo:
echo:
echo       開始下載 server.jar(CatServer) (MC version 1.12.2)
curl -O https://github.com/Luohuayu/CatServer/releases/download/23.05.09/CatServer-fed56812-universal.jar
ren CatServer-fed56812-universal.jar server.jar
cls
echo:
echo:
echo:
echo       server.jar(CatServer) (MC version 1.12.2) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:ngrok
echo       要設定NGROK嗎?
echo       這是一個可以讓在不同個網路環境下的人加入伺服器的工具
echo       輸入1即開始設定，輸入2即跳過
set nchoice=
set /p nchoice=請選擇一個：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%nchoice%'=='1' goto yngrok
if '%nchoice%'=='2' goto labe51

:yngrok
echo:
echo:
echo:
echo       即將開始下載NGROK
curl -O https://download-ngrok.pages.dev/ngrok.exe
cls
echo:
echo:
echo:
echo       請前往 NGROK 面板獲取Auth token
echo       網址： https://dashboard.ngrok.com/get-started/your-authtoken
set nchoice2=
set /p nchoice2=請輸入Auth token：
.\ngrok.exe config add-authtoken %nchoice2%
echo ngrok.exe tcp 25565 >> StartNgrok.bat
echo NGROK設定完成
goto labe51

:bungeengrok
echo       要設定NGROK嗎?
echo       這是一個可以讓在不同個網路環境下的人加入伺服器的工具
echo       輸入1即開始設定，輸入2即跳過
set nchoice=
set /p nchoice=請選擇一個：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%nchoice%'=='1' goto ybngrok
if '%nchoice%'=='2' goto allsetup

:ybngrok
echo:
echo:
echo:
echo       即將開始下載NGROK
curl -O https://download-ngrok.pages.dev/ngrok.exe
cls
echo:
echo:
echo:
echo       請前往 NGROK 面板獲取Auth token
echo       網址： https://dashboard.ngrok.com/get-started/your-authtoken
set nchoice2=
set /p nchoice2=請輸入Auth token：
.\ngrok.exe config add-authtoken %nchoice2%
echo ngrok.exe tcp 25565 >> StartNgrok.bat
echo NGROK設定完成
goto allsetup

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
echo:
:label5
call StartServer.bat
color B
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
echo       伺服器即將開始運行......
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
:bungeecordskip
:allsetup
color B
echo:                                                                
echo       伺服器設定成功！  
cls                                                                               
echo       即將啟動伺服器...                
@echo off
start StartServer.bat
ping -n 5 127.0.0.1 >NUL
cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('伺服器已經安裝完成，之後只要啟動"StartServer.bat"即可，並且可使用"stop"指令關閉伺服器(BungeeCord請用"end")。如果您有設定NGROK，請在每次開服時自行啟動StartNgrok.bat，才能讓玩家連線至外網', 'Minecraft server auto setup tool (重要訊息，請詳細閱讀)', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
cls
echo 感謝您的使用，請按任意鍵關閉本程式
PAUSE