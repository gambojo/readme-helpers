#! /usr/bin/env bash

set -euo pipefail

readLine() {
    local __maxDepth__="${MAXDEPTH-3}"
    local __fileName__="${1}"
    sed -n '/^#\{1,'${__maxDepth__}'\}[^#]/p' "${__fileName__}"
}

setTitle() {
    local __line__="${@}"
    printf '%s\n' "${__line__}" |
        sed 's/^#* //'
}

setAnchor() {
    local __title__="${@}"
    printf '%s\n' "${__title__}" |
        tr ' ' '-'
}

setLevel() {
    local __line__="${@}"
    printf '%s\n' "${__line__}" |
        grep -o '^#*' |
        wc -c
}

setIdent() {
    local __level__="${@}"
    printf '%*s' $((__level__-2)) ''
}

setFormat() {
    local __indent__="${1}"
    local __title__="${2}"
    local __anchor__="${3}"
    printf '%s\n' "${__indent__}- [${__title__}](#${__anchor__})"
}

main() {
    if [[ -z ${1} ]]; then
        printf '%s\n' "Error! Required argument: mark down file path!"
        exit 1
    elif [[ ${#} -gt 1 ]]; then
        printf '%s\n' "Error! Requires 1 argument, ${#} arguments are received!"
        exit 1
    elif [[ ! -f ${1} ]]; then
        printf '%s\n' "Error! file ${1} is not exists!"
        exit 1
    elif [[ ! -s ${1} ]]; then
        printf '%s\n' "Error! file ${1} is empty!"
        exit 1
    elif ! grep "#" ${1} &>/dev/null; then
        printf '%s\n' "Error! No headers found!"
        exit 1
    else
        printf '%s\n' "Titles for ${1}:"
    fi

    while read -r line; do
        local title=$(setTitle ${line})
        local anchor=$(setAnchor ${title})
        local level=$(setLevel ${line})
        local ident=$(setIdent ${level})
        setFormat "${ident}" "${title}" "${anchor}"
    done <<< $(readLine "${1}")
}

main "${@}"
