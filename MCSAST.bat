@echo off
:mcsasstart

set version=1.4.8

title MCSAST v%version%
if exist StartServer.bat goto bungeecordskip
color B
echo ���b�Ұ�... �Y�z�O�ϥ�CMD�׺ݶ}�ҹB���ɡA�b����Java�����ɥi��|�X�{���~�A��ĳ����DoubleCLick�}��
ping -n 1 maoyue.tw >nul
cls

if not %errorlevel%==0 (
    echo �L�k�s�u������A�нT�w�z�������s�u��A��
	goto youdonthavejava
)
where java.exe >nul 2>nul
IF NOT ERRORLEVEL 0 (
    @echo       �Х��w�� Java �~����楻�{��
	@echo       �N�۰ʶ}�� Java �U������ �нT�w�U��������A�����楻�{��
	start "" https://adoptium.net/temurin/releases/
	@echo �ݭn���U�ܡH �w��e��
	@echo       GitHub�G https://github.com/MagicTeaMC/Minecraft-server-auto-setup
    @echo       Discord�Ghttps://discord.gg/uQ4UXANnP2
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

echo       �Х��w�� Java 17�B18�B19�B20 �� 21 �~����楻�{��
echo       �N�۰ʶ}�� Java �U�������A�нT�w�U��������A�����楻�{��
start "" https://adoptium.net/temurin/releases/
@echo �ݭn���U�ܶܡH �w��e��
@echo       GitHub�G https://github.com/MagicTeaMC/Minecraft-server-auto-setup
@echo       Discord�Ghttps://discord.gg/uQ4UXANnP2
goto youdonthavejava

:foundJavaVersion
del javaversion.txt

setlocal
echo:
echo       ���bŪ���̷s������T....
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
echo       �w��ϥ�  Minecraft server auto setup tool (v%version%)

if not %version% equ %content1% (
    echo       �˴���s�����G v%content1%
)
endlocal

echo:
echo       GitHub�G https://github.com/MagicTeaMC/Minecraft-server-auto-setup
echo       Discord�Ghttps://discord.gg/uQ4UXANnP2
echo:
echo:
echo       �Х���ܤ@�Ӯ֤�
echo:
echo       ������A���֤�
echo       1. Paper (��ĳ)
echo       2. Purpur
echo       3. Pufferfish
echo:
echo       ���y���A���֤�
echo       4. Velocity
echo       5. BungeeCord
echo       6. Waterfall
echo:
echo       �Ҳզ��A���֤�
echo       7. Fabric
echo       8. Forge
echo:
echo       ��L�����֤�
echo       9. Folia
echo       10. Vanilla(�쪩�A)
echo:
echo       11. �ϥΦۭq�֤�
set choice=
set /p choice=       �п�ܤ@��(1~11)�G
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
echo       ��J���~�A�ЦA�դ@��
PAUSE
cls                          
cd %~dp0
goto mcsasstart

:dpaper
cls
echo:
setlocal
echo:
echo       ���bŪ���̷s������T....
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
echo       �}�l�U�� Paper (MC version %content2%)
curl -O https://api.papermc.io/v2/projects/paper/versions/%content2%/builds/%content1%/downloads/paper-%content2%-%content1%.jar  >NUL 2>NUL
ren paper-*.jar server.jar
cls
echo:
echo:
echo:
echo       Paper (MC version %content2%) �U������
endlocal
:dpapered
:echo
echo       �n�ϥ� Aikar Flags ��?
echo       �o�O�@�Ӧb�Y�Ǳ��p�U�i�H�����A���įണ�ɪ��ҰʰѼ�
echo       ��J1�Y�ϥΡA��J2�Y�ϥιw�]�ҰʰѼ�
set pachoice=
set /p pachoice=       �п�J�z����ܡG
if '%pachoice%'=='1' goto useaikarflag
if '%pachoice%'=='2' goto dontuseaikarflag
echo       ��J���~�A�ЦA�դ@��
goto dpapered

:dpurpur
cls
setlocal
echo:
echo       ���bŪ���̷s������T....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
set "file=./minecraft.txt"
set /p "content="<"%file%"

del minecraft.txt

cls
echo:
echo       �}�l�U�� Purpur (MC version %content%)
curl -O https://api.purpurmc.org/v2/purpur/%content%/latest/download  >NUL 2>NUL
ren download server.jar
cls
echo:
echo:
echo:
echo       Purpur (MC version %content%) �U������
endlocal
:dpurpured
echo:
echo       �n�ϥ� Aikar Flags ��?
echo       �o�O�@�Ӧb�Y�Ǳ��p�U�i�H�����A���įണ�ɪ��ҰʰѼ�
echo       ��J1�Y�ϥΡA��J2�Y�ϥιw�]�ҰʰѼ�
set puachoice=
set /p puachoice=       �п�J�z����ܡG
if '%puachoice%'=='1' goto useaikarflag
if '%puachoice%'=='2' goto dontuseaikarflag
echo       ��J���~�A�ЦA�դ@��
goto dpurpured

