@echo off
setlocal enabledelayedexpansion

echo 开始比较不同压缩算法性能...
echo.

REM 创建结果目录
if not exist "results\compression_comparison" mkdir "results\compression_comparison"

REM 创建结果文件
set RESULT_FILE=results\compression_comparison\algorithm_comparison.txt
set CSV_FILE=results\compression_comparison\algorithm_comparison.csv

echo 压缩算法性能比较 > %RESULT_FILE%
echo ======================= >> %RESULT_FILE%
echo 测试时间: %date% %time% >> %RESULT_FILE%
echo. >> %RESULT_FILE%

echo 文件名,原始大小(字节),算法,压缩后大小(字节),压缩率(%%),压缩时间(ms),解压缩时间(ms) > %CSV_FILE%

REM 测试文件列表
set TEST_FILES=repetitive_1KB.txt english_1KB.txt random_1KB.txt binary_1KB.txt repetitive_100KB.txt english_100KB.txt random_100KB.txt binary_100KB.txt repetitive_1MB.txt english_1MB.txt

REM 对每个测试文件进行测试
for %%f in (%TEST_FILES%) do (
    echo 测试文件: %%f >> %RESULT_FILE%
    echo ----------------------------- >> %RESULT_FILE%
    
    REM 获取原始文件大小
    for %%F in (%%f) do set ORIG_SIZE=%%~zF
    echo 原始文件大小: !ORIG_SIZE! 字节 >> %RESULT_FILE%
    echo. >> %RESULT_FILE%
    
    REM 测试LZW算法 (优化版)
    echo 测试LZW算法 (优化版)... >> %RESULT_FILE%
    
    REM 测量压缩时间
    set START_TIME=!time!
    lzw.exe %%f > nul
    set END_TIME=!time!
    call :calculate_time_diff "!START_TIME!" "!END_TIME!" COMP_TIME
    
    REM 获取压缩后文件大小
    for %%C in (%%f.lzw) do set COMP_SIZE=%%~zC
    
    REM 计算压缩率
    set /a COMP_RATIO=(!ORIG_SIZE!-!COMP_SIZE!)*100/!ORIG_SIZE!
    
    REM 测量解压缩时间
    set START_TIME=!time!
    REM 这里假设LZW程序在压缩时已经同时进行了解压缩测试
    REM 如果不是，需要添加单独的解压缩命令
    set END_TIME=!time!
    call :calculate_time_diff "!START_TIME!" "!END_TIME!" DECOMP_TIME
    
    echo 压缩后大小: !COMP_SIZE! 字节 >> %RESULT_FILE%
    echo 压缩率: !COMP_RATIO!%% >> %RESULT_FILE%
    echo 压缩时间: !COMP_TIME! 毫秒 >> %RESULT_FILE%
    echo 解压缩时间: !DECOMP_TIME! 毫秒 >> %RESULT_FILE%
    echo. >> %RESULT_FILE%
    
    echo %%f,!ORIG_SIZE!,LZW,!COMP_SIZE!,!COMP_RATIO!,!COMP_TIME!,!DECOMP_TIME! >> %CSV_FILE%
    
    REM 清理LZW生成的文件
    del %%f.lzw > nul 2>&1
    del %%f.decoded > nul 2>&1
    
    REM 测试ZIP算法
    echo 测试ZIP算法... >> %RESULT_FILE%
    
    REM 测量压缩时间
    set START_TIME=!time!
    powershell -command "Compress-Archive -Path '%%f' -DestinationPath '%%f.zip' -Force" > nul
    set END_TIME=!time!
    call :calculate_time_diff "!START_TIME!" "!END_TIME!" COMP_TIME
    
    REM 获取压缩后文件大小
    for %%C in (%%f.zip) do set COMP_SIZE=%%~zC
    
    REM 计算压缩率
    set /a COMP_RATIO=(!ORIG_SIZE!-!COMP_SIZE!)*100/!ORIG_SIZE!
    
    REM 测量解压缩时间
    set START_TIME=!time!
    powershell -command "Expand-Archive -Path '%%f.zip' -DestinationPath 'temp_extract' -Force" > nul
    set END_TIME=!time!
    call :calculate_time_diff "!START_TIME!" "!END_TIME!" DECOMP_TIME
    
    echo 压缩后大小: !COMP_SIZE! 字节 >> %RESULT_FILE%
    echo 压缩率: !COMP_RATIO!%% >> %RESULT_FILE%
    echo 压缩时间: !COMP_TIME! 毫秒 >> %RESULT_FILE%
    echo 解压缩时间: !DECOMP_TIME! 毫秒 >> %RESULT_FILE%
    echo. >> %RESULT_FILE%
    
    echo %%f,!ORIG_SIZE!,ZIP,!COMP_SIZE!,!COMP_RATIO!,!COMP_TIME!,!DECOMP_TIME! >> %CSV_FILE%
    
    REM 清理ZIP生成的文件
    del %%f.zip > nul 2>&1
    rmdir /s /q temp_extract > nul 2>&1
    
    REM 测试7z算法
    echo 测试7z算法... >> %RESULT_FILE%
    
    REM 检查7z是否安装
    where 7z >nul 2>&1
    if !errorlevel! equ 0 (
        REM 测量压缩时间
        set START_TIME=!time!
        7z a -t7z %%f.7z %%f > nul
        set END_TIME=!time!
        call :calculate_time_diff "!START_TIME!" "!END_TIME!" COMP_TIME
        
        REM 获取压缩后文件大小
        for %%C in (%%f.7z) do set COMP_SIZE=%%~zC
        
        REM 计算压缩率
        set /a COMP_RATIO=(!ORIG_SIZE!-!COMP_SIZE!)*100/!ORIG_SIZE!
        
        REM 测量解压缩时间
        set START_TIME=!time!
        7z x %%f.7z -otemp_extract > nul
        set END_TIME=!time!
        call :calculate_time_diff "!START_TIME!" "!END_TIME!" DECOMP_TIME
        
        echo 压缩后大小: !COMP_SIZE! 字节 >> %RESULT_FILE%
        echo 压缩率: !COMP_RATIO!%% >> %RESULT_FILE%
        echo 压缩时间: !COMP_TIME! 毫秒 >> %RESULT_FILE%
        echo 解压缩时间: !DECOMP_TIME! 毫秒 >> %RESULT_FILE%
        echo. >> %RESULT_FILE%
        
        echo %%f,!ORIG_SIZE!,7z,!COMP_SIZE!,!COMP_RATIO!,!COMP_TIME!,!DECOMP_TIME! >> %CSV_FILE%
        
        REM 清理7z生成的文件
        del %%f.7z > nul 2>&1
        rmdir /s /q temp_extract > nul 2>&1
    ) else (
        echo 未找到7z命令，跳过7z测试 >> %RESULT_FILE%
        echo. >> %RESULT_FILE%
    )
    
    REM 测试GZIP算法
    echo 测试GZIP算法... >> %RESULT_FILE%
    
    REM 检查gzip是否安装
    where gzip >nul 2>&1
    if !errorlevel! equ 0 (
        REM 复制原文件以保留原始文件
        copy %%f %%f.copy > nul
        
        REM 测量压缩时间
        set START_TIME=!time!
        gzip -f %%f.copy
        set END_TIME=!time!
        call :calculate_time_diff "!START_TIME!" "!END_TIME!" COMP_TIME
        
        REM 获取压缩后文件大小
        for %%C in (%%f.copy.gz) do set COMP_SIZE=%%~zC
        
        REM 计算压缩率
        set /a COMP_RATIO=(!ORIG_SIZE!-!COMP_SIZE!)*100/!ORIG_SIZE!
        
        REM 测量解压缩时间
        set START_TIME=!time!
        gzip -d -f %%f.copy.gz
        set END_TIME=!time!
        call :calculate_time_diff "!START_TIME!" "!END_TIME!" DECOMP_TIME
        
        echo 压缩后大小: !COMP_SIZE! 字节 >> %RESULT_FILE%
        echo 压缩率: !COMP_RATIO!%% >> %RESULT_FILE%
        echo 压缩时间: !COMP_TIME! 毫秒 >> %RESULT_FILE%
        echo 解压缩时间: !DECOMP_TIME! 毫秒 >> %RESULT_FILE%
        echo. >> %RESULT_FILE%
        
        echo %%f,!ORIG_SIZE!,GZIP,!COMP_SIZE!,!COMP_RATIO!,!COMP_TIME!,!DECOMP_TIME! >> %CSV_FILE%
        
        REM 清理GZIP生成的文件
        del %%f.copy > nul 2>&1
    ) else (
        echo 未找到gzip命令，跳过GZIP测试 >> %RESULT_FILE%
        echo. >> %RESULT_FILE%
    )
    
    REM 测试BZIP2算法
    echo 测试BZIP2算法... >> %RESULT_FILE%
    
    REM 检查bzip2是否安装
    where bzip2 >nul 2>&1
    if !errorlevel! equ 0 (
        REM 复制原文件以保留原始文件
        copy %%f %%f.copy > nul
        
        REM 测量压缩时间
        set START_TIME=!time!
        bzip2 -f %%f.copy
        set END_TIME=!time!
        call :calculate_time_diff "!START_TIME!" "!END_TIME!" COMP_TIME
        
        REM 获取压缩后文件大小
        for %%C in (%%f.copy.bz2) do set COMP_SIZE=%%~zC
        
        REM 计算压缩率
        set /a COMP_RATIO=(!ORIG_SIZE!-!COMP_SIZE!)*100/!ORIG_SIZE!
        
        REM 测量解压缩时间
        set START_TIME=!time!
        bzip2 -d -f %%f.copy.bz2
        set END_TIME=!time!
        call :calculate_time_diff "!START_TIME!" "!END_TIME!" DECOMP_TIME
        
        echo 压缩后大小: !COMP_SIZE! 字节 >> %RESULT_FILE%
        echo 压缩率: !COMP_RATIO!%% >> %RESULT_FILE%
        echo 压缩时间: !COMP_TIME! 毫秒 >> %RESULT_FILE%
        echo 解压缩时间: !DECOMP_TIME! 毫秒 >> %RESULT_FILE%
        echo. >> %RESULT_FILE%
        
        echo %%f,!ORIG_SIZE!,BZIP2,!COMP_SIZE!,!COMP_RATIO!,!COMP_TIME!,!DECOMP_TIME! >> %CSV_FILE%
        
        REM 清理BZIP2生成的文件
        del %%f.copy > nul 2>&1
    ) else (
        echo 未找到bzip2命令，跳过BZIP2测试 >> %RESULT_FILE%
        echo. >> %RESULT_FILE%
    )
    
    echo. >> %RESULT_FILE%
)

