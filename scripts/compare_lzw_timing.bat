@echo off
setlocal enabledelayedexpansion

echo 开始比较优化前后LZW算法性能...
echo.

REM 创建结果目录
if not exist "results\timing_comparison" mkdir "results\timing_comparison"

REM 创建结果文件
set RESULT_FILE=results\timing_comparison\lzw_timing_comparison.txt
set CSV_FILE=results\timing_comparison\lzw_timing_comparison.csv

echo LZW算法优化前后性能对比（包含时间测量） > %RESULT_FILE%
echo ================================================= >> %RESULT_FILE%
echo 测试时间: %date% %time% >> %RESULT_FILE%
echo. >> %RESULT_FILE%

echo 文件名,原始大小(字节),版本,压缩后大小(字节),压缩率(%%),压缩时间(ms),解压缩时间(ms) > %CSV_FILE%

REM 测试文件列表
set TEST_FILES=repetitive_1KB.txt english_1KB.txt random_1KB.txt binary_1KB.txt repetitive_10KB.txt english_10KB.txt random_10KB.txt binary_10KB.txt repetitive_100KB.txt english_100KB.txt random_100KB.txt binary_100KB.txt repetitive_1MB.txt english_1MB.txt random_1MB.txt binary_1MB.txt

REM 确保工作目录正确
cd /d "%~dp0\.."
set WORK_DIR=%CD%
set ORIGINAL_LZW=%WORK_DIR%\LZW-Algorithm-master\lzw.exe
set OPTIMIZED_LZW=%WORK_DIR%\bin\lzw.exe
set TEST_DIR=%WORK_DIR%\results\test_txt

REM 检查程序是否存在
if not exist "%ORIGINAL_LZW%" (
    echo 错误：未找到原始版本LZW程序：%ORIGINAL_LZW%
    exit /b 1
)

if not exist "%OPTIMIZED_LZW%" (
    echo 错误：未找到优化版本LZW程序：%OPTIMIZED_LZW%
    exit /b 1
)

REM 初始化汇总变量
set ORIG_TOTAL_RATIO=0
set OPT_TOTAL_RATIO=0
set ORIG_TOTAL_COMP_TIME=0
set OPT_TOTAL_COMP_TIME=0
set ORIG_TOTAL_DECOMP_TIME=0
set OPT_TOTAL_DECOMP_TIME=0
set FILE_COUNT=0

