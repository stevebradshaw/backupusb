#!/bin/bash
################################################################################
#
# Backup removable drive - assumes it's mapped to f:, but can be changed by 
# setting backup_source. Backup files go into c:\backups
#
# 
# 02/04/2008 - Initial version
# 02/06/2008 - Changed date format to YYYMMDD    
#
################################################################################


backup_source=f:/*
backup_dir=c:/backups
file_date=`date +%Y%m%d_%H%M%S`
file_name=DT_backup_${file_date}.tar
dir_name=${backup_dir}/DT_backup_${file_date}

echo "Catalog of files in backup `date`" > /tmp/backup.log 2>&1
echo "==================================================" >> /tmp/backup.log 2>&1

cd /tmp

echo "Creating backup archive ${file_name}"

tar cvf $file_name ${backup_source} >> /tmp/backup.log 2>&1
if [ $? -ne 0 ]
then
  echo "Backup failed: problem creating archive file ${file_name}"
  exit 1
fi

echo "==================================================" >> /tmp/backup.log 2>&1
echo "End of catalog" >> /tmp/backup.log 2>&1

if [ ! -d ${dir_name} ]
then
  echo Creating directory ${dir_name}
  mkdir ${dir_name}
fi

echo "Adding file ${file_name} to backup"

mv /tmp/$file_name $dir_name/
if [ $? -ne 0 ]
then
  echo "Backup failed: problem moving archive file ${file_name$} to ${dir_name}"
  exit 2
fi

# convert log to Win32 EOLs
unix2dos /tmp/backup.log > /dev/null 2>&1

mv /tmp/backup.log $dir_name/
if [ $? -ne 0 ]
then
  echo "Backup failed: problem moving logfile to ${dir_name}"
  exit 3
fi

