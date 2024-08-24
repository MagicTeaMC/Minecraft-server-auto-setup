@echo off
:mcsasstart

set version=1.4.8

title MCSAST v%version%
if exist StartServer.bat goto bungeecordskip
color B
echo 正在啟動... 若您是使用CMD終端開啟運行檔，在偵測Java版本時可能會出現錯誤，建議直接DoubleCLick開啟
ping -n 1 maoyue.tw >nul
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
	@echo 需要幫助嗎？ 歡迎前往
	@echo       GitHub： https://github.com/MagicTeaMC/Minecraft-server-auto-setup
    @echo       Discord：https://discord.gg/uQ4UXANnP2
	goto youdonthavejava
)
java -version 2> javaversion.txt
findstr /i "17." javaversion.txt > nul
if %errorlevel% equ 0 goto foundJavaVersion
findstr /i "18." javaversion.txt > nul
if %errorlevel% equ 0 goto foundJavaVersion
findstr /i "19." javaversion.txt > nul
if %errorlevel% equ 0 goto foundJavaVersion
findstr /i "20." javaversion.txt > nul
if %errorlevel% equ 0 goto foundJavaVersion
findstr /i "21." javaversion.txt > nul
if %errorlevel% equ 0 goto foundJavaVersion

del javaversion.txt

echo       請先安裝 Java 17、18、19、20 或 21 才能執行本程式
echo       將自動開啟 Java 下載網站，請確定下載完成後再次執行本程式
start "" https://adoptium.net/temurin/releases/
@echo 需要幫助嗎嗎？ 歡迎前往
@echo       GitHub： https://github.com/MagicTeaMC/Minecraft-server-auto-setup
@echo       Discord：https://discord.gg/uQ4UXANnP2
goto youdonthavejava

:foundJavaVersion
del javaversion.txt

setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/version.txt  >NUL 2>NUL
set "file1=./version.txt"

set /p "content1="<"%file1%"

del version.txt
cls

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
echo       歡迎使用  Minecraft server auto setup tool (v%version%)

if not %version% equ %content1% (
    echo       檢測到新版本： v%content1%
)
endlocal

echo:
echo       GitHub： https://github.com/MagicTeaMC/Minecraft-server-auto-setup
echo       Discord：https://discord.gg/uQ4UXANnP2
echo:
echo:
echo       請先選擇一個核心
echo:
echo       插件伺服器核心
echo       1. Paper (建議)
echo       2. Purpur
echo       3. Pufferfish
echo:
echo       分流伺服器核心
echo       4. Velocity
echo       5. BungeeCord
echo       6. Waterfall
echo:
echo       模組伺服器核心
echo       7. Fabric
echo       8. Forge
echo:
echo       其他類型核心
echo       9. Folia
echo       10. Vanilla(原版服)
echo:
echo       11. 使用自訂核心
set choice=
set /p choice=       請選擇一個(1~11)：
if '%choice%'=='1' goto dpaper
if '%choice%'=='2' goto dpurpur
if '%choice%'=='3' goto dpuffer
if '%choice%'=='4' goto dvelocity
if '%choice%'=='5' goto dbungeecord
if '%choice%'=='6' goto dwaterfall
if '%choice%'=='7' goto dfabric
if '%choice%'=='8' goto dforge
if '%choice%'=='9' goto dfolia
if '%choice%'=='10' goto dvanilla
if '%choice%'=='11' goto customcore
echo       輸入錯誤，請再試一次
PAUSE
cls                          
cd %~dp0
goto mcsasstart

:dpaper
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
if '%pachoice%'=='1' goto useaikarflag
if '%pachoice%'=='2' goto dontuseaikarflag
echo       輸入錯誤，請再試一次
goto dpapered

:dpurpur
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
if '%puachoice%'=='1' goto useaikarflag
if '%puachoice%'=='2' goto dontuseaikarflag
echo       輸入錯誤，請再試一次
goto dpurpured

:dpuffer
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
echo       開始下載 Pufferfish (MC version %content%)
curl -O https://ci.pufferfish.host/job/Pufferfish-1.20/lastSuccessfulBuild/artifact/build/libs/pufferfish-paperclip-%content%-R0.1-SNAPSHOT-reobf.jar  >NUL 2>NUL
ren pufferfish-paperclip-%content%-R0.1-SNAPSHOT-reobf.jar server.jar
cls
echo:
echo:
echo:
echo       Pufferfish (MC version %content%) 下載完成
endlocal
:dpuffered
echo:
echo       要使用 Aikar Flags 嗎?
echo       這是一個在某些情況下可以讓伺服器效能提升的啟動參數
echo       輸入1即使用，輸入2即使用預設啟動參數
set puachoice=
set /p puachoice=       請輸入您的選擇：
if '%puachoice%'=='1' goto useaikarflag
if '%puachoice%'=='2' goto dontuseaikarflag
echo       輸入錯誤，請再試一次
goto dpuffered

