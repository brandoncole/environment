#!/usr/bin/env bash
set -eo pipefail

function prereq() {

    which code || {
        echo Enable command line access from VSCode by using ⇧⌘P and using \"Shell Command: Install 'code' command in PATH\"
        return 1
    }

}

function install() {

    prereq

    local exts=(
        golang.go
        hashicorp.terraform
        DavidAnson.vscode-markdownlint
        vscode-icons-team.vscode-icons
        AmazonWebServices.aws-toolkit-vscode
        ms-kubernetes-tools.vscode-kubernetes-tools
        seunlanlege.action-buttons
    )

	for ext in "${exts[@]}"; do
        code --install-extension ${ext}
	done

}

install