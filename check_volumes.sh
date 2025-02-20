#!/bin/bash

# Путь к временному файлу для хранения метрик
METRICS_FILE="/tmp/docker_volume_metrics.prom"

# Очистка предыдущих метрик
> "$METRICS_FILE"

# Получение списка volume, содержащих "jupyter"
volumes=$(docker volume ls -q | grep jupyterhub-user)

# Перебор всех найденных volume
for volume in $volumes; do
  # Получение размера volume
  size=$(sudo du -sh $(docker volume inspect --format '{{ .Mountpoint }}' $volume) | awk '{print $1}')
  
  # Преобразование размера в байты (Prometheus работает только с числами)
  size_in_bytes=$(echo "$size" | awk '{
    if ($1 ~ /K/) {size = substr($1, 0, length($1)-1) * 1024}
    else if ($1 ~ /M/) {size = substr($1, 0, length($1)-1) * 1024 * 1024}
    else if ($1 ~ /G/) {size = substr($1, 0, length($1)-1) * 1024 * 1024 * 1024}
    else {size = $1 * 1024} # По умолчанию считаем, что это K
    print size
  }')

  # Формирование метрик Prometheus
  echo "docker_volume_size{volume=\"$volume\"} $size_in_bytes" >> "$METRICS_FILE"
done
