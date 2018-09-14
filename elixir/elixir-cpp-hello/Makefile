CC=g++
CPPFLAGS=`pkg-config --cflags msgpack nanomsg`
LDFLAGS=`pkg-config --libs msgpack nanomsg`

cnano: cnano.o

clean:
	$(RM) *.o cnano
