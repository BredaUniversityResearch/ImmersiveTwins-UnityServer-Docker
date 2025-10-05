#!/bin/bash

f="/home/mpukgame/.config/unity3d/CradleBUas/AugGIS/docker_healthcheck.txt"
if [ ! -f "$f" ]; then
  echo "File docker_healthcheck.txt not found"
  exit 1
fi
if [ $(date +%s) -ge $(( $(stat -c %Y "$f") + 15 )) ]; then
  echo "File docker_healthcheck.txt is outdated"
  exit 1
fi
val=$(cat "$f")
if [ "$val" = "1" ]; then
  echo "Server is listening"
  exit 0
else
  echo "Server is busy (not listening)"
  exit 1
fi
