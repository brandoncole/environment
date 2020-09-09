#!/usr/bin/env bash
set -eo pipefail

function prereq() {

}

function install() {

    local input

	prereq

	local casks=(
		1password-cli
		amazon-chime
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
            brew cask install ${cask}
        else
            echo Skipping ${cask}
        fi
	done

}

install