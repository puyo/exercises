
IP_ADDRESS = 192.168.0.1

all: Server.class Client.class

server: Server.class
	java Server

client: Client.class
	java Client $(IP_ADDRESS)

%.class: %.java
	javac $<
