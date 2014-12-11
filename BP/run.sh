#!/bin/bash

# Get time as a UNIX timestamp (seconds elapsed since Jan 1, 1970 0:00 UTC)
T="$(date +%s)"

/usr/bin/pig $1

T="$(($(date +%s)-T))"
echo "Time in seconds: ${T}"

printf "ElapsedTime: %02d:%02d:%02d:%02d\n" "$((T/86400))" "$((T/3600%24))" "$((T/60%60))" "$((T%60))"

