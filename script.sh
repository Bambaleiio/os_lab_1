#!/bin/bash

check_directory() {
    if [ ! -d "$1" ]; then
        echo "$1 doesn't exist"
        exit 1
    fi
}

# check if main directory and log directory exist
check_directory "$1"
check_directory "$1/log"

DIR_SIZE=$(du -s "$1" | awk '{print $1}')
LOG_SIZE=$(du -s "$1/log" | awk '{print $1}')

echo "LOG_SIZE: $LOG_SIZE"
echo "DIR_SIZE: $DIR_SIZE"

# Calculate percentage and handle division by zero
if [ "$DIR_SIZE" -ne 0 ]; then
    PERCENTAGE=$(echo "scale=2; $LOG_SIZE / $DIR_SIZE * 100" | bc)
    echo "LOG directory size as a percentage of the main directory: $PERCENTAGE%"
else
    echo "Main directory size is zero, cannot calculate percentage."
fi