::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCqDJFWN4VE5MSRHRAWQOVe3H4oZ8O3H+vqDo1kYGeY6NorD39Q=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
rem Author:  Liu Siyuan
rem Date:    2020/10/12
rem Contact: liusiyuan@bdcom.com.cn

SETLOCAL ENABLEDELAYEDEXPANSION
set DOS_PATH=%cd%

cd /d %~dp0 

for /f "eol=# tokens=1-2 delims==" %%i in (update-de.txt) do (
    if %%i equ STATIC_FILE_PATH (set STATIC_FILE_PATH=%%j) else (
    if %%i equ DE_DST_PATH (set DE_DST_PATH=%%j) else (
    if %%i equ SOURCE_LIST (set SOURCE_LIST=%%j) else (
    if %%i equ MOUNT_VOLUME (set MOUNT_VOLUME=%%j) else (
    if %%i equ KEEP_DIR (set KEEP_DIR=%%j) else (
    if %%i equ UNZIP_CMD (set UNZIP_CMD=%%j))))))
)

::echo %DOS_PATH:~1,-1%%DOS_PATH:~-1%
cd /d "%DOS_PATH%"

echo -----------------------------------
echo Source list: %SOURCE_LIST%
echo    Dst path: %DE_DST_PATH%
echo   Mount Vol: %MOUNT_VOLUME%
echo Static file: %STATIC_FILE_PATH%
echo    Keep Dir: %KEEP_DIR%
echo   Unzip CMD: %UNZIP_CMD%

if %SOURCE_LIST:~0,2% equ \\ (
    net use 1>nul 2>nul %MOUNT_VOLUME%
    if %errorlevel% neq 0 net use 1>nul 2>nul %MOUNT_VOLUME% %SOURCE_LIST%
    if %errorlevel% neq 0 net use %MOUNT_VOLUME%
    set DE_SRC_PATH=%MOUNT_VOLUME%
) else (
    set DE_SRC_PATH=%SOURCE_LIST%
)

if not defined UNZIP_CMD (
    echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
    echo Error:UNZIP_CMD is not defined^^!
    echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
    goto label_end
)

:label_input_en_name
echo -----------------------------------
echo Input the name of environment:
set EN_NAME=
set /p EN_NAME=
if not defined EN_NAME goto label_input_en_name
for %%m in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    set EN_NAME=!EN_NAME:%%m=%%m!)

set "EN_NAME=SWITCH_OLT_%EN_NAME%"

if not exist %DE_DST_PATH%%EN_NAME% (
    echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
    echo "%DE_DST_PATH%%EN_NAME%" is not exist^^!
    echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
    echo.
    goto label_input_en_name
)

if not exist %DE_SRC_PATH%%EN_NAME% (
    echo "%DE_SRC_PATH%%EN_NAME%" is not exist^^!
    goto label_input_en_name
)

set DE_SRC_PATH=%DE_SRC_PATH%%EN_NAME%
set OLD_DE_PATH=%DE_DST_PATH%%EN_NAME%

echo -----------------------------------
dir /OD/B %DE_SRC_PATH%
echo -----------------------------------
echo Source list: [%SOURCE_LIST%\%EN_NAME%]
:label_input_en_ver
echo -----------------------------------
echo Input the version number you expect:
set EN_VER=
set /p EN_VER=
if not defined EN_VER goto label_input_en_ver
set FOUND_DE=0
for /f %%d in ('dir /a-d/o-d/b %DE_SRC_PATH%') do (
    set EN_RAR=%%d
    for /f "tokens=3-4 delims=]-" %%i in ("%%d") do (
        set EN_DATE=%%j
        if !EN_VER! equ %%i (
            set FOUND_DE=1
            goto label_init_proc
        )
    )
)

echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
echo %EN_NAME%-%EN_VER% is not exist^^!
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
goto label_input_en_ver

:label_init_proc
echo -----------------------------------
echo.
echo ***********************************
echo Initializing...
for /f "delims=" %%D in (
    'dir /A:D-H/B %OLD_DE_PATH%'
) do (
    set NEED_DEL=1
    if defined KEEP_DIR (
        for %%k in (%KEEP_DIR%) do (
            if %%D equ %%k set NEED_DEL=0))
    
    if !NEED_DEL! equ 1 (
        echo Delete %%D ...
        rd /s/q %OLD_DE_PATH%\"%%D"
    )
)

dir 1>nul 2>nul /A:-D-H/B %OLD_DE_PATH%
if %errorlevel% equ 0 (
    for /f "delims=" %%F in (
        'dir /A:-D-H/B %OLD_DE_PATH%'
    ) do (del %OLD_DE_PATH%\"%%F")
)

::Check whether the specified file is cleared
set ERROR=0
for /f %%D in (
    'dir /A:D-H/B %OLD_DE_PATH%'
) do (
    set NEED_DEL=1
    if defined KEEP_DIR (
        for %%k in (%KEEP_DIR%) do (
            if %%D equ %%k set NEED_DEL=0))

    if !NEED_DEL! equ 1 set ERROR=1
)

dir 2>nul /A:-D-H/B %OLD_DE_PATH%
if %errorlevel% equ 0 (
    for /f %%F in (
        'dir /A:-D/B %OLD_DE_PATH%'
    ) do (set ERROR=1)
)

if defined STATIC_FILE_PATH (
    copy >nul /-y %STATIC_FILE_PATH%%EN_NAME%\*.def %OLD_DE_PATH%\
    copy >nul /-y %STATIC_FILE_PATH%%EN_NAME%\*.bat %OLD_DE_PATH%\
)

if %ERROR% equ 0 goto label_init_cmpl
echo.
echo --------------------------------------------------------------
echo Initialization is not complete.Do you want to try again?[Y/N]:
:label_error_proc
set "retry="
set /p retry=
if not defined retry (goto label_display_error_msg)

if %retry:~0,1% equ y goto label_init_proc
if %retry:~0,1% equ Y goto label_init_proc
if %retry:~0,1% equ n goto label_end
if %retry:~0,1% equ N goto label_end

:label_display_error_msg
echo ---------------------------------------
echo Invalid input,please enter again^^![Y/N]:
goto label_error_proc

:label_init_cmpl
echo.
echo Initialization complete^^!
echo ***********************************

:label_update_de_proc
if %FOUND_DE% equ 1 (
    echo.
    echo ***********************************
    echo --------------DE_INFO--------------
    echo NAME : %EN_NAME%
    echo Date : %EN_DATE:~0,4%/%EN_DATE:~4,2%/%EN_DATE:~6,2%
    echo Ver  : %EN_VER%
    echo -----------------------------------
    echo Updating...
    %UNZIP_CMD% %DE_SRC_PATH%\%EN_RAR% %DE_DST_PATH%
    echo.
    echo update completed^^!
    echo ***********************************
) 

:label_end
::timeout 1>nul /t 1
::net use 1>nul Z: /del
echo.
echo -----------------------------------
echo Press any key to exit...
pause>nul
