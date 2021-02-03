# e.g. crons_on
function crons_on() {
    config=$(cat <<EOF
SHELL=/bin/bash
SHELL_ENV=${HOME}/.zshrc
0 * * * * bash -l ${BOOTSTRAP_HOME}/shell/cron-hourly.sh > ${BOOTSTRAP_HOME}/backups/hourly.log
EOF
)
    crontab <<< "${config}"
    crontab -l
}

# e.g. crons_off
function crons_off() {
    crontab -r
    crontab -l
}

# e.g. crons_run_hourly
function crons_run_hourly() {
    ${BOOTSTRAP_HOME}/shell/cron-hourly.sh
}
