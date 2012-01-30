#!/bin/bash
WDAY=$(date +%w)
DIR=/backups/psql/$WDAY
if [ ! -d "$DIR" ]; then
	mkdir -p $DIR
fi
LIST=$(psql -l | awk '{ print $1}' | grep -vE '^-|^List|^Name|template[0|1]|\||\(')
for d in $LIST
do
  echo "Backup up database $d"
  pg_dump $d | gzip -c >  $DIR/$d.out.gz
done