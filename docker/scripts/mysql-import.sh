#!/usr/bin/env bash
if [ -f "db-backups/$1" ]; then
  bash docker/scripts/message.sh info "Importing '$1' into '$3'..."
  zcat "db-backups/$1" | docker exec -i "$2" mysql -u root --password="$4" "$3"
  bash docker/scripts/message.sh info "Flushing privileges..."
  echo "FLUSH PRIVILEGES;" | docker exec -i "$2" mysql -u root --password="$4"
  bash docker/scripts/message.sh success "File '$1' was successfully imported into '$3'"
else
  bash ./.utils/message.sh info "File not found: 'db-backups/$1'"
fi
