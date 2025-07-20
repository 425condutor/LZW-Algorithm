#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <windows.h>
#include "LZW.h"

// 高精度计时函数
double get_time_ms() {
    LARGE_INTEGER frequency, counter;
    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&counter);
    return (double)counter.QuadPart * 1000.0 / (double)frequency.QuadPart;
}

int main(int argc, char *argv[]) {
    FILE *input, *output, *stats_file;
    char output_file[256], decompressed_file[256], stats_filename[256];
    double start_time, end_time;
    double compression_time = 0.0, decompression_time = 0.0;
    long input_size, compressed_size;
    double compression_ratio;
    
    // 设置控制台输出为UTF-8
    SetConsoleOutputCP(CP_UTF8);
    
    if (argc != 2) {
        printf("使用方法: %s <输入文件>\n", argv[0]);
        return 1;
    }
    
    // 打开输入文件
    if (!(input = fopen(argv[1], "rb"))) {
        printf("无法打开输入文件: %s\n", argv[1]);
        return 1;
    }
    
    // 获取输入文件大小
    fseek(input, 0, SEEK_END);
    input_size = ftell(input);
    fseek(input, 0, SEEK_SET);
    fclose(input);
    
    // 创建压缩文件名
    strcpy(output_file, argv[1]);
    strcat(output_file, ".lzw");
    
    // 创建解压文件名
    strcpy(decompressed_file, argv[1]);
    strcat(decompressed_file, ".dec");
    
    // 创建统计信息文件名
    strcpy(stats_filename, argv[1]);
    strcat(stats_filename, "_stats_optimized.txt");
    
    printf("正在压缩文件 %s 到 %s...\n", argv[1], output_file);
    
    // 测量压缩时间
    if (!(input = fopen(argv[1], "rb"))) {
        printf("无法打开输入文件: %s\n", argv[1]);
        return 1;
    }
    
    if (!(output = fopen(output_file, "wb"))) {
        printf("无法创建输出文件: %s\n", output_file);
        fclose(input);
        return 1;
    }
    
    start_time = get_time_ms();
    compress(input, output);
    end_time = get_time_ms();
    compression_time = end_time - start_time;
    
    printf("压缩完成！用时: %.2f 毫秒\n", compression_time);
    
    fclose(input);
    fclose(output);
    
    // 获取压缩文件大小
    if (!(output = fopen(output_file, "rb"))) {
        printf("无法打开压缩文件: %s\n", output_file);
        return 1;
    }
    fseek(output, 0, SEEK_END);
    compressed_size = ftell(output);
    fclose(output);
    
    // 计算压缩率
    compression_ratio = (1.0 - ((double)compressed_size / input_size)) * 100.0;
    
    printf("正在解压文件到 %s...\n", decompressed_file);
    
    // 测量解压缩时间
    if (!(input = fopen(output_file, "rb"))) {
        printf("无法打开压缩文件进行解压: %s\n", output_file);
        return 1;
    }
    
    if (!(output = fopen(decompressed_file, "wb"))) {
        printf("无法创建解压文件: %s\n", decompressed_file);
        fclose(input);
        return 1;
    }
    
    start_time = get_time_ms();
    expand(input, output);
    end_time = get_time_ms();
    decompression_time = end_time - start_time;
    
    printf("解压完成！用时: %.2f 毫秒\n", decompression_time);
    
    fclose(input);
    fclose(output);
    
    // 将统计信息写入文件
    if (!(stats_file = fopen(stats_filename, "w"))) {
        printf("无法创建统计信息文件: %s\n", stats_filename);
        return 1;
    }
    
    fprintf(stats_file, "LZW压缩算法测试统计信息 (优化版本)\n");
    fprintf(stats_file, "===============================\n\n");
    fprintf(stats_file, "测试文件: %s\n", argv[1]);
    fprintf(stats_file, "测试时间: %s\n\n", __DATE__ " " __TIME__);
    
    fprintf(stats_file, "原始文件大小: %ld 字节\n", input_size);
    fprintf(stats_file, "压缩后文件大小: %ld 字节\n", compressed_size);
    fprintf(stats_file, "压缩率: %.2f%%\n\n", compression_ratio);
    
    fprintf(stats_file, "压缩时间: %.2f 毫秒\n", compression_time);
    fprintf(stats_file, "解压缩时间: %.2f 毫秒\n", decompression_time);
    
    fclose(stats_file);
    
    printf("\n统计信息已保存到: %s\n", stats_filename);
    
    return 0;
} 