#! /usr/bin/env bash

#write out current crontab
crontab -l > currCronjobs

grep -v batteryUsageData currCronjobs > cronjobs
grep -v "^crontab:" cronjobs > cronjobs

presentDir=`pwd`

echo "*/10 * * * * $presentDir/batteryUsageData.sh" >> cronjobs

#install new cron file
crontab cronjobs

rm -f cronjobs currCronjobs
