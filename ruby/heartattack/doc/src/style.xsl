<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
       xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
	<xsl:key name="references" match="reference" use="@name"/>
	<xsl:key name="sections" match="/doc//section" use="@name"/>
	<xsl:key name="activities" match="activity" use="@name"/>
	<xsl:key name="items" match="items/item" use="@name"/>

	<!-- Common header/footer data -->

	<xsl:template name="html-header">
		<xsl:param name="title">(untitled)</xsl:param>
		<xsl:param name="stylesheet">style.css</xsl:param>
		<head>
			<title><xsl:value-of select="$title"/></title>
			<meta name="author" content="{/doc/meta/author}"/>
			<meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
			<link href="{$stylesheet}" rel="stylesheet" type="text/css"/>
		</head>
	</xsl:template>

	<xsl:template name="title">
		<div class="title">
			<dl><dt><img src="images/title.gif"/></dt><dd>
				<xsl:value-of select="/doc/@subtitle"/> by <xsl:value-of select="/doc/@author"/>
			</dd></dl>
		</div>
	</xsl:template>

	<xsl:template name="nav">
		<font class="heading">Contents</font>
		<p class="nav">
			<ul>
				<xsl:apply-templates select="./section" mode="TOC"/>
			</ul>
		</p>
	</xsl:template>

	<!-- Document root (creates index.html) -->

	<xsl:template match="/doc">
		<xsl:variable name="File"><xsl:value-of select="index.html"/></xsl:variable>
		<xsl:document method="html" href="index.html">
			<html lang="en">
				<xsl:call-template name="html-header">
					<xsl:with-param name="title"><xsl:value-of select="/doc/@title"/></xsl:with-param>
				</xsl:call-template>
				<body>
					<xsl:call-template name="title"/>
					<xsl:call-template name="nav"/>
					<xsl:apply-templates/>
				</body>
			</html>
		</xsl:document>
	</xsl:template>


	<!-- Major sections (have their own page) -->

	<xsl:template match="section" mode="page">
		<xsl:variable name="File"><xsl:value-of select="@filename"/></xsl:variable>
		<xsl:message>-&gt; <xsl:value-of select="$File"/></xsl:message>
		<xsl:document method="html" href="{$File}">
			<html lang="en">
				<xsl:call-template name="html-header">
					<xsl:with-param name="title"><xsl:value-of select="/doc/@title"/> - <xsl:value-of select="@name"/></xsl:with-param>
				</xsl:call-template>
				<body>
					<xsl:call-template name="title"/>
					<xsl:call-template name="nav"/>
					<h1><xsl:value-of select="@name"/></h1>
					<xsl:apply-templates/>
				</body>
			</html>
		</xsl:document>
	</xsl:template>


	<!-- TOC -->

	<xsl:template match="section" mode="TOC">
		<li>
			<a href="#section:{@name}"><xsl:value-of select="@name"/></a>
			<ul>
				<xsl:apply-templates select="./section" mode="TOC"/>
			</ul>
		</li>
	</xsl:template>


	<!-- Sections -->

	<xsl:template name="section">
		<xsl:param name="title">(untitled)</xsl:param>
		<a name="section:{@name}"/>
		<font class="heading"><xsl:value-of select="$title"/></font>
		<div class="section">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- Minor sections -->
	<xsl:template match="section">
		<xsl:call-template name="section">
			<xsl:with-param name="title"><xsl:value-of select="@name"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- References -->

	<xsl:template match="ref">
		<xsl:variable name="Ref"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
		<xsl:variable name="File"><xsl:value-of select="key('sections', $Ref)/@filename"/></xsl:variable>
		<xsl:variable name="Name"><xsl:value-of select="key('sections', $Ref)/@name"/></xsl:variable>
		<xsl:variable name="Link"/>

		<xsl:if test="$Name=''">
			<!-- Generate error if section doesn't exist. -->
			<xsl:message>Unable to find section '<xsl:value-of select="$Ref"/>'.</xsl:message>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="$File != ''">
				<a href="{$File}"><xsl:value-of select="$Name"/></a>
			</xsl:when>
			<xsl:otherwise>
				<!-- Fetch filename from first parent section reached -->
				<xsl:variable name="File"><xsl:value-of select="key('sections', $Ref)/ancestor::section[@filename]/@filename"/></xsl:variable>
				<a href="{$File}#section:{$Ref}"><xsl:value-of select="$Ref"/></a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="cite">
		<xsl:variable name="Ref"><xsl:value-of select="."/></xsl:variable>
		<xsl:variable name="Name"><xsl:value-of select="key('references', $Ref)/@name"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$Name=''">
				<b class="error"><xsl:value-of select="$Ref"/></b>
			</xsl:when>
			<xsl:otherwise>
				<a href="References.html#ref:{$Ref}"><xsl:value-of select="$Name"/></a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="references">
		<div class="section">
			References
			<table class="references">
				<xsl:apply-templates><xsl:sort select="@name"/></xsl:apply-templates>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="references/reference">
		<tr>
			<td class="reference">
				<a name="ref:{@name}"/>
				<xsl:value-of select="@name"/>
			</td>
			<td>
				<p><a href="{@link}"><xsl:value-of select="@link"/></a></p>
				<xsl:apply-templates/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="link">
		<a href="{@href}"><xsl:apply-templates/></a>
	</xsl:template>

	<!-- Other -->

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- ############################## -->
	<!-- ############################## -->
	<!-- ############################## -->

	<xsl:template name="error">
		[<b class="error"><xsl:value-of select="."/></b>]
	</xsl:template>

	<xsl:template match="email">
		<a href="mailto:{@address}"><xsl:value-of select="@address"/></a>
	</xsl:template>

	<xsl:template match="url">
		<a href="{@address}"><xsl:value-of select="@address"/></a>
	</xsl:template>

	<!-- Other -->

	<xsl:template match="description">
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	<xsl:template match="figure">
		<div class="figure">
			<img alt="{@caption}" src="{@src}"/><br/>
			<xsl:value-of select="@caption"/>
		</div>
	</xsl:template>

	<!-- Tables and lists -->

	<xsl:template match="character-creation">
		<ol>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>
	<xsl:template match="character-creation/step">
		<li>
			<xsl:apply-templates/>
		</li>
	</xsl:template>

	<xsl:template match="attributes">
		<table class="data">
			<tr class="headings">
				<td>Attribute</td>
				<td>Type</td>
				<td>Range</td>
				<td>Notes</td>
			</tr>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="attributes/attribute">
		<tr>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="@type"/></td>
			<td><xsl:value-of select="@range"/></td>
			<td><xsl:apply-templates/></td>
		</tr>
	</xsl:template>

	<xsl:template match="stereotypes">
		<table class="data">
			<tr class="headings">
				<td>Name</td>
				<td>Notes</td>
			</tr>
			<xsl:apply-templates><xsl:sort select="@name"/></xsl:apply-templates>
		</table>
	</xsl:template>
	<xsl:template match="stereotypes/stereotype">
		<tr>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:apply-templates/></td>
		</tr>
	</xsl:template>

	<xsl:template match="locations">
		<xsl:apply-templates><xsl:sort select="@name"/></xsl:apply-templates>
	</xsl:template>
	<xsl:template match="locations/location">
		<div class="location">
			<xsl:if test="@image">
				<img class="scenery" src="images/{@image}" alt="{@name}" align="right"/>
			</xsl:if>
			<xsl:call-template name="section">
				<xsl:with-param name="title"><xsl:value-of select="@name"/></xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template match="location/description">
		<dl><dt>Description</dt><dd><xsl:apply-templates/></dd></dl>
	</xsl:template>
	<xsl:template match="location/menu">
		<dl><dt>Menu</dt><dd><xsl:call-template name="menu"/></dd></dl>
	</xsl:template>

	<xsl:template match="section/menu">
		<dl><dt>Menu</dt><dd><xsl:call-template name="menu"/></dd></dl>
	</xsl:template>
	<xsl:template match="menu" name="menu">
		<ul class="menu">
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	<xsl:template match="menuitem">
		<li><xsl:apply-templates/></li>
	</xsl:template>

	<xsl:template match="items">
		<xsl:apply-templates><xsl:sort select="@name"/></xsl:apply-templates>
	</xsl:template>
	<xsl:template match="items/item">
		<a name="item:{@name}"></a>
		<div class="item">
			<xsl:call-template name="section">
				<xsl:with-param name="title"><xsl:value-of select="@name"/></xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template match="item/description">
		<dl><dt>Description</dt><dd><xsl:apply-templates/></dd></dl>
	</xsl:template>
	<xsl:template match="item/menu">
		<dl><dt>Menu</dt><dd><xsl:call-template name="menu"/></dd></dl>
	</xsl:template>
	<xsl:template match="item" name="item">
		<xsl:variable name="Ref"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
		<xsl:variable name="File"><xsl:value-of select="key('items', $Ref)/@filename"/></xsl:variable>
		<xsl:variable name="Name"><xsl:value-of select="key('items', $Ref)/@name"/></xsl:variable>
		<xsl:variable name="Link"/>

		<xsl:if test="$Name=''">
			<!-- Generate error if doesn't exist. -->
			<xsl:message>Unable to find item '<xsl:value-of select="$Ref"/>'.</xsl:message>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="$File != ''">
				<a href="{$File}"><xsl:value-of select="$Name"/></a>
			</xsl:when>
			<xsl:otherwise>
				<!-- Fetch filename from first parent section reached -->
				<xsl:variable name="File"><xsl:value-of select="key('items', $Ref)/ancestor::section[@filename]/@filename"/></xsl:variable>
				<a href="{$File}#item:{$Ref}"><xsl:value-of select="$Ref"/></a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="activity/activities">
		<p><xsl:apply-templates/></p>
	</xsl:template>
	<xsl:template match="activities">
		<table class="data">
			<tr class="headings">
				<td>Name</td>
				<td>Selections</td>
				<td>Description</td>
				<td>Effects</td>
			</tr>
			<xsl:apply-templates><xsl:sort select="@name"/></xsl:apply-templates>
		</table>
	</xsl:template>
	<xsl:template match="activities/activity">
		<tr>
			<td><a name="act:{@name}"></a><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="@select"/></td>
			<td><xsl:apply-templates select="text()|*[not(self::effects)]"/></td>
			<td><xsl:apply-templates select="effects"/></td>
		</tr>
	</xsl:template>
	<xsl:template match="act" name="act">
		<xsl:variable name="Ref"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
		<xsl:variable name="File"><xsl:value-of select="key('activities', $Ref)/@filename"/></xsl:variable>
		<xsl:variable name="Name"><xsl:value-of select="key('activities', $Ref)/@name"/></xsl:variable>
		<xsl:variable name="Link"/>

		<xsl:if test="$Name=''">
			<!-- Generate error if doesn't exist. -->
			<xsl:message>Unable to find activity '<xsl:value-of select="$Ref"/>'.</xsl:message>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="$File != ''">
				<a href="{$File}"><xsl:value-of select="$Name"/></a>
			</xsl:when>
			<xsl:otherwise>
				<!-- Fetch filename from first parent section reached -->
				<xsl:variable name="File"><xsl:value-of select="key('activities', $Ref)/ancestor::section[@filename]/@filename"/></xsl:variable>
				<a href="{$File}#act:{$Ref}"><xsl:value-of select="$Ref"/></a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
