
CC = g++

run: readpng
	./readpng

readpng: readpng.o
	$(CC) -o readpng readpng.o -lpng

%.o: %.cpp
	$(CC) -c -Wall $< -o $@
