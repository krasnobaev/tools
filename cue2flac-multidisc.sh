#!/bin/bash

for mix in *.cue; do
    echo "Processing: ${mix}"

    totaldiscs=`kid3-cli -c "get totaldiscs" "${mix%.cue}.flac"`
    if [[ -z "${totaldiscs}" ]]; then
        echo "Error: no totaldiscs in ID3 tags"
        exit 1
    else
        echo -e "\t totaldiscs=${totaldiscs}"
    fi

    # # read disc number with pattern
    # if [[ $mix =~ CD([0-9]+) ]]; then
    # # if [[ $mix =~ CD([0-9]+) ]]; then
    #     discnumber="${BASH_REMATCH[1]}"
    # else
    #     echo "Error: cannot determine disc number from cue file: $mix"
    #     exit 1
    # fi

    discnumber=`kid3-cli -c "get discnumber" "${mix%.cue}.flac"`
    if [[ -z "${discnumber}" ]]; then
        echo "Error: no discnumber in ID3 tags"
        exit 1
    else
        echo -e "\t discnumber=${discnumber}"
    fi

    discid=`kid3-cli -c "get discid" "${mix%.cue}.flac"`
    if [[ -z "${discid}" ]]; then
        echo "Error: no discid in flac file"
        exit 1
    else
        echo -e "\t discid=${discid}"
    fi

    shnsplit -o flac -f "$mix" "${mix%.cue}.flac"
    cuetag.sh "$mix" split-track*.flac

    for track in split-track*.flac; do
        kid3-cli -c "set discnumber ${discnumber}" -c "set totaldiscs ${totaldiscs}" "${track}"
        kid3-cli -c "set discid ${discid}" "${track}"

        mv "${track}" "${discnumber}-${track}"
        echo -e "\tready: ${discnumber}-${track}"
    done
done
