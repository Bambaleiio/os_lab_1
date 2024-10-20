#!/bin/bash

check_directory() {
    if [ ! -d "$1" ]; then
        echo "$1 doesn't exist"
        exit 1
    fi
}

# check if main directory and log directory exist
check_directory "$1"
check_directory "$1/LOG"

DIR_SIZE=$(du -s "$1" | awk '{print $1}')
LOG_SIZE=$(du -s "$1/LOG" | awk '{print $1}')

echo "LOG_SIZE: $LOG_SIZE"
echo "DIR_SIZE: $DIR_SIZE"

# Calculate percentage and handle division by zero
if [ "$DIR_SIZE" -ne 0 ]; then
    LOG_USAGE=$(echo "scale=2; $LOG_SIZE / $DIR_SIZE * 100" | bc -l)
    echo "LOG directory size as a percentage of the main directory: $LOG_USAGE%"
else
    echo "Main directory size is zero, cannot calculate percentage."
fi

# Default value for THRESHOLD
THRESHOLD=70

# Parse command-line arguments
for arg in "$@"; do
    case $arg in
        -thresh=*)
        THRESHOLD="${arg#*=}"
        shift
        ;;
        *)
        # Unknown option
        ;;
    esac
done


# Setting the number of recent files to archive
FILE_COUNT=5

# Check if the usage exceeds the specified threshold
if (( $(echo "$LOG_USAGE>$THRESHOLD" | bc -l) )); then
    echo "The usage of /LOG is $LOG_USAGE%, archiving the last $FILE_COUNT files..."

    # Archiving the N latest files by modification date
    # create /BACKUP directory if not already exists
    if [ $FILE_COUNT -gt 0 ]; then
        mkdir "$1/BACKUP"
    fi

    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    # Get the newest files (sorted by modification time, descending) and select the first $FILE_COUNT
    FILES_TO_ARCHIVE=$(ls -lt "$1"/LOG | grep '^-' | head -n "$FILE_COUNT" | awk '{print $9}')

    # Archive the selected files with full paths
    for file in $FILES_TO_ARCHIVE; do
        tar -rvf "$1"/BACKUP/log_backup_"$TIMESTAMP".tar -C "$1"/LOG "$file"
    done

    # Compress the tar file into .tar.gz
    gzip "$1"/BACKUP/log_backup_"$TIMESTAMP".tar

    # Remove the archived files from /LOG
    for file in $FILES_TO_ARCHIVE; do
        rm -f "$1"/LOG/"$file"
    done

    echo "Archiving has been completed and the last $FILE_COUNT files have been deleted."
else
    echo "The usage of /LOG is normal: $LOG_USAGE%"
fi