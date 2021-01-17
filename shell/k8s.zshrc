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