:dpuffer
cls
setlocal
echo:
echo       ���bŪ���̷s������T....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
set "file=./minecraft.txt"
set /p "content="<"%file%"

del minecraft.txt

cls
echo:
echo       �}�l�U�� Pufferfish (MC version %content%)
curl -O https://ci.pufferfish.host/job/Pufferfish-1.20/lastSuccessfulBuild/artifact/build/libs/pufferfish-paperclip-%content%-R0.1-SNAPSHOT-reobf.jar  >NUL 2>NUL
ren pufferfish-paperclip-%content%-R0.1-SNAPSHOT-reobf.jar server.jar
cls
echo:
echo:
echo:
echo       Pufferfish (MC version %content%) �U������
endlocal
:dpuffered
echo:
echo       �n�ϥ� Aikar Flags ��?
echo       �o�O�@�Ӧb�Y�Ǳ��p�U�i�H�����A���įണ�ɪ��ҰʰѼ�
echo       ��J1�Y�ϥΡA��J2�Y�ϥιw�]�ҰʰѼ�
set puachoice=
set /p puachoice=       �п�J�z����ܡG
if '%puachoice%'=='1' goto useaikarflag
if '%puachoice%'=='2' goto dontuseaikarflag
echo       ��J���~�A�ЦA�դ@��
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
echo       ���bŪ���̷s������T....
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
echo       �}�l�U�� Fabric (MC version %content1%)
curl -O https://meta.fabricmc.net/v2/versions/loader/%content1%/%content2%/%content3%/server/jar  >NUL 2>NUL
ren jar server.jar
cls
echo:
echo:
echo:
echo       Fabric (MC version %content1%) �U������
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
endlocal
goto ngrok

:dforge
cls
setlocal
echo:
echo       ���bŪ���̷s������T....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/minecraft.txt  >NUL 2>NUL
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/forge.txt  >NUL 2>NUL
set "file1=./minecraft.txt"
set "file2=./forge.txt"
set /p "content1="<"%file1%"
set /p "content2="<"%file2%"
del minecraft.txt
del forge.txt
echo:
echo       �}�l�U�� Forge �w�˵{�� (MC version %content1%)
curl -O https://maven.minecraftforge.net/net/minecraftforge/forge/%content1%-%content2%/forge-%content1%-%content2%-installer.jar  >NUL 2>NUL
ren forge-*.jar installer.jar
cls
echo:
echo       Forge �w�˵{�� (MC version %content1%) �U������
echo:
echo       �}�l�w�� Forge ���A��(�o�i��ݭn�@�q�ɶ�)
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
echo       ���bŪ���̷s������T....
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
echo       �}�l�U�� Folia (MC version %content2%)
curl -O https://api.papermc.io/v2/projects/folia/versions/%content2%/builds/%content1%/downloads/folia-%content2%-%content1%.jar  >NUL 2>NUL
ren folia-*.jar server.jar
cls
echo:
echo:
echo:
echo       Folia (MC version %content2%) �U������
endlocal
:dfoliaed
:echo
echo       �n�ϥ� Aikar Flags ��?
echo       �o�O�@�Ӧb�Y�Ǳ��p�U�i�H�����A���įണ�ɪ��ҰʰѼ�
echo       ��J1�Y�ϥΡA��J2�Y�ϥιw�]�ҰʰѼ�
set pachoice=
set /p pachoice=       �п�J�z����ܡG
if '%pachoice%'=='1' goto useaikarflag
if '%pachoice%'=='2' goto dontuseaikarflag
echo       ��J���~�A�ЦA�դ@��
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
echo       �}�l�U�� BungeeCord
curl -O https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar  >NUL 2>NUL
ren BungeeCord.jar server.jar
cls
echo:
echo:
echo:
cls
echo:
echo       BungeeCord �U������
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
goto bungeengrok

