#include <stdio.h>
#ifndef LZW_STRUCT_H
#define LZW_STRUCT_H

// 位宽控制
#define MIN_BITS 9                                  // 初始位宽
#define MAX_BITS 16                                 // 增加最大位宽到16位
#define CLEAR_CODE 256                              // 清除码
#define END_CODE 257                                // 结束码
#define FIRST_CODE 258                              // 第一个可用码

// 根据位宽计算最大值
#define MAX_VALUE(bits) ((1 << (bits)) - 1)
#define MAX_CODE(bits) (MAX_VALUE(bits) - 1)        // 当前位宽下的最大编码值
#define TABLE_SIZE 65536                            // 增加字典大小到64K

// 压缩效率控制
#define COMPRESSION_THRESHOLD 0.8                    // 压缩率阈值
#define RESET_CHECK_INTERVAL 1024                    // 重置检查间隔

// 字符统计结构
typedef struct {
    unsigned int frequency;                          // 字符频率
    unsigned int last_pos;                          // 上次出现位置
    float compression_ratio;                         // 局部压缩率
} CharacterStats;

typedef struct {
    int current_bits;                               // 当前位宽
    int next_code;                                  // 下一个可用的编码
    int max_code;                                   // 当前位宽下的最大编码
    int *code;                                      // 字典中的编码
    unsigned int *prefix;                           // 前缀
    unsigned char *suffix;                          // 后缀
    CharacterStats *stats;                          // 字符统计信息
    int bit_buffer;                                 // 位缓冲区
    int bit_count;                                  // 缓冲区中的位数
    unsigned long input_bytes;                      // 输入字节计数
    unsigned long output_bytes;                     // 输出字节计数
    float current_ratio;                            // 当前压缩率
} LZW_DATA;

// 压缩相关函数
void compress(FILE *input, FILE *output);           // 压缩函数
unsigned int find_in_dictionary(int prefix, unsigned int suffix);  // 字典查找
void output_code(FILE *output, unsigned int code);  // 输出编码
void init_compression();                            // 初始化压缩
void reset_dictionary();                            // 重置字典
void update_stats(unsigned int code);               // 更新统计信息
int should_reset_dictionary();                      // 检查是否需要重置字典

// 解压缩相关函数
void expand(FILE *input, FILE *output);             // 解压缩函数
unsigned int input_code(FILE *input);               // 读取编码
unsigned char *decode_string(unsigned int code);     // 解码函数
void init_expansion();                              // 初始化解压缩

#endif