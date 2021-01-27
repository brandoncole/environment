# e.g. crons_on
function crons_on() {
    config=$(cat <<EOF
SHELL=/bin/bash
SHELL_ENV=${HOME}/.zshrc
0,10,20,30,40,50 * * * * bash -l ${BOOTSTRAP_HOME}/shell/cron-hourly.sh >> ${BOOTSTRAP_HOME}/backups/hourly.log
EOF
)
    crontab <<< "${config}"
}

# e.g. crons_off
function crons_off() {
    echo todos
}

