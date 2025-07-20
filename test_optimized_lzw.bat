@echo off
echo 开始测试优化版LZW算法压缩性能 > optimized_results\compression_summary.txt
echo ================================== >> optimized_results\compression_summary.txt
echo 测试时间: %date% %time% >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

echo 测试1KB文件... >> optimized_results\compression_summary.txt
echo ---------------------------------- >> optimized_results\compression_summary.txt

REM 测试repetitive_1KB.txt
echo 测试repetitive_1KB.txt >> optimized_results\compression_summary.txt
lzw.exe repetitive_1KB.txt
move repetitive_1KB.txt.lzw optimized_results\
move repetitive_1KB.txt.decoded optimized_results\repetitive_1KB.txt.dec
for %%F in (repetitive_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\repetitive_1KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试english_1KB.txt
echo 测试english_1KB.txt >> optimized_results\compression_summary.txt
lzw.exe english_1KB.txt
move english_1KB.txt.lzw optimized_results\
move english_1KB.txt.decoded optimized_results\english_1KB.txt.dec
for %%F in (english_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\english_1KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试random_1KB.txt
echo 测试random_1KB.txt >> optimized_results\compression_summary.txt
lzw.exe random_1KB.txt
move random_1KB.txt.lzw optimized_results\
move random_1KB.txt.decoded optimized_results\random_1KB.txt.dec
for %%F in (random_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\random_1KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试binary_1KB.txt
echo 测试binary_1KB.txt >> optimized_results\compression_summary.txt
lzw.exe binary_1KB.txt
move binary_1KB.txt.lzw optimized_results\
move binary_1KB.txt.decoded optimized_results\binary_1KB.txt.dec
for %%F in (binary_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\binary_1KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

echo 测试10KB文件... >> optimized_results\compression_summary.txt
echo ---------------------------------- >> optimized_results\compression_summary.txt

REM 测试repetitive_10KB.txt
echo 测试repetitive_10KB.txt >> optimized_results\compression_summary.txt
lzw.exe repetitive_10KB.txt
move repetitive_10KB.txt.lzw optimized_results\
move repetitive_10KB.txt.decoded optimized_results\repetitive_10KB.txt.dec
for %%F in (repetitive_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\repetitive_10KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试english_10KB.txt
echo 测试english_10KB.txt >> optimized_results\compression_summary.txt
lzw.exe english_10KB.txt
move english_10KB.txt.lzw optimized_results\
move english_10KB.txt.decoded optimized_results\english_10KB.txt.dec
for %%F in (english_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\english_10KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试random_10KB.txt
echo 测试random_10KB.txt >> optimized_results\compression_summary.txt
lzw.exe random_10KB.txt
move random_10KB.txt.lzw optimized_results\
move random_10KB.txt.decoded optimized_results\random_10KB.txt.dec
for %%F in (random_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\random_10KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试binary_10KB.txt
echo 测试binary_10KB.txt >> optimized_results\compression_summary.txt
lzw.exe binary_10KB.txt
move binary_10KB.txt.lzw optimized_results\
move binary_10KB.txt.decoded optimized_results\binary_10KB.txt.dec
for %%F in (binary_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\binary_10KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

echo 测试100KB文件... >> optimized_results\compression_summary.txt
echo ---------------------------------- >> optimized_results\compression_summary.txt

REM 测试repetitive_100KB.txt
echo 测试repetitive_100KB.txt >> optimized_results\compression_summary.txt
lzw.exe repetitive_100KB.txt
move repetitive_100KB.txt.lzw optimized_results\
move repetitive_100KB.txt.decoded optimized_results\repetitive_100KB.txt.dec
for %%F in (repetitive_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\repetitive_100KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试english_100KB.txt
echo 测试english_100KB.txt >> optimized_results\compression_summary.txt
lzw.exe english_100KB.txt
move english_100KB.txt.lzw optimized_results\
move english_100KB.txt.decoded optimized_results\english_100KB.txt.dec
for %%F in (english_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\english_100KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试random_100KB.txt
echo 测试random_100KB.txt >> optimized_results\compression_summary.txt
lzw.exe random_100KB.txt
move random_100KB.txt.lzw optimized_results\
move random_100KB.txt.decoded optimized_results\random_100KB.txt.dec
for %%F in (random_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\random_100KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试binary_100KB.txt
echo 测试binary_100KB.txt >> optimized_results\compression_summary.txt
lzw.exe binary_100KB.txt
move binary_100KB.txt.lzw optimized_results\
move binary_100KB.txt.decoded optimized_results\binary_100KB.txt.dec
for %%F in (binary_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\binary_100KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

echo 测试1MB文件... >> optimized_results\compression_summary.txt
echo ---------------------------------- >> optimized_results\compression_summary.txt

REM 测试repetitive_1MB.txt
echo 测试repetitive_1MB.txt >> optimized_results\compression_summary.txt
lzw.exe repetitive_1MB.txt
move repetitive_1MB.txt.lzw optimized_results\
move repetitive_1MB.txt.decoded optimized_results\repetitive_1MB.txt.dec
for %%F in (repetitive_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\repetitive_1MB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试english_1MB.txt
echo 测试english_1MB.txt >> optimized_results\compression_summary.txt
lzw.exe english_1MB.txt
move english_1MB.txt.lzw optimized_results\
move english_1MB.txt.decoded optimized_results\english_1MB.txt.dec
for %%F in (english_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\english_1MB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试random_1MB.txt
echo 测试random_1MB.txt >> optimized_results\compression_summary.txt
lzw.exe random_1MB.txt
move random_1MB.txt.lzw optimized_results\
move random_1MB.txt.decoded optimized_results\random_1MB.txt.dec
for %%F in (random_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\random_1MB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

REM 测试binary_1MB.txt
echo 测试binary_1MB.txt >> optimized_results\compression_summary.txt
lzw.exe binary_1MB.txt
move binary_1MB.txt.lzw optimized_results\
move binary_1MB.txt.decoded optimized_results\binary_1MB.txt.dec
for %%F in (binary_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> optimized_results\compression_summary.txt
for %%F in (optimized_results\binary_1MB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> optimized_results\compression_summary.txt
echo. >> optimized_results\compression_summary.txt

echo 测试完成！ 