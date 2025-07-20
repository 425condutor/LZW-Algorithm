@echo on
setlocal EnableDelayedExpansion
chcp 65001 > nul

echo 比较原始版本和优化版本LZW算法在不同重复率文件上的压缩效果... > comparison_repetition_results.txt
echo ================================================================= >> comparison_repetition_results.txt
echo 测试时间: %date% %time% >> comparison_repetition_results.txt
echo. >> comparison_repetition_results.txt

REM 创建比较结果的CSV文件
echo 文件名,原始大小(字节),原始版本压缩后(字节),优化版本压缩后(字节),原始版本压缩率,优化版本压缩率,改进率 > comparison_repetition_results.csv

REM 首先运行原始版本测试
call test_original_repetition.bat

REM 然后运行优化版本测试
call test_optimized_repetition.bat

REM 比较两个版本的结果
echo 比较两个版本的结果:
echo 比较两个版本的结果: >> comparison_repetition_results.txt
echo ----------------------------------------------------------------- >> comparison_repetition_results.txt
echo 文件名,原始大小,原始版本压缩后,优化版本压缩后,原始版本压缩率,优化版本压缩率,改进率 >> comparison_repetition_results.txt

for %%F in (repetition_*pct.txt) do (
    REM 获取文件大小
    for %%S in (%%F) do set ORIG_SIZE=%%~zS
    for %%S in (original_repetition_results\%%F.lzw) do set ORIG_COMP_SIZE=%%~zS
    for %%S in (optimized_repetition_results\%%F.lzw) do set OPT_COMP_SIZE=%%~zS
    
    REM 计算压缩率和改进率
    set /a ORIG_RATIO=(!ORIG_SIZE!-!ORIG_COMP_SIZE!)*100/!ORIG_SIZE!
    set /a OPT_RATIO=(!ORIG_SIZE!-!OPT_COMP_SIZE!)*100/!ORIG_SIZE!
    set /a IMPROVEMENT=!OPT_RATIO!-!ORIG_RATIO!
    
    echo %%F: 原始版本压缩率 !ORIG_RATIO!%%, 优化版本压缩率 !OPT_RATIO!%%, 改进率 !IMPROVEMENT!%%
    echo %%F,!ORIG_SIZE!,!ORIG_COMP_SIZE!,!OPT_COMP_SIZE!,!ORIG_RATIO!%%,!OPT_RATIO!%%,!IMPROVEMENT!%% >> comparison_repetition_results.txt
    echo %%F,!ORIG_SIZE!,!ORIG_COMP_SIZE!,!OPT_COMP_SIZE!,!ORIG_RATIO!%%,!OPT_RATIO!%%,!IMPROVEMENT!%% >> comparison_repetition_results.csv
)

echo.
echo 测试完成！结果已保存到 comparison_repetition_results.txt 和 comparison_repetition_results.csv
echo. >> comparison_repetition_results.txt
echo 测试完成！ >> comparison_repetition_results.txt 