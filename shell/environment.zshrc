alias cdb="cd ${BOOTSTRAP_HOME}"

function edit() {
    code ${BOOTSTRAP_HOME}
}

function edit_aws() {
    code ~/.aws/config ~/.aws/credentials
}

function edit_zshrc() {
    code ~/.zshrc
}

function edit_cache() {
    code ~/.cache
}

function reload() {
    source ${BOOTSTRAP_HOME}/shell/.zshrc
}

function reload_zshrc() {
    source ~/.zshrc
}
