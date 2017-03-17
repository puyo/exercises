HTMLDIR = html

all: html

html: clean-output
	@echo Creating player version HTML...
	@mkdir -p $(HTMLDIR)
	@xsltproc --noout \
		--param "outdir" "'$(HTMLDIR)'" \
		html.xsl doc.xml

clean-output:
	@echo Removing rebuildable files...
	@$(RM)  $(HTMLDIR)/*.html

clean: clean-output
	@$(RM) *~  $(HTMLDIR)/*~
