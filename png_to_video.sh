#!/bin/bash
# Converts the png images in the current directory into a youtube-friendly mp4 file

framerate=30

ffmpeg -framerate "$framerate" \
  -pattern_type glob \
  -i 'screenshot-*.png' \
  -c:v libx264 \
  -profile:v high -crf 20 -pix_fmt yuv420p \
  output.mp4
