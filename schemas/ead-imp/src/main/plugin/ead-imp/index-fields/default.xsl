<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ead="http://ead3.archivists.org/schema/" xmlns:util="java:org.fao.geonet.util.XslUtil" xmlns:geonet="http://www.fao.org/geonetwork">

	<!-- ========================================================================================= -->
	<!-- Tell the XSL processor to output XML. -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- ========================================================================================= -->
	<xsl:template match="/">
		<xsl:apply-templates select="ead:ead"/>
	</xsl:template>
	<xsl:template match="ead:archdesc">
			<!--TODO: uncomment<xsl:call-template name="langId-dcat-ap"/>-->
		<xsl:variable name="langCode">dut</xsl:variable>
		<Document locale="{$langCode}">
			<!-- locale information -->
			<Field name="_locale" string="{$langCode}" store="true" index="true"/>
			<Field name="_docLocale" string="{$langCode}" store="true" index="true"/>
			<!-- For multilingual docs it is good to have a title in the default locale. 
				In this type of metadata we don't have one but in the general case we do 
				so we need to add it to all -->
			<Field name="_defaultTitle" string="{string(ead:did/ead:unittitle)}" store="true" index="true"/>
			<xsl:for-each select="ead:did/ead:unitid">
				<Field name="identifier" string="{string(.)}" store="false" index="true"/>
				<Field name="fileId" string="{string(.)}" store="false" index="true"/>
			</xsl:for-each>
			<Field name="type" string="plan" store="true" index="true"/>			
			<xsl:for-each select="ead:did/ead:abstract">
				<Field name="abstract" string="{string(.)}" store="true" index="true"/>
			</xsl:for-each>
		</Document>
	</xsl:template>

</xsl:stylesheet>
