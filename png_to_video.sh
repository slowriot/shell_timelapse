#!/bin/bash
# Converts the png images in the current directory into a youtube-friendly mp4 file

framerate=30

ffmpeg -r "$framerate" -pattern_type glob -i 'screenshot-*.png' -c:v libx264 output.mp4
