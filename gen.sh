#!/bin/bash

class="$1"
name="$2"

basePath="/home/noah/Projects/Ruby/text-adventure/text"
itemPath="${basePath}/item"
areaPath="${basePath}/area"
personPath="${basePath}/person"
area_objectPath="${basePath}/area_object"

case "$class" in
	# item
	"item"|"i")
		touch "${itemPath}/${name}.rb"
	;;
	"area"|"a")
		touch "${areaPath}/${name}.rb"
	;;
	"person"|"p")
		touch "${personPath}/${name}.rb"
	;;
	"area_object"|"o"|"object"|"aobj")
		touch "${area_objectPath}/${name}.rb"
	;;
esac


