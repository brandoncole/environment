#!/usr/bin/env bash

function installHomebrew() {

	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew tap caskroom/cask

}

function installBrews() {

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
		git-lfs
		go
		jq
		kubernetes-cli
		openssl
		terraform
		tree
		watch
		wget
		zsh
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
		kindle
		lastpass
		licecap
		skype
		slack
		visual-studio-code
		webstorm
		zoom
	)

	for cask in "${casks[@]}"; do
		brew cask install $cask
	done

	# Open docker so that it sets itself up...
	open -g -a Docker

	# Complete lastpass installation...
	open -a "/usr/local/Caskroom/lastpass/latest/LastPass Installer.app"

	brew cleanup

}

function installDefaults() {

	sudo -v

	# -------------------------------------------------------------------------
	# Keyboard
	# -------------------------------------------------------------------------
	defaults write -g InitialKeyRepeat -int 15
	defaults write -g KeyRepeat -int 2

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

	# Finder: show status bar
	defaults write com.apple.finder ShowStatusBar -bool true

	# Finder: show path bar
	defaults write com.apple.finder ShowPathbar -bool true

	# -------------------------------------------------------------------------
	# iTerm2
	# -------------------------------------------------------------------------
	defaults write com.googlecode.iterm2 PromptOnQuit -int 0

}

function installDotfiles() {
	cp ./dotfiles/bash_profile.sh ~/.bash_profile && source ~/.bash_profile
}

function installOhMyZsh() {

	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

}

function installOhMyZshPlugins() {

    local zsh_plugins=${ZSH:-~/.oh-my-zsh}
	rm -rf $zsh_plugins/zsh-autosuggestions
	git clone git://github.com/zsh-users/zsh-autosuggestions $zsh_plugins/plugins/zsh-autosuggestions

	sed -i .bak 's/^plugins=(.*)$/plugins=(aws docker git kubectl web-search zsh-autosuggestions)/' ~/.zshrc

	sed -i .bak '/^.*# CUSTOM_EXTENSION/d' ~/.zshrc
    cat <<EOF >> ~/.zshrc
source ~/.bash_profile  # CUSTOM_EXTENSION
asp                     # CUSTOM_EXTENSION
EOF
}

function install() {

	installHomebrew
	installBrews
	installDefaults
	installDotfiles
	installOhMyZsh

}

function update() {
	installDefaults
	installDotfiles
	installOhMyZshPlugins
}

if [[ -z "$1" ]]; then
	install
else
	echo "Invoking $1"
	$1
fi