:useaikarflag
echo java -Xms4096M -Xmx4096M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -jar server.jar --nogui> StartServer.bat
goto ngrok
:dontuseaikarflag
echo java -Xmx4096M -Xms1024M -jar server.jar nogui >> StartServer.bat
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
setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/folia.txt  >NUL 2>NUL
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
set "file1=./folia.txt"
set "file2=./minecraft.txt"

set /p "content1="<"%file1%"
set /p "content2="<"%file2%"

del folia.txt
del minecraft.txt
cls

echo:
echo       開始下載 Folia (MC version %content2%)
curl -O https://api.papermc.io/v2/projects/folia/versions/%content2%/builds/%content1%/downloads/folia-%content2%-%content1%.jar  >NUL 2>NUL
ren folia-*.jar server.jar
cls
echo:
echo:
echo:
echo       Folia (MC version %content2%) 下載完成
endlocal
:dfoliaed
:echo
echo       要使用 Aikar Flags 嗎?
echo       這是一個在某些情況下可以讓伺服器效能提升的啟動參數
echo       輸入1即使用，輸入2即使用預設啟動參數
set pachoice=
set /p pachoice=       請輸入您的選擇：
if '%pachoice%'=='1' goto useaikarflag
if '%pachoice%'=='2' goto dontuseaikarflag
echo       輸入錯誤，請再試一次
goto dfoliaed

:useaikarflag
echo java -Xms4096M -Xmx4096M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -jar server.jar --nogui> StartServer.bat
goto ngrok
:dontuseaikarflag
echo java -Xmx4096M -Xms1024M -jar server.jar nogui >> StartServer.bat
goto ngrok

:dbungeecord
cls
echo:
echo       開始下載 BungeeCord
curl -O https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar  >NUL 2>NUL
ren BungeeCord.jar server.jar
cls
echo:
echo:
echo:
cls
echo:
echo       BungeeCord 下載完成
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
goto bungeengrok

:dwaterfall
cls
setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/waterfall.txt  >NUL 2>NUL
set "file1=./waterfall.txt"
set /p "content1="<"%file1%"
del waterfall.txt
cls
echo:
echo       開始下載 Waterfall
curl -O https://api.papermc.io/v2/projects/waterfall/versions/1.20/builds/%content1%/downloads/waterfall-1.20-%content1%.jar  >NUL 2>NUL
ren waterfall-1.20-%content1%.jar server.jar
cls
echo:
echo:
echo:
echo       Waterfall 下載完成
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
endlocal
goto bungeengrok

:dvelocity
cls
setlocal
echo:
echo       正在讀取最新版本資訊....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/velocity.txt  >NUL 2>NUL
set "file1=./velocity.txt"
set /p "content1="<"%file1%"
del velocity.txt
cls
echo:
echo       開始下載 Velocity
curl -O https://api.papermc.io/v2/projects/velocity/versions/3.3.0-SNAPSHOT/builds/%content1%/downloads/velocity-3.3.0-SNAPSHOT-%content1%.jar  >NUL 2>NUL
ren velocity-3.3.0-SNAPSHOT-%content1%.jar server.jar
cls
echo:
echo:
echo:
echo       Velocity 下載完成
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
endlocal
goto bungeengrok

:dvanilla
cls
echo:
echo       開始下載 Vanilla (MC version 1.20.4)
curl -O https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar  >NUL 2>NUL
cls
echo:
echo:
echo:
echo       Vanilla (MC version 1.20.4) 下載完成
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
echo       請按任意鍵同意 Minecraft EULA
PAUSE
cls
:label6
@echo off&setlocal enabledelayedexpansion
for /f "eol=* tokens=*" %%i in (eula.txt) do (
set a=%%i
set "a=!a:false=true!"
echo !a!>>$)
move $ eula.txt
cls

if '%choice%'=='4' goto allsetup
if '%choice%'=='5' goto allsetup
if '%choice%'=='6' goto allsetup
if '%choice%'=='7' goto allsetup
if '%choice%'=='8' goto allsetup
if '%choice%'=='9' goto allsetup
if '%choice%'=='10' goto allsetup
if '%choice%'=='11' goto allsetup

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
echo       1. EssentialsX - 伺服器必不可少的插件，包括 130 多個指令和無數功能！ 
echo       2. LuckPerms - Minecraft 伺服器的權限插件（Bukkit/Spigot、BungeeCord 等）
echo       3. CoreProtect - 快速、高效的塊日誌記錄、回滾和恢復
echo       4. WorldEdit - 一個實用的 Minecraft 地圖編輯器。
echo       5. DiscordSRV - 一個實用的Discord互通插件
echo       6. InteractiveChat - 可互動聊天插件。
echo       7. InteractiveChatDiscordSRV - InteractiveChat的延伸功能，與Discord互通。
echo       8. PvPManager - 簡單好用的PvP管理插件。
echo       9. PluginPortal - 可伺服器端直接使用指令下載並安裝插件的實用插件。
echo       10. Vault - 基本的經濟系統
echo       11. Dynmap - 線上的GUI地圖檢視器，還可以與在線玩家聊天，支援Lands領地插件
echo       12. SSHD - 可在指定端口上使用SSH(Console only),SFTP
echo       更多插件即將新增....
echo       請輸入 leave 以結束插件安裝
echo:
echo       注意：插件安裝完成後請自行設定插件，相關方法請自行學習
set pchoice=
set /p pchoice=       請輸入您的選擇(1~5)：
if '%pchoice%'=='1' goto EssentialsX
if '%pchoice%'=='2' goto LuckPerms
if '%pchoice%'=='3' goto CoreProtect
if '%pchoice%'=='4' goto WorldEdit
if '%pchoice%'=='5' goto DiscordSRV
if '%pchoice%'=='6' goto InteractiveChat
if '%pchoice%'=='7' goto InteractiveChatSRV
if '%pchoice%'=='8' goto PVP
if '%pchoice%'=='9' goto PluginPortal
if '%pchoice%'=='10' goto Vault
if '%pchoice%'=='11' goto Dynmap
if '%pchoice%'=='12' goto SSHD
if '%pchoice%'=='leave' goto allsetup
echo       輸入錯誤，請再試一次
PAUSE
cls                          
goto plugins

