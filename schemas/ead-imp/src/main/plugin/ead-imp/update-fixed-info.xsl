<?xml version="1.0" encoding="UTF-8"?>
<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->
<xsl:stylesheet version="1.0" xmlns:ead="http://ead3.archivists.org/schema/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:util="java:java.util.UUID" exclude-result-prefixes="#all">
	<!-- Tell the XSL processor to output XML. -->
	<xsl:output method="xml" indent="yes"/>
	<!-- =================================================================   -->
	<xsl:variable name="serviceUrl" select="/root/env/siteURL"/>
	<xsl:variable name="unitid" select="/root//ead:ead/ead:archdesc/ead:did/ead:unitid"/>
	<xsl:variable name="isNew" select="/root/env/uuid!=$unitid"/>
	<xsl:template match="/root">
		<xsl:apply-templates select="//ead:ead"/>
	</xsl:template>
	<!-- =================================================================  -->
	<xsl:template match="ead:did[name(..)='ead:archdesc']">
		<ead:did>
			<xsl:apply-templates select="@*|node()"/>
		</ead:did>
		<xsl:if test="$isNew and count(../ead:relations)=0">
			<ead:relations>
				<ead:relation relationtype="resourcerelation" href="{concat($serviceUrl,'catalog.search#/metadata/',$unitid)}">
					<ead:resourcerelation><xsl:value-of select="ead:unittitle"/></ead:resourcerelation>
				</ead:relation>
			</ead:relations>
		</xsl:if>
	</xsl:template>
	<!-- =================================================================  -->
	<xsl:template match="ead:did[name(..)='ead:c']">
		<ead:did>
			<xsl:apply-templates select="@*|node()"/>
		</ead:did>
		<xsl:if test="$isNew and count(../ead:relations)=0">
			<ead:relations>
				<ead:relation relationtype="resourcerelation" href="{concat($serviceUrl,'catalog.search#/metadata/',$unitid,'?serieUuid=',ead:unitid)}">
					<ead:resourcerelation><xsl:value-of select="ead:unittitle"/></ead:resourcerelation>
				</ead:relation>
			</ead:relations>
		</xsl:if>
	</xsl:template>
	<!-- =================================================================  -->
	<xsl:template match="ead:relations[name(..)='ead:archdesc' or name(..)='ead:c']">
		<ead:relations>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:if test="$isNew">
				<ead:relation relationtype="resourcerelation">
					<xsl:attribute name="href"><xsl:value-of select="concat($serviceUrl,'catalog.search#/metadata/',$unitid)"/><xslif test="name(..)='ead:c'"><xsl:value-of select="concat('?serieUuid=',../ead:did/ead:unitid)"/></xslif></xsl:attribute>
					<ead:resourcerelation><xsl:value-of select="../ead:did/ead:unittitle"/></ead:resourcerelation>
				</ead:relation>
			</xsl:if>
		</ead:relations>
	</xsl:template>
	<!-- =================================================================  -->
	<xsl:template match="ead:unitid[name(../..)='ead:archdesc']">
		<ead:unitid>
			<xsl:apply-templates select="@*"/>
			<xsl:value-of select="/root/env/uuid"/>
		</ead:unitid>
	</xsl:template>
	<!-- =================================================================  -->
	<xsl:template match="ead:unitid[name(../..)='ead:c']">
		<ead:unitid>
			<xsl:apply-templates select="@*"/>
			<xsl:if test="$isNew">
				<xsl:value-of select="util:toString(util:randomUUID())"/>
			</xsl:if>
			<xsl:if test="not($isNew)">
				<xsl:if test="normalize-space(.)=''">
					<xsl:value-of select="util:toString(util:randomUUID())"/>
				</xsl:if>
				<xsl:if test="normalize-space(.)!=''">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:if>
		</ead:unitid>
	</xsl:template>
	<!-- =================================================================  -->
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
