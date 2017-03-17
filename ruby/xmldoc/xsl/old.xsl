<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:output method="html" indent="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
	<xsl:key name="references" match="reference" use="@name"/>
	<xsl:key name="sections" match="/doc//section" use="@name"/>

	<xsl:key name="characters" match="npc|player" use="@name"/>
	<xsl:key name="places" match="places//place" use="@name"/>
	<xsl:key name="urls" match="/doc//urls/url" use="@name"/>

	<xsl:param name="outdir">.</xsl:param>
	<xsl:param name="imagesdir">../images</xsl:param>
	<xsl:param name="filesdir">../files</xsl:param>

	<!-- Common header/footer data -->

	<xsl:template name="html-header">
		<xsl:param name="title">(untitled)</xsl:param>
		<xsl:param name="stylesheet">../html.css</xsl:param>
		<head>
			<title><xsl:value-of select="$title"/></title>
			<meta name="author" content="{/doc/meta/author}"/>
			<meta http-equiv="content-type" content="text/html; charset=iso-8859-1"/>
			<link href="{$stylesheet}" rel="stylesheet" type="text/css"/>
		</head>
	</xsl:template>

	<xsl:template name="title">
		<div>
			<img src="{$imagesdir}/title.png"/>
		</div>
	</xsl:template>

	<xsl:template name="nav">
		<p class="nav">
			<a href="index.html">Summary</a>
			<xsl:apply-templates select="/doc/contents" mode="TOC"/>
		</p>
	</xsl:template>

	<!-- Document root (creates index.html) -->

	<xsl:template match="/doc">
		<xsl:variable name="file">index.html</xsl:variable>
		<xsl:message>-&gt; <xsl:value-of select="$outdir"/>/<xsl:value-of select="$file"/></xsl:message>
		<xsl:document method="html" href="{$outdir}/{$file}">
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
		<xsl:variable name="file"><xsl:value-of select="@filename"/></xsl:variable>
		<xsl:message>-&gt; <xsl:value-of select="$outdir"/>/<xsl:value-of select="$file"/></xsl:message>
		<xsl:document method="html" href="{$file}">
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

	<xsl:template match="contents">
		<xsl:apply-templates mode="page"/>
	</xsl:template>

	<xsl:template match="section" mode="TOC">
		| <a href="{@filename}"><xsl:value-of select="@name"/></a>
	</xsl:template>


	<!-- Sections -->

	<xsl:template name="box">
		<xsl:param name="title">(untitled)</xsl:param>
		<a name="section:{normalize-space(@name)}"/>
		<div class="box">
			<xsl:value-of select="$title"/>
			<div class="inside-box">
				<xsl:apply-templates/>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="section">
		<xsl:param name="title">(untitled)</xsl:param>
		<a name="section:{normalize-space(@name)}"/>
		<font class="head"><xsl:value-of select="$title"/></font>
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
		<xsl:variable name="label"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
		<xsl:variable name="file"><xsl:value-of select="key('sections', $label)/@filename"/></xsl:variable>

		<xsl:choose>
			<xsl:when test="$file != ''">
				<a href="{$file}">
					<xsl:value-of select="key('sections', $label)/@name"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="file"><xsl:value-of select="key('sections', $label)/ancestor::section[@filename]/@filename"/></xsl:variable>
				<xsl:if test="$file=''">
					<xsl:message>Reference to section '<xsl:value-of select="$label"/>' not found.</xsl:message>
					<b class="error"><xsl:value-of select="$label"/></b>
				</xsl:if>
				<a href="{$file}#section:{$label}">
					<xsl:value-of select="key('sections', $label)/@name"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="cite">
		<xsl:variable name="label"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
		<xsl:variable name="name"><xsl:value-of select="key('references', $label)/@name"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$name=''">
				<b class="error"><xsl:value-of select="$label"/></b>
			</xsl:when>
			<xsl:otherwise>
				<a href="references.html#ref:{$label}"><xsl:value-of select="$name"/></a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="references">
		<div class="box">
			References
			<table class="inside-box">
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

	<!-- Tables -->
	<xsl:template name="data-table">
		<div class="box">
			<xsl:value-of select="@table"/>
			<div class="inside-box">
				<table class="data">
					<xsl:for-each select="headings">
						<xsl:call-template name="data-table-headings"/>
					</xsl:for-each>
					<xsl:for-each select="*[not(self::headings)]">
						<xsl:sort select="name"/>
						<xsl:call-template name="data-table-data"/>
					</xsl:for-each>
				</table>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="data-table-headings">
		<tr class="headings">
			<xsl:for-each select="heading">
				<td><xsl:apply-templates/></td>
			</xsl:for-each>
		</tr>
	</xsl:template>

	<xsl:template name="data-table-data">
		<tr class="data">
			<xsl:for-each select="heading">
				<td class="row-head"><xsl:apply-templates/></td>
			</xsl:for-each>
			<xsl:for-each select="*[not(self::heading) and position() = 1]">
				<td><a name="{.}"/><xsl:apply-templates/></td>
			</xsl:for-each>
			<xsl:for-each select="*[not(self::heading) and position() > 1]">
				<td><xsl:apply-templates/></td>
			</xsl:for-each>
		</tr>
	</xsl:template>

	<!-- Only show stuff between secret tags if the parameter 'secrets' is set to 'shown' -->

	<xsl:template match="secret">
		<xsl:if test="$secrets='shown'">
			<div class="secret">
				<xsl:apply-templates select="*|node()"/>
				<br class="clear"/>
			</div>
		</xsl:if>
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

	<xsl:template match="*[@table]">
		<xsl:call-template name="data-table"/>
	</xsl:template>

	<xsl:template name="error">
		[<b class="error"><xsl:value-of select="."/></b>]
	</xsl:template>

	<xsl:template match="email">
		<a href="mailto:{@address}"><xsl:value-of select="@address"/></a>
	</xsl:template>

	<!-- NPCs -->

	<xsl:template match="npcs">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="npc">
		<a name="character:{@name}"/>
		<div class="npc">
			<font class="head"><xsl:value-of select="@name"/></font><br/>
			<xsl:choose>
				<xsl:when test="@portrait">
					<img class="portrait" src="portraits/{@portrait}" align="left"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>No portrait for character '<xsl:value-of select="@name"/>'.</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="player">
		<a name="character:{@name}"/>
		<div class="player">
			<font class="head" style="clear:both"><xsl:value-of select="owner"/></font><br/>
			<table class="data" style="margin-top: 0px" cellspacing="0">
				<tr><td class="head">Name</td><td><xsl:value-of select="name"/></td></tr>
				<tr><td class="head">Race</td><td><xsl:value-of select="race"/></td></tr>
				<tr><td class="head">Gender</td><td><xsl:value-of select="gender"/></td></tr>
			</table>
			<xsl:choose>
				<xsl:when test="@portrait">
					<img class="portrait" src="portraits/{@portrait}" align="left"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>No portrait for character '<xsl:value-of select="@name"/>'.</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="description"/>
		</div>
	</xsl:template>

	<xsl:template match="npc//description">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<!-- Places -->

	<xsl:template match="places">
		<xsl:apply-templates><xsl:sort select="@name"/></xsl:apply-templates>
	</xsl:template>

	<xsl:template match="places//place">
		<a name="place:{@name}"/>
		<div class="place">
			<font class="head"><xsl:value-of select="@name"/></font><br/>
			<xsl:choose>
				<xsl:when test="@scenery">
					<img class="scenery" src="scenery/{@scenery}" align="left"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>No scenery for place '<xsl:value-of select="@name"/>'.</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- Other -->

	<xsl:template match="description">
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	<xsl:template match="skills">
		<table class="data" cellspacing="1">
			<tr class="head">
				<td><xsl:value-of select="@type"/> Skills</td>
				<td>Cost</td>
				<td>Notes/Examples of Specialisation</td>
			</tr>
			<xsl:apply-templates><xsl:sort select="@name"/></xsl:apply-templates>
		</table>
	</xsl:template>

	<xsl:template match="skills/skill">
		<tr class="data">
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="@cost"/></td>
			<td><xsl:apply-templates/></td>
		</tr>
	</xsl:template>

	<!-- Custom References -->

	<xsl:template match="character" name="character">
		<xsl:variable name="label"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
		<xsl:variable name="file">characters.html</xsl:variable>
		<xsl:variable name="name"><xsl:value-of select="key('characters', $label)/@name"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$name != ''">
				<a href="{$file}#character:{$name}"><xsl:value-of select="$name"/></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>Character '<xsl:value-of select="$label"/>' not found.</xsl:message>
				<xsl:call-template name="error"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="place" name="place">
		<xsl:variable name="label"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
		<xsl:variable name="file">places.html</xsl:variable>
		<xsl:variable name="name"><xsl:value-of select="key('places', $label)/@name"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$name != ''">
				<a href="{$file}#place:{$name}"><xsl:value-of select="$name"/></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>Place '<xsl:value-of select="$label"/>' not found.</xsl:message>
				<xsl:call-template name="error"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="urls">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="urls/url">
	</xsl:template>

	<xsl:template match="url" name="url">
		<xsl:param name="label"><xsl:value-of select="normalize-space(.)"/></xsl:param>
		<xsl:variable name="url"><xsl:value-of select="key('urls', $label)/@url"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$url != ''">
				<a href="{$url}"><xsl:value-of select="$url"/></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>Link '<xsl:value-of select="$label"/>' not found.</xsl:message>
				<xsl:call-template name="error"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="link" name="link">
		<xsl:param name="label"><xsl:value-of select="normalize-space(.)"/></xsl:param>
		<xsl:variable name="url"><xsl:value-of select="key('urls', $label)/@url"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$url != ''">
				<a href="{$url}"><xsl:value-of select="$label"/></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>Link '<xsl:value-of select="$label"/>' not found.</xsl:message>
				<xsl:call-template name="error"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="races">
		<dl class="race">
			<xsl:apply-templates/>
		</dl>
	</xsl:template>
	<xsl:template match="races/race">
		<dt><xsl:value-of select="@name"/></dt>
		<dd><xsl:apply-templates/></dd>
	</xsl:template>

	<xsl:template match="magiccolleges">
		<dl class="magiccolleges">
			<xsl:apply-templates/>
		</dl>
	</xsl:template>
	<xsl:template match="magiccolleges/magiccollege">
		<dt><xsl:value-of select="@name"/></dt>
		<dd><xsl:apply-templates/></dd>
	</xsl:template>

	<xsl:template match="starsigns">
		<dl class="starsigns">
			<xsl:apply-templates/>
		</dl>
	</xsl:template>
	<xsl:template match="starsigns/starsign">
		<dt><xsl:value-of select="@name"/></dt>
		<dd><xsl:apply-templates/></dd>
	</xsl:template>

</xsl:stylesheet>
