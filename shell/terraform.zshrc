# eg. tf_find_values <path> <pattern> <value>
function tf_find_values() {

    local dir=${1?Directory}
    local file_pattern=${2?File pattern}
    local value_name=${3?Value}

    local regex_pattern="${value_name}\s*=\s*\"([^\"]+)"

    grep -r -o --include ${file_pattern} -E ${regex_pattern} ${dir}
}
