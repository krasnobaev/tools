#!/bin/bash

# cuetag.sh to tag all FLAC files in current directory with CUE files info

for set in *.cue; do
    flac="${cue%.cue}.flac"
    if [ -f "$flac" ]; then
        cuetag.sh "$set" "$flac"
    else
        echo "No matching FLAC for: $set"
    fi

    break
done
