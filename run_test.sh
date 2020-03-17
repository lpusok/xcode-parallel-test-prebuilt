#!/usr/bin/env bash
set -euxo
# Save resource usage
STATS_PATH="$BITRISE_DEPLOY_DIR/stat.txt"

echo 'while [[ true ]] ; do 
    top -o cpu | head -18 >> '${STATS_PATH}'
    echo "\n-----------------------------------------------------\n" >> '${STATS_PATH}'
    sleep 30
done' > stats.sh

sh ./stats.sh &


# xcbeautify
brew tap thii/xcbeautify https://github.com/thii/xcbeautify.git
brew install xcbeautify


curl -X GET \
  -o "prebuilt.zip" \
 "https://storage.googleapis.com/firefox_ios_test_prebuilt/firefox_ios_prebuilt.zip"

unzip prebuilt.zip


set -euxo pipefail
env NSUnbufferedIO=YES \
xcodebuild test-without-building \
  -xctestrun ./Products/Fennec_Enterprise_XCUITests_iphonesimulator13.2-x86_64.xctestrun \
  -destination "platform=iOS Simulator,name=iPhone 8,OS=13.3" \
  -parallel-testing-worker-count $WORKERS \
  -derivedDataPath "build" | xcbeautify


