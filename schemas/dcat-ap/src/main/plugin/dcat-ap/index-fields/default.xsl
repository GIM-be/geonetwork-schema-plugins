<?xml version="1.0" encoding="UTF-8"?>
<!-- ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the ~ 
	United Nations (FAO-UN), United Nations World Food Programme (WFP) ~ and 
	United Nations Environment Programme (UNEP) ~ ~ This program is free software; 
	you can redistribute it and/or modify ~ it under the terms of the GNU General 
	Public License as published by ~ the Free Software Foundation; either version 
	2 of the License, or (at ~ your option) any later version. ~ ~ This program 
	is distributed in the hope that it will be useful, but ~ WITHOUT ANY WARRANTY; 
	without even the implied warranty of ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR 
	PURPOSE. See the GNU ~ General Public License for more details. ~ ~ You should 
	have received a copy of the GNU General Public License ~ along with this 
	program; if not, write to the Free Software ~ Foundation, Inc., 51 Franklin 
	St, Fifth Floor, Boston, MA 02110-1301, USA ~ ~ Contact: Jeroen Ticheler 
	- FAO - Viale delle Terme di Caracalla 2, ~ Rome - Italy. email: geonetwork@osgeo.org -->
<xsl:stylesheet version="2.0" xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dcat="http://www.w3.org/ns/dcat#"
	xmlns:util="java:org.fao.geonet.util.XslUtil"
	xmlns:geonet="http://www.fao.org/geonetwork" xmlns:dct="http://purl.org/dc/terms/">
	<xsl:include href="../convert/functions.xsl" />
	<xsl:include href="../../../xsl/utils-fn.xsl"/>
	
	<!-- TODO: remove this comment 
	<xsl:include href="../../../../../../../web/target/geonetwork/xsl/utils-fn.xsl" /> 
	xmlns:util="java:org.fao.geonet.util.XslUtil?path=file:///C:/git/aiv-geonetwork-gim/core/target/classes/"

<xsl:include href="../../../../../../../web/target/geonetwork/xsl/utils-fn.xsl" />	
<xsl:include href="../../../xsl/utils-fn.xsl"/>

