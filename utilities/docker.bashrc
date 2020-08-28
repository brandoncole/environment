#!/usr/bin/env bash

# e.g. docker_cleanup
function docker_cleanup() {
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')
    docker images -q --filter "dangling=true" | xargs docker rmi
}

# Purges all versions of an image by name
# e.g. docker_purge registry.com/imagename
function docker_delete_image() {

    local image=$1
    docker images | grep $image | awk {'print $3'} | xargs docker rmi

}
