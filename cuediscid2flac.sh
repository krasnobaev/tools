#!/bin/bash

find . -name "*.cue" | while read -r cuefile; do
    dir=$(dirname "$cuefile")
    mixfile=$(basename "$cuefile")
    echo ""
    echo "cd into $dir"

    cd "$dir" || exit

    # read DISCID by reading row with pattern: DISCID ([0-9a-fA-Z]+)
    echo "searching for DISCID in $mixfile"
    discid=`grep 'REM DISCID [A-Z0-9]*' "${mixfile}" | awk '{print $3}'`

    # if discid not empty, write ID3 with kid3-cli tor $mixfile file but with flac extension in name
    if [[ -n "${discid}" ]]; then
        echo "${mixfile}: discid=${discid}"
        kid3-cli -c "set discid ${discid}" "${mixfile%.cue}.flac"
    else
        echo "Error: no discid in cue file"
        exit 1
    fi

    cd - || exit
done
