#!/usr/bin/env bash

function install() {

    # Set up the scratch directory for temporary files...
    mkdir -p ./scratch

    local osname=`uname`
    if [[ "$osname" == "Darwin" ]]; then
       ./bootstrap-macOS.sh
    else
        echo "Bootstrapping $osname not supported."
    fi

}

install