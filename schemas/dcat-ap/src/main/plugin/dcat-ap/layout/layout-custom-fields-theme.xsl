<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:dct="http://purl.org/dc/terms/" 
				xmlns:dcat="http://www.w3.org/ns/dcat#"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
				xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:xslutil="java:org.fao.geonet.util.XslUtil"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                version="2.0"
                exclude-result-prefixes="#all">


  <xsl:template mode="mode-dcat-ap" priority="2000" match="dcat:theme|dct:language">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="resource" select="normalize-space(skos:Concept/skos:inScheme/@rdf:resource)"/>
    <xsl:variable name="thesaurusTitle"><xsl:call-template name="get-dcat-ap-thesaurus-title"><xsl:with-param name="resource" select="$resource"/></xsl:call-template></xsl:variable>
    <xsl:variable name="attributes">
      <xsl:if test="$isEditing">
        <!-- Create form for all existing attribute (not in gn namespace)
        and all non existing attributes not already present. -->
        <xsl:apply-templates mode="render-for-field-for-attribute"
                             select="
          @*|
          gn:attribute[not(@name = parent::node()/@*/name())]">
          <xsl:with-param name="ref" select="gn:element/@ref"/>
          <xsl:with-param name="insertRef" select="gn:element/@ref"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>


    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label"
                      select="if ($thesaurusTitle)
                then $thesaurusTitle
                else gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', $xpath)/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
      <xsl:with-param name="subTreeSnippet">
        <xsl:apply-templates mode="mode-dcat-ap" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>


  <xsl:template mode="mode-dcat-ap" match="skos:Concept" priority="2000">


    <xsl:variable name="resource" select="normalize-space(skos:inScheme/@rdf:resource)"/>

    <xsl:variable name="thesaurusTitle"><xsl:call-template name="get-dcat-ap-thesaurus-title"><xsl:with-param name="resource" select="$resource"/></xsl:call-template></xsl:variable>

    <xsl:choose>
      <xsl:when test="$resource!=''">
	    <xsl:variable name="thesaurusConfig"
	                  as="element()?"
	                  select="$listOfThesaurus/thesaurus[starts-with(defaultNamespace,$resource)]"/>
	
        <!-- The thesaurus key may be contained in the MD_Identifier field or
          get it from the list of thesaurus based on its title.
          -->
	    <xsl:choose>
			<xsl:when test="$thesaurusConfig">
		        <xsl:variable name="thesaurusInternalKey"
		                      select="$thesaurusConfig/key"/>
		        <xsl:variable name="thesaurusKey"
		                      select="if (starts-with($thesaurusInternalKey, 'geonetwork.thesaurus.'))
		                      then substring-after($thesaurusInternalKey, 'geonetwork.thesaurus.')
		                      else $thesaurusInternalKey"/>
		
		        <!-- if gui lang eng > #EN -->
		        <xsl:variable name="guiLangId"
                      select="
                      if (count(skos:prefLabel[@xml:lang=lower-case(xslutil:twoCharLangCode($lang))]) = 1)
                        then $lang
                        else $metadataLanguage"/>
                 		        <!-- if gui lang eng > #EN -->
		        <xsl:message select="concat('===>lang (gui) = ',$lang)"/>
		        <xsl:message select="concat('===>guiLangId = ',$guiLangId)"/>
		        <xsl:variable name="prefLabelLangId" select="lower-case(xslutil:twoCharLangCode($guiLangId))"/>
		        <xsl:message select="concat('===>prefLabelLangId = ',$prefLabelLangId)"/>
		        <!--
		        get keyword in gui lang
		        in default language
		        -->
		        <xsl:variable name="keywords" select="string-join(replace(skos:prefLabel[@xml:lang=$prefLabelLangId], ',', ',,'), ',')"/>
		        <xsl:message select="concat('===>keywords = |',$keywords,'|')"/>
		
		        <!-- Define the list of transformation mode available. -->
		        <xsl:variable name="transformations"
		                      as="xs:string"
		                      select="if ($thesaurusConfig/@transformations != '')
		                              then $thesaurusConfig/@transformations
		                              else 'to-dcat-ap-concept'"/>
		
		        <!-- Get current transformation mode based on XML fragment analysis -->
		        <xsl:variable name="transformation"
		                      select="'to-dcat-ap-concept'"/>
		
		        <xsl:variable name="parentName" select="name(..)"/>
		
		        <!-- Create custom widget:
		              * '' for item selector,
		              * 'tagsinput' for tags
		              * 'tagsinput' and maxTags = 1 for only one tag
		              * 'multiplelist' for multiple selection list
		        -->
		        <xsl:variable name="widgetMode" select="'tagsinput'"/>
<!--		        <xsl:variable name="widgetMode" select="'multiplelist'"/>-->
		        <xsl:variable name="maxTags"
		                      as="xs:string"><xsl:choose><xsl:when test="$thesaurusKey = 'external.theme.data-theme'">1</xsl:when><xsl:otherwise><xsl:value-of select="if ($thesaurusConfig/@maxtags) then $thesaurusConfig/@maxtags else ''"/></xsl:otherwise></xsl:choose></xsl:variable>
		        <!--
		          Example: to restrict number of keyword to 1 for INSPIRE
		          <xsl:variable name="maxTags"
		          select="if ($thesaurusKey = 'external.theme.inspire-theme') then '1' else ''"/>
		        -->
		        <!-- Create a div with the directive configuration
		            * elementRef: the element ref to edit
		            * elementName: the element name
		            * thesaurusName: the thesaurus title to use
		            * thesaurusKey: the thesaurus identifier
		            * keywords: list of keywords in the element
		            * transformations: list of transformations
		            * transformation: current transformation
		          -->
		
		        <xsl:variable name="allLanguages"
		                      select="$metadataLanguage"></xsl:variable>
		        <div data-gn-keyword-selector="{$widgetMode}"
		             data-metadata-id="{$metadataId}"
		             data-element-ref="{concat('_X', ../gn:element/@ref, '_replace')}"
		             data-thesaurus-title="{$thesaurusTitle}"
		             data-thesaurus-key="{$thesaurusKey}"
		             data-keywords="{$keywords}" data-transformations="{$transformations}"
		             data-current-transformation="{$transformation}"
		             data-max-tags="{$maxTags}"
		             data-lang="{$metadataOtherLanguagesAsJson}"
		             data-textgroup-only="false">
		        </div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="mode-dcat-ap" select="*"/>
			</xsl:otherwise>
	    </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mode-dcat-ap" select="*"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="get-dcat-ap-thesaurus-title">
	<xsl:param name="resource"/>
	<xsl:choose>
		<xsl:when test="$resource = 'http://publications.europa.eu/resource/authority/data-theme'">
			<xsl:value-of select="'Theme thesaurus'"/>
		</xsl:when>
		<xsl:when test="$resource = 'http://publications.europa.eu/resource/authority/language'">
			<xsl:value-of select="'Language thesaurus'"/>
		</xsl:when>
		<xsl:otherwise>
	  		<xsl:value-of select="'Untitled thesaurus'"/>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

</xsl:stylesheet>
