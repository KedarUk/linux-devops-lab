OURCE_DIR="examples"
BACKUP_DIR="backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/examples_backup_${TIMESTAMP}.tar.gz"

echo "=================================="
echo "         BACKUP SCRIPT"
echo "=================================="

if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory not found: $SOURCE_DIR"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

if [ $? -eq 0 ]; then
    echo
    echo "Backup created successfully!"
    echo "Backup file: $BACKUP_FILE"
else
    echo
    echo "ERROR: Backup failed!"
    exit 1
fi

echo
echo "Backup Details:"
ls -lh "$BACKUP_FILE"

echo
echo "=================================="
echo "       BACKUP COMPLETED"
echo "=================================="
