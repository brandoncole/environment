#!/usr/bin/env bash

# Aliases
alias a=aws
alias g=gcloud
alias k=kubectl
alias dir="ls -la"

# Environment
export GOPATH=~/Workspace/go
mkdir -p $GOPATH
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Bash Settings
HISTFILESIZE=10000

# Functions
function update() {
    (cd ~/environment/ && ./bootstrap-macOS.sh update)
}