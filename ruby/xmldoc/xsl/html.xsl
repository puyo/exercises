<?xml version="1.0" ?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>

	<xsl:key name="classes" match="Class|Module" use="@name"/>
	<xsl:key name="methods" match="method-list/method" use="@name"/>

	<xsl:param name="outdir">html_xsl_output</xsl:param>

	<!-- Common header/footer data -->

	<xsl:template name="header">
		<xsl:param name="title">(untitled)</xsl:param>
		<xsl:param name="author"><xsl:value-of select="/rdoc/@author"/></xsl:param>
		<xsl:param name="charset">utf-8</xsl:param>
		<xsl:param name="stylesheet"><xsl:value-of select="$outdir"/>/html.css</xsl:param>
		<head>
			<title><xsl:value-of select="$title"/></title>
			<meta name="author" content="{$author}"/>
			<meta http-equiv="content-type" content="text/html; charset={$charset}"/>
			<link href="{$stylesheet}" rel="stylesheet" type="text/css"/>
		</head>
	</xsl:template>

	<xsl:template name="nav">
		<p class="nav">
			<a href="index.html">Home</a> |
			<a href="index_classes.html">Classes and Modules</a> |
			<a href="index_methods.html">Features</a>
		</p>
	</xsl:template>

	<!-- Document root (creates index.html) -->

	<xsl:template match="/*">
		<xsl:call-template name="index"/>
		<xsl:call-template name="index_methods"/>
		<xsl:call-template name="index_classes"/>
		<xsl:call-template name="pages"/>
	</xsl:template>

	<xsl:template name="index">
		<xsl:variable name="file">index.html</xsl:variable>
		<xsl:message>-&gt; <xsl:value-of select="$outdir"/>/<xsl:value-of select="$file"/></xsl:message>
		<xsl:document method="html" href="{$outdir}/{$file}">
			<html lang="en">
				<xsl:call-template name="header"/>
				<body>
					<xsl:call-template name="nav"/>
					<xsl:apply-templates/>
				</body>
			</html>
		</xsl:document>
	</xsl:template>

	<xsl:template name="index_methods">
		<xsl:variable name="file">index_methods.html</xsl:variable>
		<xsl:message>-&gt; <xsl:value-of select="$outdir"/>/<xsl:value-of select="$file"/></xsl:message>
		<xsl:document method="html" href="{$outdir}/{$file}">
			<html lang="en">
				<xsl:call-template name="header"/>
				<body>
					<xsl:call-template name="nav"/>
					<xsl:apply-templates/>
				</body>
			</html>
		</xsl:document>
	</xsl:template>

	<xsl:template name="index_classes">
		<xsl:variable name="file">index_classes.html</xsl:variable>
		<xsl:message>-&gt; <xsl:value-of select="$outdir"/>/<xsl:value-of select="$file"/></xsl:message>
		<xsl:document method="html" href="{$outdir}/{$file}">
			<html lang="en">
				<xsl:call-template name="header"/>
				<body>
					<xsl:call-template name="nav"/>
					<xsl:apply-templates/>
				</body>
			</html>
		</xsl:document>
	</xsl:template>

	<xsl:template name="pages">
		<xsl:for-each select="class-module-list/*">
			<xsl:call-template name="page"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="page">
		<xsl:variable name="file"><xsl:value-of select="@name"/>.html</xsl:variable>
		<xsl:message>-&gt; <xsl:value-of select="$outdir"/>/<xsl:value-of select="$file"/></xsl:message>
		<xsl:document method="html" href="{$outdir}/{$file}">
			<html lang="en">
				<xsl:call-template name="header"/>
				<body>
					<xsl:call-template name="nav"/>
					<xsl:apply-templates/>
				</body>
			</html>
		</xsl:document>
	</xsl:template>
</xsl:stylesheet>
