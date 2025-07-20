#include "LZW.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

int main(int argc,char *argv[])
{
	FILE *fp1,*fp2;
	int flag=0;
	char *op;
	clock_t start_time, end_time;
	double process_time;
	
	if(argc!=4)flag=1;
	else
	{
		op=argv[1];
		if((strcmp(op,"-z")!=0) && strcmp(op,"-e")!=0)flag=1;
	}
	if(flag)
	{
		printf("使用方法：command -z/-e source dest\n");
		exit(1);
	}
	if((fp1=fopen(argv[2],"rb"))==NULL)
	{
		printf("不能打开源文件！！！\n");
		exit(1);
	}
	if((fp2=fopen(argv[3],"wb"))==NULL)
	{
		printf("不能创建目标文件！！！\n");
		exit(1);
	}
	
	// 测量处理时间
	start_time = clock();
	
	if(strcmp(op,"-z")==0)
		compress(fp1,fp2);     // 调用压缩函数 
	else
		expand(fp1,fp2);       // 解压缩函数
	
	end_time = clock();
	process_time = ((double)(end_time - start_time)) / CLOCKS_PER_SEC * 1000; // 转换为毫秒
	
	if(strcmp(op,"-z")==0)
		printf("\n压缩完成！用时: %.2f 毫秒\n", process_time);
	else
		printf("\n解压完成！用时: %.2f 毫秒\n", process_time);
	
	// 输出CSV格式的时间数据，便于脚本解析
	printf("TIMING_DATA,%s,%s,%.2f\n", argv[2], (strcmp(op,"-z")==0) ? "compress" : "decompress", process_time);
		
    fclose(fp1);
    fclose(fp2);
    return 0;
}