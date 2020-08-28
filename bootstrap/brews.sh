#!/usr/bin/env bash
set -eo pipefail

function prereq() {

    which -s brew && return 0
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

}

function install() {

    local input

    prereq
    
    brew update
    brew upgrade

    local brews=(
        asciinema
        autoconf
        automake
        awscli
        bash-completion
        coreutils
        curl
        figlet
        git
        git-flow
        git-lfs
        go
        jq
        kops
        kubernetes-cli
        kubernetes-helm
        lastpass-cli
        node
        openssl
        pwgen
        python
        r
        terraform
        thefuck
        tree
        watch
        wget
    )

	for brew in "${brews[@]}"; do
        echo "Install ${brew}? (Enter 'y' to install or any other key to skip)"
        read -s -n 1 input
        if [ $input == "y" ]; then
            echo Installing ${brew}...
            brew install ${brew}
        else
            echo Skipping ${brew}
        fi
	done

}

install