@echo off
:mcsasstart
title MCSAST v1.4.1
if exist StartServer.bat goto bungeecordskip
color B
echo 正在啟動...
ping -n 1 github.com >nul
cls

if not %errorlevel%==0 (
    echo 無法連線到網路，請確定您的網路連線後再試
	goto youdonthavejava
)
where java.exe >nul 2>nul
IF NOT ERRORLEVEL 0 (
    @echo       請先安裝 Java 才能執行本程式
	@echo       將自動開啟 Java 下載網站 請確定下載完成後再次執行本程式
	start "" https://adoptium.net/temurin/releases/
	@echo 需要幫助嗎嗎？ 歡迎前往
	@echo       GitHub： https://github.com/MagicTeaMC/Minecraft-server-auto-setup
    @echo       Discord：https://discord.gg/uQ4UXANnP2
	goto youdonthavejava
)

java -version 2> javaversion.txt
findstr /i "17." javaversion.txt > nul
findstr /i "18." javaversion.txt > nul
findstr /i "19." javaversion.txt > nul
findstr /i "20." javaversion.txt > nul

if not %errorlevel% equ 0 (
  echo       請先安裝 Java 17、18、19 或 20 才能執行本程式
  echo       將自動開啟 Java 下載網站，請確定下載完成後再次執行本程式
  start "" https://adoptium.net/temurin/releases/
  @echo 需要幫助嗎嗎？ 歡迎前往
  @echo       GitHub： https://github.com/MagicTeaMC/Minecraft-server-auto-setup
  @echo       Discord：https://discord.gg/uQ4UXANnP2
  goto youdonthavejava
)

del javaversion.txt

cls
color B
cls
echo:       
echo       #     #  #####   #####     #     #####  ####### 
echo       ##   ## #     # #     #   # #   #     #    #    
echo       # # # # #       #        #   #  #          #    
echo       #  #  # #        #####  #     #  #####     #    
echo       #     # #             # #######       #    #    
echo       #     # #     # #     # #     # #     #    #    
echo       #     #  #####   #####  #     #  #####     #  
echo                    by Maoyue(MagicTeaMC)
echo:
echo       歡迎使用  Minecraft server auto setup tool (v1.4.1)
echo       GitHub： https://github.com/MagicTeaMC/Minecraft-server-auto-setup
echo       Discord：https://discord.gg/uQ4UXANnP2
echo:
echo:
echo       請先選擇一個核心
echo:
echo       插件伺服器核心
echo       1.Spigot
echo       2.CraftBukkit
echo       3.Paper (建議)
echo       4.Purpur
echo:
echo       分流伺服器核心
echo       5.BungeeCord
echo       6.Waterfall
echo       7.Velocity
echo:
echo       模組伺服器核心
echo       8.Fabric
echo       9.Forge
echo:
echo       其他類型核心
echo       10.Folia
echo       11.Vanilla(原版服)
echo:
echo       12.使用自訂核心
set choice=
set /p choice=       請選擇一個(1~12)：
if not '%choice%'=='' set choice=%choice:~0,2%
if '%choice%'=='1' goto dspigot
if '%choice%'=='2' goto dcraftbukkit
if '%choice%'=='3' goto dpaper
if '%choice%'=='4' goto dpurpur
if '%choice%'=='5' goto dbungeecord
if '%choice%'=='6' goto dwaterfall
if '%choice%'=='7' goto dvelocity
if '%choice%'=='8' goto dfabric
if '%choice%'=='9' goto dforge
if '%choice%'=='10' goto dfolia
if '%choice%'=='11' goto dvanilla
if '%choice%'=='12' goto customcore
echo       輸入錯誤，請再試一次
PAUSE
cls                          
cd %~dp0
goto mcsasstart

:dpaper
:dpaper1194
cls
echo:
setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/paper.txt  >NUL 2>NUL
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
set "file1=./paper.txt"
set "file2=./minecraft.txt"

set /p "content1="<"%file1%"
set /p "content2="<"%file2%"

del paper.txt
del minecraft.txt
cls

