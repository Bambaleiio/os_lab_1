#!/bin/bash

# check if enough arguments are passed
if [ $# -lt 1 ]; then 
   printf "Not enough arguments - %d\nPlese provide number of test files to create\n" $# 
   exit 0 
fi 

# create log dir if not already created
LOGDIR="./test_directory/log"
mkdir $LOGDIR

# initialize random generator with current timestamp
RANDOM=$(date +%s)

# Create $1 (first argument) files with random sizes up to 2048m
for i in $(seq $1); do
    # get size of file to be created
    R_SIZE=$(($RANDOM % 2048)) 
    # file path
    FILEPATH="${LOGDIR}/example${i}.file"
    # flags for truncate command
    FLAGS="-s ${R_SIZE}m $FILEPATH"

    # echo current file status
    if [ -f $FILEPATH ]; then
        echo "${FILEPATH} has been overwritten"
    else 
        echo "${FILEPATH} has been created"
    fi

    # create SPARSE file (filled with null bytes only) with given size
    truncate $FLAGS
done

echo "Test cases successfully created"

# truancate usage
# truncate -s 24m example.file