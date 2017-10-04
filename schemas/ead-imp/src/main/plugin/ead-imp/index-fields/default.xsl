<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ead="http://ead3.archivists.org/schema/" xmlns:util="java:org.fao.geonet.util.XslUtil" xmlns:geonet="http://www.fao.org/geonetwork">
	<!-- ========================================================================================= -->
	<!-- Tell the XSL processor to output XML. -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- ========================================================================================= -->
	<xsl:template match="/">
		<xsl:apply-templates select="ead:ead"/>
	</xsl:template>
	<xsl:template match="/">
		<!--TODO: uncomment<xsl:call-template name="langId-dcat-ap"/>-->
		<xsl:variable name="langCode">dut</xsl:variable>
		<Document locale="{$langCode}">
			<!-- locale information -->
			<Field name="_locale" string="{$langCode}" store="true" index="true"/>
			<Field name="_docLocale" string="{$langCode}" store="true" index="true"/>
			<!-- For multilingual docs it is good to have a title in the default locale. 
				In this type of metadata we don't have one but in the general case we do 
				so we need to add it to all -->
			<xsl:message select="concat('root is ',name(.))"/>
			<xsl:variable name="_defaultTitle" select="ead:ead/ead:archdesc/ead:did/ead:unittitle"/>
			<Field name="_defaultTitle" string="{string($_defaultTitle)}" store="true" index="true"/>
			<xsl:if test="geonet:info/isTemplate != 's'">
				<Field name="_title" string="{string($_defaultTitle)}" store="true" index="true"/>
			</xsl:if>
			<xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:unitid">
				<Field name="identifier" string="{string(.)}" store="false" index="true"/>
				<Field name="fileId" string="{string(.)}" store="false" index="true"/>
			</xsl:for-each>
			<Field name="type" string="plan" store="true" index="true"/>
			<xsl:for-each select="ead:ead/ead:archdesc/ead:did/ead:abstract">
				<Field name="abstract" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>
			<xsl:variable name="seriesAsAttributeTable">
				<xsl:for-each select="/ead:ead/ead:archdesc/ead:dsc/ead:c/ead:did">
{&quot;name&quot;: &quot;<xsl:value-of select="./ead:unittitle/string()"/>&quot;,
&quot;definition&quot;: "<xsl:value-of select="./ead:abstract/string()"/>&quot;,
&quot;type&quot;: "<xsl:value-of select="./ead:unitid/string()"/>&quot;}
					<xsl:if test="position()!=last()" ><xsl:text>, </xsl:text></xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<Field name="attributeTable" string="[{$seriesAsAttributeTable}]" store="true" index="true"/>
			<xsl:apply-templates mode="index" select="*"/>
		</Document>
	</xsl:template>
	<xsl:template mode="index" match="*|@*">
		<xsl:apply-templates mode="index" select="*|@*"/>
	</xsl:template>
</xsl:stylesheet>
