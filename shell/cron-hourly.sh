#!/bin/bash
set -eo pipefail

ENVIRONMENT_DIR=$(dirname $(dirname ${0}))

function backup() {

    BACKUPS_DIR=${ENVIRONMENT_DIR}/backups
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
    fi

}

backup
