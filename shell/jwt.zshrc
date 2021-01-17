# e.g. echo <jwt> | jwt_decode
function jwt_decode() {
    jq -r -R 'split(".") |
        {
            "header":(.[0] | @base64d | fromjson),
            "payload":(.[1] | @base64d | fromjson)
        }'
}
