#!/usr/bin/env bash

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
        wget
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

    # Open docker so that it sets itself up...
    open -g -a Docker

    brew cleanup

}

function installPlugins() {

    # https://plugins.jetbrains.com/
    local plugins=(
        https://plugins.jetbrains.com/files/4230/28046/BashSupport-1.5.8.163.zip
        https://github.com/ShyykoSerhiy/gfm-plugin/releases/download/v0.1.12/gfm-plugin.zip
        https://plugins.jetbrains.com/files/5047/30154/Go-0.13.1896.zip
    )

    # Figure out the websorm directory.  This directory won't exist
    # until after WebStorm launches the first time so launch it in
    # the background.
    echo -n "Waiting for WebStorm to launch and initialize"
    open -g -a WebStorm
    local plugin_dir=""
    while [[ -z $plugin_dir ]]; do
        echo -n .
        sleep 1
        plugin_dir=$(find ~/Library/Application\ Support/ -type d -iname Webstorm* | tail -n 1)
    done
    echo "Done!  Found Plugin Directory: $plugin_dir"

    # Install all the plugins...
    for plugin in "${plugins[@]}"; do
        echo "Downloading $plugin..."
        wget $plugin -O ./scratch/plugin.zip
        unzip -o ./scratch/plugin.zip -d "$plugin_dir"
    done

    # Shut down WebStorm so that the new plugins will take effect
    ps x | grep webstorm | head -n 1 | awk '{print $1}' | xargs kill -9

}

function installDefaults() {

    sudo -v

    # -------------------------------------------------------------------------
    # Keyboard
    # -------------------------------------------------------------------------
    defaults write -g InitialKeyRepeat -int 10
    defaults write -g KeyRepeat -int 0

    # -------------------------------------------------------------------------
    # Trackpad
    # -------------------------------------------------------------------------
    defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1

    # -------------------------------------------------------------------------
    # Activity Monitor
    # -------------------------------------------------------------------------

    # Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

    # Visualize CPU usage in the Activity Monitor Dock icon
    defaults write com.apple.ActivityMonitor IconType -int 5

    # Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0

    # Sort Activity Monitor results by CPU usage
    defaults write com.apple.ActivityMonitor SortColumn -string "CPU"
    defaults write com.apple.ActivityMonitor SortDirection -int 0

    # -------------------------------------------------------------------------
    # Finder
    # -------------------------------------------------------------------------

    # Show all extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

}

function installDotfiles() {
    rsync -rv ./dotfiles/ ~/
}

function install() {

    installHomebrew
    installBrews
    installPlugins
    installDefaults
    installDotfiles

}

if [[ -z "$1" ]]; then
    install
else
    echo "Invoking $1"
    $1
fi
