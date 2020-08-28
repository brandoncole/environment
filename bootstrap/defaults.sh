#!/usr/bin/env bash
set -eo pipefail

function install() {

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

	# Finder: show dotfiles
	defaults write com.apple.finder AppleShowAllFiles -bool true

	# -------------------------------------------------------------------------
	# iTerm2
	# -------------------------------------------------------------------------
	defaults write com.googlecode.iterm2 PromptOnQuit -int 0

}

install