REM 对每个测试文件进行测试
for %%f in (%TEST_FILES%) do (
    echo 测试文件: %%f >> %RESULT_FILE%
    echo ----------------------------- >> %RESULT_FILE%
    
    REM 获取原始文件大小
    for %%F in (%TEST_DIR%\%%f) do set ORIG_SIZE=%%~zF
    echo 原始文件大小: !ORIG_SIZE! 字节 >> %RESULT_FILE%
    echo. >> %RESULT_FILE%
    
    REM 测试原始版本LZW算法
    echo 测试原始版本LZW算法... >> %RESULT_FILE%
    
    REM 创建临时目录
    if not exist "temp" mkdir "temp"
    copy "%TEST_DIR%\%%f" "temp\" > nul
    
    REM 压缩
    cd temp
    set ORIG_COMP_TIME=0
    set ORIG_DECOMP_TIME=0
    
    echo 压缩中...
    "%ORIGINAL_LZW%" -z %%f %%f.lzw > output.txt 2>&1
    
    REM 解析输出中的时间数据
    for /f "tokens=1-4 delims=," %%a in (output.txt) do (
        if "%%a"=="TIMING_DATA" (
            if "%%c"=="compress" (
                set ORIG_COMP_TIME=%%d
            )
        )
    )
    
    REM 解压缩
    echo 解压缩中...
    "%ORIGINAL_LZW%" -e %%f.lzw %%f.dec > output2.txt 2>&1
    
    REM 解析输出中的时间数据
    for /f "tokens=1-4 delims=," %%a in (output2.txt) do (
        if "%%a"=="TIMING_DATA" (
            if "%%c"=="decompress" (
                set ORIG_DECOMP_TIME=%%d
            )
        )
    )
    
    REM 获取压缩后文件大小
    for %%C in (%%f.lzw) do set ORIG_COMP_SIZE=%%~zC
    
    REM 计算压缩率
    set /a ORIG_COMP_RATIO=(!ORIG_SIZE!-!ORIG_COMP_SIZE!)*100/!ORIG_SIZE!
    
    echo 原始版本压缩后大小: !ORIG_COMP_SIZE! 字节 >> %RESULT_FILE%
    echo 原始版本压缩率: !ORIG_COMP_RATIO!%% >> %RESULT_FILE%
    echo 原始版本压缩时间: !ORIG_COMP_TIME! 毫秒 >> %RESULT_FILE%
    echo 原始版本解压缩时间: !ORIG_DECOMP_TIME! 毫秒 >> %RESULT_FILE%
    echo. >> %RESULT_FILE%
    
    echo %%f,!ORIG_SIZE!,原始版本,!ORIG_COMP_SIZE!,!ORIG_COMP_RATIO!,!ORIG_COMP_TIME!,!ORIG_DECOMP_TIME! >> %CSV_FILE%
    
    REM 清理文件
    cd ..
    rmdir /s /q temp
    
    REM 测试优化版本LZW算法
    echo 测试优化版本LZW算法... >> %RESULT_FILE%
    
    REM 创建临时目录
    if not exist "temp" mkdir "temp"
    copy "%TEST_DIR%\%%f" "temp\" > nul
    
    REM 运行优化版本
    cd temp
    echo 运行优化版本...
    "%OPTIMIZED_LZW%" %%f > output.txt 2>&1
    
    REM 解析输出中的时间数据
    set OPT_COMP_TIME=0
    set OPT_DECOMP_TIME=0
    for /f "tokens=1-5 delims=," %%a in (output.txt) do (
        if "%%a"=="TIMING_DATA" (
            set OPT_COMP_TIME=%%c
            set OPT_DECOMP_TIME=%%d
        )
    )
    
    REM 获取压缩后文件大小
    for %%C in (%%f.lzw) do set OPT_COMP_SIZE=%%~zC
    
    REM 计算压缩率
    set /a OPT_COMP_RATIO=(!ORIG_SIZE!-!OPT_COMP_SIZE!)*100/!ORIG_SIZE!
    
    echo 优化版本压缩后大小: !OPT_COMP_SIZE! 字节 >> %RESULT_FILE%
    echo 优化版本压缩率: !OPT_COMP_RATIO!%% >> %RESULT_FILE%
    echo 优化版本压缩时间: !OPT_COMP_TIME! 毫秒 >> %RESULT_FILE%
    echo 优化版本解压缩时间: !OPT_DECOMP_TIME! 毫秒 >> %RESULT_FILE%
    echo. >> %RESULT_FILE%
    
    echo %%f,!ORIG_SIZE!,优化版本,!OPT_COMP_SIZE!,!OPT_COMP_RATIO!,!OPT_COMP_TIME!,!OPT_DECOMP_TIME! >> %CSV_FILE%
    
    REM 清理文件
    cd ..
    rmdir /s /q temp
    
    REM 计算性能提升
    set /a RATIO_IMPROVE=!OPT_COMP_RATIO!-!ORIG_COMP_RATIO!
    
    echo 性能对比: >> %RESULT_FILE%
    echo 压缩率提升: !RATIO_IMPROVE!%% >> %RESULT_FILE%
    
    REM 避免除以零错误
    if !ORIG_COMP_TIME! NEQ 0 (
        set /a COMP_SPEEDUP=(!ORIG_COMP_TIME!-!OPT_COMP_TIME!)*100/!ORIG_COMP_TIME!
        echo 压缩速度提升: !COMP_SPEEDUP!%% >> %RESULT_FILE%
    ) else (
        echo 压缩速度提升: 无法计算 >> %RESULT_FILE%
    )
    
    if !ORIG_DECOMP_TIME! NEQ 0 (
        set /a DECOMP_SPEEDUP=(!ORIG_DECOMP_TIME!-!OPT_DECOMP_TIME!)*100/!ORIG_DECOMP_TIME!
        echo 解压缩速度提升: !DECOMP_SPEEDUP!%% >> %RESULT_FILE%
    ) else (
        echo 解压缩速度提升: 无法计算 >> %RESULT_FILE%
    )
    
    REM 累加汇总数据
    set /a ORIG_TOTAL_RATIO+=!ORIG_COMP_RATIO!
    set /a OPT_TOTAL_RATIO+=!OPT_COMP_RATIO!
    set /a ORIG_TOTAL_COMP_TIME+=!ORIG_COMP_TIME!
    set /a OPT_TOTAL_COMP_TIME+=!OPT_COMP_TIME!
    set /a ORIG_TOTAL_DECOMP_TIME+=!ORIG_DECOMP_TIME!
    set /a OPT_TOTAL_DECOMP_TIME+=!OPT_DECOMP_TIME!
    set /a FILE_COUNT+=1
    
    echo. >> %RESULT_FILE%
    echo ======================================== >> %RESULT_FILE%
    echo. >> %RESULT_FILE%
)

