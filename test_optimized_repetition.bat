@echo on
setlocal EnableDelayedExpansion
chcp 65001 > nul

echo 使用优化版LZW算法压缩不同重复率的测试文件... > optimized_repetition_results.txt
echo ================================================== >> optimized_repetition_results.txt
echo 测试时间: %date% %time% >> optimized_repetition_results.txt
echo. >> optimized_repetition_results.txt

REM 创建存放结果的目录
if not exist "optimized_repetition_results" mkdir optimized_repetition_results

echo 文件名,原始大小(字节),压缩后大小(字节),压缩率 > optimized_repetition_results\summary.csv

REM 测试所有不同重复率的文件
for %%F in (repetition_*pct.txt) do (
    echo.
    echo ========================================
    echo 测试文件: %%F
    echo 测试文件: %%F >> optimized_repetition_results.txt
    echo -------------------------------------------- >> optimized_repetition_results.txt
    
    REM 使用优化版本LZW压缩
    echo 使用优化版本LZW压缩...
    echo 使用优化版本LZW压缩... >> optimized_repetition_results.txt
    echo 执行命令: lzw.exe %%F
    lzw.exe %%F
    if errorlevel 1 (
        echo 压缩失败，错误代码: !errorlevel!
        echo 压缩失败，错误代码: !errorlevel! >> optimized_repetition_results.txt
    )
    
    REM 检查文件是否存在
    if exist %%F.lzw (
        echo 移动文件: %%F.lzw 到 optimized_repetition_results\
        move %%F.lzw optimized_repetition_results\
    ) else (
        echo 警告: %%F.lzw 文件不存在
        echo 警告: %%F.lzw 文件不存在 >> optimized_repetition_results.txt
    )
    
    if exist %%F.decoded (
        echo 移动文件: %%F.decoded 到 optimized_repetition_results\
        move %%F.decoded optimized_repetition_results\
    )
    
    REM 获取文件大小并计算压缩率
    for %%S in (%%F) do set ORIG_SIZE=%%~zS
    for %%S in (optimized_repetition_results\%%F.lzw) do set COMP_SIZE=%%~zS
    
    echo 原始文件大小: !ORIG_SIZE! 字节
    echo 压缩后大小: !COMP_SIZE! 字节
    
    REM 计算压缩率
    set /a RATIO=(!ORIG_SIZE!-!COMP_SIZE!)*100/!ORIG_SIZE!
    
    echo 压缩率: !RATIO!%%
    
    REM 输出结果到文件
    echo 原始文件大小: !ORIG_SIZE! 字节 >> optimized_repetition_results.txt
    echo 压缩后大小: !COMP_SIZE! 字节 >> optimized_repetition_results.txt
    echo 压缩率: !RATIO!%% >> optimized_repetition_results.txt
    echo. >> optimized_repetition_results.txt
    
    REM 添加到CSV摘要
    echo %%F,!ORIG_SIZE!,!COMP_SIZE!,!RATIO!%% >> optimized_repetition_results\summary.csv
)

echo.
echo 测试完成！结果已保存到 optimized_repetition_results.txt 和 optimized_repetition_results\summary.csv
echo 测试完成！ >> optimized_repetition_results.txt 