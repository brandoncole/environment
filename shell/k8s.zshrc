function k8s_delete_pods_restarted() {

    local namespace=${1?Namespace}
    local pod=${2?Pod name pattern}

    kubectl get pods -n ${namespace} |
        column -t |
        sort -k4 -n |
        grep ${pod} |
        awk '$4>0' |
        awk '{print $1}' |
        xargs kubectl delete pod -n ${namespace}
}

function k8s_ds_ready() {

    namespace=${1?Namespace}
    name=${2?Daemonset Name}

    details=$(kubectl get daemonset -n ${namespace} ${name} --no-headers)
    desired=$(echo $details | awk '{print $2}')
    uptodate=$(echo ${details} | awk '{print $5}')
    available=$(echo ${details} | awk '{print $6}')
    nodesNotReady=$(kubectl get nodes | grep NotReady | wc -l)

    echo ${available} of ${desired} available and ${uptodate} up-to-date
    if [[ $desired == $available ]] && [[ $updtodate == $available ]]; then
        return 0
    fi

    bestEffort=$(($nodesNotReady + $available))
    if [[ $desired == $bestEffort ]]; then
        echo ...${nodesNotReady} nodes not ready, so as ready as we can be.
        return 0
    fi

    return 1
}

# e.g. k8s_foreach_cluster <some_command>
function k8s_foreach_cluster() {

    for cluster in $(kubectl config get-contexts -o=name); do
        kubectl config use-context ${cluster} > /dev/null
        kubectl api-resources > /dev/null
        echo $* ${cluster}
    done

}

function k8s_namespaces_json() {
    kubectl get namespaces -o json
}

function k8s_endpoint() {
    local active=$(kubectl config current-context)
    local server=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"${active}\")].cluster.server}")
    echo $server
}

function k8s_accessible() {
    local json=$(curl -sSL -m 2 --insecure $(k8s_endpoint) 2> /dev/null)
    local version=$(echo ${json} | jq -r '.apiVersion // ""')
    if [ -n "${version}" ]; then
        return 0
    fi
    return 1
}

# e.g. k8s_use_context <name>
function k8s_use_context() {
    local name=${1?Name}
    if [ -f ~/.kube/config.lock ]; then
        echo "Remove the Kubeconfig lock? (Y/N)"
        read answer
        if [[ "${answer}" == "Y" ]]; then
            rm -f ~/.kube/config.lock
        fi
    fi
    kubectl config use-context ${name}
}

# e.g. k8s_size [<name>]
function k8s_size() {
    local nodes=$(kubectl get nodes --no-headers | wc -l)
    cat <<EOF
{
    "nodes": ${nodes}
}
EOF
}

# e.g. k8s_cached_size
function k8s_cached_size() {
    local cluster=$(kubectl config current-context)
    cached "k8s/${cluster}/size.json" k8s_size
}

# e.g. k8s_server_version
function k8s_server_version() {
    kubectl version  -o json | jq '.serverVersion'
}

# e.g. k8s_cached_server_version
function k8s_server_version_cached() {
    local cluster=$(kubectl config current-context)
    cached "k8s/${cluster}/version.json" k8s_server_version
}

# Estimates a birthdate based on the oldest discoverable resource
# e.g. k8s_birthdate
function k8s_birthdate() {
    kubectl get configmap -n kube-system -o json | jq '.items[].metadata.creationTimestamp' | sort | head -n1
}

# Estimates a birthdate based on the oldest discoverable resource
# e.g. k8s_birthdate
function k8s_birthdate_cached() {
    local cluster=$(kubectl config current-context)
    cached "k8s/${cluster}/birthdate.json" k8s_birthdate
}

# e.g. k8s_daemonset_labels <namespace> <name>
function k8s_daemonset_labels() {
    local namespace=${1?Namespace}
    local name=${2?Name}
    local json=$(kubectl get daemonset -n ${namespace} ${name} -o json 2>/dev/null | jq '.spec.template.metadata.labels')
    if [ -z ${json} ]; then
        return 1
    fi
    echo ${json}
}

# e.g. k8s_deployment_labels <namespace> <name>
function k8s_deployment_labels() {
    local namespace=${1?Namespace}
    local name=${2?Name}
    kubectl get deployment -n ${namespace} ${name} -o json 2>/dev/null  |
        jq '.spec.template.metadata.labels'
}

# e.g. k8s_can_i
function k8s_can_i() {
    kubectl auth can-i --list
}
