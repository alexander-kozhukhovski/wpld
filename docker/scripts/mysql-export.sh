#!/usr/bin/env bash
file=db_
date=$(date '+%Y-%m-%d')
fileName="$file-$date"

if [[ -f "db-backups/$fileName.sql.gz" || -L "db-backups/$fileName.sql.gz" ]]; then
  i=0
  while [[ -f "db-backups/$fileName-$i.sql.gz" || -L "db-backups/$fileName-$i.sql.gz" ]]; do
    i++
  done
  fileName=$fileName-$i
fi

docker exec -i "$1" mysqldump -u root --password="$3" --single-transaction --events --databases "$2" --routines --comments | gzip >"db-backups/$fileName.sql.gz"
bash docker/scripts/message.sh success "Database '$2' was successfully exported into '$fileName' file."
