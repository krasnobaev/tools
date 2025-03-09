#!/bin/bash
until darkice -v 10 -c ~/.darkice.cfg; do
    echo "darkice dies with exit code $?.  Respawning.." >&2
    sleep 1
done
