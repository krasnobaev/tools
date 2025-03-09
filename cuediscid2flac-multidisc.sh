#!/bin/bash

totaldiscs=9

for cue in *.cue; do
    # read DISCID by reading row with pattern: DISCID ([0-9a-fA-Z]+)
    discid=`grep 'REM DISCID [A-Z0-9]*' "${cue}" | awk '{print $3}'`

    # read disc number with pattern
    if [[ $cue =~ Vol.([0-9]+) ]]; then
    # if [[ $cue =~ CD([0-9]+) ]]; then
    # if [[ $cue =~ disc ([0-9]+)" ]]; then
        discnumber="${BASH_REMATCH[1]}"
    else
        echo "Error: cannot determine disc number from cue file: $mix"
        exit 1
    fi

    # if discid not empty, write ID3 with kid3-cli tor $cue file but with flac extension in name
    if [[ -n "${discid}" ]]; then
        echo "${cue}: discid=${discid}"
        kid3-cli -c "set discid ${discid}" -c "set discnumber ${discnumber}" -c "set totaldiscs ${totaldiscs}" "${cue%.cue}.flac"
    else
        echo "Error: no discid in cue file"
        exit 1
    fi
done