REM 计算平均值
if !FILE_COUNT! NEQ 0 (
    set /a AVG_ORIG_RATIO=!ORIG_TOTAL_RATIO!/!FILE_COUNT!
    set /a AVG_OPT_RATIO=!OPT_TOTAL_RATIO!/!FILE_COUNT!
    set /a AVG_ORIG_COMP_TIME=!ORIG_TOTAL_COMP_TIME!/!FILE_COUNT!
    set /a AVG_OPT_COMP_TIME=!OPT_TOTAL_COMP_TIME!/!FILE_COUNT!
    set /a AVG_ORIG_DECOMP_TIME=!ORIG_TOTAL_DECOMP_TIME!/!FILE_COUNT!
    set /a AVG_OPT_DECOMP_TIME=!OPT_TOTAL_DECOMP_TIME!/!FILE_COUNT!
) else (
    set AVG_ORIG_RATIO=0
    set AVG_OPT_RATIO=0
    set AVG_ORIG_COMP_TIME=0
    set AVG_OPT_COMP_TIME=0
    set AVG_ORIG_DECOMP_TIME=0
    set AVG_OPT_DECOMP_TIME=0
)

REM 生成汇总报告
echo 生成汇总报告...
echo. >> %RESULT_FILE%
echo LZW算法优化前后性能汇总 >> %RESULT_FILE%
echo ================================== >> %RESULT_FILE%
echo. >> %RESULT_FILE%

echo 平均压缩率: >> %RESULT_FILE%
echo 原始版本: !AVG_ORIG_RATIO!%% >> %RESULT_FILE%
echo 优化版本: !AVG_OPT_RATIO!%% >> %RESULT_FILE%
set /a AVG_RATIO_IMPROVE=!AVG_OPT_RATIO!-!AVG_ORIG_RATIO!
echo 提升: !AVG_RATIO_IMPROVE!%% >> %RESULT_FILE%
echo. >> %RESULT_FILE%

echo 平均压缩时间: >> %RESULT_FILE%
echo 原始版本: !AVG_ORIG_COMP_TIME! 毫秒 >> %RESULT_FILE%
echo 优化版本: !AVG_OPT_COMP_TIME! 毫秒 >> %RESULT_FILE%
if !AVG_ORIG_COMP_TIME! NEQ 0 (
    set /a AVG_COMP_SPEEDUP=(!AVG_ORIG_COMP_TIME!-!AVG_OPT_COMP_TIME!)*100/!AVG_ORIG_COMP_TIME!
    echo 提升: !AVG_COMP_SPEEDUP!%% >> %RESULT_FILE%
) else (
    echo 提升: 无法计算 >> %RESULT_FILE%
)
echo. >> %RESULT_FILE%

echo 平均解压缩时间: >> %RESULT_FILE%
echo 原始版本: !AVG_ORIG_DECOMP_TIME! 毫秒 >> %RESULT_FILE%
echo 优化版本: !AVG_OPT_DECOMP_TIME! 毫秒 >> %RESULT_FILE%
if !AVG_ORIG_DECOMP_TIME! NEQ 0 (
    set /a AVG_DECOMP_SPEEDUP=(!AVG_ORIG_DECOMP_TIME!-!AVG_OPT_DECOMP_TIME!)*100/!AVG_ORIG_DECOMP_TIME!
    echo 提升: !AVG_DECOMP_SPEEDUP!%% >> %RESULT_FILE%
) else (
    echo 提升: 无法计算 >> %RESULT_FILE%
)
echo. >> %RESULT_FILE%

echo 测试完成！详细结果已保存到 %RESULT_FILE% 和 %CSV_FILE% 