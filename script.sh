#!/bin/bash

# Environment variables
DB_TYPE=${DB_TYPE:-"postgres"}
DB_HOST=${DB_HOST:-"db"}
DB_PORT=${DB_PORT:-""}
DB_USER=${DB_USER:-"root"}
DB_PASSWORD=${DB_PASSWORD:-"password"}
DB_NAME=${DB_NAME:-"mydb"}

# Output directory for backups
BACKUP_DIR=/backup
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Export the password for tools that require it
export PGPASSWORD=$DB_PASSWORD

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

echo "Starting backup for $DB_TYPE database..."

case "$DB_TYPE" in
  postgres)
    # Set default port for PostgreSQL if not specified
    DB_PORT=${DB_PORT:-5432}
    echo "Backing up PostgreSQL database..."
    pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME > $BACKUP_DIR/pg_backup_$TIMESTAMP.sql
    ;;

  mysql|mariadb)
    # Set default port for MySQL/MariaDB if not specified
    DB_PORT=${DB_PORT:-3306}
    echo "Backing up MySQL/MariaDB database..."
    mysqldump -h $DB_HOST -P $DB_PORT -u $DB_USER --password=$DB_PASSWORD $DB_NAME > $BACKUP_DIR/mysql_backup_$TIMESTAMP.sql
    ;;

  mongo)
    # Set default port for MongoDB if not specified
    DB_PORT=${DB_PORT:-27017}
    echo "Backing up MongoDB database..."
    mongodump --host $DB_HOST --port $DB_PORT --username $DB_USER --password $DB_PASSWORD --db $DB_NAME --out $BACKUP_DIR/mongo_backup_$TIMESTAMP
    ;;

  *)
    echo "Unsupported database type: $DB_TYPE"
    exit 1
    ;;
esac

echo "Backup completed for $DB_TYPE database at $TIMESTAMP"

# Cleanup old backups (optional: keep last 7 backups)
find $BACKUP_DIR -type f -mtime +30 -exec rm -f {} \;

exit 0
