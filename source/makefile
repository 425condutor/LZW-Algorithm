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
# 明确列出所有需要的 .o 文件
OBJ=LZW.o main.o

$(PRG): $(OBJ)
	$(CC) $(OBJ) $(INC) $(LIB) -o $(PRG)

.SUFFIXES: .c .o .cpp
.cpp.o:
	$(CC) $(INC) -c $< $(CC_FLAG)

.PHONY: clean
clean:
	rm -f $(OBJ) $(PRG)