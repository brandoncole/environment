#!/usr/bin/env bash

# Aliases
alias a=aws
alias g=gcloud
alias k=kubectl

# Environment
export GOPATH=~/Workspace/go
mkdir -p $GOPATH
export GOROOT=$(cd "$(dirname $(which go))/$(dirname $(readlink $(which go)))" && pwd)

# Functions
function update() {
    (cd ~/environment/ && ./bootstrap-macOS.sh update)
}