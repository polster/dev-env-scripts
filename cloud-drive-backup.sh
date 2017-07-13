#!/bin/bash

# The smtp server, e.g. smtp.example.com:25
EMAIL_SERVER=""
# The sender email address
EMAIL_FROM=""
# The recipient email address
EMAIL_TO=""
# The subject
EMAIL_SUBJ=""
# The backup base dir
BACKUP_DIR_BASE=""
# The backup folder's prefix
BACKUP_DIR_PREFIX=""
# The current date time to be used as backup dir name
CURRENT_TIMESTAMP=`date +%Y%m%d%H%M%S`

if [ ! -d "$BACKUP_DIR_BASE" ]; then
  echo "Backup dir base [$BACKUP_DIR_BASE] does not exist!"
  exit 1
fi

cd $BACKUP_DIR_BASE
target_backup_dir=${BACKUP_DIR_PREFIX}_${CURRENT_TIMESTAMP}
latest_backup_dir=${BACKUP_DIR_PREFIX}_latest
message="Backup host: [`hostname`]\nBackup target: [$BACKUP_DIR_BASE/$target_backup_dir]\n"

if [ ! -d "$target_backup_dir" ]; then
  # dir does not exist, create
  mkdir $target_backup_dir

fi

# symlink to latest
ln -s $target_backup_dir $latest_backup_dir

# perform backup
rclone copy --log-file $BACKUP_DIR_BASE/logs/rclone_$CURRENT_TIMESTAMP.log gdrive-remote: $target_backup_dir/

if [ $? -eq 0 ]; then
  message+="\nBackup was successful"
else
  message+="\nBackup failed, check logs"
fi

# send email after backup
sendemail -f $EMAIL_FROM -t $EMAIL_TO -u $EMAIL_SUBJ -m $message -s $EMAIL_SERVER -o tls=no
