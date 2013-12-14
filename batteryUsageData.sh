#! /usr/bin/env bash

timeStamp=`date "+%d %m %Y %H %M %S"`
batteryPercentage=`pmset -g batt | grep "InternalBattery" | cut -d";" -f1 | cut -s -f2 | cut -d% -f1`
batteryStatus=`pmset -g batt | grep "InternalBattery" | cut -d";" -f2 | cut -d' ' -f2`
batteryEstimate=`pmset -g batt | grep "InternalBattery" | cut -d";" -f3`

echo "$batteryPercentage $batteryStatus $timeStamp|$batteryEstimate" >> ~/.batteryStatus

if [ $batteryPercentage -eq 100 ]
then
    osascript -e 'tell app "System Events" to display dialog "The battery is fully charged!\nPlease turn off the external power supply." buttons "OK" default button 1 with title "vachavaRe Battery"'
fi
