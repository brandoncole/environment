function v() {
    local host=${1?A vault host is required}
    export VAULT_ADDR=${host}
    vault status
}