echo:
echo       開始下載 Paper (MC version %content2%)
curl -O https://api.papermc.io/v2/projects/paper/versions/%content2%/builds/%content1%/downloads/paper-%content2%-%content1%.jar  >NUL 2>NUL
ren paper-*.jar server.jar
cls
echo:
echo:
echo:
echo       Paper (MC version %content2%) 下載完成
endlocal
:dpapered
:echo
echo       要使用 Aikar Flags 嗎?
echo       這是一個在某些情況下可以讓伺服器效能提升的啟動參數
echo       輸入1即使用，輸入2即使用預設啟動參數
set pachoice=
set /p pachoice=       請輸入您的選擇：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%pachoice%'=='1' goto paperuseaikarflag
if '%pachoice%'=='2' goto paperdontuseaikarflag
echo       輸入錯誤，請再試一次
goto dpapered
:paperuseaikarflag
echo java -Xms4096M -Xmx4096M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -jar server.jar --nogui >> StartServer.bat
goto ngrok
:paperdontuseaikarflag
echo java -Xmx4096M -Xms1024M -jar server.jar nogui >> StartServer.bat
goto ngrok

:dpurpur
:purpur1194
cls
setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
set "file=./minecraft.txt"
set /p "content="<"%file%"

del minecraft.txt

cls
echo:
echo       開始下載 Purpur (MC version %content%)
curl -O https://api.purpurmc.org/v2/purpur/%content%/latest/download  >NUL 2>NUL
ren download server.jar
cls
echo:
echo:
echo:
echo       Purpur (MC version %content%) 下載完成
endlocal
:dpurpured
echo:
echo       要使用 Aikar Flags 嗎?
echo       這是一個在某些情況下可以讓伺服器效能提升的啟動參數
echo       輸入1即使用，輸入2即使用預設啟動參數
set puachoice=
set /p puachoice=       請輸入您的選擇：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%puachoice%'=='1' goto purpuruseaikarflag
if '%puachoice%'=='2' goto purpurdontuseaikarflag
echo       輸入錯誤，請再試一次
goto dpapered
:purpuruseaikarflag
echo java -Xms4096M -Xmx4096M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -jar server.jar --nogui> StartServer.bat
goto ngrok
:purpurdontuseaikarflag
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:dcraftbukkit
cls
setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
set "file=./minecraft.txt"
set /p "content="<"%file%"
del minecraft.txt
cls
echo:
echo       開始下載 CraftBukkit (MC version %content%)
curl -O https://download.getbukkit.org/craftbukkit/craftbukkit-%content%.jar  >NUL 2>NUL
ren craftbukkit-%content%.jar server.jar
cls
echo:
echo:
echo:
echo       CraftBukkit (MC version %content%) 下載完成
endlocal
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:dspigot
cls
setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
set "file=./minecraft.txt"
set /p "content="<"%file%"
del minecraft.txt
cls
echo:
echo       開始下載 Spigot (MC version %content%)
curl -O https://download.getbukkit.org/spigot/spigot-%content%.jar  >NUL 2>NUL
ren spigot-%content%.jar server.jar
cls
echo:
echo:
echo:
echo       Spigot (MC version %content%) 下載完成
endlocal
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:dfabric
cls
setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/fabric-loader.txt  >NUL 2>NUL
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/fabric-installer.txt  >NUL 2>NUL
set "file1=./minecraft.txt"
set "file2=./fabric-loader.txt"
set "file3=./fabric-installer.txt"
set /p "content1="<"%file1%"
set /p "content2="<"%file2%"
set /p "content3="<"%file3%"
del minecraft.txt
del fabric-loader.txt
del fabric-installer.txt
cls
echo:
echo       開始下載 Fabric (MC version %content1%)
curl -O https://meta.fabricmc.net/v2/versions/loader/%content1%/%content2%/%content3%/server/jar  >NUL 2>NUL
ren jar server.jar
cls
echo:
echo:
echo:
echo       Fabric (MC version %content1%) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
endlocal
goto ngrok

:dforge
cls
setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/forge.txt  >NUL 2>NUL
set "file1=./minecraft.txt"
set "file2=./forge.txt"
set /p "content1="<"%file1%"
set /p "content2="<"%file2%"
del minecraft.txt
del forge.txt
echo:
echo       開始下載 Forge 安裝程式 (MC version %content1%)
curl -O https://maven.minecraftforge.net/net/minecraftforge/forge/%content1%-%content2%/forge-%content1%-%content2%-installer.jar  >NUL 2>NUL
ren forge-*.jar installer.jar
cls
echo:
echo       Forge 安裝程式 (MC version %content1%) 下載完成
echo:
echo       開始安裝 Forge 伺服器(這可能需要一段時間)
endlocal
java -jar installer.jar --installServer  >NUL 2>NUL
del installer.jar
del installer.jar.log
del installer.log
del run.sh
ren run.bat StartServer.bat
goto ngrok

