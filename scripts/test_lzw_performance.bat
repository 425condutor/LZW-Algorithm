@echo off
setlocal
chcp 65001 > nul

echo 测试LZW压缩算法性能...
echo.

REM 设置工作目录
set WORK_DIR=%~dp0..
cd /d %WORK_DIR%

REM 检测可用的make命令
set MAKE_CMD=make
where make >nul 2>&1
if %errorlevel% neq 0 (
    where mingw32-make >nul 2>&1
    if %errorlevel% neq 0 (
        where nmake >nul 2>&1
        if %errorlevel% neq 0 (
            echo 错误：未找到可用的make工具（make、mingw32-make或nmake）
            exit /b 1
        ) else (
            set MAKE_CMD=nmake
        )
    ) else (
        set MAKE_CMD=mingw32-make
    )
)

echo 使用编译命令: %MAKE_CMD%
echo.

REM 编译原始版本
echo 编译原始版本LZW测试程序...
cd LZW-Algorithm-master
%MAKE_CMD% clean
%MAKE_CMD% test_lzw
if not exist test_lzw.exe (
    echo 编译原始版本失败！
    exit /b 1
)
cd ..

REM 编译优化版本
echo 编译优化版本LZW测试程序...
cd source
%MAKE_CMD% clean
%MAKE_CMD% test_lzw_opt
if not exist test_lzw_opt.exe (
    echo 编译优化版本失败！
    exit /b 1
)
cd ..

REM 创建结果目录
if not exist results\performance_test mkdir results\performance_test

REM 询问用户输入测试文件
set /p TEST_FILE="请输入要测试的文件路径: "

REM 检查文件是否存在
if not exist "%TEST_FILE%" (
    echo 文件不存在: %TEST_FILE%
    exit /b 1
)

echo.
echo 开始测试原始版本LZW算法...
cd LZW-Algorithm-master
test_lzw.exe "%TEST_FILE%"
cd ..

echo.
echo 开始测试优化版本LZW算法...
cd source
test_lzw_opt.exe "%TEST_FILE%"
cd ..

echo.
echo 测试完成！
echo 原始版本统计信息: %TEST_FILE%_stats.txt
echo 优化版本统计信息: %TEST_FILE%_stats_optimized.txt

REM 生成对比报告
echo 生成对比报告...
echo LZW算法优化前后性能对比 > results\performance_test\comparison_report.txt
echo ================================== >> results\performance_test\comparison_report.txt
echo 测试时间: %date% %time% >> results\performance_test\comparison_report.txt
echo 测试文件: %TEST_FILE% >> results\performance_test\comparison_report.txt
echo. >> results\performance_test\comparison_report.txt

REM 提取原始版本统计信息
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats.txt" ^| findstr "原始文件大小"') do (
    echo 原始版本: %%a >> results\performance_test\comparison_report.txt
)
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats.txt" ^| findstr "压缩后文件大小"') do (
    echo 原始版本: %%a >> results\performance_test\comparison_report.txt
)
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats.txt" ^| findstr "压缩率"') do (
    echo 原始版本: %%a >> results\performance_test\comparison_report.txt
)
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats.txt" ^| findstr "压缩时间"') do (
    echo 原始版本: %%a >> results\performance_test\comparison_report.txt
)
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats.txt" ^| findstr "解压缩时间"') do (
    echo 原始版本: %%a >> results\performance_test\comparison_report.txt
)
echo. >> results\performance_test\comparison_report.txt

REM 提取优化版本统计信息
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats_optimized.txt" ^| findstr "原始文件大小"') do (
    echo 优化版本: %%a >> results\performance_test\comparison_report.txt
)
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats_optimized.txt" ^| findstr "压缩后文件大小"') do (
    echo 优化版本: %%a >> results\performance_test\comparison_report.txt
)
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats_optimized.txt" ^| findstr "压缩率"') do (
    echo 优化版本: %%a >> results\performance_test\comparison_report.txt
)
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats_optimized.txt" ^| findstr "压缩时间"') do (
    echo 优化版本: %%a >> results\performance_test\comparison_report.txt
)
for /f "tokens=*" %%a in ('type "%TEST_FILE%_stats_optimized.txt" ^| findstr "解压缩时间"') do (
    echo 优化版本: %%a >> results\performance_test\comparison_report.txt
)
echo. >> results\performance_test\comparison_report.txt

echo 对比报告已保存到: results\performance_test\comparison_report.txt
echo. 