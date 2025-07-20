@echo off
echo 开始测试原始LZW算法压缩性能 > original_results\compression_summary.txt
echo ================================== >> original_results\compression_summary.txt
echo 测试时间: %date% %time% >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

echo 测试1KB文件... >> original_results\compression_summary.txt
echo ---------------------------------- >> original_results\compression_summary.txt

REM 测试repetitive_1KB.txt
echo 测试repetitive_1KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\repetitive_1KB.txt ..\original_results\repetitive_1KB.txt.lzw
lzw_original.exe -e ..\original_results\repetitive_1KB.txt.lzw ..\original_results\repetitive_1KB.txt.dec
cd ..
for %%F in (repetitive_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\repetitive_1KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试english_1KB.txt
echo 测试english_1KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\english_1KB.txt ..\original_results\english_1KB.txt.lzw
lzw_original.exe -e ..\original_results\english_1KB.txt.lzw ..\original_results\english_1KB.txt.dec
cd ..
for %%F in (english_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\english_1KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试random_1KB.txt
echo 测试random_1KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\random_1KB.txt ..\original_results\random_1KB.txt.lzw
lzw_original.exe -e ..\original_results\random_1KB.txt.lzw ..\original_results\random_1KB.txt.dec
cd ..
for %%F in (random_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\random_1KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试binary_1KB.txt
echo 测试binary_1KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\binary_1KB.txt ..\original_results\binary_1KB.txt.lzw
lzw_original.exe -e ..\original_results\binary_1KB.txt.lzw ..\original_results\binary_1KB.txt.dec
cd ..
for %%F in (binary_1KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\binary_1KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

echo 测试10KB文件... >> original_results\compression_summary.txt
echo ---------------------------------- >> original_results\compression_summary.txt

REM 测试repetitive_10KB.txt
echo 测试repetitive_10KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\repetitive_10KB.txt ..\original_results\repetitive_10KB.txt.lzw
lzw_original.exe -e ..\original_results\repetitive_10KB.txt.lzw ..\original_results\repetitive_10KB.txt.dec
cd ..
for %%F in (repetitive_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\repetitive_10KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试english_10KB.txt
echo 测试english_10KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\english_10KB.txt ..\original_results\english_10KB.txt.lzw
lzw_original.exe -e ..\original_results\english_10KB.txt.lzw ..\original_results\english_10KB.txt.dec
cd ..
for %%F in (english_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\english_10KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试random_10KB.txt
echo 测试random_10KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\random_10KB.txt ..\original_results\random_10KB.txt.lzw
lzw_original.exe -e ..\original_results\random_10KB.txt.lzw ..\original_results\random_10KB.txt.dec
cd ..
for %%F in (random_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\random_10KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试binary_10KB.txt
echo 测试binary_10KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\binary_10KB.txt ..\original_results\binary_10KB.txt.lzw
lzw_original.exe -e ..\original_results\binary_10KB.txt.lzw ..\original_results\binary_10KB.txt.dec
cd ..
for %%F in (binary_10KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\binary_10KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

echo 测试100KB文件... >> original_results\compression_summary.txt
echo ---------------------------------- >> original_results\compression_summary.txt

REM 测试repetitive_100KB.txt
echo 测试repetitive_100KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\repetitive_100KB.txt ..\original_results\repetitive_100KB.txt.lzw
lzw_original.exe -e ..\original_results\repetitive_100KB.txt.lzw ..\original_results\repetitive_100KB.txt.dec
cd ..
for %%F in (repetitive_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\repetitive_100KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试english_100KB.txt
echo 测试english_100KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\english_100KB.txt ..\original_results\english_100KB.txt.lzw
lzw_original.exe -e ..\original_results\english_100KB.txt.lzw ..\original_results\english_100KB.txt.dec
cd ..
for %%F in (english_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\english_100KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试random_100KB.txt
echo 测试random_100KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\random_100KB.txt ..\original_results\random_100KB.txt.lzw
lzw_original.exe -e ..\original_results\random_100KB.txt.lzw ..\original_results\random_100KB.txt.dec
cd ..
for %%F in (random_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\random_100KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试binary_100KB.txt
echo 测试binary_100KB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\binary_100KB.txt ..\original_results\binary_100KB.txt.lzw
lzw_original.exe -e ..\original_results\binary_100KB.txt.lzw ..\original_results\binary_100KB.txt.dec
cd ..
for %%F in (binary_100KB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\binary_100KB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

echo 测试1MB文件... >> original_results\compression_summary.txt
echo ---------------------------------- >> original_results\compression_summary.txt

REM 测试repetitive_1MB.txt
echo 测试repetitive_1MB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\repetitive_1MB.txt ..\original_results\repetitive_1MB.txt.lzw
lzw_original.exe -e ..\original_results\repetitive_1MB.txt.lzw ..\original_results\repetitive_1MB.txt.dec
cd ..
for %%F in (repetitive_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\repetitive_1MB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试english_1MB.txt
echo 测试english_1MB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\english_1MB.txt ..\original_results\english_1MB.txt.lzw
lzw_original.exe -e ..\original_results\english_1MB.txt.lzw ..\original_results\english_1MB.txt.dec
cd ..
for %%F in (english_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\english_1MB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试random_1MB.txt
echo 测试random_1MB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\random_1MB.txt ..\original_results\random_1MB.txt.lzw
lzw_original.exe -e ..\original_results\random_1MB.txt.lzw ..\original_results\random_1MB.txt.dec
cd ..
for %%F in (random_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\random_1MB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

REM 测试binary_1MB.txt
echo 测试binary_1MB.txt >> original_results\compression_summary.txt
cd LZW-Algorithm-master
lzw_original.exe -z ..\binary_1MB.txt ..\original_results\binary_1MB.txt.lzw
lzw_original.exe -e ..\original_results\binary_1MB.txt.lzw ..\original_results\binary_1MB.txt.dec
cd ..
for %%F in (binary_1MB.txt) do echo 原始文件大小: %%~zF 字节 >> original_results\compression_summary.txt
for %%F in (original_results\binary_1MB.txt.lzw) do echo 压缩后大小: %%~zF 字节 >> original_results\compression_summary.txt
echo. >> original_results\compression_summary.txt

echo 测试完成！ 