ourpath=$_
BOOTSTRAP_HOME=$(realpath $(dirname $(dirname ${ourpath})))

for file in ${BOOTSTRAP_HOME}/shell/*.zshrc; do
    source ${file}
done

if [ -d ${BOOTSTRAP_HOME}/private ]; then
    for file in ${BOOTSTRAP_HOME}/private/**/*.zshrc; do
        source ${file}
    done
fi
