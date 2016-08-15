#!/bin/bash

resize=true
target_size=1920x1080
exposures=10
delay=60

delay_per_exposure="$(bc <<< "scale=2; $delay / $exposures")"
tmpdir="/dev/shm/timelapse"

mkdir -p "$tmpdir"
rm "$tmpdir/screenshot-exposure-"*".png" 2>/dev/null
echo "Combining $exposures exposures every $delay seconds ($delay_per_exposure seconds each)"
while true; do
  combined_file="screenshot-$(date +%s).png"
  echo -n "Combining $exposures exposures to produce $combined_file"
  for exposure in $(seq 1 $exposures); do
    sleep "$delay_per_exposure"
    targetfile="$tmpdir/$combined_file.part_$exposure.png"
    echo -n '.'
    if $resize; then
      nice ionice -c3 import -window root -resize "$target_size" "$targetfile"&
    else
      nice ionice -c3 import -window root "$targetfile"&
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
