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

<xsl:stylesheet xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:java="java:org.fao.geonet.util.XslUtil"
                xmlns:joda="java:org.fao.geonet.domain.ISODate"
                xmlns:mime="java:org.fao.geonet.util.MimeTypeFinder"              
                version="2.0"
                exclude-result-prefixes="#all">

<!-- TODO: remove this comment
                xmlns:java="java:org.fao.geonet.util.XslUtil?path=file:///C:/git/aiv-geonetwork-gim/core/target/classes/"
                xmlns:joda="java:org.fao.geonet.domain.ISODate?path=file:///C:/git/aiv-geonetwork-gim/domain/target/classes/"
                xmlns:mime="java:org.fao.geonet.util.MimeTypeFinder?path=file:///C:/git/aiv-geonetwork-gim/core/target/classes/"

                xmlns:java="java:org.fao.geonet.util.XslUtil"
                xmlns:joda="java:org.fao.geonet.domain.ISODate"
                xmlns:mime="java:org.fao.geonet.util.MimeTypeFinder"
-->

  <!-- ========================================================================================= -->
  <!-- latlon coordinates indexed as numeric. -->

  <xsl:template match="*" mode="latLon">
    <xsl:variable name="format" select="'##.00'"></xsl:variable>

    <xsl:if test="number(gmd:westBoundLongitude/gco:Decimal)
            and number(gmd:southBoundLatitude/gco:Decimal)
            and number(gmd:eastBoundLongitude/gco:Decimal)
            and number(gmd:northBoundLatitude/gco:Decimal)
            ">
      <Field name="westBL" string="{format-number(gmd:westBoundLongitude/gco:Decimal, $format)}"
             store="false" index="true"/>
      <Field name="southBL" string="{format-number(gmd:southBoundLatitude/gco:Decimal, $format)}"
             store="false" index="true"/>

      <Field name="eastBL" string="{format-number(gmd:eastBoundLongitude/gco:Decimal, $format)}"
             store="false" index="true"/>
      <Field name="northBL" string="{format-number(gmd:northBoundLatitude/gco:Decimal, $format)}"
             store="false" index="true"/>

      <Field name="geoBox" string="{concat(gmd:westBoundLongitude/gco:Decimal, '|',
                gmd:southBoundLatitude/gco:Decimal, '|',
                gmd:eastBoundLongitude/gco:Decimal, '|',
                gmd:northBoundLatitude/gco:Decimal
                )}" store="true" index="false"/>
    </xsl:if>

  </xsl:template>
  <!-- ================================================================== -->

  <xsl:template name="fixSingle">
    <xsl:param name="value"/>

    <xsl:choose>
      <xsl:when test="string-length(string($value))=1">
        <xsl:value-of select="concat('0',$value)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================== -->

  <xsl:template name="getMimeTypeFile">
    <xsl:param name="datadir"/>
    <xsl:param name="fname"/>
    <xsl:value-of select="mime:detectMimeTypeFile($datadir,$fname)"/>
  </xsl:template>

  <!-- ==================================================================== -->

  <xsl:template name="getMimeTypeUrl">
    <xsl:param name="linkage"/>
    <xsl:value-of select="mime:detectMimeTypeUrl($linkage)"/>
  </xsl:template>



  <!-- ================================================================== -->
  <!-- iso3code of default index language -->
  <xsl:variable name="defaultLang">eng</xsl:variable>

  <xsl:template name="langId19139">
    <xsl:variable name="tmp">
      <xsl:choose>
        <xsl:when test="/*[name(.)='gmd:MD_Metadata' or @gco:isoType='gmd:MD_Metadata']/gmd:language/gco:CharacterString|
                                /*[name(.)='gmd:MD_Metadata' or @gco:isoType='gmd:MD_Metadata']/gmd:language/gmd:LanguageCode/@codeListValue">
          <xsl:value-of select="/*[name(.)='gmd:MD_Metadata' or @gco:isoType='gmd:MD_Metadata']/gmd:language/gco:CharacterString|
                                /*[name(.)='gmd:MD_Metadata' or @gco:isoType='gmd:MD_Metadata']/gmd:language/gmd:LanguageCode/@codeListValue"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$defaultLang"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="normalize-space(string($tmp))"></xsl:value-of>
  </xsl:template>


</xsl:stylesheet>
