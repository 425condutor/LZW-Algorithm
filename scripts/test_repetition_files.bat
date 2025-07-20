@echo on
setlocal EnableDelayedExpansion
chcp 65001 > nul
echo 开始测试不同重复率文件的LZW压缩效果... > repetition_test_results.txt
echo ============================================== >> repetition_test_results.txt
echo 测试时间: %date% %time% >> repetition_test_results.txt
echo. >> repetition_test_results.txt

REM 创建存放结果的目录
if not exist "repetition_results" mkdir repetition_results
if not exist "repetition_results\original" mkdir repetition_results\original
if not exist "repetition_results\optimized" mkdir repetition_results\optimized

echo 文件名,原始大小(字节),原始版本压缩后(字节),优化版本压缩后(字节),原始版本压缩率,优化版本压缩率,改进率 > repetition_results\summary.csv

REM 显示要测试的文件
echo 将测试以下文件:
dir repetition_*pct.txt

REM 测试所有不同重复率的文件
for %%F in (repetition_*pct.txt) do (
    echo.
    echo ========================================
    echo 测试文件: %%F
    echo 测试文件: %%F >> repetition_test_results.txt
    echo -------------------------------------------- >> repetition_test_results.txt
    
    REM 测试原始版本LZW
    echo 使用原始版本LZW压缩...
    echo 使用原始版本LZW压缩... >> repetition_test_results.txt
    cd LZW-Algorithm-master
    echo 执行命令: lzw_original.exe -z ..\%%F ..\repetition_results\original\%%F.lzw
    lzw_original.exe -z ..\%%F ..\repetition_results\original\%%F.lzw
    if errorlevel 1 (
        echo 压缩失败，错误代码: !errorlevel!
        echo 压缩失败，错误代码: !errorlevel! >> ..\repetition_test_results.txt
    )
    echo 执行命令: lzw_original.exe -e ..\repetition_results\original\%%F.lzw ..\repetition_results\original\%%F.dec
    lzw_original.exe -e ..\repetition_results\original\%%F.lzw ..\repetition_results\original\%%F.dec
    if errorlevel 1 (
        echo 解压失败，错误代码: !errorlevel!
        echo 解压失败，错误代码: !errorlevel! >> ..\repetition_test_results.txt
    )
    cd ..
    
    REM 测试优化版本LZW
    echo 使用优化版本LZW压缩...
    echo 使用优化版本LZW压缩... >> repetition_test_results.txt
    echo 执行命令: lzw.exe %%F
    lzw.exe %%F
    if errorlevel 1 (
        echo 压缩失败，错误代码: !errorlevel!
        echo 压缩失败，错误代码: !errorlevel! >> repetition_test_results.txt
    )
    
    REM 检查文件是否存在
    if exist %%F.lzw (
        echo 移动文件: %%F.lzw 到 repetition_results\optimized\
        move %%F.lzw repetition_results\optimized\
    ) else (
        echo 警告: %%F.lzw 文件不存在
        echo 警告: %%F.lzw 文件不存在 >> repetition_test_results.txt
    )
    
    if exist %%F.decoded (
        echo 移动文件: %%F.decoded 到 repetition_results\optimized\%%F.dec
        move %%F.decoded repetition_results\optimized\%%F.dec
    ) else (
        echo 警告: %%F.decoded 文件不存在
        echo 警告: %%F.decoded 文件不存在 >> repetition_test_results.txt
    )
    
    REM 检查压缩文件是否存在
    if not exist repetition_results\original\%%F.lzw (
        echo 错误: 原始版本压缩文件不存在
        echo 错误: 原始版本压缩文件不存在 >> repetition_test_results.txt
        goto :continue
    )
    
    if not exist repetition_results\optimized\%%F.lzw (
        echo 错误: 优化版本压缩文件不存在
        echo 错误: 优化版本压缩文件不存在 >> repetition_test_results.txt
        goto :continue
    )
    
    REM 获取文件大小并计算压缩率
    for %%S in (%%F) do set ORIG_SIZE=%%~zS
    for %%S in (repetition_results\original\%%F.lzw) do set ORIG_COMP_SIZE=%%~zS
    for %%S in (repetition_results\optimized\%%F.lzw) do set OPT_COMP_SIZE=%%~zS
    
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
    echo 原始文件大小: !ORIG_SIZE! 字节 >> repetition_test_results.txt
    echo 原始版本压缩后大小: !ORIG_COMP_SIZE! 字节 >> repetition_test_results.txt
    echo 优化版本压缩后大小: !OPT_COMP_SIZE! 字节 >> repetition_test_results.txt
    echo 原始版本压缩率: !ORIG_RATIO!%% >> repetition_test_results.txt
    echo 优化版本压缩率: !OPT_RATIO!%% >> repetition_test_results.txt
    echo 改进率: !IMPROVEMENT!%% >> repetition_test_results.txt
    echo. >> repetition_test_results.txt
    
    REM 添加到CSV摘要
    echo %%F,!ORIG_SIZE!,!ORIG_COMP_SIZE!,!OPT_COMP_SIZE!,!ORIG_RATIO!%%,!OPT_RATIO!%%,!IMPROVEMENT!%% >> repetition_results\summary.csv
    
    :continue
)

echo.
echo 测试完成！结果已保存到 repetition_test_results.txt 和 repetition_results\summary.csv
echo 测试完成！ >> repetition_test_results.txt 