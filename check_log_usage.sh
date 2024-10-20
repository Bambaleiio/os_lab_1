#!/bin/bash

# We get percentage of usage of the /LOG folder
LOG_USAGE=$(df /LOG | tail -1 | awk '{print $5}' | sed 's/%//')

# Setting a threshold value (for ex. 70%)
THRESHOLD=70

# Setting the number of recent files to archive
FILE_COUNT=5

# Check if the usage exceeds the specified threshold
if [ "$LOG_USAGE" -gt "$THRESHOLD" ]; then
  echo "The usage of /LOG is $LOG_USAGE%, archiving the last $FILE_COUNT files..."
  
  # Archiving the N latest files by modification date
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  FILES_TO_ARCHIVE=$(ls -lt /LOG | grep '^-' | head -n $FILE_COUNT | awk '{print $9}')
  tar -czvf /BACKUP/log_backup_"$TIMESTAMP".tar.gz "$FILES_TO_ARCHIVE"

  for file in $FILES_TO_ARCHIVE; do
    rm -f /LOG/"$file"
  done

  echo "Archiving has been completed and the last $FILE_COUNT  files have been deleted."
else
  echo "The usage of /LOG is normal: $LOG_USAGE%"
fi


