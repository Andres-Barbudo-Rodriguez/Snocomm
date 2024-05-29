#!/bin/zsh

# Ruta al archivo xcconfig
CONFIG_FILE="/DeploymentInfo.xcconfig"

# Ruta al proyecto Xcode
PROJECT_FILE="/.xcodeproj"

# Nombre del esquema y la configuración
SCHEME="Snocomm"
CONFIGURATION="Debug"

# Aplicar el archivo xcconfig al proyecto Xcode
xcodebuild -project "$PROJECT_FILE" -scheme "$SCHEME" -configuration "$CONFIGURATION" -xcconfig "$CONFIG_FILE"

