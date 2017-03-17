JAVAFILES = $(wildcard *.java)
CLASSFILES = $(JAVAFILES:.java=.class)

ShadowrunCharacterGenerator: $(CLASSFILES)

run: ShadowrunCharacterGenerator
	java ShadowrunCharacterGenerator

%.class: %.java
	javac $<