:dwaterfall
cls
setlocal
echo:
echo       ���bŪ���̷s������T....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/waterfall.txt  >NUL 2>NUL
set "file1=./waterfall.txt"
set /p "content1="<"%file1%"
del waterfall.txt
cls
echo:
echo       �}�l�U�� Waterfall
curl -O https://api.papermc.io/v2/projects/waterfall/versions/1.20/builds/%content1%/downloads/waterfall-1.20-%content1%.jar  >NUL 2>NUL
ren waterfall-1.20-%content1%.jar server.jar
cls
echo:
echo:
echo:
echo       Waterfall �U������
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
endlocal
goto bungeengrok

:dvelocity
cls
setlocal
echo:
echo       ���bŪ���̷s������T....
curl -O https://raw.githubusercontent.com/MagicTeaMC/Minecraft-server-auto-setup/version/velocity.txt  >NUL 2>NUL
set "file1=./velocity.txt"
set /p "content1="<"%file1%"
del velocity.txt
cls
echo:
echo       �}�l�U�� Velocity
curl -O https://api.papermc.io/v2/projects/velocity/versions/3.3.0-SNAPSHOT/builds/%content1%/downloads/velocity-3.3.0-SNAPSHOT-%content1%.jar  >NUL 2>NUL
ren velocity-3.3.0-SNAPSHOT-%content1%.jar server.jar
cls
echo:
echo:
echo:
echo       Velocity �U������
echo java -Xmx512M -Xms124M -jar server.jar nogui> StartServer.bat
endlocal
goto bungeengrok

:dvanilla
cls
echo:
echo       �}�l�U�� Vanilla (MC version 1.20.4)
curl -O https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar  >NUL 2>NUL
cls
echo:
echo:
echo:
echo       Vanilla (MC version 1.20.4) �U������
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:customcore
echo:
echo:
echo       �бN .jar �ɮש�b���{���ۦP�ؿ��U������N��(.jar �ɮפ������R�W)
PAUSE
if exist *.jar (
    goto haveserverjar
) else (
    @echo       �䤣�� .jar �ɮסA�ЦA�դ@��
	goto customcore
)

:haveserverjar
echo:
ren *.jar server.jar
cls
echo:
echo:
echo:
echo       ���A�� .jar �ɮ׳B�z����
echo java -Xmx4096M -Xms1024M -jar server.jar nogui> StartServer.bat
goto ngrok

:ngrok
cls
echo:
echo       �n�]�w NGROK ��?
echo       �o�O�@�ӥi�H���b���P�Ӻ������ҤU���H�[�J���A�����u��
echo       ��J1�Y�}�l�]�w�A��J2�Y���L
set nchoice=
set /p nchoice=       �п�J�z����ܡG
if '%nchoice%'=='1' goto yngrok
if '%nchoice%'=='2' goto labe51
echo       ��J���~�A�ЦA�դ@��
PAUSE
cls                          
goto ngrok

:yngrok
echo:
echo:
echo:
echo       �Y�N�}�l�U�� NGROK
curl -O https://download-ngrok.pages.dev/ngrok.exe >NUL 2>NUL
cls
echo:
echo:
echo:
echo       �Ыe�� NGROK ���O��� Auth token
echo:
echo:
echo       ���b�۰ʶ}�� NGROK ���O....
start "" https://dashboard.ngrok.com/get-started/your-authtoken
echo:
echo:
echo       �p�G�S���۰ʶ}�ҡA�Ф�ʫe�������}�G https://dashboard.ngrok.com/get-started/your-authtoken
set nchoice2=
set /p nchoice2=�п�J Auth token�G
.\ngrok.exe config add-authtoken %nchoice2%
echo ngrok.exe tcp 25565 >> StartNgrok.bat
echo       NGROK�]�w����
goto labe51

:bungeengrok
cls
echo:
echo       �n�]�w NGROK ��?
echo       �o�O�@�ӥi�H���b���P�Ӻ������ҤU���H�[�J���A�����u��
echo       ��J1�Y�}�l�]�w�A��J2�Y���L
set nchoice=
set /p nchoice=       �п�J�z����ܡG
if '%nchoice%'=='1' goto ybngrok
if '%nchoice%'=='2' goto allsetup
echo       ��J���~�A�ЦA�դ@��
PAUSE
cls                          
goto bungeengrok

