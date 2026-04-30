#!/bin/bash
# Script de sauvegarde PostgreSQL
# Usage: ./backup-postgres.sh [restore] [fichier_backup.sql]
set -e

CONTAINER="test_db"
DB_NAME="testdb"
DB_USER="admin"
BACKUP_DIR="./docker/backups"
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql"
LATEST="$BACKUP_DIR/backup_latest.sql"

backup() {
  echo "=== Backup PostgreSQL ==="
  mkdir -p $BACKUP_DIR
  docker exec $CONTAINER pg_dump -U $DB_USER $DB_NAME > $BACKUP_FILE
  cp $BACKUP_FILE $LATEST
  echo "Backup cree : $BACKUP_FILE"
  echo "Backup latest : $LATEST"
}

restore() {
  RESTORE_FILE=${1:-$LATEST}
  echo "=== Restauration PostgreSQL depuis $RESTORE_FILE ==="
  docker-compose down -v
  docker-compose up -d
  sleep 5
  Get-Content $RESTORE_FILE | docker exec -i $CONTAINER psql -U $DB_USER -d $DB_NAME
  echo "Restauration terminee"
  docker exec -it $CONTAINER psql -U $DB_USER -d $DB_NAME -c "SELECT COUNT(*) FROM utilisateurs;"
}

case "$1" in
  restore) restore "$2" ;;
  *) backup ;;
esac
