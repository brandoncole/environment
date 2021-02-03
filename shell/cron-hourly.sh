#!/bin/bash
set -eo pipefail

ENVIRONMENT_DIR=$(dirname $(dirname ${0}))
BACKUPS_DIR=${ENVIRONMENT_DIR}/backups

function backup() {


    OLD_BACKUP_ZIP=${BACKUPS_DIR}/$(gls -l ${BACKUPS_DIR} --sort=time --format=single-column | head -n1)
    NEW_BACKUP_ZIP=${BACKUPS_DIR}/$(date +%Y-%m-%d-%H-%M-%S.zip)

    zip -r -1 ${NEW_BACKUP_ZIP} ${ENVIRONMENT_DIR} -x "*/.git/*" "*/backups/*"

    OLD_SHA=$(shasum -a 256 ${OLD_BACKUP_ZIP} | awk '{print $1}')
    NEW_SHA=$(shasum -a 256 ${NEW_BACKUP_ZIP} | awk '{print $1}')

    echo ${OLD_BACKUP_ZIP}: ${OLD_SHA}
    echo ${NEW_BACKUP_ZIP}: ${NEW_SHA}

    if [[ "${OLD_SHA}" == "${NEW_SHA}" ]]; then
        echo No changes.  Removing ${NEW_BACKUP_ZIP}
        rm -f ${NEW_BACKUP_ZIP}
    else
        echo Changes detected, keeping new backup.
    fi

}

function rotate() {

    local max_logs=5
    gls ${BACKUPS_DIR}/*.log -t
    gls ${BACKUPS_DIR}/*.log -t | tail -n +${max_logs}
    gls ${BACKUPS_DIR}/*.log -t | tail -n +${max_logs} | xargs -I % echo will delete %

}

backup
rotate
