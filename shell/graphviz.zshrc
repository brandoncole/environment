# e.g. gv_begin [digraph|graph] <file>
function gv_begin() {

    local kind=${1?Kind}
    local file=${2?Filename}
    local dir=$(dirname ${file})
    mkdir -p ${dir}
    export GV_FILE=${file}

    echo "${kind} G {" > ${GV_FILE}
    gv_emit_graph_attributes

}

function gv_emit_graph_attributes() {

    cat << EOF | gv_emit
node [shape=record,color="#333333",fontname="Menlo"];
nodesep=0.1
ranksep=0.1
rankdir=TB
edge [dir=none style=invisible]
EOF

}

# e.g. gv_emit <code>
# e.g. echo "<code>" | gv_emit
function gv_emit() {

    if [ -t 0 ]; then
        echo "${1}" >> ${GV_FILE}
    else
        </dev/stdin >> ${GV_FILE}
    fi

}

# e.g. gv_end
function gv_end() {

    echo "}" | gv_emit
    unset GV_FILE
}
