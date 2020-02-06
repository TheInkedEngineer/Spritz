#!/bin/bash
set -e

# Install Homebrew dependency manager
if ! [[ -x "$(command -v brew)" ]]; then
    echo 'Homebrew is not installed.' >&2

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install XcodeGen to generate the xcodeproj.
if ! [[ -x "$(command -v xcodegen)" ]]; then
    echo 'XcodeGen is not installed.' >&2

    brew install xcodegen
fi

# remove present .xcodeproj
rm -rf *.xcodeproj

# run xcodegen to generate new file
xcodegen

# move config files to right place
cp Configurations/IDETemplateMacros.plist Spritz.xcodeproj/xcshareddata/IDETemplateMacros.plist

# if argument "open" passed, open the project
if [[ $1 == "open" ]]; then
    open Spritz.xcodeproj
fi
