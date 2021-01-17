function helm_repo_charts() {
    local repo=${1?Repo is required}
    helm search repo ${repo}
}

function helm_chart_versions() {
    local chart=${1?Chart is required. e.g. repo/chart}
    helm search repo ${chart} -l
}
