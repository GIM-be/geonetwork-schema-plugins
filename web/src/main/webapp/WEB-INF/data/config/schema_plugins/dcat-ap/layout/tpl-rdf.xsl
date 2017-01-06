<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:saxon="http://saxon.sf.net/"
 xmlns:adms="http://www.w3.org/ns/adms#" 
				xmlns:dct="http://purl.org/dc/terms/" 
				xmlns:dcat="http://www.w3.org/ns/dcat#" 
				xmlns:foaf="http://xmlns.com/foaf/0.1/" 
				xmlns:locn="http://www.w3.org/ns/locn#" 
				xmlns:owl="http://www.w3.org/2002/07/owl#" 
				xmlns:schema="http://schema.org/" 
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
				xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
				xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
				xmlns:spdx="http://spdx.org/rdf/terms#" 
				xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
				xmlns:void="http://www.w3.org/TR/void/"  
				xmlns:ogc="http://www.opengis.net/rdf#"
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
      <xsl:copy-of select="dct:*|dcat:*[name(.) != 'dcat:Distribution']|foaf:*|owl:*|adms:*"/>  <!-- dct:*[name(.) != 'dct:spatial'  -->
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
