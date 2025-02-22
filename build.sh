#!/bin/bash
# build.sh - Run unit tests using xcodebuild

xcodebuild -scheme "coinApp" -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.1' test
