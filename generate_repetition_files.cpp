#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <random>
#include <ctime>
#include <windows.h> // 添加Windows头文件

// 生成具有不同重复率的文件
// 重复率参数范围：0.0到1.0，表示文件中重复内容的比例
void generateFileWithRepetition(const std::string& filename, size_t fileSize, double repetitionRate) {
    std::ofstream outFile(filename, std::ios::binary);
    if (!outFile) {
        std::cerr << "无法创建文件: " << filename << std::endl;
        return;
    }

    try {
        // 初始化随机数生成器
        std::random_device rd;
        std::mt19937 gen(rd());
        std::uniform_int_distribution<> dist(0, 255); // 生成0-255的随机字节

        // 计算重复内容和随机内容的大小
        size_t repetitionSize = static_cast<size_t>(fileSize * repetitionRate);
        size_t randomSize = fileSize - repetitionSize;

        // 生成重复内容的基本模式
        // 使用一个固定的重复模式，长度为1KB
        std::vector<char> pattern;
        const size_t patternSize = 1024; // 1KB的模式
        pattern.reserve(patternSize);
        
        for (size_t i = 0; i < patternSize; ++i) {
            pattern.push_back(static_cast<char>(dist(gen)));
        }

        // 写入重复内容
        size_t bytesWritten = 0;
        while (bytesWritten < repetitionSize) {
            size_t bytesToWrite = std::min(patternSize, repetitionSize - bytesWritten);
            outFile.write(pattern.data(), bytesToWrite);
            bytesWritten += bytesToWrite;
        }

        // 写入随机内容
        for (size_t i = 0; i < randomSize; ++i) {
            char byte = static_cast<char>(dist(gen));
            outFile.write(&byte, 1);
        }

        outFile.close();
        std::cout << "已创建文件: " << filename << " (大小: " << fileSize 
                << " 字节, 重复率: " << repetitionRate * 100 << "%)" << std::endl;
    }
    catch (const std::exception& e) {
        std::cerr << "生成文件时出错: " << e.what() << std::endl;
        outFile.close();
    }
}

int main() {
    // 设置控制台编码为UTF-8
    SetConsoleOutputCP(CP_UTF8);
    SetConsoleCP(CP_UTF8);
    
    const size_t fileSize = 100 * 1024; // 100KB
    const std::vector<double> repetitionRates = {0.0, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99, 1.0};
    
    std::cout << "开始生成具有不同重复率的测试文件..." << std::endl;
    
    try {
        for (double rate : repetitionRates) {
            std::string filename = "repetition_" + std::to_string(static_cast<int>(rate * 100)) + "pct.txt";
            generateFileWithRepetition(filename, fileSize, rate);
        }
        
        std::cout << "所有测试文件生成完成！" << std::endl;
    }
    catch (const std::exception& e) {
        std::cerr << "程序执行出错: " << e.what() << std::endl;
        return 1;
    }
    
    return 0;
} 