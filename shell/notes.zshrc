# e.g. <some command> | note
# e.g. <some command> | note alias
# e.g. note | grep -v text
# e.g. note alias | grep -v text
function note() {

    local name=${1:-default}
    local cache=/tmp/notes/${name}.txt

    if [ ! -d $(dirname $cache) ]; then
        mkdir -p $(dirname $cache)
    fi

    if [ -t 0 ]; then
        if [ -f ${cache} ]; then
            cat ${cache}
        fi
    else
        tee ${cache}
    fi
}
