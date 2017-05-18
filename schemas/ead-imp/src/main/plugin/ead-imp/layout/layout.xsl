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
		xmlns:ead="http://ead3.archivists.org/schema/"
  		xmlns:gn="http://www.fao.org/geonetwork"
		xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
		xmlns:gn-fn-ead-imp="http://geonetwork-opensource.org/xsl/functions/profiles/ead-imp"
		exclude-result-prefixes="#all">

  <xsl:include href="utility-fn.xsl"/>
  <xsl:include href="utility-tpl.xsl"/>
  <xsl:include href="layout-custom-fields.xsl"/>
  <xsl:include href="layout-custom-fields-date.xsl"/>
  <xsl:include href="layout-custom-tpl.xsl"/>  

  <!-- Ignore all gn element -->
  <xsl:template mode="mode-ead-imp"
                match="gn:*|@gn:*|@*"
                priority="1000"/>

  <!-- Template to display non existing element ie. geonet:child element
  of the metadocument. Display in editing mode only and if
  the editor mode is not flat mode. -->
  <xsl:template mode="mode-ead-imp" match="gn:child" priority="2000">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>


    <xsl:variable name="name" select="concat(@prefix, ':', @name)"/>
    <xsl:variable name="flatModeException"
                  select="gn-fn-metadata:isFieldFlatModeException($viewConfig, $name)"/>

    <!-- TODO: this should be common to all schemas -->
    <xsl:if test="$isEditing and
      (not($isFlatMode) or $flatModeException)">

      <xsl:variable name="directive"
                    select="gn-fn-metadata:getFieldAddDirective($editorConfig, $name)"/>

      <xsl:call-template name="render-element-to-add">
        <!-- TODO: add xpath and isoType to get label ? -->
        <xsl:with-param name="label"
                        select="gn-fn-metadata:getLabel($schema, $name, $labels, name(..), '', '')/label"/>
        <xsl:with-param name="directive" select="$directive"/>
        <xsl:with-param name="childEditInfo" select="."/>
        <xsl:with-param name="parentEditInfo" select="../gn:element"/>
        <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $name]) = 0"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-ead-imp" match="ead:*">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:apply-templates mode="mode-ead-imp" select="*|@*">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- 
    ... but not the one proposing the list of elements to add in DC schema
    
    Template to display non existing element ie. geonet:child element
    of the metadocument. Display in editing mode only and if 
  the editor mode is not flat mode. -->
  <xsl:template mode="mode-ead-imp" match="gn:child[contains(@name, 'CHOICE_ELEMENT')]"
    priority="3000">
    <xsl:if test="$isEditing and 
      not($isFlatMode)">

      <!-- Create a new configuration to only create
            a add action for non existing node. The add action for 
            the existing one is below the last element. -->
      <xsl:variable name="newElementConfig">
        <xsl:variable name="dcConfig"
          select="ancestor::node()/gn:child[contains(@name, 'CHOICE_ELEMENT')]"/>
        <xsl:variable name="existingElementNames" select="string-join(../descendant::*/name(), ',')"/>

        <gn:child>
          <xsl:copy-of select="$dcConfig/@*"/>
          <xsl:copy-of select="$dcConfig/gn:choose[not(contains($existingElementNames, @name))]"/>
        </gn:child>
      </xsl:variable>

      <xsl:call-template name="render-element-to-add">
        <xsl:with-param name="childEditInfo" select="$newElementConfig/gn:child"/>
        <xsl:with-param name="parentEditInfo" select="../gn:element"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- Hide from the editor the dct:references pointing to uploaded files -->
  <xsl:template mode="mode-ead-imp" priority="101"
                match="*[(name(.) = 'dct:references' or
                          name(.) = 'dc:relation') and
                         (starts-with(., 'http') or
                          contains(. , 'resources.get') or
                          contains(., 'file.disclaimer'))]" />


  <!-- the other elements in DC. -->
  <xsl:template mode="mode-ead-imp" priority="100" match="ead:*">
    <xsl:variable name="name" select="name(.)"/>
    <xsl:variable name="ref" select="gn:element/@ref"/>
    <xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, $name, $labels)"/>
    <xsl:variable name="helper" select="gn-fn-metadata:getHelper($labelConfig/helper, .)"/>

    <xsl:variable name="added" select="parent::node()/parent::node()/@gn:addedObj"/>
    <xsl:variable name="container" select="parent::node()/parent::node()"/>

    <!-- Add view and edit template-->
    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="$labelConfig/label"/>
      <xsl:with-param name="value" select="."/>
      <xsl:with-param name="cls" select="local-name()"/>
      <!--<xsl:with-param name="widget"/>
            <xsl:with-param name="widgetParams"/>-->
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <!--<xsl:with-param name="attributesSnippet" as="node()"/>-->
      <xsl:with-param name="type" select="gn-fn-metadata:getFieldType($editorConfig, name(), '')"/>
      <xsl:with-param name="name" select="if ($isEditing) then gn:element/@ref else ''"/>
      <xsl:with-param name="editInfo"
                      select="gn:element"/>
      <xsl:with-param name="parentEditInfo"
                      select="if ($added) then $container/gn:element else element()"/>
      <xsl:with-param name="listOfValues" select="$helper"/>
      <!-- When adding an element, the element container contains
      information about cardinality. -->
      <xsl:with-param name="isFirst"
                      select="if ($added) then
                      (($container/gn:element/@down = 'true' and not($container/gn:element/@up)) or
                      (not($container/gn:element/@down) and not($container/gn:element/@up)))
                      else
                      ((gn:element/@down = 'true' and not(gn:element/@up)) or
                      (not(gn:element/@down) and not(gn:element/@up)))"/>
    </xsl:call-template>

    <!-- Add a control to add this type of element
      if this element is the last element of its kind.
    -->
    <xsl:if
      test="$isEditing and 
            (
              not($isFlatMode) or
              gn-fn-metadata:isFieldFlatModeException($viewConfig, $name)
            ) and
            $service != 'md.element.add' and
            count(following-sibling::node()[name() = $name]) = 0">

      <!-- Create configuration to add action button for this element. -->
      <xsl:variable name="dcConfig"
        select="ancestor::node()/gn:child[contains(@name, 'CHOICE_ELEMENT')]"/>
      <xsl:variable name="newElementConfig">
        <gn:child>
          <xsl:copy-of select="$dcConfig/@*"/>
          <xsl:copy-of select="$dcConfig/gn:choose[@name = $name]"/>
        </gn:child>
      </xsl:variable>
      <xsl:call-template name="render-element-to-add">
        <xsl:with-param name="childEditInfo" select="$newElementConfig/gn:child"/>
        <xsl:with-param name="parentEditInfo" select="$dcConfig/parent::node()/gn:element"/>
        <xsl:with-param name="isFirst" select="false()"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- Readonly elements -->
  <xsl:template mode="mode-ead-imp" priority="200" match="ead:unitid">
    
    <xsl:call-template name="render-element">
      <xsl:with-param name="label" select="gn-fn-metadata:getLabel($schema, name(), $labels)/label"/>
      <xsl:with-param name="value" select="."/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="type" select="gn-fn-metadata:getFieldType($editorConfig, name(), '')"/>
      <xsl:with-param name="name" select="''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="isDisabled" select="true()"/>
    </xsl:call-template>
    
  </xsl:template>
  
  


  <!-- Boxed the root element -->
  <xsl:template mode="mode-ead-imp" priority="200" match="ead:archdesc">
    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label" select="gn-fn-metadata:getLabel($schema, name(.), $labels)/label"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="gn-fn-metadata:getXPath(.)"/>
      <xsl:with-param name="subTreeSnippet">
        <xsl:apply-templates mode="mode-ead-imp" select="*"/>
      </xsl:with-param>
      <xsl:with-param name="editInfo" select="gn:element"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
