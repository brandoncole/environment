#!/usr/bin/env bash
set -euo pipefail

function prereq() {
    which -s brew && return 0

    # Automatically install brew...
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

}

function install() {

    local input

	prereq

	local casks=(
		1password-cli
		amazon-chime
		aws-vault
		docker
		docker-toolbox
		dotnet
		dotnet-sdk
		google-chrome
		google-cloud-sdk
		iterm2
		lastpass
		licecap
		minikube
		pgadmin4
		rstudio
		skype
		slack
		visual-studio-code
		zoomus
	)

	for cask in "${casks[@]}"; do
        echo "Install ${cask}? (Enter 'y' to install or any other key to skip)"
        read -s -n 1 input
        if [ $input == "y" ]; then
            echo Installing ${cask}...
            brew install --cask ${cask}
        else
            echo Skipping ${cask}
        fi
	done

}

install