:EssentialsX
cls
echo:
echo       正在下載 EssentialsX
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/944809403054452736/1191369528911876158/EssentialsX-2.21.0-dev24-0af4436.jar  >NUL 2>NUL
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
curl -O https://cdn.discordapp.com/attachments/944809403054452736/1191370041636167680/LuckPerms-Bukkit-5.4.113.jar  >NUL 2>NUL
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
curl -O https://cdn.discordapp.com/attachments/944809403054452736/1160783093989384223/CoreProtect-22.2.jar  >NUL 2>NUL
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
curl -O https://cdn.discordapp.com/attachments/944809403054452736/1191370483430604800/worldedit-bukkit-7.2.18-dist.jar  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:DiscordSRV
cls
echo:
echo       正在下載 DiscordSRV
echo       重新啟動後請修改/DiscordSRV/config.yml裡的BotToken和Channels並確定您已經把所有關於Intents的選項打開(Discord)
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244169007863435264/DiscordSRV-Build-1.27.0.jar?ex=6654222f&is=6652d0af&hm=ab3408e1071a08beaddb87b50c14588bc77b7ad5573c6ffda2d596071708e109&  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:InteractiveChat
cls
echo:
echo       正在下載 InteractiveChat
echo       若您想要將InteractiveChat的功能延伸至Discord，可以安裝InteractiveDiscordSRVAddon
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244169007175700510/InteractiveChatDiscordSrvAddon-4.2.10.2.jar?ex=6654222e&is=6652d0ae&hm=3de33ab65e0d75c7f66a99b4e7ef1cc6c189e22da1ee2738342ef6bb24fd9834&  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:InteractiveChatSRV
cls
echo:
echo       正在下載 InteractiveChatSRV
echo       此插件為InteractiveChat的延伸版，需要先安裝InteractiveChat和DiscordSRV才可使用
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244169007175700510/InteractiveChatDiscordSrvAddon-4.2.10.2.jar?ex=6654222e&is=6652d0ae&hm=3de33ab65e0d75c7f66a99b4e7ef1cc6c189e22da1ee2738342ef6bb24fd9834&  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:PVP
cls
echo:
echo       正在下載 PvPManager
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172604642951168/PvPManager.jar?ex=66542588&is=6652d408&hm=b58ad1328bf279ea9677ea08a928f066de116ece925aca6c4edba87cca56a779&  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:PVP
cls
echo:
echo       正在下載 PvPManager
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172604642951168/PvPManager.jar?ex=66542588&is=6652d408&hm=b58ad1328bf279ea9677ea08a928f066de116ece925aca6c4edba87cca56a779&  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:PluginPortal
cls
echo:
echo       正在下載 PluginPortal
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172041263775814/PluginPortal-1.5.0.jar?ex=66542502&is=6652d382&hm=d9929fd4e4b105594dceb34bc171e248308cd1a8c0050de208b5762531aa9e1d&  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:Vault
cls
echo:
echo       正在下載 Vault
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172040550744074/Vault.jar?ex=66542502&is=6652d382&hm=66ecdf442d62bb944517362f395d3ae102c9a5966508369c293991e005a4a5cb&  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:Dynmap
cls
echo:
echo       正在下載 Dynmap
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172040110608414/Dynmap-3.7-beta-5-spigot.jar?ex=66542501&is=6652d381&hm=40a1358ace1aad65a34062c9afc3877a9a5d36023f40600bc6dc2c5223ced5b6&  >NUL 2>NUL
cd ../
cls
echo:
echo 還要安裝其他插件嗎？
goto secondplugin

:SSHD
cls
echo:
echo       正在下載 SSHD
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172039431131166/SSHD-1.3.4.jar?ex=66542501&is=6652d381&hm=c2a11f34b59b8406a1eed1e6652866cc3248db1c15f19a2a0e8c5a840fa62c0a&  >NUL 2>NUL
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