xmlns:java="java:org.fao.geonet.util.XslUtil"
	 -->
	 
	<!-- This file defines what parts of the metadata are indexed by Lucene 
		Searches can be conducted on indexes defined here. The Field@name attribute 
		defines the name of the search variable. If a variable has to be maintained 
		in the user session, it needs to be added to the GeoNetwork constants in 
		the Java source code. Please keep indexes consistent among metadata standards 
		if they should work accross different metadata resources -->
	<!-- ========================================================================================= -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8"
		indent="yes" />
	<!-- ========================================================================================= -->
	<xsl:template match="/">
		<xsl:apply-templates select="rdf:RDF/dcat:Catalog/dcat:dataset/dcat:Dataset" />
	</xsl:template>
	<xsl:template match="dcat:Dataset">
		<xsl:variable name="langCode"
			select="if (normalize-space(dct:language) != '')
                          then string(dct:language) else 'eng'" />
		<Document locale="{$langCode}">
			<!-- locale information -->
			<Field name="_locale" string="{$langCode}" store="true" index="true" />
			<Field name="_docLocale" string="{$langCode}" store="true"
				index="true" />
			<!-- For multilingual docs it is good to have a title in the default locale. 
				In this type of metadata we don't have one but in the general case we do 
				so we need to add it to all -->
			<Field name="_defaultTitle" string="{string(dct:title)}" store="true"
				index="true" />
			<xsl:for-each select="dct:language">
				<Field name="mdLanguage" string="{string(.)}" store="true"
					index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:identifier">
				<Field name="identifier" string="{string(.)}" store="false"
					index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:description">
				<Field name="abstract" string="{string(.)}" store="true"
					index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:issued">
				<Field name="createDate" string="{string(.)}" store="true"
					index="true" />
				<Field name="createDateYear" string="{substring(string(.), 0, 5)}"
					store="true" index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:modified">
				<Field name="changeDate" string="{string(.)}" store="true"
					index="true" />
				<!--<Field name="createDateYear" string="{substring(., 0, 5)}" store="true" 
					index="true"/> -->
			</xsl:for-each>
			<xsl:for-each select="dct:format">
				<Field name="format" string="{string(.)}" store="true" index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:type">
				<Field name="type" string="{string(.)}" store="true" index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:source">
				<Field name="lineage" string="{string(.)}" store="true" index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:relation">
				<Field name="relation" string="{string(.)}" store="false"
					index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:accessRights">
				<Field name="MD_ConstraintsUseLimitation" string="{string(.)}"
					store="true" index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:rights">
				<Field name="MD_LegalConstraintsUseLimitation" string="{string(.)}"
					store="true" index="true" />
			</xsl:for-each>
			<xsl:for-each select="dct:spatial">
				<Field name="spatial" string="{string(.)}" store="false"
					index="true" />
			</xsl:for-each>
			<!-- This is needed by the CITE test script to look for strings like 'a 
				b*' strings that contain spaces -->
			<xsl:for-each select="dct:title">
				<Field name="title" string="{string(.)}" store="true" index="true" />
				<!-- not tokenized title for sorting -->
				<Field name="_title" string="{string(.)}" store="false" index="true" />
			</xsl:for-each>
			<xsl:for-each
				select="(dcat:landingPage|dcat:downloadURL|dcat:accessURL)[normalize-space(.) != '']">
				<xsl:variable name="name" select="tokenize(., '/')[last()]" />
				<!-- Index link where last token after the last / is the link name. -->
				<Field name="link" string="{concat($name, '||', ., '|WWW-LINK|WWW:LINK|0')}"
					store="true" index="false" />
			</xsl:for-each>
			<xsl:for-each
				select="(dcat:landingPage|dcat:downloadURL|dcat:accessURL)[normalize-space(.) != ''
                              and matches(., '.*(.gif|.png.|.jpeg|.jpg)$', 'i')]">
				<xsl:variable name="thumbnailType"
					select="if (position() = 1) then 'thumbnail' else 'overview'" />
				<!-- First thumbnail is flagged as thumbnail and could be considered 
					the main one -->
				<Field name="image" string="{concat($thumbnailType, '|', ., '|')}"
					store="true" index="false" />
			</xsl:for-each>

			<xsl:message>
				format is:
				<xsl:value-of select="dcat:distribution/dcat:Distribution[0]/text()" />
			</xsl:message>

			<!-- dcat:Distribution -->
			<xsl:for-each select="dcat:distribution/dcat:Distribution">
				<xsl:variable name="name" select="dct:title" />
				<!-- Index link where last token after the last / is the link name. -->
				<Field name="link"
					string="{concat(dct:title, '||', dcat:accessURL, '|WWW-LINK|WWW:LINK|0')}"
					store="true" index="false" />
				<xsl:for-each select="dct:format">
					<Field name="format" string="{.}" store="true" index="true" />
				</xsl:for-each>
				<Field name="linkage_name_des"
					string="{string(concat(variable_title, ':::', variable_desc))}"
					store="true" index="true" />
				<!-- index online protocol -->
				<xsl:variable name="tPosition" select="position()" />
				<xsl:variable name="download_check">
					<xsl:text>&amp;fname=&amp;access</xsl:text>
				</xsl:variable>
				<xsl:variable name="linkage" select="dcat:accessURL" />
				<xsl:variable name="title"
					select="normalize-space(dcat:name/dcat:CharacterString|dcat:name/dcat:MimeFileType)" />
				<xsl:variable name="desc"
					select="normalize-space(dcat:description/dcat:CharacterString)" />
				<xsl:variable name="protocol"
					select="normalize-space(dcat:protocol/dcat:CharacterString)" />
				<xsl:variable name="mimetype"
					select="geonet:protocolMimeType($linkage, $protocol, dcat:name/dcat:MimeFileType/@type)" />
				<!-- If the linkage points to WMS service and no protocol specified, 
					manage as protocol OGC:WMS -->
				<xsl:variable name="wmsLinkNoProtocol"
					select="contains(lower-case($linkage), 'service=wms') and not(string($protocol))" />
				<xsl:if
					test="string(dct:title)!='' and string(dct:description)!='' and not(contains(dcat:accessURL,$download_check))" />

				<xsl:if test="normalize-space($mimetype)!=''">
					<Field name="mimetype" string="{$mimetype}" store="true"
						index="true" />
				</xsl:if>
				<xsl:if test="contains($protocol, 'WWW:DOWNLOAD')">
					<Field name="download" string="true" store="false" index="true" />
				</xsl:if>
				<xsl:if test="contains($protocol, 'OGC:WMS') or $wmsLinkNoProtocol">
					<Field name="dynamic" string="true" store="false" index="true" />
				</xsl:if>
				<!-- ignore WMS links without protocol (are indexed below with mimetype 
					application/vnd.ogc.wms_xml) -->
				<xsl:if test="not($wmsLinkNoProtocol)">
					<Field name="link"
						string="{concat(dct:title, '|', dct:description, '|', $linkage, '|', $protocol, '|', $mimetype, '|', $tPosition)}"
						store="true" index="false" />
				</xsl:if>
				<!-- Add KML link if WMS -->
				<xsl:if
					test="starts-with($protocol,'OGC:WMS') and string($linkage)!='' and string(dct:title)!=''">
					<!-- FIXME : relative path -->
					<Field name="link"
						string="{concat(dct:title, '|', dct:description, '|',
                                                '../../srv/en/google.kml?uuid=', /dcat:MD_Metadata/dcat:fileIdentifier/dcat:CharacterString, '&amp;layers=', dct:title,
                                                '|application/vnd.google-earth.kml+xml|application/vnd.google-earth.kml+xml', '|', $tPosition)}"
						store="true" index="false" />
				</xsl:if>
				<!-- Try to detect Web Map Context by checking protocol or file extension -->
				<xsl:if
					test="starts-with($protocol,'OGC:WMC') or contains($linkage,'.wmc')">
					<Field name="link"
						string="{concat(dct:title, '|', dct:description, '|',
                                                $linkage, '|application/vnd.ogc.wmc|application/vnd.ogc.wmc', '|', $tPosition)}"
						store="true" index="false" />
				</xsl:if>
				<!-- Try to detect OWS Context by checking protocol or file extension -->
				<xsl:if
					test="starts-with($protocol,'OGC:OWS-C') or contains($linkage,'.ows')">
					<Field name="link"
						string="{concat(dct:title, '|', dct:description, '|',
                                                $linkage, '|application/vnd.ogc.ows|application/vnd.ogc.ows', '|', $tPosition)}"
						store="true" index="false" />
				</xsl:if>
				<xsl:if test="$wmsLinkNoProtocol">
					<Field name="link"
						string="{concat(dct:title, '|', dct:description, '|',
                                                $linkage, '|OGC:WMS|application/vnd.ogc.wms_xml', '|', $tPosition)}"
						store="true" index="false" />
				</xsl:if>
			</xsl:for-each>
			<!-- This index for "coverage" requires significant expansion to work 
				well for spatial searches. It now only works for very strictly formatted 
				content -->
			<!-- TODO parse wkt string polygon with java -->
			<!-- <xsl:for-each select="dct:spatial"> <xsl:variable name="coverage" 
				select="."/> <xsl:choose> <xsl:when test="starts-with(., 'North')"> <xsl:variable 
				name="n" select="substring-after($coverage,'North ')"/> <xsl:variable name="north" 
				select="substring-before($n, ',')"/> <xsl:variable name="s" select="substring-after($coverage,'South 
				')"/> <xsl:variable name="south" select="substring-before($s, ',')"/> <xsl:variable 
				name="e" select="substring-after($coverage,'East ')"/> <xsl:variable name="east" 
				select="substring-before($e, ',')"/> <xsl:variable name="w" select="substring-after($coverage,'West 
				')"/> <xsl:variable name="west" select="if (contains($w, '. ')) then substring-before($w, 
				'. ') else $w"/> <xsl:variable name="p" select="substring-after($coverage,'(')"/> 
				<xsl:variable name="place" select="substring-before($p,')')"/> <Field name="westBL" 
				string="{$west}" store="false" index="true"/> <Field name="eastBL" string="{$east}" 
				store="false" index="true"/> <Field name="southBL" string="{$south}" store="false" 
				index="true"/> <Field name="northBL" string="{$north}" store="false" index="true"/> 
				<Field name="geoBox" string="{concat($west, '|', $south, '|', $east, '|', 
				$north )}" store="true" index="false"/> <Field name="keyword" string="{$place}" 
				store="true" index="true"/> </xsl:when> <xsl:otherwise> <Field name="keyword" 
				string="{.}" store="true" index="true"/> </xsl:otherwise> </xsl:choose> </xsl:for-each> -->
			<xsl:apply-templates select="dct:subject">
				<xsl:with-param name="name" select="'keyword'" />
				<xsl:with-param name="store" select="'true'" />
			</xsl:apply-templates>
			<xsl:apply-templates select="dcat:keyword">
				<xsl:with-param name="name" select="'keyword'" />
				<xsl:with-param name="store" select="'true'" />
			</xsl:apply-templates>
			<xsl:for-each select="dct:isPartOf">
				<Field name="parentUuid" string="{string(.)}" store="true"
					index="true" />
			</xsl:for-each>
			<!-- TODO when using this we get an error about the concat first parameter 
				<Field name="any" store="false" index="true"> <xsl:attribute name="string"> 
				<xsl:value-of select="normalize-space(string(dcat:Dataset))"/> <xsl:text> 
				</xsl:text> <xsl:for-each select="//*/@*"> <xsl:value-of select="concat(., 
				' ')"/> </xsl:for-each> </xsl:attribute> </Field> -->
			<!-- locally searchable fields -->
			<!-- defaults to true -->
			<Field name="digital" string="true" store="false" index="true" />
			<xsl:for-each select="dcat:contactPerson">
				<xsl:variable name="role" select="string($langCode)" />
				<Field name="responsibleParty" string="{concat($role, '|resource|', ., '|')}"
					store="true" index="false" />
			</xsl:for-each>
			<xsl:for-each select="dct:publisher/foaf:Agent/foaf:name">
				<xsl:variable name="role" select="string($langCode)" />
				<Field name="responsibleParty" string="{concat($role, '|metadata|', ., '|')}"
					store="true" index="false" />
			</xsl:for-each>
			<xsl:choose>
				<xsl:when test="dct:accrualPeriodicity">
					<xsl:for-each select="dct:accrualPeriodicity">
						<Field name="updateFrequency" string="{string(.)}" store="true"
							index="true" />
						<Field name="cl_maintenanceAndUpdateFrequency_text" string="string($langCode)"
							store="true" index="true" />
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<Field name="updateFrequency" string="unknown" store="true"
						index="true" />
					<Field name="cl_maintenanceAndUpdateFrequency_text" string="string($langCode)"
						store="true" index="true" />
				</xsl:otherwise>
			</xsl:choose>
		</Document>
	</xsl:template>
	<!-- {java:getCodelistTranslation('dcat:MD_MaintenanceFrequencyCode', string(.), 
		string($langCode))} -->
	<!-- ========================================================================================= -->
	<!-- text element, by default indexed, not stored, tokenized -->
	<xsl:template match="*">
		<xsl:param name="name" select="name(.)" />
		<xsl:param name="store" select="'false'" />
		<xsl:param name="index" select="'true'" />
		<Field name="{$name}" string="{string(.)}" store="{$store}"
			index="{$index}" />
	</xsl:template>
</xsl:stylesheet>
