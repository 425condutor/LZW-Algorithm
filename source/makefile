### makefile for simple programs
###########################################
# INC=
# LIB=

# CC=g++
# CC_FLAG=-Wall

# PRG=lzw
# OBJ=*.o

# $(PRG):$(OBJ)
# 	$(CC) $(OBJ) $(INC) $(LIB) -o $(PRG)
# .SUFFIXES: .c .o .cpp
# .cpp.o:
# 	$(CC) $(INC) -c $*.cpp $(CC_FLAG)
# .PRONY:clean
# clean:
# 	rm -f $(OBJ) $(PRG)


INC=
LIB=

CC=g++
CC_FLAG=-Wall

PRG=lzw
TEST_PRG=test_lzw_opt
# 明确列出所有需要的 .o 文件
OBJ=LZW.o main.o
TEST_OBJ=LZW.o test_optimized_lzw.o

all: $(PRG) $(TEST_PRG)

$(PRG): $(OBJ)
	$(CC) $(OBJ) $(INC) $(LIB) -o $(PRG)

$(TEST_PRG): $(TEST_OBJ)
	$(CC) $(TEST_OBJ) $(INC) $(LIB) -o $(TEST_PRG)

.SUFFIXES: .c .o .cpp
.cpp.o:
	$(CC) $(INC) -c $< $(CC_FLAG)

.PHONY: clean
clean:
	rm -f $(OBJ) $(TEST_OBJ) $(PRG) $(TEST_PRG)