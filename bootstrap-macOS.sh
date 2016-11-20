#!/usr/bin/env bash

function installXCode() {

    xcode-select --install

}

function installHomebrew() {

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap caskroom/cask

}

function installBrews() {

    brew update
    brew upgrade

    local brews=(
        autoconf
        automake
        awscli
        bash-completion
        coreutils
        curl
        git
        git-lfs
        go
        jq
        kubectl
        openssl
        tree
        watch
    )

    for brew in "${brews[@]}"; do
        brew install $brew
    done

    local casks=(
        docker
        google-chrome
        google-cloud-sdk
        google-drive
        iterm2
        licecap
        slack
        webstorm
    )

    for cask in "${casks[@]}"; do
        brew cask install $cask
    done

    brew cleanup

}

function installWebstormPlugins() {

    # https://plugins.jetbrains.com/
    local plugins=(
        https://plugins.jetbrains.com/files/4230/26121/BashSupport-1.5.8.162.zip
        https://github.com/ShyykoSerhiy/gfm-plugin/releases/download/v0.1.12/gfm-plugin.zip
        https://plugins.jetbrains.com/files/5047/30154/Go-0.13.1896.zip
    )

    # Figure out the websorm directory...
    local plugin_dir=$(find ~/Library/Application\ Support/ -type d -iname Webstorm* | tail -n 1)

    # Install all the plugins...
    for plugin in "${plugins[@]}"; do
        wget $plugin -O ./scratch/plugin.zip
        unzip -o ./scratch/plugin.zip -d "$plugin_dir"
    done

}

function install() {

    installXCode
    installHomebrew
    installBrews
    installWebstormPlugins

}

if [[ -z "$1" ]]; then
    install
else
    echo "Invoking $1"
    $1
fi