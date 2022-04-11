#!/bin/bash

#
#   To create template, from ./fgun-labs:
#       - ./create-template.sh [lab*_to_template_project]
#
#   To use template, from ./fgun-labs:
#       - ./templates/[lab*_to_template_to_use]/boot.sh [lab*_to_new_flutter_project]
#

# Create new template folder + add lib and test template
mkdir ./templates/$1_template
cp -r ./$1/lib ./$1/test ./templates/$1_template

# find and replace arg dir with 
find ./templates/$1_template -type f -print0 | xargs -0 sed -i "s/$1/{REPLACEME}/g"

# Copy boot script to template folder + replace names
cp -r ./boot.sh ./templates/$1_template
find ./templates/$1_template/boot.sh -type f -print0 | xargs -0 sed -i "s/{EDITME}/$1/g"