@echo off
echo 开始LZW算法优化前后对比测试...
echo.

REM 运行原始版本测试
echo 测试原始版本LZW算法...
call test_original_lzw.bat
echo 原始版本测试完成！
echo.

REM 运行优化版本测试
echo 测试优化版本LZW算法...
call test_optimized_lzw.bat
echo 优化版本测试完成！
echo.

REM 生成对比报告
echo 生成对比报告...
echo LZW算法优化前后性能对比 > comparison_report.txt
echo ================================== >> comparison_report.txt
echo 测试时间: %date% %time% >> comparison_report.txt
echo. >> comparison_report.txt

echo 1KB文件对比: >> comparison_report.txt
echo ---------------------------------- >> comparison_report.txt

REM repetitive_1KB.txt对比
echo repetitive_1KB.txt: >> comparison_report.txt
for %%F in (repetitive_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\repetitive_1KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\repetitive_1KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM english_1KB.txt对比
echo english_1KB.txt: >> comparison_report.txt
for %%F in (english_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\english_1KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\english_1KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM random_1KB.txt对比
echo random_1KB.txt: >> comparison_report.txt
for %%F in (random_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\random_1KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\random_1KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM binary_1KB.txt对比
echo binary_1KB.txt: >> comparison_report.txt
for %%F in (binary_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\binary_1KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\binary_1KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

echo 10KB文件对比: >> comparison_report.txt
echo ---------------------------------- >> comparison_report.txt

REM repetitive_10KB.txt对比
echo repetitive_10KB.txt: >> comparison_report.txt
for %%F in (repetitive_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\repetitive_10KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\repetitive_10KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM english_10KB.txt对比
echo english_10KB.txt: >> comparison_report.txt
for %%F in (english_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\english_10KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\english_10KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM random_10KB.txt对比
echo random_10KB.txt: >> comparison_report.txt
for %%F in (random_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\random_10KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\random_10KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM binary_10KB.txt对比
echo binary_10KB.txt: >> comparison_report.txt
for %%F in (binary_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\binary_10KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\binary_10KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

echo 100KB文件对比: >> comparison_report.txt
echo ---------------------------------- >> comparison_report.txt

REM repetitive_100KB.txt对比
echo repetitive_100KB.txt: >> comparison_report.txt
for %%F in (repetitive_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\repetitive_100KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\repetitive_100KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM english_100KB.txt对比
echo english_100KB.txt: >> comparison_report.txt
for %%F in (english_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\english_100KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\english_100KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM random_100KB.txt对比
echo random_100KB.txt: >> comparison_report.txt
for %%F in (random_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\random_100KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\random_100KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM binary_100KB.txt对比
echo binary_100KB.txt: >> comparison_report.txt
for %%F in (binary_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\binary_100KB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\binary_100KB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

echo 1MB文件对比: >> comparison_report.txt
echo ---------------------------------- >> comparison_report.txt

REM repetitive_1MB.txt对比
echo repetitive_1MB.txt: >> comparison_report.txt
for %%F in (repetitive_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\repetitive_1MB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\repetitive_1MB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM english_1MB.txt对比
echo english_1MB.txt: >> comparison_report.txt
for %%F in (english_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\english_1MB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\english_1MB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM random_1MB.txt对比
echo random_1MB.txt: >> comparison_report.txt
for %%F in (random_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\random_1MB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\random_1MB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

REM binary_1MB.txt对比
echo binary_1MB.txt: >> comparison_report.txt
for %%F in (binary_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> comparison_report.txt
for %%F in (original_results\binary_1MB.txt.lzw) do echo 原始版本压缩后大小: %%~zF 字节 >> comparison_report.txt
for %%F in (optimized_results\binary_1MB.txt.lzw) do echo 优化版本压缩后大小: %%~zF 字节 >> comparison_report.txt
echo. >> comparison_report.txt

echo 对比测试完成！结果已保存到comparison_report.txt文件中。 