echo 测试完成！结果已保存到 %RESULT_FILE% 和 %CSV_FILE%

goto :eof

:calculate_time_diff
REM 计算两个时间之间的差值（毫秒）
REM 参数：%1=开始时间，%2=结束时间，%3=返回变量名
setlocal

set START=%1
set END=%2

REM 提取小时、分钟、秒和毫秒
for /f "tokens=1-4 delims=:,. " %%a in ("%START%") do (
    set /a START_H=%%a
    set /a START_M=%%b
    set /a START_S=%%c
    set /a START_MS=%%d
)

for /f "tokens=1-4 delims=:,. " %%a in ("%END%") do (
    set /a END_H=%%a
    set /a END_M=%%b
    set /a END_S=%%c
    set /a END_MS=%%d
)

REM 计算总毫秒数
set /a START_TOTAL_MS=(START_H*3600 + START_M*60 + START_S)*1000 + START_MS*10
set /a END_TOTAL_MS=(END_H*3600 + END_M*60 + END_S)*1000 + END_MS*10

REM 处理跨天的情况
if %END_TOTAL_MS% lss %START_TOTAL_MS% (
    set /a END_TOTAL_MS=END_TOTAL_MS+86400000
)

set /a DIFF_MS=END_TOTAL_MS-START_TOTAL_MS

REM 返回结果
endlocal & set %3=%DIFF_MS%
goto :eof 