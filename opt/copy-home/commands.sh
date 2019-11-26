#!/bin/bash

set -euo pipefail

stubbed_cmds=(rm cp)

[[ ${TEST:-} = true ]] && {
    stub_prefix='echo '
    echo_prefix=': '
}

capitalise() {
    tr '[a-z]' '[A-Z]' <<< "$1"
}

for cmd in "${stubbed_cmds[@]}" ; do readonly "$(capitalise $cmd)=${stub_prefix:-}$cmd"; done

readonly ECHO="${echo_prefix:-}echo"
