#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <windows.h>

// 文件类型
#define TYPE_RANDOM 1       // 完全随机文本
#define TYPE_REPETITIVE 2   // 高重复性文本
#define TYPE_ENGLISH 3      // 类英语文本
#define TYPE_BINARY 4       // 二进制数据

// 生成完全随机文本文件
void generate_random_file(const char* filename, long size) {
    FILE* file = fopen(filename, "wb");
    if (!file) {
        printf("无法创建文件: %s\n", filename);
        return;
    }
    
    srand((unsigned int)time(NULL));
    for (long i = 0; i < size; i++) {
        // 生成可打印ASCII字符 (32-126)
        char c = 32 + (rand() % 95);
        fputc(c, file);
    }
    
    fclose(file);
    printf("已生成随机文本文件: %s (大小: %ld 字节)\n", filename, size);
}

// 生成高重复性文本文件
void generate_repetitive_file(const char* filename, long size) {
    FILE* file = fopen(filename, "wb");
    if (!file) {
        printf("无法创建文件: %s\n", filename);
        return;
    }
    
    srand((unsigned int)time(NULL));
    
    // 创建一些重复模式
    const char* patterns[] = {
        "abcdefghijklmnopqrstuvwxyz",
        "hello world hello world ",
        "compression algorithm test ",
        "AAAAAAAAAAAAAAAA",
        "010101010101010101",
        "The quick brown fox jumps over the lazy dog. ",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
        "这是一个用于测试压缩算法的文本文件。"
    };
    int num_patterns = sizeof(patterns) / sizeof(patterns[0]);
    
    long total = 0;
    while (total < size) {
        int pattern_idx = rand() % num_patterns;
        int len = strlen(patterns[pattern_idx]);
        
        // 重复写入模式多次
        int repeat = 1 + rand() % 20;  // 更多重复
        for (int r = 0; r < repeat && total < size; r++) {
            for (int i = 0; i < len && total < size; i++) {
                fputc(patterns[pattern_idx][i], file);
                total++;
            }
        }
    }
    
    fclose(file);
    printf("已生成高重复性文本文件: %s (大小: %ld 字节)\n", filename, size);
}

// 生成类英语文本文件（更接近自然语言）
void generate_english_file(const char* filename, long size) {
    FILE* file = fopen(filename, "wb");
    if (!file) {
        printf("无法创建文件: %s\n", filename);
        return;
    }
    
    srand((unsigned int)time(NULL));
    
    // 常用英语单词
    const char* words[] = {
        "the", "be", "to", "of", "and", "a", "in", "that", "have", "I", 
        "it", "for", "not", "on", "with", "he", "as", "you", "do", "at", 
        "this", "but", "his", "by", "from", "they", "we", "say", "her", "she", 
        "or", "an", "will", "my", "one", "all", "would", "there", "their", "what", 
        "so", "up", "out", "if", "about", "who", "get", "which", "go", "me",
        "computer", "algorithm", "compression", "data", "file", "program", "code",
        "system", "memory", "disk", "network", "software", "hardware", "byte"
    };
    int num_words = sizeof(words) / sizeof(words[0]);
    
    // 标点符号
    const char* punctuation = ",.!?;:";
    int num_punct = strlen(punctuation);
    
    long total = 0;
    while (total < size) {
        // 添加一个单词
        int word_idx = rand() % num_words;
        int word_len = strlen(words[word_idx]);
        
        for (int i = 0; i < word_len && total < size; i++) {
            fputc(words[word_idx][i], file);
            total++;
        }
        
        // 添加空格或标点
        if (total < size) {
            if (rand() % 10 == 0) {  // 10%的几率添加标点
                char punct = punctuation[rand() % num_punct];
                fputc(punct, file);
                total++;
            }
            
            if (total < size) {
                fputc(' ', file);  // 添加空格
                total++;
            }
        }
        
        // 偶尔添加换行
        if (rand() % 20 == 0 && total < size) {  // 5%的几率添加换行
            fputc('\n', file);
            total++;
        }
    }
    
    fclose(file);
    printf("已生成类英语文本文件: %s (大小: %ld 字节)\n", filename, size);
}

// 生成二进制文件
void generate_binary_file(const char* filename, long size) {
    FILE* file = fopen(filename, "wb");
    if (!file) {
        printf("无法创建文件: %s\n", filename);
        return;
    }
    
    srand((unsigned int)time(NULL));
    for (long i = 0; i < size; i++) {
        // 生成任意字节值 (0-255)
        unsigned char c = rand() % 256;
        fputc(c, file);
    }
    
    fclose(file);
    printf("已生成二进制文件: %s (大小: %ld 字节)\n", filename, size);
}

