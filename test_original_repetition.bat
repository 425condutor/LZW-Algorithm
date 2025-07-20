@echo on
setlocal EnableDelayedExpansion
chcp 65001 > nul

echo 使用原始LZW算法压缩不同重复率的测试文件... > original_repetition_results.txt
echo ================================================== >> original_repetition_results.txt
echo 测试时间: %date% %time% >> original_repetition_results.txt
echo. >> original_repetition_results.txt

REM 创建存放结果的目录
if not exist "original_repetition_results" mkdir original_repetition_results

echo 文件名,原始大小(字节),压缩后大小(字节),压缩率 > original_repetition_results\summary.csv

REM 测试所有不同重复率的文件
for %%F in (repetition_*pct.txt) do (
    echo.
    echo ========================================
    echo 测试文件: %%F
    echo 测试文件: %%F >> original_repetition_results.txt
    echo -------------------------------------------- >> original_repetition_results.txt
    
    REM 使用原始版本LZW压缩
    echo 使用原始版本LZW压缩...
    echo 使用原始版本LZW压缩... >> original_repetition_results.txt
    cd LZW-Algorithm-master
    echo 执行命令: lzw_original.exe -z ..\%%F ..\original_repetition_results\%%F.lzw
    lzw_original.exe -z ..\%%F ..\original_repetition_results\%%F.lzw
    if errorlevel 1 (
        echo 压缩失败，错误代码: !errorlevel!
        echo 压缩失败，错误代码: !errorlevel! >> ..\original_repetition_results.txt
    )
    cd ..
    
    REM 获取文件大小并计算压缩率
    for %%S in (%%F) do set ORIG_SIZE=%%~zS
    for %%S in (original_repetition_results\%%F.lzw) do set COMP_SIZE=%%~zS
    
    echo 原始文件大小: !ORIG_SIZE! 字节
    echo 压缩后大小: !COMP_SIZE! 字节
    
    REM 计算压缩率
    set /a RATIO=(!ORIG_SIZE!-!COMP_SIZE!)*100/!ORIG_SIZE!
    
    echo 压缩率: !RATIO!%%
    
    REM 输出结果到文件
    echo 原始文件大小: !ORIG_SIZE! 字节 >> original_repetition_results.txt
    echo 压缩后大小: !COMP_SIZE! 字节 >> original_repetition_results.txt
    echo 压缩率: !RATIO!%% >> original_repetition_results.txt
    echo. >> original_repetition_results.txt
    
    REM 添加到CSV摘要
    echo %%F,!ORIG_SIZE!,!COMP_SIZE!,!RATIO!%% >> original_repetition_results\summary.csv
)

echo.
echo 测试完成！结果已保存到 original_repetition_results.txt 和 original_repetition_results\summary.csv
echo 测试完成！ >> original_repetition_results.txt 