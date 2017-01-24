@ECHO OFF
:: # This script is used to download DCT-AP rdf metadata from CKAN, normalise it into RDF, ... 
:: # Prerequisites: 
:: # 		* This script relies  on the Apache Jena command line SPARQL tool.
:: # 		* This script relies on the XALAN XSLT processor.

:: all processing is done in an output folder
if not exist output\NUL mkdir output
:: Processing selected records from opendata.vlaanderen
(ECHO SELECT ^* WHERE ^{ ^?subject ^?predicate ^?object.^}) > output\vl.sparql
FOR %%G IN (6ab538f3-a8d7-4252-baed-de4eec15566d 605240ec-3121-424f-988e-bdd5f0eab218 afdeb9ae-0884-48e5-8cd3-92adb5717415 8929f2d8-5949-4db9-8157-42822ea2ad46 c6c01930-eb24-4360-9619-33590bb53b83) DO (call :convertVl "%%G")
GOTO :eof

:convertVl
 SETLOCAL
 SET uuid =
 FOR /f %%H IN ('java -cp . GenerateUUID') DO (SET uuid=%%H)
 curl http://opendata.vlaanderen.be/dataset/%~1.rdf > output\%~1.rdf
 CD output
 CALL sparql.bat --data %~1.rdf --query vl.sparql --results=XML  > %~1.sparql.xml
 CD ..
 java -cp "C:\Users\sgoedertier\Documents\Software\SaxonPE9-7-0-14J\*" net.sf.saxon.Transform -s:output\%~1.sparql.xml -xsl:rdf-to-xml.xsl -o:output\%~1.xml uuid=%uuid%
 curl -X POST -u admin:psw4piloot --header "Accept: application/json" -F "file=@output\%~1.xml" -F "metadataType=METADATA" -F "uuidProcessing=OVERWRITE" -F "rejectIfInvalid=false" -F "transformWith=_none_" -F "assignToCatalog=false" -F "group=2" "http://geonetwork30.gim.be/geonetwork/srv/api/0.1/records"
 ENDLOCAL
 GOTO :eof