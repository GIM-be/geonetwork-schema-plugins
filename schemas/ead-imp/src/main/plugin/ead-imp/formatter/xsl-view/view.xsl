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

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="http://ead3.archivists.org/schema/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tr="java:org.fao.geonet.api.records.formatters.SchemaLocalizations"
                xmlns:gn-fn-render="http://geonetwork-opensource.org/xsl/functions/render"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                exclude-result-prefixes="#all">
   
  <!-- Load the editor configuration to be able
  to render the different views -->
  <xsl:variable name="configuration"
                select="document('../../layout/config-editor.xml')"/>

  <!-- Some utility -->
  <xsl:include href="../../layout/evaluate.xsl"/>

  <!-- The core formatter XSL layout based on the editor configuration -->
  <xsl:include href="sharedFormatterDir/xslt/render-layout.xsl"/>
  <!--<xsl:include href="../../../../../data/formatter/xslt/render-layout.xsl"/>-->

  <!-- Define the metadata to be loaded for this schema plugin-->
  <xsl:variable name="metadata"
                select="/root/ead:ead"/>




  <!-- Specific schema rendering -->
  <xsl:template mode="getMetadataTitle" match="ead:ead">
    <xsl:value-of select="ead:archdesc/ead:did/ead:unittitle"/>
  </xsl:template>

  <xsl:template mode="getMetadataAbstract" match="ead:ead">
  	<xsl:message>Abstract</xsl:message>
    <xsl:value-of select="ead:archdesc/ead:did/ead:abstract"/>
  </xsl:template>

  <xsl:template mode="getMetadataHeader" match="ead:ead">
  </xsl:template>


  <!-- Most of the elements are ... -->
  <xsl:template mode="render-field" match="*">
    <xsl:param name="fieldName" select="''" as="xs:string"/>

    <dl>
      <dt>
        <xsl:value-of select="if ($fieldName)
                                then $fieldName
                                else tr:node-label(tr:create($schema), name(), null)"/>
      </dt>
      <dd>
        <xsl:apply-templates mode="render-value" select="."/>
      </dd>
    </dl>
  </xsl:template>

  <!-- Traverse the tree -->
  <xsl:template mode="render-field" match="ead:ead">
    <xsl:apply-templates mode="render-field"/>
  </xsl:template>

  <!-- ########################## -->
  <!-- Render values for text ... -->
  <xsl:template mode="render-value" match="*">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- ... URL -->
  <xsl:template mode="render-value" match="*[starts-with(., 'http')]">
    <a href="{.}"><xsl:value-of select="."/></a>
  </xsl:template>

  <!-- ... Dates -->
  <xsl:template mode="render-value" match="*[matches(., '[0-9]{4}-[0-9]{2}-[0-9]{2}')]">
    <xsl:value-of select="format-date(., $dateFormats/date/for[@lang = $language]/text())"/>
  </xsl:template>

  <xsl:template mode="render-value" match="*[matches(., '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}')]">
    <xsl:value-of select="format-dateTime(., $dateFormats/dateTime/for[@lang = $language]/text())"/>
  </xsl:template>

</xsl:stylesheet>