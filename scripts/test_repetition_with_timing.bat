@echo off
setlocal EnableDelayedExpansion
chcp 65001 > nul
echo 开始测试不同重复率文件的LZW压缩效果(包含时间测量)... > repetition_timing_results.txt
echo ============================================== >> repetition_timing_results.txt
echo 测试时间: %date% %time% >> repetition_timing_results.txt
echo. >> repetition_timing_results.txt

REM 创建存放结果的目录
if not exist "repetition_timing" mkdir repetition_timing
if not exist "repetition_timing\original" mkdir repetition_timing\original
if not exist "repetition_timing\optimized" mkdir repetition_timing\optimized

echo 文件名,原始大小(字节),原始版本压缩后(字节),优化版本压缩后(字节),原始版本压缩率,优化版本压缩率,改进率,原始版本压缩时间(ms),优化版本压缩时间(ms),原始版本解压时间(ms),优化版本解压时间(ms) > repetition_timing\summary.csv

REM 显示要测试的文件
echo 将测试以下文件:
dir repetition_*pct.txt

REM 测试所有不同重复率的文件
for %%F in (repetition_*pct.txt) do (
    echo.
    echo ========================================
    echo 测试文件: %%F
    echo 测试文件: %%F >> repetition_timing_results.txt
    echo -------------------------------------------- >> repetition_timing_results.txt
    
    REM 测试原始版本LZW压缩
    echo 使用原始版本LZW压缩...
    echo 使用原始版本LZW压缩... >> repetition_timing_results.txt
    cd LZW-Algorithm-master
    
    REM 记录压缩开始时间
    set START_COMPRESS_TIME=!time!
    echo 开始压缩时间: !START_COMPRESS_TIME! >> ..\repetition_timing_results.txt
    
    echo 执行命令: lzw_original.exe -z ..\%%F ..\repetition_timing\original\%%F.lzw
    lzw_original.exe -z ..\%%F ..\repetition_timing\original\%%F.lzw
    if errorlevel 1 (
        echo 压缩失败，错误代码: !errorlevel!
        echo 压缩失败，错误代码: !errorlevel! >> ..\repetition_timing_results.txt
    )
    
    REM 记录压缩结束时间并计算耗时
    set END_COMPRESS_TIME=!time!
    echo 结束压缩时间: !END_COMPRESS_TIME! >> ..\repetition_timing_results.txt
    
    REM 计算压缩耗时(毫秒)
    call :TimeDiff "!START_COMPRESS_TIME!" "!END_COMPRESS_TIME!"
    set ORIG_COMPRESS_MS=!DIFF_IN_MS!
    echo 原始版本压缩耗时: !ORIG_COMPRESS_MS! 毫秒 >> ..\repetition_timing_results.txt
    
    REM 记录解压开始时间
    set START_DECOMPRESS_TIME=!time!
    echo 开始解压时间: !START_DECOMPRESS_TIME! >> ..\repetition_timing_results.txt
    
    echo 执行命令: lzw_original.exe -e ..\repetition_timing\original\%%F.lzw ..\repetition_timing\original\%%F.dec
    lzw_original.exe -e ..\repetition_timing\original\%%F.lzw ..\repetition_timing\original\%%F.dec
    if errorlevel 1 (
        echo 解压失败，错误代码: !errorlevel!
        echo 解压失败，错误代码: !errorlevel! >> ..\repetition_timing_results.txt
    )
    
    REM 记录解压结束时间并计算耗时
    set END_DECOMPRESS_TIME=!time!
    echo 结束解压时间: !END_DECOMPRESS_TIME! >> ..\repetition_timing_results.txt
    
    REM 计算解压耗时(毫秒)
    call :TimeDiff "!START_DECOMPRESS_TIME!" "!END_DECOMPRESS_TIME!"
    set ORIG_DECOMPRESS_MS=!DIFF_IN_MS!
    echo 原始版本解压耗时: !ORIG_DECOMPRESS_MS! 毫秒 >> ..\repetition_timing_results.txt
    
    cd ..
    
    REM 测试优化版本LZW
    echo 使用优化版本LZW压缩...
    echo 使用优化版本LZW压缩... >> repetition_timing_results.txt
    
    REM 记录压缩开始时间
    set START_COMPRESS_TIME=!time!
    echo 开始压缩时间: !START_COMPRESS_TIME! >> repetition_timing_results.txt
    
    echo 执行命令: lzw.exe %%F
    lzw.exe %%F
    if errorlevel 1 (
        echo 压缩失败，错误代码: !errorlevel!
        echo 压缩失败，错误代码: !errorlevel! >> repetition_timing_results.txt
    )
    
    REM 记录压缩结束时间并计算耗时
    set END_COMPRESS_TIME=!time!
    echo 结束压缩时间: !END_COMPRESS_TIME! >> repetition_timing_results.txt
    
    REM 计算压缩耗时(毫秒)
    call :TimeDiff "!START_COMPRESS_TIME!" "!END_COMPRESS_TIME!"
    set OPT_COMPRESS_MS=!DIFF_IN_MS!
    echo 优化版本压缩耗时: !OPT_COMPRESS_MS! 毫秒 >> repetition_timing_results.txt
    
    REM 检查压缩文件是否存在
    if exist %%F.lzw (
        echo 移动文件: %%F.lzw 到 repetition_timing\optimized\
        move %%F.lzw repetition_timing\optimized\
    ) else (
        echo 警告: %%F.lzw 文件不存在
        echo 警告: %%F.lzw 文件不存在 >> repetition_timing_results.txt
    )
    
    REM 记录解压开始时间
    set START_DECOMPRESS_TIME=!time!
    echo 开始解压时间: !START_DECOMPRESS_TIME! >> repetition_timing_results.txt
    
    REM 执行解压命令
    echo 执行命令: lzw.exe repetition_timing\optimized\%%F.lzw
    lzw.exe repetition_timing\optimized\%%F.lzw
    if errorlevel 1 (
        echo 解压失败，错误代码: !errorlevel!
        echo 解压失败，错误代码: !errorlevel! >> repetition_timing_results.txt
    )
    
    REM 记录解压结束时间并计算耗时
    set END_DECOMPRESS_TIME=!time!
    echo 结束解压时间: !END_DECOMPRESS_TIME! >> repetition_timing_results.txt
    
    REM 计算解压耗时(毫秒)
    call :TimeDiff "!START_DECOMPRESS_TIME!" "!END_DECOMPRESS_TIME!"
    set OPT_DECOMPRESS_MS=!DIFF_IN_MS!
    echo 优化版本解压耗时: !OPT_DECOMPRESS_MS! 毫秒 >> repetition_timing_results.txt
    
    if exist repetition_timing\optimized\%%F.lzw.decoded (
        echo 移动文件: repetition_timing\optimized\%%F.lzw.decoded 到 repetition_timing\optimized\%%F.dec
        move repetition_timing\optimized\%%F.lzw.decoded repetition_timing\optimized\%%F.dec
    ) else (
        echo 警告: repetition_timing\optimized\%%F.lzw.decoded 文件不存在
        echo 警告: repetition_timing\optimized\%%F.lzw.decoded 文件不存在 >> repetition_timing_results.txt
    )
    
    REM 检查压缩文件是否存在
    if not exist repetition_timing\original\%%F.lzw (
        echo 错误: 原始版本压缩文件不存在
        echo 错误: 原始版本压缩文件不存在 >> repetition_timing_results.txt
        goto :continue
    )
    
    if not exist repetition_timing\optimized\%%F.lzw (
        echo 错误: 优化版本压缩文件不存在
        echo 错误: 优化版本压缩文件不存在 >> repetition_timing_results.txt
        goto :continue
    )
    
    REM 获取文件大小并计算压缩率
    for %%S in (%%F) do set ORIG_SIZE=%%~zS
    for %%S in (repetition_timing\original\%%F.lzw) do set ORIG_COMP_SIZE=%%~zS
    for %%S in (repetition_timing\optimized\%%F.lzw) do set OPT_COMP_SIZE=%%~zS
    
    echo 原始文件大小: !ORIG_SIZE! 字节
    echo 原始版本压缩后大小: !ORIG_COMP_SIZE! 字节
    echo 优化版本压缩后大小: !OPT_COMP_SIZE! 字节
    
    REM 计算压缩率和改进率
    set /a ORIG_RATIO=(!ORIG_SIZE!-!ORIG_COMP_SIZE!)*100/!ORIG_SIZE!
    set /a OPT_RATIO=(!ORIG_SIZE!-!OPT_COMP_SIZE!)*100/!ORIG_SIZE!
    set /a IMPROVEMENT=!OPT_RATIO!-!ORIG_RATIO!
    
    echo 原始版本压缩率: !ORIG_RATIO!%%
    echo 优化版本压缩率: !OPT_RATIO!%%
    echo 改进率: !IMPROVEMENT!%%
    
    REM 输出结果到文件
    echo 原始文件大小: !ORIG_SIZE! 字节 >> repetition_timing_results.txt
    echo 原始版本压缩后大小: !ORIG_COMP_SIZE! 字节 >> repetition_timing_results.txt
    echo 优化版本压缩后大小: !OPT_COMP_SIZE! 字节 >> repetition_timing_results.txt
    echo 原始版本压缩率: !ORIG_RATIO!%% >> repetition_timing_results.txt
    echo 优化版本压缩率: !OPT_RATIO!%% >> repetition_timing_results.txt
    echo 改进率: !IMPROVEMENT!%% >> repetition_timing_results.txt
    echo 原始版本压缩耗时: !ORIG_COMPRESS_MS! 毫秒 >> repetition_timing_results.txt
    echo 优化版本压缩耗时: !OPT_COMPRESS_MS! 毫秒 >> repetition_timing_results.txt
    echo 原始版本解压耗时: !ORIG_DECOMPRESS_MS! 毫秒 >> repetition_timing_results.txt
    echo 优化版本解压耗时: !OPT_DECOMPRESS_MS! 毫秒 >> repetition_timing_results.txt
    echo. >> repetition_timing_results.txt
    
    REM 添加到CSV摘要
    echo %%F,!ORIG_SIZE!,!ORIG_COMP_SIZE!,!OPT_COMP_SIZE!,!ORIG_RATIO!%%,!OPT_RATIO!%%,!IMPROVEMENT!%%,!ORIG_COMPRESS_MS!,!OPT_COMPRESS_MS!,!ORIG_DECOMPRESS_MS!,!OPT_DECOMPRESS_MS! >> repetition_timing\summary.csv
    
    :continue
)