// 显示帮助信息
void show_help(const char* program_name) {
    printf("使用方法: %s [选项]\n\n", program_name);
    printf("选项:\n");
    printf("  -f <文件名>   指定输出文件名 (默认: test_file.txt)\n");
    printf("  -s <大小>     指定文件大小，单位为字节 (默认: 1048576 = 1MB)\n");
    printf("  -t <类型>     指定文件类型 (默认: 1)\n");
    printf("                1 = 随机文本\n");
    printf("                2 = 高重复性文本\n");
    printf("                3 = 类英语文本\n");
    printf("                4 = 二进制数据\n");
    printf("  -h            显示此帮助信息\n\n");
    printf("大小单位后缀:\n");
    printf("  可以使用K、M、G后缀表示KB、MB、GB\n");
    printf("  例如: 10K = 10240字节, 5M = 5242880字节\n\n");
    printf("示例:\n");
    printf("  %s -f random.txt -s 1M -t 1\n", program_name);
    printf("  %s -f english.txt -s 500K -t 3\n", program_name);
}

// 解析大小参数
long parse_size(const char* size_str) {
    long size = 0;
    char* end_ptr;
    
    size = strtol(size_str, &end_ptr, 10);
    
    if (*end_ptr != '\0') {
        // 检查单位后缀
        switch (*end_ptr) {
            case 'k':
            case 'K':
                size *= 1024;
                break;
            case 'm':
            case 'M':
                size *= 1024 * 1024;
                break;
            case 'g':
            case 'G':
                size *= 1024 * 1024 * 1024;
                break;
            default:
                printf("警告: 未知的大小单位 '%c'，使用字节作为单位\n", *end_ptr);
        }
    }
    
    return size;
}

// 生成一组不同大小的测试文件
void generate_test_set(int type) {
    const char* type_name;
    switch (type) {
        case TYPE_RANDOM:    type_name = "random"; break;
        case TYPE_REPETITIVE: type_name = "repetitive"; break;
        case TYPE_ENGLISH:   type_name = "english"; break;
        case TYPE_BINARY:    type_name = "binary"; break;
        default:            type_name = "unknown"; break;
    }
    
    char filename[256];
    long sizes[] = {1024, 10240, 102400, 1048576, 10485760}; // 1KB, 10KB, 100KB, 1MB, 10MB
    const char* size_names[] = {"1KB", "10KB", "100KB", "1MB", "10MB"};
    
    printf("生成%s类型的测试文件集...\n", type_name);
    
    for (int i = 0; i < sizeof(sizes)/sizeof(sizes[0]); i++) {
        sprintf(filename, "%s_%s.txt", type_name, size_names[i]);
        
        switch (type) {
            case TYPE_RANDOM:
                generate_random_file(filename, sizes[i]);
                break;
            case TYPE_REPETITIVE:
                generate_repetitive_file(filename, sizes[i]);
                break;
            case TYPE_ENGLISH:
                generate_english_file(filename, sizes[i]);
                break;
            case TYPE_BINARY:
                generate_binary_file(filename, sizes[i]);
                break;
        }
    }
    
    printf("%s类型的测试文件集生成完成\n\n", type_name);
}

int main(int argc, char* argv[]) {
    SetConsoleOutputCP(CP_UTF8);
    SetConsoleCP(CP_UTF8);
    
    char filename[256] = "test_file.txt";
    long size = 1048576;  // 默认1MB
    int type = TYPE_RANDOM;
    int generate_set = 0;
    
    // 解析命令行参数
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-f") == 0 && i + 1 < argc) {
            strcpy(filename, argv[++i]);
        } else if (strcmp(argv[i], "-s") == 0 && i + 1 < argc) {
            size = parse_size(argv[++i]);
        } else if (strcmp(argv[i], "-t") == 0 && i + 1 < argc) {
            type = atoi(argv[++i]);
            if (type < 1 || type > 4) {
                printf("错误: 无效的文件类型 %d\n", type);
                show_help(argv[0]);
                return 1;
            }
        } else if (strcmp(argv[i], "-set") == 0) {
            generate_set = 1;
        } else if (strcmp(argv[i], "-h") == 0) {
            show_help(argv[0]);
            return 0;
        } else {
            printf("未知选项: %s\n", argv[i]);
            show_help(argv[0]);
            return 1;
        }
    }
    
    if (generate_set) {
        // 生成所有类型的测试文件集
        for (int t = TYPE_RANDOM; t <= TYPE_BINARY; t++) {
            generate_test_set(t);
        }
        printf("所有测试文件集生成完成！\n");
        return 0;
    }
    
    // 生成单个文件
    printf("生成测试文件...\n");
    printf("文件名: %s\n", filename);
    printf("大小: %ld 字节\n", size);
    
    switch (type) {
        case TYPE_RANDOM:
            printf("类型: 随机文本\n");
            generate_random_file(filename, size);
            break;
        case TYPE_REPETITIVE:
            printf("类型: 高重复性文本\n");
            generate_repetitive_file(filename, size);
            break;
        case TYPE_ENGLISH:
            printf("类型: 类英语文本\n");
            generate_english_file(filename, size);
            break;
        case TYPE_BINARY:
            printf("类型: 二进制数据\n");
            generate_binary_file(filename, size);
            break;
    }
    
    printf("文件生成完成！\n");
    return 0;
} 