:dfolia
cls
echo:
echo       開始下載 Folia (MC version 1.19.4)
curl -O https://cdn.discordapp.com/attachments/1097029368141844630/1113084228620537968/folia-paperclip-1.19.4-R0.1-SNAPSHOT-reobf.jar  >NUL 2>NUL
ren folia-paperclip-1.19.4-R0.1-SNAPSHOT-reobf.jar server.jar
cls
echo:
echo:
echo:
echo       Folia (MC version 1.19.4) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:dbungeecord
cls
echo:
echo       開始下載 BungeeCord (MC version 1.19.X)
curl -O https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar  >NUL 2>NUL
ren BungeeCord.jar server.jar
cls
echo:
echo:
echo:
cls
echo:
echo       BungeeCord (MC version 1.19.X) 下載完成
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
goto bungeengrok

:dwaterfall
cls
echo:
echo       開始下載 Waterfall (MC version 1.19.X)
curl -O https://api.papermc.io/v2/projects/waterfall/versions/1.19/builds/526/downloads/waterfall-1.19-526.jar  >NUL 2>NUL
ren waterfall-1.19-526.jar server.jar
cls
echo:
echo:
echo:
echo       Waterfall (MC version 1.19.X) 下載完成
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
goto bungeengrok

:dvelocity
cls
echo:
echo       開始下載 Velocity (MC version 1.19.X)
curl -O https://api.papermc.io/v2/projects/velocity/versions/3.2.0-SNAPSHOT/builds/256/downloads/velocity-3.2.0-SNAPSHOT-256.jar  >NUL 2>NUL
ren velocity-3.2.0-SNAPSHOT-256.jar server.jar
cls
echo:
echo:
echo:
echo       Waterfall (MC version 1.19.X) 下載完成
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
goto bungeengrok

:dvanilla
cls
echo:
echo       開始下載 Vanilla (MC version 1.19.4)
curl -O https://piston-data.mojang.com/v1/objects/8f3112a1049751cc472ec13e397eade5336ca7ae/server.jar  >NUL 2>NUL
cls
echo:
echo:
echo:
echo       Vanilla (MC version 1.19.4) 下載完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:customcore
echo:
echo:
echo       請將 .jar 檔案放在此程式相同目錄下後按任意鍵(.jar 檔案不須重命名)
PAUSE
if exist *.jar (
    goto haveserverjar
) else (
    @echo       找不到 .jar 檔案，請再試一次
	goto customcore
)
:haveserverjar
echo:
ren *.jar server.jar
cls
echo:
echo:
echo:
echo       伺服器 .jar 檔案處理完成
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:ngrok
cls
echo:
echo       要設定 NGROK 嗎?
echo       這是一個可以讓在不同個網路環境下的人加入伺服器的工具
echo       輸入1即開始設定，輸入2即跳過
set nchoice=
set /p nchoice=       請輸入您的選擇：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%nchoice%'=='1' goto yngrok
if '%nchoice%'=='2' goto labe51
echo       輸入錯誤，請再試一次
PAUSE
cls                          
goto ngrok

:yngrok
echo:
echo:
echo:
echo       即將開始下載 NGROK
curl -O https://download-ngrok.pages.dev/ngrok.exe >NUL 2>NUL
cls
echo:
echo:
echo:
echo       請前往 NGROK 面板獲取 Auth token
echo:
echo:
echo       正在自動開啟 NGROK 面板....
start "" https://dashboard.ngrok.com/get-started/your-authtoken
echo:
echo:
echo       如果沒有自動開啟，請手動前往此網址： https://dashboard.ngrok.com/get-started/your-authtoken
set nchoice2=
set /p nchoice2=請輸入 Auth token：
.\ngrok.exe config add-authtoken %nchoice2%
echo ngrok.exe tcp 25565 >> StartNgrok.bat
echo       NGROK設定完成
goto labe51

:bungeengrok
cls
echo:
echo       要設定 NGROK 嗎?
echo       這是一個可以讓在不同個網路環境下的人加入伺服器的工具
echo       輸入1即開始設定，輸入2即跳過
set nchoice=
set /p nchoice=       請輸入您的選擇：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%nchoice%'=='1' goto ybngrok
if '%nchoice%'=='2' goto allsetup
echo       輸入錯誤，請再試一次
PAUSE
cls                          
goto bungeengrok

