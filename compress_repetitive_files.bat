@echo off
echo Starting LZW compression of repetitive test files > compression_output.txt
echo ================================================ >> compression_output.txt

echo Processing repetitive_1KB.txt... >> compression_output.txt
lzw.exe repetitive_1KB.txt >> compression_output.txt 2>&1
echo. >> compression_output.txt

echo Processing repetitive_10KB.txt... >> compression_output.txt
lzw.exe repetitive_10KB.txt >> compression_output.txt 2>&1
echo. >> compression_output.txt

echo Processing repetitive_100KB.txt... >> compression_output.txt
lzw.exe repetitive_100KB.txt >> compression_output.txt 2>&1
echo. >> compression_output.txt

echo Processing repetitive_1MB.txt... >> compression_output.txt
lzw.exe repetitive_1MB.txt >> compression_output.txt 2>&1
echo. >> compression_output.txt

echo Compression complete! Results saved to compression_output.txt 