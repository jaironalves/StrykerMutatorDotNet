#!/bin/bash

_replace_delimiter() {
  local string="$1"
  echo "$string" | sed 's/ = /:/'
}

_replace_dots() {
  local string="$1"
  local replacement="$2"
  echo "$string" | awk -v rep="$replacement" 'BEGIN{FS=OFS=":"} {gsub(/\./,rep,$1); print}'
}

_yaml_to_properties() {
  local yaml_file="$1"
  yq -o p '... comments = ""' "$yaml_file"
}

_parse_properties() {
  local properties="$1"
    
  properties=$(_replace_delimiter "$properties")
  properties=$(_replace_dots "$properties" "_")

  echo "$properties"
}

_array_to_json() {
  local -n arr=$1
  local json="["
  for element in "${arr[@]}"
  do
    json+="\"$element\","
  done
  # remove the trailing comma
  json=${json%?}
  json+="]"
  echo "$json"
}

set -o nounset

_properties=$(yaml_to_properties "$YAMLPARSER_FILE_PATH")
echo $_properties
_parsed_properties=$(_parse_properties "${_properties}")

echo "$_parsed_properties"

# Split the string into an array
readarray -t content_array <<< "$_parsed_properties"

# Convert the array to a JSON array
array_json=$(_array_to_json content_array)
echo $array_json

