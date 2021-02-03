# e.g. new_uuid
function new_uuid() {
    uuidgen | tr '[:upper:]' '[:lower:]'
}
