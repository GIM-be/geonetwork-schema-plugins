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

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:saxon="http://saxon.sf.net/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:void="http://www.w3.org/TR/void/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:dcat="http://www.w3.org/ns/dcat#"
  xmlns:ogc="http://www.opengis.net/rdf#"  
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  extension-element-prefixes="saxon"
  exclude-result-prefixes="#all">

  <!-- 
    Create reference block to metadata record and dataset to be added in dcat:Catalog usually.
  -->
  <!-- FIME : $url comes from a global variable. -->
  <xsl:template match="dcat:Dataset" mode="record-reference">
    <dcat:Dataset rdf:resource="{$url}/resource/{dct:identifier[1]}"/>
    <dcat:record rdf:resource="{$url}/metadata/{dct:identifier[1]}"/>
  </xsl:template>


  <xsl:template match="dcat:Dataset" mode="to-dcat">
    <dcat:CatalogRecord rdf:about="{$url}/metadata/{dct:identifier[1]}">
      <!-- Link to a dcat:Dataset or a rdf:Description for services and feature catalogue. -->
      <foaf:primaryTopic rdf:resource="{$url}/resource/{dct:identifier[1]}"/>
    </dcat:CatalogRecord>

    <dcat:Dataset rdf:about="{$url}/metadata/{dct:identifier[1]}">
      <xsl:copy-of select="dct:*[name(.) != 'dct:spatial']|dcat:*[name(.) != 'dcat:Distribution']"/>
      <xsl:call-template name="spatial-to-dcat"/>
      <dcat:distribution>
      		 <xsl:copy-of select="dcat:Distribution"/>     		
      </dcat:distribution>
    </dcat:Dataset>
  </xsl:template>
  
  <!-- "Spatial coverage of the dataset.-->
  <xsl:template name="spatial-to-dcat">
  <xsl:for-each select="dct:spatial">
   		<xsl:variable name="coverage" select="."/>
		<xsl:variable name="n" select="substring-after($coverage,'North ')"/>
		<xsl:variable name="north" select="substring-before($n,',')"/>
		<xsl:variable name="s" select="substring-after($coverage,'South ')"/>
		<xsl:variable name="south" select="substring-before($s,',')"/>
		<xsl:variable name="e" select="substring-after($coverage,'East ')"/>
		<xsl:variable name="east" select="substring-before($e,',')"/>
		<xsl:variable name="west" select="substring-after($coverage,'West ')"/>
		<xsl:if test="$west!='' and $east!='' and $north!='' and $south!=''">		
	    <dct:spatial>
	      <ogc:Polygon>
	        <ogc:asWKT rdf:datatype="http://www.opengis.net/rdf#WKTLiteral">
	          &lt;http://www.opengis.net/def/crs/OGC/1.3/CRS84&gt;
	          Polygon(<xsl:value-of select="concat($north, ' ', $west, ', ', $north, ' ', $east, ', ', $south, ' ', $east, ', ', $south, ' ', $west, ', ', $north, ' ', $west)" />)
	        </ogc:asWKT>
	      </ogc:Polygon>
	    </dct:spatial>
	    </xsl:if>
  </xsl:for-each>
  </xsl:template>

  <xsl:template match="dcat:Dataset" mode="references"/>

  <xsl:template mode="dcat:Dataset" match="gui|request|metadata"/>

</xsl:stylesheet>
