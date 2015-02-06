#!/bin/bash

readonly PROJECT_NAME="PEObjc-Commons"
readonly SDK_VERSION="8.1"
readonly ARCH="i386" # 32-bit iPhone/iPad simulator
readonly CONFIGURATION="Debug"

oclint-runner.sh \
${PROJECT_NAME}.xcodeproj \
${PROJECT_NAME} \
iphonesimulator${SDK_VERSION} \
${CONFIGURATION} \
${ARCH}
