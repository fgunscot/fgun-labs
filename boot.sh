#!/bin/sh

#
#   To use template, from ./fgun-labs:
#       - ./templates/[lab*_to_template_to_use]/boot.sh [lab*_to_new_flutter_project]
#

#create flutter project
flutter create -t skeleton $1

sudo rm -rf ./$1/lib ./$1/test
# copy over custom bootstrap
cp -R ./templates/{EDITME}_template/lib/ ./templates/{EDITME}_template/test/ ./$1

# find and replace package name
find ./$1/ -type f -print0 | xargs -0 sed -i "s/{REPLACEME}/$1/g"

# pub dependaces
cd ./$1
flutter pub add --dev mockito
flutter pub add --dev build_runner
flutter pub add --dev firebase_auth_mocks

flutter pub add firebase_core
flutter pub add firebase_auth