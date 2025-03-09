#!/bin/bash

find . -name "*.cue" | while read -r cuefile; do
    dir=$(dirname "$cuefile")
    mixfile=$(basename "$cuefile")
    echo ""
    echo "cd into $dir"
    cd "$dir" || exit

    echo "Processing: ${mixfile}"
    totaldiscs=1
    discnumber=1

    discid=`kid3-cli -c "get discid" "${mixfile%.cue}.flac"`
    if [[ -z "${discid}" ]]; then
        echo "Error: no discid in flac file"
        exit 1
    else
        echo -e "\t discid=${discid}"
    fi

    shnsplit -o flac -f "$mixfile" "${mixfile%.cue}.flac"
    cuetag.sh "$mixfile" split-track*.flac

    for track in split-track*.flac; do
        kid3-cli -c "set discnumber ${discnumber}" -c "set totaldiscs ${totaldiscs}" "${track}"
        kid3-cli -c "set discid ${discid}" "${track}"
    done

    cd - || exit
done
