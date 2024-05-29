#!/bin/zsh


CONFIG_FILE="/DeploymentInfo.xcconfig"
PROJECT_FILE="/.xcodeproj"
SCHEME="Snocomm"
CONFIGURATION="Debug"
xcodebuild -project "$PROJECT_FILE" -scheme "$SCHEME" -configuration "$CONFIGURATION" -xcconfig "$CONFIG_FILE"

