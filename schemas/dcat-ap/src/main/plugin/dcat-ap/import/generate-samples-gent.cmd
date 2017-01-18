@ECHO OFF
:: # This script is used to download DCT-AP rdf metadata from CKAN, normalise it into RDF, ... 
:: # Prerequisites: 
:: # 		* This script relies  on the Apache Jena command line SPARQL tool.
:: # 		* This script relies on the XALAN XSLT processor.

 :: Processing selected records for Gent uuidProcessing=GENERATEUUID
curl https://datatank.stad.gent/4/api/dcat > output\gent.ttl
FOR %%G IN (gentsefeestenlocaties,gentsefeestendata,bibliotheek,buurtsportlocaties,historischefilmvoorstellingen) DO (call :convertGent "%%G")
GOTO :eof

:convertGent
 SETLOCAL
 SET uuid =
 FOR /f %%H IN ('java -cp . GenerateUUID') DO (SET uuid=%%H)
 (ECHO SELECT ^* WHERE ^{ ^?subject ^?predicate ^?object. FILTER^(?subject = ^<https://datatank.stad.gent/4/cultuursportvrijetijd/%~1^>^)^}) > output\gent.sparql
 CALL sparql.bat --data output\gent.ttl --query output\gent.sparql  --results=XML  > output\%~1.rdf.xml
 java -cp "C:\Users\sgoedertier\Documents\Software\SaxonPE9-7-0-14J\*" net.sf.saxon.Transform -s:output\%~1.rdf.xml -xsl:rdf-to-xml.xsl -o:output\%~1.xml  uuid=%uuid%
 curl -X POST -u admin:psw4piloot --header "Accept: application/json" -F "file=@output\%~1.xml" -F "metadataType=METADATA" -F "uuidProcessing=OVERWRITE" -F "rejectIfInvalid=false" -F "transformWith=_none_" -F "assignToCatalog=false" -F "group=14951" "http://geonetwork30.gim.be/geonetwork/srv/api/0.1/records"
 ENDLOCAL
 GOTO :eof