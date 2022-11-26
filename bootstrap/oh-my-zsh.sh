#!/usr/bin/env bash
ourpath=$_
set -euo pipefail


function prereq() {
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || return 0
}

function plugins() {

    local zsh_plugins=${ZSH:-~/.oh-my-zsh}
	rm -rf $zsh_plugins/zsh-autosuggestions
	if [ ! -d $zsh_plugins/plugins/zsh-autosuggestions ]; then
	    git clone https://github.com/zsh-users/zsh-autosuggestions --depth=1 $zsh_plugins/plugins/zsh-autosuggestions
	fi

    local plugins=(
        aws
        command-not-found
        docker
        fzf
        gcloud
        git
        golang
        kubectl
        terraform
        thefuck
        zsh-autosuggestions
    )
    local cmd='s/^plugins=(.*)$/plugins=('${plugins[@]}')/'
	sed -i .bak "${cmd}" ~/.zshrc

}

function zshrc() {

    rcfile=$(realpath $(dirname $(dirname ${ourpath}))/shell/.zshrc)
    if ! cat ~/.zshrc | grep -q $rcfile; then
        echo "Adding $rcfile to $(realpath ~/.zshrc)"
        echo "source $rcfile" >> ~/.zshrc
    fi

}

function install() {

	prereq
    plugins
    zshrc

}

install
