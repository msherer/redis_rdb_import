#!/bin/bash

set -e

##
# Paths for the original RDB file
##
#rdbPath = "/var/redis/6381"
rdbPath = "/usr/local/var/db/redis"
rdbFile = "dump.rdb"
rdbBackup = "dump.rdb.bak"

##
# Paths for the dump in the user directory that will be imported
##
#backupPath = "/home/www-upload"
backupPath = "/Users/MY_USER_HERE/Desktop"
backupFile = "6381-dump.rdb"

# Check for original file and backup file
if [ -f "$rdbPath/$rdbFile" && -f "$backupPath/$backupFile" ]; then
    # Stop Redis for import
    redis-cli -p 6381 shutdown

    rdbFilepath = "$rdbPath/$rdbFile"
    rdbBackupFilepath = "$rdbPath/$rdbBackup"
    backupFilepath = "$backupPath/$backupFile"

    # Backup the original redis file
    echo "Making backup from $rdbFilepath -> $rdbBackupFilepath"
    mv $rdbFilepath $rdbBackupFilepath || {
        echo "Failed to move file $rdbFilepath -> $rdbBackupFilepath"
        echo "Restarting Redis."
        service redis_6381 start
        exit 1
    }

    # Import redis dump
    echo "Importing redis backup from $backupPath/$backupFile -> $rdbFilePath"
    cp $backupFilepath $rdbFilepath || {
        echo "Failed to copy $backupFilepath -> $rdbFilepath"
        echo "Restarting Redis."
        service redis_6381 start
        exit 1
    }

    # Start Redis after completion
    start redis_6381 start
else
    echo "Please make sure $rdbPath/$rdbFile AND $backupPath/$backupFile both exist and try again."
fi
