<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:sr="http://www.w3.org/2005/sparql-results#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:adms="http://www.w3.org/ns/adms#" xmlns:dct="http://purl.org/dc/terms/" xmlns:dcat="http://www.w3.org/ns/dcat#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:spdx="http://spdx.org/rdf/terms#" xmlns:vcard="http://www.w3.org/2006/vcard/ns#" xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:saxon="http://saxon.sf.net/" xmlns:fn-rdf="http://geonetwork-opensource.org/xsl/functions/rdf" version="2.0" extension-element-prefixes="saxon">
	<!-- Tell the XSL processor to output XML. -->
	<xsl:output method="xml" indent="yes"/>
	<!-- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="../schema.xsd" -->
	<!-- dcat:Catalog -->
	<xsl:template match="/">
		<xsl:variable name="results" select="/sr:sparql/sr:results/sr:result"/>
		<xsl:variable name="catalogs" select="$results[sr:binding[@name='predicate']/sr:uri = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' and
																		sr:binding[@name='object']/sr:uri = 'http://www.w3.org/ns/dcat#Catalog']"/>
		<xsl:for-each select="$catalogs">
			<xsl:variable name="catalogURI" select="./sr:binding[@name='subject']/sr:uri"/>
			<dcat:Catalog rdf:about="{$catalogURI}">
				<!-- dct:title -->
				<xsl:call-template name="properties">
					<xsl:with-param name="results" select="$results"/>
					<xsl:with-param name="subject" select="$catalogURI"/>
					<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:title')"/>
				</xsl:call-template>
				<!-- dct:description -->
				<xsl:call-template name="properties">
					<xsl:with-param name="results" select="$results"/>
					<xsl:with-param name="subject" select="$catalogURI"/>
					<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:description')"/>
				</xsl:call-template>
				<!-- dct:publisher -->
				<xsl:call-template name="properties">
					<xsl:with-param name="results" select="$results"/>
					<xsl:with-param name="subject" select="$catalogURI"/>
					<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:publisher')"/>
				</xsl:call-template>
				<!-- dcat:dataset -->
				<dcat:dataset>
					<xsl:call-template name="datasets">
						<xsl:with-param name="results" select="$results"/>
						<xsl:with-param name="datasetURIs" select="$results[sr:binding[@name='predicate']/sr:uri = 'http://www.w3.org/ns/dcat#dataset' and
											sr:binding[@name='subject']/sr:uri = $catalogURI]/sr:binding[@name='object']/sr:uri"/>
					</xsl:call-template>
				</dcat:dataset>
			</dcat:Catalog>
		</xsl:for-each>
		<xsl:if test="fn:count($catalogs) = 0">
			<!-- dcat:dataset -->
			<xsl:call-template name="datasets">
				<xsl:with-param name="results" select="$results"/>
				<xsl:with-param name="datasetURIs" select="$results[sr:binding[@name='predicate']/sr:uri = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' and
																					  sr:binding[@name='object']/sr:uri = 'http://www.w3.org/ns/dcat#Dataset']/sr:binding[@name='subject']/sr:uri"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<!-- dcat:Dataset -->
	<xsl:template name="datasets">
		<xsl:param name="results"/>
		<xsl:param name="datasetURIs"/>
		<!-- for each dataset -->
		<xsl:for-each select="$datasetURIs">
			<dcat:Dataset rdf:about="{.}">
				<!-- dct:title -->
				<xsl:call-template name="properties">
					<xsl:with-param name="results" select="$results"/>
					<xsl:with-param name="subject" select="."/>
					<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:title')"/>
				</xsl:call-template>
				<!-- dct:description -->
				<xsl:call-template name="properties">
					<xsl:with-param name="results" select="$results"/>
					<xsl:with-param name="subject" select="."/>
					<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:description')"/>
				</xsl:call-template>
				<!-- dct:publisher -->
				<xsl:call-template name="properties">
					<xsl:with-param name="results" select="$results"/>
					<xsl:with-param name="subject" select="."/>
					<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:publisher')"/>
				</xsl:call-template>
				<!-- dcat:distribution -->
				<xsl:call-template name="distributions">
					<xsl:with-param name="results" select="$results"/>
					<xsl:with-param name="datasetURI" select="."/>
				</xsl:call-template>
			</dcat:Dataset>
		</xsl:for-each>
	</xsl:template>
	<!-- dct:Agent -->
	<xsl:template name="publishers">
		<xsl:param name="results"/>
		<xsl:param name="datasetURI"/>
		<dcat:distribution>
			<!-- for each publisher -->
			<xsl:for-each select="$results[sr:binding[@name='predicate']/sr:uri = 'http://www.w3.org/ns/dcat#distribution' and
											sr:binding[@name='subject']/sr:uri = $datasetURI]">
				<xsl:variable name="distributiontURI" select="./sr:binding[@name='object']/sr:uri"/>
				<dcat:Distribution rdf:about="{$distributiontURI}">
					<!-- dcat:accessURL -->
					<xsl:call-template name="properties">
						<xsl:with-param name="results" select="$results"/>
						<xsl:with-param name="subject" select="$distributiontURI"/>
						<xsl:with-param name="predicate" select="fn:QName('http://www.w3.org/ns/dcat#','dcat:accessURL')"/>
					</xsl:call-template>
					<!-- dct:title -->
					<xsl:call-template name="properties">
						<xsl:with-param name="results" select="$results"/>
						<xsl:with-param name="subject" select="$distributiontURI"/>
						<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:title')"/>
					</xsl:call-template>
					<!-- dct:description -->
					<xsl:call-template name="properties">
						<xsl:with-param name="results" select="$results"/>
						<xsl:with-param name="subject" select="$distributiontURI"/>
						<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:description')"/>
					</xsl:call-template>
				</dcat:Distribution>
			</xsl:for-each>
		</dcat:distribution>
	</xsl:template>
	<!-- dct:Publisher -->
	<xsl:template name="distributions">
		<xsl:param name="results"/>
		<xsl:param name="datasetURI"/>
		<dcat:distribution>
			<!-- for each distribution 'http://purl.org/dc/terms/title',fn:QName('http://purl.org/dc/terms/','dct:title')) -->
			<xsl:for-each select="$results[sr:binding[@name='predicate']/sr:uri = 'http://www.w3.org/ns/dcat#distribution' and
											sr:binding[@name='subject']/sr:uri = $datasetURI]">
				<xsl:variable name="distributiontURI" select="./sr:binding[@name='object']/sr:uri"/>
				<dcat:Distribution rdf:about="{$distributiontURI}">
					<!-- dcat:accessURL -->
					<xsl:call-template name="properties">
						<xsl:with-param name="results" select="$results"/>
						<xsl:with-param name="subject" select="$distributiontURI"/>
						<xsl:with-param name="predicate" select="fn:QName('http://www.w3.org/ns/dcat#','dcat:accessURL')"/>
					</xsl:call-template>
					<!-- dct:title -->
					<xsl:call-template name="properties">
						<xsl:with-param name="results" select="$results"/>
						<xsl:with-param name="subject" select="$distributiontURI"/>
						<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:title')"/>
					</xsl:call-template>
					<!-- dct:description -->
					<xsl:call-template name="properties">
						<xsl:with-param name="results" select="$results"/>
						<xsl:with-param name="subject" select="$distributiontURI"/>
						<xsl:with-param name="predicate" select="fn:QName('http://purl.org/dc/terms/','dct:description')"/>
					</xsl:call-template>
				</dcat:Distribution>
			</xsl:for-each>
		</dcat:distribution>
	</xsl:template>	
	<!-- simple properties -->
	<xsl:template name="properties">
		<xsl:param name="results"/>
		<xsl:param name="subject"/>
		<xsl:param name="predicate"/>
		<xsl:variable name="predicateString" select="concat(fn:namespace-uri-from-QName($predicate),fn:local-name-from-QName($predicate))"/>
		<!-- Select all objects matching the subject and predicate pattern -->
		<xsl:for-each select="$results[sr:binding[@name='subject']/sr:uri = $subject and
											sr:binding[@name='predicate']/sr:uri = $predicateString]/sr:binding[@name='object']">
			<xsl:choose>
				<xsl:when test="./sr:literal">
					<xsl:element name="{$predicate}">
						<xsl:value-of select="./sr:literal"/>
					</xsl:element>
				</xsl:when>
				<xsl:when test="./sr:uri">
					<xsl:element name="{$predicate}">
						<xsl:attribute name="rdf:resource" select="./sr:uri"/>
					</xsl:element>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
