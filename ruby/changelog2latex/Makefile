
all: out.tex
	latex changelog.tex
	latex changelog.tex
	dvips changelog.dvi -o changelog.ps
	gv changelog

out.tex: changelog2latex ChangeLog
	./changelog2latex ChangeLog > out.tex
