#!/bin/bash

BACKUP_FILE=$1

# see if s3cmd is configure
if test -f "/home/steam/.s3cfg"; then
  echo "s3cmd configured, backing up to s3 storage..."
  s3cmd put $BACKUP_FILE s3://ark-backups$BACKUP_FILE
  echo "backup of $BACKUP_FILE complete"
else
  echo "s3cmd is not configured, doing nothing..."
fi