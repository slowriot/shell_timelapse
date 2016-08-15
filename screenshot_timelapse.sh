#!/bin/bash

resize=true
target_size=1920x1080
exposures=10
delay=60
idle_limit=120
idle_check_delay=10

delay_per_exposure="$(bc <<< "scale=2; $delay / $exposures")"
tmpdir="/dev/shm/timelapse"

mkdir -p "$tmpdir"
rm "$tmpdir/screenshot-exposure-"*".png" 2>/dev/null
echo "Combining $exposures exposures every $delay seconds ($delay_per_exposure seconds each)"
while true; do
  idle_time="$(xprintidle)"
  idle_time_seconds=$((idle_time / 1000))
  if [ "$idle_time_seconds" -gt "$idle_limit" ]; then
    echo "User is idle for $idle_time_seconds seconds, waiting until they return before continuing"
    while [ "$idle_time_seconds" -gt "$idle_limit" ]; do
      sleep "$idle_check_delay";
      idle_time="$(xprintidle)"
      idle_time_seconds=$((idle_time / 1000))
    done
  fi
  combined_file="screenshot-$(date +%s).png"
  echo -n "Combining $exposures exposures to produce $combined_file"
  for exposure in $(seq 1 $exposures); do
    sleep "$delay_per_exposure"
    targetfile="$tmpdir/$combined_file.part_$exposure.png"
    echo -n '.'
    if $resize; then
      nice ionice -c3 import -silent -window root -resize "$target_size" "$targetfile"&
    else
      nice ionice -c3 import -silent -window root "$targetfile"&
    fi
  done
  echo
  combined_file_list="$tmpdir/$combined_file.part_"*".png"
  (
    nice ionice -c3 \
    convert $combined_file_list -average "$combined_file" && \
    rm $combined_file_list
  )&
done
