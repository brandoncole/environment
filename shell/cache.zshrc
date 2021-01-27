# e.g. cached <key> <generator>
function cached() {

    local key=${1?Key}
    local generator=${2:-}
    local file=$(cache_file ${key})

    if [ -f ${file} ]; then
        cat ${file}
    else
        if [ -z ${generator} ]; then
            return 1;
        fi
        mkdir -p $(dirname ${file})
        ${generator}| tee ${file}
    fi

}

# e.g. cache_exists <key>
function cache_exists() {

    local key=${1?Key}
    local file=$(cache_file ${key})

    if [ -f ${file} ]; then
        return 0
    fi

    return 1
}

# e.g. local file=$(cache_file <key>)
function cache_file() {
    echo ${BOOTSTRAP_HOME}/cache/${key}
}

# e.g. cache_clear <key>
function cache_clear() {

    local key=${1?Key}
    local file=$(cache_file ${key})

    mkdir -p $(dirname ${file})
    rm -f $(cache_file ${key})
}

# e.g. cache_update <key> <data> [<verify larger>]
function cache_update() {

    local key=${1?Key}
    local data=${2?Data}
    local verify=${3:-false}
    local file=$(cache_file ${key})

    if ! ${verify}; then
        echo "${data}" > ${file}
        return 0
    fi

    echo "${data}" > ${file}.bak

    local old_size=$(stat -c "%s" ${file})
    local new_size=$(stat -c "%s" ${file}.bak)
    if [ "${new_size}" -ge "${old_size}" ]; then
        mv ${file}.bak ${file}
        return 0
    fi

    echo "${file} not updated.  New Size: ${new_size} vs. Old Size: ${old_size}" 1>&2
    return 1
}

# e.g. cache_append <key> <data>
function cache_append() {

    local key=${1?Key}
    local data=${2?Data}
    local file=$(cache_file ${key})

    echo "${data}" >> ${file}
}
