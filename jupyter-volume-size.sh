#!/bin/bash

volumes=$(docker volume ls -q | grep jupyter)

for volume in $volumes; do
  size=$(sudo du -sh $(docker volume inspect --format '{{ .Mountpoint }}' $volume) | awk '{print $1}')
  echo "Volume: $volume, Size: $size"
done