:ybngrok
echo:
echo:
echo:
echo       即將開始下載 NGROK
curl -O https://download-ngrok.pages.dev/ngrok.exe >NUL 2>NUL
cls
echo:
echo:
echo:
echo       請前往 NGROK 面板獲取 Auth token
echo:
echo:
echo       正在自動開啟 NGROK 面板....
start "" https://dashboard.ngrok.com/get-started/your-authtoken
echo:
echo:
echo       如果沒有自動開啟，請手動前往此網址： https://dashboard.ngrok.com/get-started/your-authtoken
set nchoice2=
set /p nchoice2=       請輸入 Auth token：
.\ngrok.exe config add-authtoken %nchoice2%
echo ngrok.exe tcp 25565 >> StartNgrok.bat
echo       NGROK 設定完成
goto allsetup

:labe51
mode con cols=70 lines=30
color B                
cls
echo:
echo:
echo:
echo       正在設定檔案......
echo       這可能需要一段時間
if not exist StartServer.bat goto label5
if exist 伺服器架設中.bat goto label3
:label3
if not exist usercache.json goto label5
if exist usercache.json goto label6
:label4
:label5
call StartServer.bat >NUL 2>NUL
:mceula
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
cd %~dp0
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
set /p eulayn=       請輸入"1"同意 Minecraft EULA：
if not '%eulayn%'=='' set choice=%choice:~0,1%
if '%eulayn%'=='1' goto label6
echo       輸入錯誤，請再試一次
PAUSE
cls                          
goto mceula
:label6
@echo off&setlocal enabledelayedexpansion
for /f "eol=* tokens=*" %%i in (eula.txt) do (
set a=%%i
set "a=!a:false=true!"
echo !a!>>$)
move $ eula.txt
cls

md plugins  >NUL 2>NUL
:plugins
cls
echo:
echo       要安裝一些插件嗎?
echo       使用插件可以為伺服器添加更多實用功能
echo       您也可以自行以下網站下載插件後，放入 plugins 資料夾後重啟伺服器
echo       https://modrinth.com
:secondplugin
echo:
echo:
echo:
echo       1.EssentialsX - EssentialsX 是 Spigot 伺服器必不可少的插件，包括 130 多個指令和適用於任何規模伺服器的無數功能！ 
echo       2.LuckPerms - Minecraft 伺服器的權限插件（Bukkit/Spigot、BungeeCord 等）
echo       3.CoreProtect - 快速、高效的塊日誌記錄、回滾和恢復
echo       4.WorldEdit - 一個實用的 Minecraft 地圖編輯器。
echo       更多插件即將新增....
echo       請輸入 5 結束插件安裝
echo:
echo       注意：插件安裝完成後請自行設定插件，相關方法請自行學習
set pchoice=
set /p pchoice=       請輸入您的選擇(1~5)：
if not '%choice%'=='' set choice=%choice:~0,1%
if '%pchoice%'=='1' goto EssentialsX
if '%pchoice%'=='2' goto LuckPerms
if '%pchoice%'=='3' goto CoreProtect
if '%pchoice%'=='4' goto WorldEdit
if '%pchoice%'=='5' goto allsetup
echo       輸入錯誤，請再試一次
PAUSE
cls                          
goto plugins

:EssentialsX
cls
echo:
echo       正在下載 EssentialsX
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/935036132851318784/1115282815974637598/EssentialsX-2.20.0.jar  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:LuckPerms
cls
echo:
echo       正在下載 LuckPerms
cd ./plugins
curl -O https://download.luckperms.net/1491/bukkit/loader/LuckPerms-Bukkit-5.4.79.jar  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:CoreProtect
cls
echo:
echo       正在下載 CoreProtect
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/935036132851318784/1114529722228027423/CoreProtect-21.3.jar  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:WorldEdit
cls
echo:
echo       正在下載 WorldEdit
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/935036132851318784/1114529721863131237/worldedit-bukkit-7.2.14.jar  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:bungeecordskip
:allsetup
color B
echo:                                                                
echo       伺服器設定成功！  
cls                                                                               
echo       即將啟動伺服器...                
@echo off
start StartServer.bat
ping -n 3 127.0.0.1 >NUL
cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('伺服器已經安裝完成，之後只要啟動"StartServer.bat"即可，並且可使用"stop"指令關閉伺服器(BungeeCord請用"end")。如果您有設定NGROK，請在每次開服時自行啟動StartNgrok.bat，才能讓玩家連線至外網', 'Minecraft server auto setup tool (重要訊息，請詳細閱讀)', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}" >NUL
cls
echo       感謝您的使用，請按任意鍵關閉本程式
:youdonthavejava
PAUSE