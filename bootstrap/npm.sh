#!/usr/bin/env bash
set -euo pipefail

function prereq() {

    which -s npm && return 0
    return 1

}

function install() {

    prereq

    local modules=(
        aws-cdk
        yarn
    )

	for module in "${modules[@]}"; do
        echo "Install ${module}? (Enter 'y' to install or any other key to skip)"
        read -s -n 1 input
        if [ $input == "y" ]; then
            echo Installing ${module}...
            npm install -g ${module}
        else
            echo Skipping ${module}
        fi
	done

}

install