:ybngrok
echo:
echo:
echo:
echo       �Y�N�}�l�U�� NGROK
curl -O https://download-ngrok.pages.dev/ngrok.exe >NUL 2>NUL
cls
echo:
echo:
echo:
echo       �Ыe�� NGROK ���O��� Auth token
echo:
echo:
echo       ���b�۰ʶ}�� NGROK ���O....
start "" https://dashboard.ngrok.com/get-started/your-authtoken
echo:
echo:
echo       �p�G�S���۰ʶ}�ҡA�Ф�ʫe�������}�G https://dashboard.ngrok.com/get-started/your-authtoken
set nchoice2=
set /p nchoice2=       �п�J Auth token�G
.\ngrok.exe config add-authtoken %nchoice2%
echo ngrok.exe tcp 25565 >> StartNgrok.bat
echo       NGROK �]�w����
goto allsetup

:labe51
mode con cols=70 lines=30
color B                
cls
echo:
echo:
echo:
echo       ���b�]�w�ɮ�......
echo       �o�i��ݭn�@�q�ɶ�
call StartServer.bat >NUL 2>NUL
:mceula
color B
echo:
@echo off
echo:
echo:
echo:
echo:
echo       �]�w�����I
cls
@echo off
echo:
echo       ���A���Y�N�}�l�B��......
@echo off
cls
color B                          
cd %~dp0
echo:
echo:
echo:
echo       �иԲӾ\Ū Minecraft EULA
echo:                                                                  
echo:                              
echo       https://account.mojang.com/documents/minecraft_eula                                                                      
@echo off
echo:
echo:
echo       �Ы����N��P�N Minecraft EULA
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
echo       �n�w�ˤ@�Ǵ����?
echo       �ϥδ���i�H�����A���K�[��h��Υ\��
echo       �z�]�i�H�ۦ�H�U�����U�������A��J plugins ��Ƨ��᭫�Ҧ��A��
echo       https://modrinth.com
:secondplugin
echo:
echo:
echo:
echo       1. EssentialsX - ���A�������i�֪�����A�]�A 130 �h�ӫ��O�M�L�ƥ\��I 
echo       2. LuckPerms - Minecraft ���A�����v������]Bukkit/Spigot�BBungeeCord ���^
echo       3. CoreProtect - �ֳt�B���Ī�����x�O���B�^�u�M��_
echo       4. WorldEdit - �@�ӹ�Ϊ� Minecraft �a�Ͻs�边�C
echo       5. DiscordSRV - �@�ӹ�Ϊ�Discord���q����
echo       6. InteractiveChat - �i���ʲ�Ѵ���C
echo       7. InteractiveChatDiscordSRV - InteractiveChat�������\��A�PDiscord���q�C
echo       8. PvPManager - ²��n�Ϊ�PvP�޲z����C
echo       9. PluginPortal - �i���A���ݪ����ϥΫ��O�U���æw�˴��󪺹�δ���C
echo       10. Vault - �򥻪��g�٨t��
echo       11. Dynmap - �u�W��GUI�a���˵����A�٥i�H�P�b�u���a��ѡA�䴩Lands��a����
echo       12. SSHD - �i�b���w�ݤf�W�ϥ�SSH(Console only),SFTP
echo       ��h����Y�N�s�W....
echo       �п�J leave �H��������w��
echo:
echo       �`�N�G����w�˧�����Цۦ�]�w����A������k�Цۦ�ǲ�
set pchoice=
set /p pchoice=       �п�J�z�����(1~5)�G
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
echo       ��J���~�A�ЦA�դ@��
PAUSE
cls                          
goto plugins

:EssentialsX
cls
echo:
echo       ���b�U�� EssentialsX
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/944809403054452736/1191369528911876158/EssentialsX-2.21.0-dev24-0af4436.jar  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:LuckPerms
cls
echo:
echo       ���b�U�� LuckPerms
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/944809403054452736/1191370041636167680/LuckPerms-Bukkit-5.4.113.jar  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:CoreProtect
cls
echo:
echo       ���b�U�� CoreProtect
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/944809403054452736/1160783093989384223/CoreProtect-22.2.jar  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:WorldEdit
cls
echo:
echo       ���b�U�� WorldEdit
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/944809403054452736/1191370483430604800/worldedit-bukkit-7.2.18-dist.jar  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:DiscordSRV
cls
echo:
echo       ���b�U�� DiscordSRV
echo       ���s�Ұʫ�Эק�/DiscordSRV/config.yml�̪�BotToken�MChannels�ýT�w�z�w�g��Ҧ�����Intents���ﶵ���}(Discord)
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244169007863435264/DiscordSRV-Build-1.27.0.jar?ex=6654222f&is=6652d0af&hm=ab3408e1071a08beaddb87b50c14588bc77b7ad5573c6ffda2d596071708e109&  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:InteractiveChat
cls
echo:
echo       ���b�U�� InteractiveChat
echo       �Y�z�Q�n�NInteractiveChat���\�ੵ����Discord�A�i�H�w��InteractiveDiscordSRVAddon
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244169007175700510/InteractiveChatDiscordSrvAddon-4.2.10.2.jar?ex=6654222e&is=6652d0ae&hm=3de33ab65e0d75c7f66a99b4e7ef1cc6c189e22da1ee2738342ef6bb24fd9834&  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:InteractiveChatSRV
cls
echo:
echo       ���b�U�� InteractiveChatSRV
echo       ������InteractiveChat���������A�ݭn���w��InteractiveChat�MDiscordSRV�~�i�ϥ�
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244169007175700510/InteractiveChatDiscordSrvAddon-4.2.10.2.jar?ex=6654222e&is=6652d0ae&hm=3de33ab65e0d75c7f66a99b4e7ef1cc6c189e22da1ee2738342ef6bb24fd9834&  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:PVP
cls
echo:
echo       ���b�U�� PvPManager
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172604642951168/PvPManager.jar?ex=66542588&is=6652d408&hm=b58ad1328bf279ea9677ea08a928f066de116ece925aca6c4edba87cca56a779&  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:PVP
cls
echo:
echo       ���b�U�� PvPManager
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172604642951168/PvPManager.jar?ex=66542588&is=6652d408&hm=b58ad1328bf279ea9677ea08a928f066de116ece925aca6c4edba87cca56a779&  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:PluginPortal
cls
echo:
echo       ���b�U�� PluginPortal
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172041263775814/PluginPortal-1.5.0.jar?ex=66542502&is=6652d382&hm=d9929fd4e4b105594dceb34bc171e248308cd1a8c0050de208b5762531aa9e1d&  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:Vault
cls
echo:
echo       ���b�U�� Vault
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172040550744074/Vault.jar?ex=66542502&is=6652d382&hm=66ecdf442d62bb944517362f395d3ae102c9a5966508369c293991e005a4a5cb&  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:Dynmap
cls
echo:
echo       ���b�U�� Dynmap
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172040110608414/Dynmap-3.7-beta-5-spigot.jar?ex=66542501&is=6652d381&hm=40a1358ace1aad65a34062c9afc3877a9a5d36023f40600bc6dc2c5223ced5b6&  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:SSHD
cls
echo:
echo       ���b�U�� SSHD
cd ./plugins
curl -O https://cdn.discordapp.com/attachments/1218563696058699779/1244172039431131166/SSHD-1.3.4.jar?ex=66542501&is=6652d381&hm=c2a11f34b59b8406a1eed1e6652866cc3248db1c15f19a2a0e8c5a840fa62c0a&  >NUL 2>NUL
cd ../
cls
echo:
echo �٭n�w�˨�L����ܡH
goto secondplugin

:bungeecordskip
:allsetup
color B
echo:                                                                
echo       ���A���]�w���\�I  
cls                                                                               
echo       �Y�N�Ұʦ��A��...                
@echo off
start StartServer.bat
ping -n 3 127.0.0.1 >NUL
cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('���A���w�g�w�˧����A����u�n�Ұ�"StartServer.bat"�Y�i�A�åB�i�ϥ�"stop"���O�������A��(BungeeCord�Х�"end")�C�p�G�z���]�wNGROK�A�Цb�C���}�A�ɦۦ�Ұ�StartNgrok.bat�A�~�������a�s�u�ܥ~��', 'Minecraft server auto setup tool (���n�T���A�иԲӾ\Ū)', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}" >NUL
cls
echo       �P�±z���ϥΡA�Ы����N���������{��
:youdonthavejava
PAUSE