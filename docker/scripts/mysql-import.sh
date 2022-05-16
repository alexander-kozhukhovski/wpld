#!/usr/bin/env bash

if [ -z "$4" ]; then
  bash docker/scripts/message.sh warning "Empty file name"
  return 2>/dev/null || exit 0
fi

if [ -f "db-backups/$4" ]; then
  bash docker/scripts/message.sh info "Importing '$4' into '$2'..."
  gunzip -c "db-backups/$4" | docker exec -i "$1" mysql -u root --password="$3" "$2"
  bash docker/scripts/message.sh info "Flushing privileges..."
  echo "FLUSH PRIVILEGES;" | docker exec -i "$1" mysql -u root --password="$3"
  bash docker/scripts/message.sh success "File '$4' was successfully imported into '$2'"
else
  bash docker/scripts/message.sh warning "File not found: 'db-backups/$4'"
fi
