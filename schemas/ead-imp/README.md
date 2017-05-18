# EAD-IMP Schema Plugin for GeoNetwork

The [schemas/ead-imp](/schemas/ead-imp) folder contains a [EAD-IMP](https://overheid.vlaanderen.be/informatiemanagement/informatiebeheersplan) schema plugin for [GeoNetwork](http://geonetwork-opensource.org/). 


## Features

* **XML Schema for EAD-IMP**: This plugin makes use of the fact that GeoNetwork is capable of storing metadata in any XML format. The plugin therefore defines its own XML Schema (see the [schema](/schemas/ead-imp/src/main/plugin/ead-imp/schema)) folder for EAD-IMP that is used for the internal representation of EAD-IMP fields. 
* **EAD-IMP input form**: A custom form was created following the guidance in the GeoNetwork [form customization guide](http://geonetwork-opensource.org/manuals/trunk/eng/users/customizing-application/editor-ui/creating-custom-editor.html). 


## Usage note 

To include this schema plugin in a build, copy the ead-imp schema folder in the 
schemas folder, add it to the schemas/pom.xml 
and add it to the copy-schemas execution in web/pom.xml.

Samples and templates can be imported via the 'Admin Console' > 'Metadata and Templates' > 'EAD-IMP' menu.

For further guidance on setting up a development environment/building Geonetwork/compiling user documentation/making a release see:
[Software Development Documentation](https://github.com/geonetwork/core-geonetwork/tree/develop/software_development)


## Future work

This plugin would merit further improvements in the following areas:
