ourpath=$_
BOOTSTRAP_HOME=$(dirname $(dirname ${ourpath}))

for file in ${BOOTSTRAP_HOME}/shell/*.zshrc; do
    source ${file}
done

for file in ${BOOTSTRAP_HOME}/private/**/*.zshrc; do
    source ${file}
done

