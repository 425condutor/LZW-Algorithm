#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "LZW.h"

LZW_DATA lzw1, *lzw;
unsigned char decode_stack[TABLE_SIZE];  // 用于保存解压缩后的数据

// 初始化压缩
void init_compression() {
    lzw = &lzw1;
    lzw->current_bits = MIN_BITS;
    lzw->next_code = FIRST_CODE;
    lzw->max_code = MAX_CODE(lzw->current_bits);
    lzw->bit_buffer = 0;
    lzw->bit_count = 0;
    lzw->input_bytes = 0;
    lzw->output_bytes = 0;
    lzw->current_ratio = 1.0;

    if (!(lzw->code = (int*)malloc(TABLE_SIZE * sizeof(int))) ||
        !(lzw->prefix = (unsigned int*)malloc(TABLE_SIZE * sizeof(unsigned int))) ||
        !(lzw->suffix = (unsigned char*)malloc(TABLE_SIZE * sizeof(unsigned char))) ||
        !(lzw->stats = (CharacterStats*)malloc(TABLE_SIZE * sizeof(CharacterStats)))) {
        printf("内存分配失败！\n");
        exit(0);
    }

    // 初始化字典和统计信息
    for (int i = 0; i < TABLE_SIZE; i++) {
        lzw->code[i] = -1;
        lzw->stats[i].frequency = 0;
        lzw->stats[i].last_pos = 0;
        lzw->stats[i].compression_ratio = 1.0;
    }
}

// 更新统计信息
void update_stats(unsigned int code) {
    lzw->stats[code].frequency++;
    lzw->stats[code].last_pos = lzw->input_bytes;
    
    // 更新局部压缩率
    if (lzw->input_bytes > 0) {
        lzw->current_ratio = (float)lzw->output_bytes / lzw->input_bytes;
        lzw->stats[code].compression_ratio = lzw->current_ratio;
    }
}

// 检查是否需要重置字典
int should_reset_dictionary() {
    // 如果达到最大位宽且压缩率低于阈值
    if (lzw->current_bits >= MAX_BITS && 
        lzw->current_ratio > COMPRESSION_THRESHOLD) {
        return 1;
    }
    
    // 检查最近的压缩效率
    if (lzw->next_code % RESET_CHECK_INTERVAL == 0) {
        float recent_ratio = 0;
        int count = 0;
        
        // 计算最近的压缩效率
        for (int i = lzw->next_code - RESET_CHECK_INTERVAL; 
             i < lzw->next_code; i++) {
            if (lzw->stats[i].frequency > 0) {
                recent_ratio += lzw->stats[i].compression_ratio;
                count++;
            }
        }
        
        if (count > 0) {
            recent_ratio /= count;
            if (recent_ratio > COMPRESSION_THRESHOLD) {
                return 1;
            }
        }
    }
    
    return 0;
}

// 重置字典
void reset_dictionary() {
    lzw->current_bits = MIN_BITS;
    lzw->next_code = FIRST_CODE;
    lzw->max_code = MAX_CODE(lzw->current_bits);
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        lzw->code[i] = -1;
        // 保留频率信息，但重置其他统计
        lzw->stats[i].last_pos = 0;
        lzw->stats[i].compression_ratio = 1.0;
    }
}

// 在字典中查找
unsigned int find_in_dictionary(int prefix, unsigned int suffix) {
    unsigned int hash = ((prefix << 8) | suffix) % TABLE_SIZE;
    unsigned int orig_hash = hash;
    
    while (1) {
        if (lzw->code[hash] == -1) {
            return -1;  // 未找到
        }
        if (lzw->prefix[hash] == prefix && lzw->suffix[hash] == suffix) {
            return lzw->code[hash];  // 找到匹配项
        }
        hash = (hash + 1) % TABLE_SIZE;  // 线性探测
        if (hash == orig_hash) {
            return -1;  // 表已满
        }
    }
}

// 输出编码
void output_code(FILE *output, unsigned int code) {
    lzw->bit_buffer |= (code << lzw->bit_count);
    lzw->bit_count += lzw->current_bits;

    while (lzw->bit_count >= 8) {
        putc(lzw->bit_buffer & 0xFF, output);
        lzw->bit_buffer >>= 8;
        lzw->bit_count -= 8;
        lzw->output_bytes++;
    }
}

