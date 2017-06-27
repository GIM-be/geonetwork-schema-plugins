<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:gml="http://www.opengis.net/gml" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:geonet="http://www.fao.org/geonetwork" version="2.0">
	<xsl:output method="xml" indent="yes" encoding="utf-8"/>
	<xsl:variable name="series" select="document(seriesfomexcel.xml)"/>
	<xsl:variable name="outputFolder">
		<xsl:call-template name="getOutputFolderPer50"/>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:comment>
		Voorbeeld van een informatiebeheersplan met individuele reeksen in eenzelfde document.
		</xsl:comment>
		<ead:ead xmlns:ead="http://ead3.archivists.org/schema/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" audience="external" lang="nl" script="Latn" relatedencoding="token" base="http://www.vlaanderen.be/" xsi:schemaLocation="http://ead3.archivists.org/schema/ ../../schema/ead3-imp.xsd">
			<ead:control audience="external" lang="nl" script="Latn" relatedencoding="token" langencoding="iso639-1" scriptencoding="iso15924" dateencoding="iso8601" countryencoding="iso3166-1" repositoryencoding="otherrepositoryencoding">
				<ead:recordid audience="external" lang="nl" script="Latn" instanceurl="http://www.vlaanderen.be/f2429644-6ba6-423d-9a39-fc2887670b48">f2429644-6ba6-423d-9a39-fc2887670b48</ead:recordid>
				<ead:filedesc audience="external" lang="nl" script="Latn">
					<ead:titlestmt audience="external" lang="nl" script="Latn">
						<ead:titleproper audience="external" lang="nl" script="Latn" localtype="token" render="boldsmcaps">Informatiebeheersplan: Agentschap Wegen en Verkeer (V01)</ead:titleproper>
					</ead:titlestmt>
				</ead:filedesc>
				<ead:maintenancestatus audience="external" lang="nl" script="Latn" value="new">aangemaakt</ead:maintenancestatus>
				<ead:maintenanceagency audience="external" lang="nl" script="Latn" countrycode="be">
					<ead:agencyname audience="external" lang="nl" script="Latn" localtype="token">Agentschap Wegen en Verkeer</ead:agencyname>
				</ead:maintenanceagency>
				<xsl:comment> Goedkeuringshistoriek informatiebeheersplan</xsl:comment>
				<ead:maintenancehistory audience="external" lang="nl" script="Latn">
					<ead:maintenanceevent audience="external" lang="nl" script="Latn">
						<ead:eventtype audience="external" lang="nl" script="Latn" value="created"/>
						<ead:eventdatetime audience="external" lang="nl" script="Latn" standarddatetime="2016-01-01"/>
						<ead:agenttype audience="external" lang="nl" script="Latn" value="human"/>
						<ead:agent audience="external" lang="nl" script="Latn"/>
					</ead:maintenanceevent>
				</ead:maintenancehistory>
			</ead:control>
			<ead:archdesc audience="external" lang="nl" script="Latn" localtype="token" relatedencoding="token" otherlevel="token" level="series">
				<ead:did audience="external" lang="nl" script="Latn">
					<!-- Identifier van de selectielijst -->
					<ead:unitid audience="external" lang="nl" script="Latn">Identifier van de selectielijst</ead:unitid>
					<!-- Titel van de selectielijst -->
					<ead:unittitle audience="external" lang="nl" script="Latn" localtype="token" label="titel">Titel van de selectielijst</ead:unittitle>
					<!--Datering van de selectielijst: Begin en eind datum -->
					<ead:unitdatestructured label="begin- en einddatum">
						<ead:daterange>
							<ead:fromdate standarddate="" lang="nl" script="Latn">Begin datum selectielijst</ead:fromdate>
							<ead:todate lang="nl" script="Latn">Einddatum van de selectielijst</ead:todate>
						</ead:daterange>
					</ead:unitdatestructured>
					<!-- Omschrijving van de selectielijst -->
						<ead:abstract audience="external" lang="nl" script="Latn" localtype="token" label="omschrijving">Abstract van de selectielijst</ead:abstract>
				</ead:did>
				<ead:dsc dsctype="analyticover">
					<xsl:for-each select="./Series/Serie">
						<ead:c level="series">
							<ead:did audience="external" lang="nl" script="Latn">
								<ead:unitid audience="external" lang="nl" script="Latn"><xsl:value-of select="./NAAM_en_INHOUD/ID"/></ead:unitid>
								<xsl:comment> Naam_informatieobject </xsl:comment>
								<ead:unittitle audience="external" lang="nl" script="Latn" localtype="token" label="titel"><xsl:value-of select="./NAAM_en_INHOUD/Naam_informatieobject"/></ead:unittitle>
								<xsl:comment>Datering: Begin en eind datum </xsl:comment>
								<ead:unitdatestructured label="begin- en einddatum">
									<ead:daterange>
										<ead:fromdate standarddate="" lang="nl" script="Latn"><xsl:value-of select="./Datering/Begindatum"/></ead:fromdate>
										<ead:todate lang="nl" script="Latn"><xsl:value-of select="./Datering/Einddatum"/></ead:todate>
									</ead:daterange>
								</ead:unitdatestructured>
								<xsl:comment> Omschrijving_informatieobject </xsl:comment>
								<xsl:variable name="abstract" select="tokenize(./NAAM_en_INHOUD/Omschrijving_informatieobject,'\+ ')"/>
								<ead:abstract audience="external" lang="nl" script="Latn" localtype="token" label="omschrijving"><xsl:if test="count($abstract)=1"><xsl:value-of select="$abstract[1]"/></xsl:if><xsl:if test="count($abstract)>1"><xsl:for-each select="$abstract"><xsl:value-of select="."/><ead:lb/></xsl:for-each></xsl:if></ead:abstract>
								<ead:origination>
									<ead:corpname>
										<ead:part lang="nl" script="Latn"><xsl:value-of select="./BEWAARNIVEAU/Bewaarniveau"/></ead:part>
									</ead:corpname>
								</ead:origination>
								<xsl:comment> Drager </xsl:comment>
								<ead:physdescstructured physdescstructuredtype="carrier" coverage="whole">
									<ead:quantity>Niet van toepassing</ead:quantity>
									<ead:unittype/>
									<xsl:comment> Voor EAD is dit een tekstveld. Geen controlled vocabularies. </xsl:comment>
									<ead:physfacet><xsl:value-of select="./DRAGER/Drager"/></ead:physfacet>
								</ead:physdescstructured>
								<xsl:comment> Extra info drager </xsl:comment>
								<ead:physdesc><xsl:value-of select="./DRAGER/Extra_info_drager"/></ead:physdesc>
							</ead:did>
							<ead:appraisal>
								<xsl:comment> Bewaarniveau </xsl:comment>
								<xsl:comment> Opmerking: hiermee wordt de organisatie bedoeld die verantwoordelijk is voor het bewaren het informatie-object. Een appraisal heeft eigenlijk een andere betekenis volgens EAD 'An element for documenting decisions and actions related to assessing the archival value and disposition of the materials being described. '.</xsl:comment>
								<ead:list>
									<ead:item lang="nl" script="Latn"><xsl:value-of select="./BEWAARNIVEAU/Bewaarniveau"/></ead:item>
								</ead:list>
								<ead:list>
									<xsl:comment> verantwoording_bestemming</xsl:comment>
									<ead:item lang="nl" script="Latn"><xsl:value-of select="./BESTEMMING/Verantwoording_bestemming"/></ead:item>
								</ead:list>
							</ead:appraisal>
							<ead:relations>
								<xsl:comment> Wettelijke bewaartermijn. </xsl:comment>
								<ead:relation relationtype="otherrelationtype" otherrelationtype="legalretentionschedule">
									<xsl:comment> ead:objectxmlwrap is de enige manier waarop EAD kan worden uitgebreid, zonder XML Schema validiteit te compromiteren. </xsl:comment>
									<ead:objectxmlwrap>
										<mr:DisposalSchedule xmlns:mr="http://moreq.info/files/export" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" SystemId="00000000-0000-0000-0000-000000000000" ExportedInFull="true">
											<mr:AccessControlList IncludeInheritedRoles="true"/>
											<mr:Created>2001-12-17T09:30:47Z</mr:Created>
											<mr:Originated>2001-12-17T09:30:47Z</mr:Originated>
											<mr:Title Lang="nl">Wettelijke bewaartermijnspecificatie: <xsl:value-of select="./Naam_informatieobject"/></mr:Title>
											<mr:Description Lang="nl"><xsl:value-of select="./WETTELIJKE_BEWAARTERMIJN/Verantwoording_bewaartermijn"/></mr:Description>
											<xsl:comment> Verantwoording bestemming </xsl:comment>
											<mr:ScopeNotes Lang="nl"><xsl:value-of select="./BESTEMMING/Verantwoording_bestemming"/></mr:ScopeNotes>												
											<xsl:comment> Bestemming </xsl:comment>
											<mr:DisposalAction><xsl:value-of select="./BESTEMMING/Bestemming"/></mr:DisposalAction>										
											<xsl:comment> Termijnspecificatie </xsl:comment>
											<mr:RetentionTrigger><xsl:value-of select="./WETTELIJKE_BEWAARTERMIJN/Termijnspecificatie"/></mr:RetentionTrigger>
											<xsl:comment> Tijdseenheid </xsl:comment>
											<mr:RetentionInterval><xsl:value-of select="./WETTELIJKE_BEWAARTERMIJN/Tijdseenheid"/></mr:RetentionInterval>
											<xsl:comment> Tijdswaarde </xsl:comment>
											<mr:RetentionIntervalDuration><xsl:value-of select="./WETTELIJKE_BEWAARTERMIJN/Waarde"/></mr:RetentionIntervalDuration>
										</mr:DisposalSchedule>
									</ead:objectxmlwrap>
								</ead:relation>
								<xsl:comment> Administratieve bewaartermijn. </xsl:comment>
								<ead:relation relationtype="otherrelationtype" otherrelationtype="adminretentionschedule">
									<xsl:comment> ead:objectxmlwrap is de enige manier waarop EAD kan worden uitgebreid, zonder XML Schema validiteit te compromiteren. </xsl:comment>
									<ead:objectxmlwrap>
										<mr:DisposalSchedule xmlns:mr="http://moreq.info/files/export" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" SystemId="00000000-0000-0000-0000-000000000000" ExportedInFull="true">
											<mr:AccessControlList IncludeInheritedRoles="true"/>
											<mr:Created>2001-12-17T09:30:47Z</mr:Created>
											<mr:Originated>2001-12-17T09:30:47Z</mr:Originated>
											<mr:Title Lang="nl">Administratieve bewaartermijnspecificatie: <xsl:value-of select="./Naam_informatieobject"/></mr:Title>
											<mr:Description Lang="nl"><xsl:value-of select="./ADMINISTRATIEVE_BEWAARTERMIJN/Verantwoording_bewaartermijn"/></mr:Description>
											<xsl:comment> Verantwoording bestemming </xsl:comment>
											<mr:ScopeNotes Lang="nl"><xsl:value-of select="./BESTEMMING/Verantwoording_bestemming"/></mr:ScopeNotes>														
											<xsl:comment> Bestemming </xsl:comment>
											<mr:DisposalAction><xsl:value-of select="./BESTEMMING/Bestemming"/></mr:DisposalAction>									
											<xsl:comment> Termijnspecificatie </xsl:comment>
											<mr:RetentionTrigger><xsl:value-of select="./ADMINISTRATIEVE_BEWAARTERMIJN/Termijnspecificatie"/></mr:RetentionTrigger>
											<xsl:comment> Tijdseenheid </xsl:comment>
											<mr:RetentionInterval><xsl:value-of select="./ADMINISTRATIEVE_BEWAARTERMIJN/Tijdseenheid"/></mr:RetentionInterval>
											<xsl:comment> Tijdswaarde </xsl:comment>
											<mr:RetentionIntervalDuration><xsl:value-of select="./ADMINISTRATIEVE_BEWAARTERMIJN/Waarde"/></mr:RetentionIntervalDuration>
										</mr:DisposalSchedule>
									</ead:objectxmlwrap>
								</ead:relation>
								<xsl:comment> raadplegingregime </xsl:comment>
								<ead:relation relationtype="otherrelationtype" otherrelationtype="transparencyclassification">
									<ead:objectxmlwrap>
										<dct:type xmlns:dct="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#">
											<skos:Concept rdf:about="uri-here">
												<skos:prefLabel xml:lang="nl"><xsl:value-of select="./RAADPLEGINGSREGIME/Raadplegingsregime"/></skos:prefLabel>
												<skos:inScheme rdf:resource="uri-here"/>
											</skos:Concept>
										</dct:type>
									</ead:objectxmlwrap>
								</ead:relation>
								<xsl:comment> Gevoelige_persoonsgegevens </xsl:comment>
								<ead:relation relationtype="otherrelationtype" otherrelationtype="personaldataclassification">
									<ead:objectxmlwrap>
										<dct:type xmlns:dct="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#">
											<skos:Concept rdf:about="uri-here">
												<skos:prefLabel xml:lang="nl"><xsl:value-of select="./PERSOONSGEGEVENS/Gevoelige_persoonsgegevens"/></skos:prefLabel>
												<skos:inScheme rdf:resource="uri-here"/>
											</skos:Concept>
										</dct:type>
									</ead:objectxmlwrap>
								</ead:relation>
								<xsl:comment> Hergebruik </xsl:comment>
								<ead:relation relationtype="otherrelationtype" otherrelationtype="reusepotentialclassification">
									<ead:objectxmlwrap>
										<dct:type xmlns:dct="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#">
											<skos:Concept rdf:about="uri-here">
												<skos:prefLabel xml:lang="nl"><xsl:value-of select="./HERGEBRUIK/Hergebruik"/></skos:prefLabel>
												<skos:inScheme rdf:resource="uri-here"/>
											</skos:Concept>
										</dct:type>
									</ead:objectxmlwrap>
								</ead:relation>
								<xsl:comment> parent </xsl:comment>
								<ead:relation relationtype="resourcerelation">
									<ead:relationentry/>
								</ead:relation>
								<xsl:comment> child </xsl:comment>
								<ead:relation relationtype="resourcerelation">
									<ead:relationentry localtype="child"/>
								</ead:relation>
								<xsl:comment> associatief </xsl:comment>
								<ead:relation relationtype="resourcerelation">
									<ead:relationentry localtype="association"/>
								</ead:relation>
								<xsl:comment> Taakgebied	Taak	Handeling1</xsl:comment>
								<ead:relation relationtype="functionrelation">
									<ead:objectxmlwrap>
										<dct:relation xmlns:dct="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#">
											<skos:Concept rdf:about="uri-here">
												<skos:prefLabel xml:lang="nl"><xsl:value-of select="./STRUCTUUR_PROCES/Taakgebied"/></skos:prefLabel>
												<skos:inScheme rdf:resource="uri-here"/>
											</skos:Concept>
										</dct:relation>
									</ead:objectxmlwrap>
								</ead:relation>
								<ead:relation relationtype="functionrelation">
									<ead:objectxmlwrap>
										<dct:relation xmlns:dct="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#">
											<skos:Concept rdf:about="uri-here">
												<skos:prefLabel xml:lang="nl"><xsl:value-of select="./STRUCTUUR_PROCES/Taak"/></skos:prefLabel>
												<skos:inScheme rdf:resource="uri-here"/>
											</skos:Concept>
										</dct:relation>
									</ead:objectxmlwrap>
								</ead:relation>
								<ead:relation relationtype="functionrelation">
									<ead:objectxmlwrap>
										<dct:relation xmlns:dct="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#">
											<skos:Concept rdf:about="uri-here">
												<skos:prefLabel xml:lang="nl"><xsl:value-of select="./STRUCTUUR_PROCES/Handeling1"/></skos:prefLabel>
												<skos:inScheme rdf:resource="uri-here"/>
											</skos:Concept>
										</dct:relation>
									</ead:objectxmlwrap>
								</ead:relation>
							</ead:relations>
						</ead:c>
					</xsl:for-each>
				</ead:dsc>
			</ead:archdesc>
		</ead:ead>
	</xsl:template>
	<xsl:variable name="filePerFolder">50</xsl:variable>
	<xsl:template name="getOutputFolderPer50">
		<xsl:variable name="index"><xsl:number/></xsl:variable>
		<xsl:variable name="startIndex" select="(floor(($index - 1) div $filePerFolder) * $filePerFolder)+1"/>
		<xsl:value-of select="concat($startIndex,'-', $startIndex + $filePerFolder - 1)"/>
	</xsl:template>
</xsl:stylesheet>