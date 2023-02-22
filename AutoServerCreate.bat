color B
@echo off
echo:
echo       開始安裝伺服器 .jar [purpur.jar]
echo:
echo:                                                     
echo:                       
echo:                                                                             
echo:                 
echo:                   
echo:                   
echo:                             
:labe50
cd %~dp0
curl -O https://api.purpurmc.org/v2/purpur/1.19.3/latest/download
ren *.jar purpur.jar
:labe51
@echo off
rem setting title
title=Minecraft Server auto setup tool
mode con cols=70 lines=30
echo:
echo:
echo:
echo:
color B                
echo                  purpur.jar 下載完成
echo:  
echo:              
echo:
echo:
pause
cls
if exist purpur.jar goto label2
if not exist purpur.jar goto label1
:label1
color 4
echo   ERROR     
echo         ERROR: 找不到 purpur.jar，請確認 purpur.jar 與此工具在同一個資料夾重試                                                           
color
pause
exit
:label2
echo = 請確認 purpur.jar，放於同一資料夾
echo:
echo:
echo 1.正在檢查伺服器環境
ping -n 2 127.0.0.1:25565 >NUL
@echo off
echo:
echo 2.正在設定伺服器檔案
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
ping -n 3 127.0.0.1 >NUL
@echo off
echo 伺服器檔案創建完成 "StartServer.bat"
ping -n 3 127.0.0.1 >NUL
@echo off
echo:
echo 四、伺服器即將運行...
ping -n 6 127.0.0.1 >NUL
@echo off
cls
color 4
echo:
echo:
echo:
echo:
echo                      請詳細閱讀Minecraft EULA
echo:                                                                  
echo:                              
echo        https://account.mojang.com/documents/minecraft_eula      
echo:                                                                  
echo:                                                                  
echo:  
echo:                                                                
echo                          請稍後三秒                 
echo:                                                                 
echo:   
ping -n 6 127.0.0.1 >NUL
@echo off
echo:
echo:
pause
:label6
rem 定義變數延遲環境，關閉回顯
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
echo:
echo:
echo:
echo:
echo: 
echo:                                                             
echo:                                                                  
echo                          伺服器設定成功                
echo:                                                                 
echo:                                                                  
echo:   
echo:                                                                  
echo                           即將自動啟動伺服器...                
echo:                                                                 
echo:  
echo:
echo:
ping -n 5 127.0.0.1 >NUL
@echo off
start StartServer.bat
