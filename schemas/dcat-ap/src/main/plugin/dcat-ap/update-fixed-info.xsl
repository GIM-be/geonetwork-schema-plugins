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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:spdx="http://spdx.org/rdf/terms#"
		xmlns:skos="http://www.w3.org/2004/02/skos/core#"
		xmlns:adms="http://www.w3.org/ns/adms#" 
		xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:dcat="http://www.w3.org/ns/dcat#"
		xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
		xmlns:foaf="http://xmlns.com/foaf/0.1/" 
		xmlns:owl="http://www.w3.org/2002/07/owl#"
		xmlns:schema="http://schema.org/">

  <!-- =================================================================   -->

  <xsl:variable name="serviceUrl" select="/root/env/siteURL"/>

  <xsl:template match="/root">
    <xsl:apply-templates select="rdf:RDF"/>
  </xsl:template>
  
  <!-- ================================================================= -->

  <xsl:template match="@*|node()">
	<xsl:message select="concat('----->Verwerking element ',name(.))"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- ================================================================= -->

  <xsl:template match="dcat:Catalog/dct:title">
		<dct:title>Catalog name must be used here</dct:title>
  </xsl:template>

  <xsl:template match="dcat:Catalog/dct:description">
		<dct:description>Catalog description must be used here with organization name and catalog site id?</dct:description>
  </xsl:template>

  <!-- ================================================================= -->
  <xsl:template match="dcat:Dataset">
    <dcat:Dataset>
      <dct:identifier>
        <xsl:value-of select="/root/env/uuid"/>
      </dct:identifier>
      <xsl:apply-templates select="dct:*[name(.)!= 'dct:identifier']"/>
      <xsl:apply-templates select="dcat:*|vcard:*|foaf:*|spdx:*|adms:*|owl:*|schema:*"/>
    </dcat:Dataset>
  </xsl:template>

  <xsl:template match="dct:issued[*:DateTime]|dct:modified[*:DateTime]|schema:startDate[*:DateTime]|schema:endDate[*:DateTime]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
	  <xsl:value-of select="*:DateTime"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="dcat:homepage/foaf:Document">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
	  <xsl:value-of select="$serviceUrl"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
  