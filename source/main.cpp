#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "LZW.h"
#include <windows.h>
#include <time.h>

int main(int argc, char *argv[]) {
	FILE *input, *output;
	char output_file[256];
	clock_t start_time, end_time;
	double compression_time, decompression_time;

	SetConsoleOutputCP(CP_UTF8);
	SetConsoleCP(CP_UTF8);

	if (argc != 2) {
		printf("使用方法: %s <输入文件>\n", argv[0]);
		return 1;
	}

	// 打开输入文件
	if (!(input = fopen(argv[1], "rb"))) {
		printf("无法打开输入文件: %s\n", argv[1]);
		return 1;
	}

	// 创建压缩文件名
	strcpy(output_file, argv[1]);
	strcat(output_file, ".lzw");

	// 打开输出文件
	if (!(output = fopen(output_file, "wb"))) {
		printf("无法创建输出文件: %s\n", output_file);
		fclose(input);
		return 1;
	}

	printf("正在压缩文件 %s 到 %s...\n", argv[1], output_file);
	
	// 测量压缩时间
	start_time = clock();
	compress(input, output);
	end_time = clock();
	compression_time = ((double)(end_time - start_time)) / CLOCKS_PER_SEC * 1000; // 转换为毫秒
	
	printf("\n压缩完成！用时: %.2f 毫秒\n", compression_time);

	fclose(input);
	fclose(output);

	// 测试解压缩
	if (!(input = fopen(output_file, "rb"))) {
		printf("无法打开压缩文件进行解压\n");
		return 1;
	}

	// 创建解压文件名
	strcpy(output_file, argv[1]);
	strcat(output_file, ".decoded");

	if (!(output = fopen(output_file, "wb"))) {
		printf("无法创建解压文件\n");
		fclose(input);
		return 1;
	}

	printf("正在解压文件到 %s...\n", output_file);
	
	// 测量解压缩时间
	start_time = clock();
	expand(input, output);
	end_time = clock();
	decompression_time = ((double)(end_time - start_time)) / CLOCKS_PER_SEC * 1000; // 转换为毫秒
	
	printf("\n解压完成！用时: %.2f 毫秒\n", decompression_time);
	
	// 输出CSV格式的时间数据，便于脚本解析
	printf("TIMING_DATA,%s,%.2f,%.2f\n", argv[1], compression_time, decompression_time);

	fclose(input);
	fclose(output);

	return 0;
}