color B
@echo off
echo:
echo       開始下載 purpur.jar (MC version 1.19.3)                   
echo:                             
:labe50
cd %~dp0
curl -O https://api.purpurmc.org/v2/purpur/1.19.3/latest/download
ren download purpur.jar
:labe51
@echo off
rem setting title
title=Minecraft server auto setup tool
mode con cols=70 lines=30
color B                
echo                  purpur.jar(MC version:1.19.3) 下載成功
pause
cls
@echo off
echo:
echo 正在設定檔案......
if not exist StartServer.bat goto label4
if exist 伺服器架設中.bat goto label3
:label3
if not exist usercache.json goto label5
if exist usercache.json goto label6
:label4
echo java -Xmx4096M -Xms1024M -jar purpur.jar nogui> StartServer.bat
echo:
:label5
call StartServer.bat
echo:
@echo off
echo 設定完成！
cls
@echo off
echo:
echo 伺服器即將開始運行......
ping -n 6 127.0.0.1 >NUL
@echo off
cls
color B
echo                      請詳細閱讀 Minecraft EULA
echo:                                                                  
echo:                              
echo        https://account.mojang.com/documents/minecraft_eula                                                                      
echo:   
ping -n 3 127.0.0.1 >NUL
@echo off
echo:
echo:
pause
:label6
@echo off&setlocal enabledelayedexpansion
rem 讀取eula.txt所有內容
for /f "eol=* tokens=*" %%i in (eula.txt) do (
rem 變數a為每行內容
set a=%%i
rem 如果該行有false，則將其改為true
set "a=!a:false=true!"
rem 把修改後的全部行存入$
echo !a!>>$)
rem 用$的內容替換原來eula.txt內容
move $ eula.txt
cls
echo:                                                                
echo 伺服器設定成功！  
cls                                                                               
echo                           即將啟動伺服器...                
@echo off
start StartServer.bat
