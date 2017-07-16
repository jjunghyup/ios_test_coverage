#!/bin/sh

#  run_cov.sh
#
#  this program measure coverage for IOS Code
#  Not only Object-C but also Swift Language..
#  By Using Slather(Open Source : https://github.com/SlatherOrg/slather)
#
#

function install_coverage_program() {
    # install xcpretty
    xcpretty_str=$(gem list -i xcpretty)
    if [[ "$xcpretty_str" == false ]];then
        echo "xcpretty install..."
        gem install xcpretty
    fi

    # install slather
    slather_str=$(gem list -i slather)
    if [[ "$slather_str" == false ]];then
        echo "slather install..."
        gem install slather
    fi
}

function build_and_test() {
    echo "\033[1;32m=== Run Test Project($1), Scheme($2)  === \033[0m"

    xcodebuild clean build test \
        -project $1 \
        -scheme $2 \
        -destination "platform=iOS Simulator,name=iPhone 6,OS=10.2" \
        -configuration Debug \
        -enableCodeCoverage YES \
        | xcpretty -r junit -r html
}

function measure_coverage() {
    echo "\033[1;32m=== Test Coverage Report for $1  === \033[0m"

    BUILD_SETTINGS=$(xcodebuild \
        -project $1 \
        -scheme $2 \
        -destination "platform=iOS Simulator,name=iPhone 6,OS=10.2" \
        -configuration Debug \
        -showBuildSettings)

    PROJECT_TEMP_ROOT=$(echo "${BUILD_SETTINGS}" | grep -m1 PROJECT_TEMP_ROOT | cut -d= -f2 | xargs)

    PROFDATA=$(find ${PROJECT_TEMP_ROOT} -name "Coverage.profdata")

    BINARY=$(find ${PROJECT_TEMP_ROOT} -path "*$2.app/$2")

    # SKIP Detail Report
    # xcrun llvm-cov show -instr-profile ${PROFDATA} ${BINARY}

    xcrun llvm-cov report \
        -instr-profile ${PROFDATA} \
        ${BINARY}

    slather coverage  \
        --html \
        --cobertura-xml \
        --output-directory slather-report \
        --scheme $2 \
        $1
}

#Check Input Arguments
if [ -z "$1" ]; then
    echo "\033[0;36m=== No argument supplied, please check example  === \033[0m"
    echo "    example) sh run_cov.sh Foo.xcodeproj Foo"
else
    project="$1"
    scheme="$2"

    install_coverage_program
    build_and_test $project $scheme
    measure_coverage $project $scheme
fi