echo.
echo 测试完成！结果已保存到 repetition_timing_results.txt 和 repetition_timing\summary.csv
echo 测试完成！ >> repetition_timing_results.txt 
goto :EOF

:TimeDiff
REM 计算两个时间点之间的差值（毫秒）
REM 参数：%1=开始时间，%2=结束时间
setlocal EnableDelayedExpansion

REM 提取时间部分
for /F "tokens=1-4 delims=:,. " %%a in ("%~1") do (
    set /a START_H=%%a
    set /a START_M=%%b
    set /a START_S=%%c
    set /a START_MS=%%d
)

for /F "tokens=1-4 delims=:,. " %%a in ("%~2") do (
    set /a END_H=%%a
    set /a END_M=%%b
    set /a END_S=%%c
    set /a END_MS=%%d
)

REM 计算总毫秒数
set /a START_TOTAL_MS=(!START_H!*3600 + !START_M!*60 + !START_S!)*1000 + !START_MS!*10
set /a END_TOTAL_MS=(!END_H!*3600 + !END_M!*60 + !END_S!)*1000 + !END_MS!*10

REM 如果结束时间小于开始时间，说明跨越了午夜
if !END_TOTAL_MS! LSS !START_TOTAL_MS! (
    set /a END_TOTAL_MS=!END_TOTAL_MS! + 24*3600*1000
)

REM 计算差值
set /a DIFF_IN_MS=!END_TOTAL_MS! - !START_TOTAL_MS!

REM 返回结果
endlocal & set DIFF_IN_MS=%DIFF_IN_MS%
exit /b 