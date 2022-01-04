#!/bin/bash

SERVER_NAME=$(curl -s  ifconfig.me)

TIMESTAMP=$(date +"%F")
BACKUP_DIR="/root/backup/$TIMESTAMP"
MYSQL=/usr/bin/mysql
MYSQLDUMP=/usr/bin/mysqldump
SECONDS=0

mkdir -p "$BACKUP_DIR/mysql"

echo "Starting Backup Database";
databases=`$MYSQL -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)"`

for db in $databases; do
	$MYSQLDUMP --force --opt $db | gzip > "$BACKUP_DIR/mysql/$db.gz"
done
echo "Finished";
echo '';

echo "Starting Backup Website";
# Loop through /home directory
for D in /home/*; do
	if [ -d "${D}" ]; then #If a directory
		domain=${D##*/} # Domain name
		echo "- "$domain;
		cd /home/$domain/public_html/
		zip -r $BACKUP_DIR/$domain.zip . -q -x wp-content/cache/**\* #Exclude cache
	fi
done
echo "Finished";
echo '';

echo "Starting Backup Nginx Configuration";
cp -r /etc/nginx/conf.d/ $BACKUP_DIR/nginx/
rm -f $BACKUP_DIR/nginx/default.conf
echo "Finished";
echo '';

size=$(du -sh $BACKUP_DIR | awk '{ print $1}')

echo "Starting Uploading Backup";
rclone move $BACKUP_DIR "remote:$SERVER_NAME/$TIMESTAMP" >> /var/log/rclone.log 2>&1
# Clean up
rm -rf $BACKUP_DIR
rclone -q --min-age 1w delete "remote:$SERVER_NAME" #Remove all backups older than 1 week
rclone -q --min-age 1w rmdirs "remote:$SERVER_NAME" #Remove all empty folders older than 1 week
rclone cleanup "remote:" #Cleanup Trash
echo "Finished";
echo '';

duration=$SECONDS
echo "Total $size, $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
