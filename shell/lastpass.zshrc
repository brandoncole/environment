# Securely loads a password from LastPass and shows echoes it out
# e.g. load_pass <secretname>
function load_pass() {

    local item=$1
    local username=""

    if  ! lpass status --quiet; then
        echo "Enter LastPass Username: "
        read username
        lpass login $username || exit 1
    fi

    echo Loading $item from LastPass...
    local content=$(lpass show --notes "$item")
    if [[ ! "$content" == "" ]]; then
        eval "$content"
    fi

}