// 压缩函数
void compress(FILE *input, FILE *output) {
    unsigned int prefix, suffix;
    int index;

    init_compression();
    
    // 输出初始CLEAR_CODE
    output_code(output, CLEAR_CODE);
    
    prefix = getc(input);
    lzw->input_bytes++;
    
    while ((suffix = getc(input)) != (unsigned)EOF) {
        lzw->input_bytes++;
        index = find_in_dictionary(prefix, suffix);
        
        if (index != -1) {
            // 找到匹配项，继续查找更长的匹配
            prefix = index;
            update_stats(index);
        } else {
            // 输出前缀编码
            output_code(output, prefix);
            update_stats(prefix);
            
            // 检查是否需要增加位宽或重置字典
            if (lzw->next_code > lzw->max_code) {
                if (lzw->current_bits < MAX_BITS) {
                    // 增加位宽
                    lzw->current_bits++;
                    lzw->max_code = MAX_CODE(lzw->current_bits);
                } else if (should_reset_dictionary()) {
                    // 字典效率低，需要重置
                    output_code(output, CLEAR_CODE);
                    reset_dictionary();
                }
            }

            // 将新字符串加入字典
            if (lzw->next_code < TABLE_SIZE) {
                index = ((prefix << 8) | suffix) % TABLE_SIZE;
                while (lzw->code[index] != -1) {
                    index = (index + 1) % TABLE_SIZE;
                }
                
                lzw->code[index] = lzw->next_code++;
                lzw->prefix[index] = prefix;
                lzw->suffix[index] = suffix;
            }
            
            prefix = suffix;
        }
    }
    
    // 输出最后的前缀
    output_code(output, prefix);
    update_stats(prefix);
    
    // 输出END_CODE
    output_code(output, END_CODE);
    
    // 清空位缓冲区
    if (lzw->bit_count > 0) {
        putc(lzw->bit_buffer & 0xFF, output);
        lzw->output_bytes++;
    }
    
    // 释放内存
    free(lzw->code);
    free(lzw->prefix);
    free(lzw->suffix);
    free(lzw->stats);
}

// 初始化解压缩
void init_expansion() {
    lzw = &lzw1;
    lzw->current_bits = MIN_BITS;
    lzw->next_code = FIRST_CODE;
    lzw->max_code = MAX_CODE(lzw->current_bits);
    lzw->bit_buffer = 0;
    lzw->bit_count = 0;

    if (!(lzw->prefix = (unsigned int*)malloc(TABLE_SIZE * sizeof(unsigned int))) ||
        !(lzw->suffix = (unsigned char*)malloc(TABLE_SIZE * sizeof(unsigned char)))) {
        printf("内存分配失败！\n");
        exit(0);
    }
}

// 读取编码
unsigned int input_code(FILE *input) {
    unsigned int code = 0;
    
    while (lzw->bit_count < lzw->current_bits) {
        int next_byte = getc(input);
        if (next_byte == EOF) return END_CODE;
        
        lzw->bit_buffer |= next_byte << lzw->bit_count;
        lzw->bit_count += 8;
    }
    
    code = lzw->bit_buffer & ((1 << lzw->current_bits) - 1);
    lzw->bit_buffer >>= lzw->current_bits;
    lzw->bit_count -= lzw->current_bits;
    
    return code;
}

// 解码字符串
unsigned char *decode_string(unsigned int code) {
    int i = 0;
    unsigned char *stack = decode_stack;
    
    while (code > 255) {
        *stack++ = lzw->suffix[code];
        code = lzw->prefix[code];
        if (i++ >= TABLE_SIZE) {
            printf("解码错误：字符串过长\n");
            exit(1);
        }
    }
    *stack = code;
    return stack;
}

// 解压缩函数
void expand(FILE *input, FILE *output) {
    unsigned int code, old_code, character;
    unsigned char *decode_stack_ptr;
    
    init_expansion();
    
    code = input_code(input);
    if (code != CLEAR_CODE) {
        printf("错误：未找到初始CLEAR_CODE\n");
        return;
    }
    
    old_code = input_code(input);
    if (old_code == END_CODE) return;
    
    character = old_code;
    putc(old_code, output);
    
    while ((code = input_code(input)) != END_CODE) {
        if (code == CLEAR_CODE) {
            // 重置字典
            lzw->current_bits = MIN_BITS;
            lzw->next_code = FIRST_CODE;
            lzw->max_code = MAX_CODE(lzw->current_bits);
            
            code = input_code(input);
            if (code == END_CODE) break;
            
            putc(code, output);
            old_code = code;
            continue;
        }
        
        if (code >= lzw->next_code) {
            // 特殊情况：编码尚未加入字典
            *decode_stack = character;
            decode_stack_ptr = decode_string(old_code);
        } else {
            decode_stack_ptr = decode_string(code);
        }
        
        // 输出解码后的字符串
        character = *decode_stack_ptr;
        while (decode_stack_ptr >= decode_stack) {
            putc(*decode_stack_ptr--, output);
        }
        
        // 将新字符串加入字典
        if (lzw->next_code < TABLE_SIZE) {
            lzw->prefix[lzw->next_code] = old_code;
            lzw->suffix[lzw->next_code] = character;
            
            // 检查是否需要增加位宽
            if (++lzw->next_code > lzw->max_code && lzw->current_bits < MAX_BITS) {
                lzw->current_bits++;
                lzw->max_code = MAX_CODE(lzw->current_bits);
            }
        }
        
        old_code = code;
    }
    
    // 释放内存
    free(lzw->prefix);
    free(lzw->suffix);
}