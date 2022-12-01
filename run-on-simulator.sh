#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $CMDNAME [UDID] [target-runtime]"
    exit 1
fi

UDID=$1
target=$2

# Place swift-files
if [[ ! -d "./app" ]]; then
    mkdir -p app
    echo "print(\"Hello from main.swift\")" > ./app/main.swift
fi

bin_dir="bin"
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
bin="run-on-simulator"
src=`find app -name "*.swift"`
app_bundle="run-on-simulator.app/"
app_id=`xmllint --xpath '//key[text()="CFBundleIdentifier"]/following::string[1]/text()' ${script_dir}/Info.plist`

plutil -replace 'CFBundleIdentifier' -string "com.takuma.matsushita.run-on-simulator" ${script_dir}/Info.plist

if [[ `xcrun simctl list | grep "Booted"` != *${UDID}* ]]; then
    xcrun simctl boot ${UDID}
fi

mkdir -p ${bin_dir}
xcrun -sdk iphonesimulator swiftc -target ${target} ${src} -o ${bin_dir}/${bin}
mkdir -p ${app_bundle}
cp ${script_dir}/Info.plist ${bin_dir}/${bin} ${app_bundle}

xcrun simctl install ${UDID} ${app_bundle}
xcrun simctl launch --console ${UDID} ${app_id}
xcrun simctl uninstall ${UDID} ${app_id}

exit 0

