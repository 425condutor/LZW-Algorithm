#include <stdio.h>
#include <stdlib.h>
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

    if (!(lzw->code = (int*)malloc(TABLE_SIZE * sizeof(int))) ||
        !(lzw->prefix = (unsigned int*)malloc(TABLE_SIZE * sizeof(unsigned int))) ||
        !(lzw->suffix = (unsigned char*)malloc(TABLE_SIZE * sizeof(unsigned char)))) {
        printf("内存分配失败！\n");
        exit(0);
    }

    // 初始化字典
    for (int i = 0; i < TABLE_SIZE; i++) {
        lzw->code[i] = -1;
    }
}

// 重置字典
void reset_dictionary() {
    lzw->current_bits = MIN_BITS;
    lzw->next_code = FIRST_CODE;
    lzw->max_code = MAX_CODE(lzw->current_bits);
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        lzw->code[i] = -1;
    }
}

// 在字典中查找
unsigned int find_in_dictionary(int prefix, unsigned int suffix) {
    int index = (suffix << (MAX_BITS-8)) ^ prefix;
    int offset = (index == 0) ? 1 : TABLE_SIZE - index;
    
    while (1) {
        if (lzw->code[index] == -1) {
            return -1;  // 未找到
        }
        if (lzw->prefix[index] == prefix && lzw->suffix[index] == suffix) {
            return lzw->code[index];  // 找到匹配项
        }
        index -= offset;
        if (index < 0) {
            index += TABLE_SIZE;
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
    while ((suffix = getc(input)) != (unsigned)EOF) {
        index = find_in_dictionary(prefix, suffix);
        
        if (index != -1) {
            // 找到匹配项，继续查找更长的匹配
            prefix = index;
        } else {
            // 输出前缀编码
            output_code(output, prefix);
            
            // 检查是否需要增加位宽或重置字典
            if (lzw->next_code > lzw->max_code) {
                if (lzw->current_bits < MAX_BITS) {
                    // 增加位宽
                    lzw->current_bits++;
                    lzw->max_code = MAX_CODE(lzw->current_bits);
                } else {
                    // 字典已满，输出CLEAR_CODE并重置
                    output_code(output, CLEAR_CODE);
                    reset_dictionary();
                }
            }

            // 将新字符串加入字典
            if (lzw->next_code < TABLE_SIZE) {
                index = (suffix << (MAX_BITS-8)) ^ prefix;
                int offset = (index == 0) ? 1 : TABLE_SIZE - index;
                
                while (lzw->code[index] != -1) {
                    index -= offset;
                    if (index < 0) index += TABLE_SIZE;
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
    
    // 输出END_CODE
    output_code(output, END_CODE);
    
    // 清空位缓冲区
    if (lzw->bit_count > 0) {
        putc(lzw->bit_buffer & 0xFF, output);
    }
    
    // 释放内存
    free(lzw->code);
    free(lzw->prefix);
    free(lzw->suffix);
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