#! /usr/bin/env bash
set -e

readLine() {
    __maxDepth__="${MAXDEPTH-3}"
    __fileName__="${1}"
    sed -n '/^#\{1,'${__maxDepth__}'\}[^#]/p' "${__fileName__}"
}

setTitle() {
    __line__="${@}"
    printf '%s\n' "${__line__}" |
        sed 's/^#* //'
}

setAnchor() {
    __title__="${@}"
    printf '%s\n' "${__title__}" |
        tr ' ' '-'
}

setLevel() {
    __line__="${@}"
    printf '%s\n' "${__line__}" |
        grep -o '^#*' |
        wc -c
}

setIdent() {
    __level__="${@}"
    printf '%*s' $((__level__-2)) ''
}

setFormat() {
    __indent__="${1}"
    __title__="${2}"
    __anchor__="${3}"
    printf '%s\n' "${__indent__}- [${__title__}](#${__anchor__})"
}

main() {
    if [[ -z ${@} ]]; then
        printf '%s\n' "Required argument: mark down file path"
        exit 1
    fi

    while read -r line; do
        title=$(setTitle ${line})
        anchor=$(setAnchor ${title})
        level=$(setLevel ${line})
        ident=$(setIdent ${level})
        setFormat "${ident}" "${title}" "${anchor}"
    done <<< $(readLine "${@}")
}

main "${@}"
