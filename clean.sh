#!/bin/bash

LOGDIR="./test_directory/log"
# Delete files matching the pattern
# (./test_directory/log/example?.file)
rm -f "$PWD"/"$LOGDIR"/example?.file