
all:
	@echo Creating HTML...
	@xsltproc --noout style.xsl main.xml
	@mv *.html ..

opera: all
	op ../index.html

clean:
	@rm -vf *~ ../*~ ../*.html
