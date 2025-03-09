#!/bin/bash

find . -name "*.m4a" | while read -r track_path; do
    dir=$(dirname "${track_path}")
    track_file=$(basename "${track_path}")
    echo ""
    echo "converting ${track_file}, cd into ${dir}"

    pushd "./${dir}" || exit
    ffmpeg -i "${track_file}" -c:a flac "${track_file%.m4a}.flac"

    popd || exit
done
