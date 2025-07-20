@echo off
echo LZW算法对不同重复率文件的压缩效果测试 > repetition_test_results.txt
echo ================================================== >> repetition_test_results.txt
echo 测试时间: %date% %time% >> repetition_test_results.txt
echo. >> repetition_test_results.txt

REM 创建存放结果的目录
mkdir repetition_test_results 2>nul

echo 测试文件信息: >> repetition_test_results.txt
echo 大小: 100KB >> repetition_test_results.txt
echo 重复率: 0%%, 25%%, 50%%, 75%%, 90%%, 95%%, 99%%, 100%% >> repetition_test_results.txt
echo. >> repetition_test_results.txt

echo 测试结果: >> repetition_test_results.txt
echo -------------------------------------------------- >> repetition_test_results.txt
echo 文件名,原始大小,原始版本压缩后大小,优化版本压缩后大小,原始版本压缩率,优化版本压缩率,改进率 >> repetition_test_results.txt

REM 测试所有重复率文件
for %%F in (repetition_*pct.txt) do (
    echo 测试文件: %%F
    
    REM 测试原始版本
    cd LZW-Algorithm-master
    lzw_original.exe -z ..\%%F ..\repetition_test_results\%%F.original.lzw
    cd ..
    
    REM 测试优化版本
    lzw.exe %%F
    move %%F.lzw repetition_test_results\%%F.optimized.lzw
    move %%F.decoded repetition_test_results\%%F.decoded
    
    REM 获取文件大小
    for %%S in (%%F) do set original_size=%%~zS
    for %%S in (repetition_test_results\%%F.original.lzw) do set original_compressed=%%~zS
    for %%S in (repetition_test_results\%%F.optimized.lzw) do set optimized_compressed=%%~zS
    
    REM 计算压缩率
    set /a original_ratio=(!original_compressed! * 100 / !original_size!)
    set /a optimized_ratio=(!optimized_compressed! * 100 / !original_size!)
    set /a improvement=(!original_ratio! - !optimized_ratio!)
    
    REM 计算实际压缩率（1 - 压缩后/原始大小）
    set /a original_compression_rate=100 - !original_ratio!
    set /a optimized_compression_rate=100 - !optimized_ratio!
    
    echo %%F,!original_size!,!original_compressed!,!optimized_compressed!,!original_compression_rate!%%,!optimized_compression_rate!%%,!improvement!%% >> repetition_test_results.txt
)

echo. >> repetition_test_results.txt
echo 测试完成！结果已保存到repetition_test_results.txt文件中。 >> repetition_test_results.txt
echo 测试完成！结果已保存到repetition_test_results.txt文件中。 