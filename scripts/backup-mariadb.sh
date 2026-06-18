#!/bin/bash
# Script de sauvegarde / restauration de la base WordPress (MariaDB)
# Usage: ./backup-mariadb.sh [restore] [fichier_backup.sql]
set -e

CONTAINER="wordpress_db"
DB_NAME="wordpress"
BACKUP_DIR="./docker/backups"
BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql"
LATEST="$BACKUP_DIR/backup_latest.sql"

backup() {
  echo "=== Backup MariaDB (WordPress) ==="
  mkdir -p "$BACKUP_DIR"
  docker exec "$CONTAINER" sh -c 'exec mysqldump -uroot -p"$MARIADB_ROOT_PASSWORD" '"$DB_NAME" > "$BACKUP_FILE"
  cp "$BACKUP_FILE" "$LATEST"
  echo "Backup cree   : $BACKUP_FILE"
  echo "Backup latest : $LATEST"
}

restore() {
  RESTORE_FILE=${1:-$LATEST}
  echo "=== Restauration MariaDB depuis $RESTORE_FILE ==="
  docker exec -i "$CONTAINER" sh -c 'exec mysql -uroot -p"$MARIADB_ROOT_PASSWORD" '"$DB_NAME" < "$RESTORE_FILE"
  echo "Restauration terminee"
  docker exec "$CONTAINER" sh -c 'exec mysql -uroot -p"$MARIADB_ROOT_PASSWORD" -e "SHOW TABLES;" '"$DB_NAME"
}

case "$1" in
  restore) restore "$2" ;;
  *) backup ;;
esac
